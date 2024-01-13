// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_local_variable, avoid_print
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymtracker/models/user_model.dart';
import 'package:hive/hive.dart';

import '../constants.dart';
import '../models/enroll_model.dart';
import '../widgets/customsnackbar.dart';

class ApprovalState {
  bool? isApproved;
  bool? isDetailsUpdating;
  bool? isRemoved;
  bool? isRemovalUpdating;
  DateTime? pickedDate;

  ApprovalState({
    this.isRemovalUpdating,
    this.isRemoved,
    this.isApproved,
    this.isDetailsUpdating,
    this.pickedDate,
  });

  ApprovalState copyWith({
    bool? isApproved,
    bool? isDetailsUpdating,
    bool? isRemoved,
    bool? isRemovalUpdating,
    DateTime? pickedDate,
  }) {
    return ApprovalState(
      isRemoved: isRemoved ?? this.isRemoved,
      isRemovalUpdating: isRemovalUpdating ?? this.isRemovalUpdating,
      isApproved: isApproved ?? this.isApproved,
      pickedDate: pickedDate ?? this.pickedDate,
      isDetailsUpdating: isDetailsUpdating ?? this.isDetailsUpdating,
    );
  }

  @override
  String toString() =>
      'ApprovalState(isApproved: $isApproved, isDetailsUpdating: $isDetailsUpdating)';

  @override
  bool operator ==(covariant ApprovalState other) {
    if (identical(this, other)) return true;

    return other.isApproved == isApproved &&
        other.isDetailsUpdating == isDetailsUpdating;
  }

