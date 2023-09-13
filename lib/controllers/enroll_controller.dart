import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:gymtracker/models/user_model.dart';
import 'package:hive/hive.dart';

import '../constants.dart';
import '../models/enroll_model.dart';
import '../widgets/customsnackbar.dart';

class EnrollController extends ChangeNotifier {
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  List<EnrollModel> gymPartnersData = [];
  List<String> gymNames = [];
  CollectionReference? _collectionData;
  String dropdownvalue = '';
  bool isLoading = false;
  bool isEnrolled = false;
  int selectedIndexOfGymPartnersData = 0;
  EnrollController() {
    _collectionData = fireBaseFireStore.collection("gympartners");
    getGymPartnersDetails();
    notifyListeners();
  }
  getGymPartnersDetails() async {
    QuerySnapshot querySnapshot = await _collectionData!.get();
    final allData = querySnapshot.docs.map((doc) {
      return doc.data();
    }).toList();
    gymPartnersData = allData.map(
      (e) {
        final x = e as Map<String, dynamic>;
        return EnrollModel.fromMap(x);
      },
    ).toList();
    for (EnrollModel x in gymPartnersData) {
      gymNames.add(x.gymPartnerGYMName!);
    }
    dropdownvalue = gymNames[0];
    notifyListeners();
  }

  changeEnrollGymName(String newValue) {
    selectedIndexOfGymPartnersData = gymNames.indexOf(newValue);

    dropdownvalue = newValue;
    notifyListeners();
  }

  updateEnrollmentInfo(BuildContext context) async {
    notifyListeners();
    isLoading = true;
    isEnrolled = false;
    await usersCollection
        .doc(Hive.box(miscellaneousDataHIVE).get('uid'))
        .update({
      'isAwaitingEnrollment': true,
      'enrolledGym': dropdownvalue,
      'enrolledGymDate': DateTime.now(),
    }).then(
      (value) {
        if (kDebugMode) {
          print('user data update successful');
        }
      },
    ).onError(
      (error, stackTrace) {
        if (kDebugMode) {
          print('user data update un-successful $error');
        }
      },
    ); // user
    final adminUID = gymPartnersData[selectedIndexOfGymPartnersData].UID!;
    final pendingApprovalsOfAdminData =
        await getPendingApprovalsOfAdminData(adminUID);
    await usersCollection.doc(adminUID).update({
      'pendingApprovals': pendingApprovalsOfAdminData,
    }).then(
      (value) {
        if (kDebugMode) {
          print('admin data update successful');
        }
      },
    ).onError(
      (error, stackTrace) {
        if (kDebugMode) {
          print('admin data update un-successful  $error');
        }
      },
    ); // admin
    CustomSnackBar.buildSnackbar(
        color: const Color(0xff4CB944),
        context: context,
        iserror: false,
        message:
            'Enrollment request has been sent to $dropdownvalue. You can exit this page.',
        textcolor: color_gt_headersTextColorWhite);
    isLoading = false;
    isEnrolled = true;
    notifyListeners();
  }

  Future getPendingApprovalsOfAdminData(String uid) async {
    DocumentSnapshot adminDataSnapshot = await usersCollection.doc(uid).get();
    final userModelData = UserModel.toModel(adminDataSnapshot);
    if (userModelData.pendingApprovals == null) {
      userModelData.pendingApprovals = [];
      userModelData.pendingApprovals!
          .add(Hive.box(miscellaneousDataHIVE).get('uid'));
      return userModelData.pendingApprovals;
    }
    userModelData.pendingApprovals!
        .add(Hive.box(miscellaneousDataHIVE).get('uid'));
    return userModelData.pendingApprovals;
  }
}
