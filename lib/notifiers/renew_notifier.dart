// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../constants.dart';
import '../models/user_model.dart';
import '../widgets/customsnackbar.dart';

class RenewState {
  bool? isApproved;
  bool? isDetailsUpdating;
  RenewState({
    this.isApproved,
    this.isDetailsUpdating,
  });

  RenewState copyWith({
    bool? isApproved,
    bool? isDetailsUpdating,
  }) {
    return RenewState(
      isApproved: isApproved ?? this.isApproved,
      isDetailsUpdating: isDetailsUpdating ?? this.isDetailsUpdating,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isApproved': isApproved,
      'isDetailsUpdating': isDetailsUpdating,
    };
  }

  factory RenewState.fromMap(Map<String, dynamic> map) {
    return RenewState(
      isApproved: map['isApproved'] != null ? map['isApproved'] as bool : null,
      isDetailsUpdating: map['isDetailsUpdating'] != null
          ? map['isDetailsUpdating'] as bool
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RenewState.fromJson(String source) =>
      RenewState.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'RenewState(isApproved: $isApproved, isDetailsUpdating: $isDetailsUpdating)';
}

class RenewNotifer extends StateNotifier<RenewState> {
  RenewNotifer(RenewState state, int id)
      : super(RenewState(
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

  Future renewUser(
      {required int index,
      required UserModel userModelData,
      required BuildContext context}) async {
    try {
      updateDetails();

      final membershipExpiry = DateTime.now();
      var newDate = DateTime(
        membershipExpiry.year,
        membershipExpiry.month + int.parse(validityController.text),
        membershipExpiry.day,
        membershipExpiry.day,
        membershipExpiry.hour,
        membershipExpiry.minute,
        membershipExpiry.second,
        membershipExpiry.millisecond,
      );

      await fireBaseFireStore
          .collection('users')
          .doc(userModelData.uid)
          .update({
        'membershipExpiry': newDate,
        'memberShipFeesPaid': int.parse(moneyPaidController.text),
        'recentRenewedOn': DateTime.now(),
        'awaitingRenewal': false,
      }).then(
        (value) {
          print('membership renewal updated on user');
        },
      );
      UserModel adminData = Hive.box(userDetailsHIVE).get('usermodeldata');
      adminData.pendingRenewals!.remove(userModelData.uid);
      await fireBaseFireStore.collection('users').doc(adminData.uid).update({
        'pendingRenewals': adminData.pendingRenewals,
      }).then(
        (value) {
          print('admin pending renewals updated');
          CustomSnackBar.buildSnackbar(
              color: const Color(0xff4CB944),
              context: context,
              iserror: false,
              message:
                  'Membership of ${userModelData.userName} has been renewed for ${validityController.text} month(s).',
              textcolor: color_gt_headersTextColorWhite);
        },
      ).onError(
        (error, stackTrace) {
          CustomSnackBar.buildSnackbar(
              color: Colors.red,
              context: context,
              iserror: true,
              message: 'Something went wrong !',
              textcolor: color_gt_headersTextColorWhite);
        },
      );
      restoreDetails();
    } catch (e) {
      CustomSnackBar.buildSnackbar(
          color: Colors.red,
          context: context,
          iserror: true,
          message: 'Re-check the entered fields !',
          textcolor: color_gt_headersTextColorWhite);
      state = state.copyWith(isApproved: false, isDetailsUpdating: false);
    }
  }

  @override
  void dispose() {
    validityController.dispose();
    moneyPaidController.dispose();

    super.dispose();
  }
}