  @override
  int get hashCode => isApproved.hashCode ^ isDetailsUpdating.hashCode;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isApproved': isApproved,
      'isDetailsUpdating': isDetailsUpdating,
    };
  }

  factory ApprovalState.fromMap(Map<String, dynamic> map) {
    return ApprovalState(
      isApproved: map['isApproved'] != null ? map['isApproved'] as bool : null,
      isDetailsUpdating: map['isDetailsUpdating'] != null
          ? map['isDetailsUpdating'] as bool
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ApprovalState.fromJson(String source) =>
      ApprovalState.fromMap(json.decode(source) as Map<String, dynamic>);
}

class ApprovalNotifier extends StateNotifier<ApprovalState> {
  ApprovalNotifier(ApprovalState state, int id)
      : super(ApprovalState(
          isApproved: false,
          isDetailsUpdating: false,
        ));
  TextEditingController validityController = TextEditingController();
  TextEditingController moneyPaidController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  updateDetails() {
    state = state.copyWith(isApproved: false, isDetailsUpdating: true);
  }

  restoreDetails() {
    state = state.copyWith(isApproved: true, isDetailsUpdating: false);
  }

  removeApprovalInitialState() {
    state = state.copyWith(isRemoved: false, isRemovalUpdating: true);
  }

  removeApprovalFinalButtonState() {
    state = state.copyWith(isRemoved: true, isRemovalUpdating: false);
  }

  updateDate(DateTime value) {
    state = state.copyWith(pickedDate: value);
  }

  Future removeUser({
    required String approveeUID,
    required BuildContext context,
  }) async {
    removeApprovalInitialState();
    UserModel adminData = Hive.box(userDetailsHIVE).get('usermodeldata');
    List tempData = [];
    await fireBaseFireStore.collection('users').doc(approveeUID).update({
      'enrolledGym': null,
      'enrolledGymDate': null,
      'enrolledGymOwnerName': null,
      'enrolledGymOwnerUID': null,
      'isAwaitingEnrollment': false,
      'memberShipFeesPaid': null,
      'membershipExpiry': null,
      'recentRenewedOn': null,
    });

    await fireBaseFireStore.collection('users').doc(adminData.uid).get().then(
      (value) {
        final data = value.data() as Map<String, dynamic>;
        tempData = data['pendingApprovals'] ?? [];
        tempData.remove(approveeUID);
      },
    );
    await fireBaseFireStore.collection('users').doc(adminData.uid).update({
      "pendingApprovals": tempData,
    });

    removeApprovalFinalButtonState();
  }

  approveUser({
    required String approveeUID,
    required int index,
    required String userName,
    required BuildContext context,
    DateTime? memberShipStartDate,
  }) async {
    List _pendingApprovalDataList = [];
    List _usersUIDs = [];
    DateTime newDate;
    EnrollModel? enrollModel;
    CollectionReference? gymPartnersCollection =
        fireBaseFireStore.collection('gympartners');
    //updateDetails();
    CollectionReference? usersCollection =
        fireBaseFireStore.collection('users');
    final membershipExpiry = DateTime.now();
    UserModel adminData = Hive.box(userDetailsHIVE).get('usermodeldata');
    if (memberShipStartDate != null) {
      newDate = DateTime(
        memberShipStartDate.year,
        memberShipStartDate.month + int.parse(validityController.text),
        memberShipStartDate.day,
        memberShipStartDate.hour,
        memberShipStartDate.minute,
        memberShipStartDate.second,
        memberShipStartDate.millisecond,
      );
    } else {
      newDate = DateTime(
        membershipExpiry.year,
        membershipExpiry.month + int.parse(validityController.text),
        membershipExpiry.day,
        membershipExpiry.hour,
        membershipExpiry.minute,
        membershipExpiry.second,
        membershipExpiry.millisecond,
      );
    }
    if ((newDate as DateTime).isBefore(DateTime.now())) {
      CustomSnackBar.buildSnackbar(
          color: Colors.red,
          context: context,
          iserror: true,
          message:
              'Invalid membership. Selected plan has already been expired.',
          textcolor: color_gt_headersTextColorWhite);
    } else {
      updateDetails();
      await usersCollection.doc(approveeUID).update({
        'membershipExpiry': newDate,
        'enrolledGymOwnerName': adminData.userName,
        'enrolledGymOwnerUID': adminData.uid,
        'enrolledGymDate': (memberShipStartDate != null)
            ? memberShipStartDate
            : DateTime.now(),
        'memberShipFeesPaid': int.parse(moneyPaidController.text),
        'isAwaitingEnrollment': false,
        'recentRenewedOn': (memberShipStartDate != null)
            ? memberShipStartDate
            : DateTime.now(),
      }).then(
        (value) {
          print('user approved');
        },
      ).onError(
        (error, stackTrace) {
          print('user approval failed $error');
        },
      ); // user
      List pendingApprovalDataList = [];
      await usersCollection.doc(fireBaseAuth.currentUser!.uid).get().then(
        (value) {
          pendingApprovalDataList =
              (value.data() as Map<String, dynamic>)['pendingApprovals'];
        },
      ).onError(
        (error, stackTrace) {
          print('admin data updation failed $error');
        },
      );
      pendingApprovalDataList.removeAt(index);

      await usersCollection.doc(fireBaseAuth.currentUser!.uid).update({
        'pendingApprovals': pendingApprovalDataList,
      }).then(
        (value) {
          print('admin data updated');
          CustomSnackBar.buildSnackbar(
              color: const Color(0xff4CB944),
              context: context,
              iserror: false,
              message: 'Request from $userName has been approved.',
              textcolor: color_gt_headersTextColorWhite);
        },
      ).onError(
        (error, stackTrace) {
          print('admin data updation failed $error');
        },
      ); // admin
      await gymPartnersCollection
          .doc(fireBaseAuth.currentUser!.uid)
          // .where('gymPartnerUID', isEqualTo: fireBaseAuth.currentUser!.uid)
          .get()
          .then(
        (value) {
          enrollModel =
              EnrollModel.fromMap(value.data() as Map<String, dynamic>);
          // enrollModel =
          //     EnrollModel.fromMap(value.docs[0].data() as Map<String, dynamic>);
          print(enrollModel);
        },
      ).onError(
        (error, stackTrace) {
          print('enrollmodel data failed $error');
        },
      );

      await gymPartnersCollection.doc(fireBaseAuth.currentUser!.uid).get().then(
        (value) {
          _usersUIDs = (value.data() as Map<String, dynamic>)['users'] ?? [];
        },
      ).onError(
        (error, stackTrace) {
          print('failed to fetch users from gym partners $error');
        },
      );
      _usersUIDs.add(approveeUID);
      await gymPartnersCollection
          .doc(fireBaseAuth.currentUser!.uid)
          .update({'users': _usersUIDs}).then(
        (value) {
          print('users data uploaded to ${enrollModel!.gymPartnerGYMName}');
        },
      ).onError(
        (error, stackTrace) {
          print(
              'users data couldnt upload to  ${enrollModel!.gymPartnerGYMName}');
        },
      );
      restoreDetails();
    }
  }

  @override
  void dispose() {
    validityController.dispose();
    moneyPaidController.dispose();

    super.dispose();
  }
  // ApprovalNotifier() : super(ApprovalState());
}
