// ignore_for_file: unnecessary_cast, non_constant_identifier_names, prefer_final_fields, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gymtracker/constants.dart';
import 'package:gymtracker/models/enroll_model.dart';
import 'package:gymtracker/models/user_model.dart';
import 'package:gymtracker/widgets/customsnackbar.dart';
import 'package:hive_flutter/adapters.dart';

class ApprovalController extends ChangeNotifier {
  // UserModel? userModelData;
  List? ApproveeUIDs;
  EnrollModel? enrollModel;
  CollectionReference? usersCollection;
  CollectionReference? gymPartnersCollection;
  List usersModelData = [];
  bool isApproved = false;
  bool isDetailsUpdating = false;
  List _pendingApprovalDataList = [];
  List _usersUIDs = [];
  DateTime? pickedDate;
  bool? isDateEditable;
  ApprovalController() {
    usersCollection = fireBaseFireStore.collection('users');
    gymPartnersCollection = fireBaseFireStore.collection('gympartners');
    //getAllUsersDataFromFireStore();
    //getAllUsersDataFromFireStore();
    //fetchApproveeDetails();
    //notifyListeners();
  }
  getAllUsersDataFromFireStore() async {
    for (String uid in ApproveeUIDs!) {
      await fireStoreCall(uid);
    }
    notifyListeners();
    print(usersModelData);
  }

  updateDate(DateTime value) {
    pickedDate = value;
    notifyListeners();
  }

  Future get_isApprovalMembershipStartDateEditable() async {
    UserModel adminData = Hive.box(userDetailsHIVE).get('usermodeldata');
    await gymPartnersCollection!.doc(adminData.uid).get().then(
      (value) {
        isDateEditable = (value.data()
            as Map<String, dynamic>)['isApprovalMembershipStartDateEditable'];
      },
    );
    notifyListeners();
  }

  Future fireStoreCall(String uid) async {
    final data = await usersCollection!.doc(uid).get();
    usersModelData.add(UserModel.toModel(data));
  }

  getApproveeUID(List newvalue) {
    ApproveeUIDs = newvalue;
    print(ApproveeUIDs);
  }
  // approveUser({
  //   required String approveeUID,
  //   required int index,
  //   required userName,
  //   required TextEditingController validityController,
  //   required TextEditingController moneyPaidController,
  //   required BuildContext context,
  // }) async {
  //   notifyListeners();
  //   isApproved = false;
  //   isDetailsUpdating = true;
  //   CollectionReference? usersCollection =
  //       fireBaseFireStore.collection('users');
  //   final membershipExpiry = DateTime.now();

  //   var newDate = DateTime(
  //     membershipExpiry.year,
  //     membershipExpiry.month + int.parse(validityController.text),
  //     membershipExpiry.day,
  //     membershipExpiry.minute,
  //     membershipExpiry.second,
  //     membershipExpiry.millisecond,
  //   );
  //   await usersCollection.doc(approveeUID).update({
  //     'membershipExpiry': newDate,
  //     'enrolledGymDate': DateTime.now(),
  //     'recentRenewedOn': DateTime.now(),
  //     'memberShipFeesPaid': int.parse(moneyPaidController.text),
  //     'isAwaitingEnrollment': false,
  //   }).then(
  //     (value) {
  //       print('user approved');
  //     },
  //   ).onError(
  //     (error, stackTrace) {
  //       print('user approval failed $error');
  //     },
  //   ); // user

  //   _pendingApprovalDataList.removeAt(index);

  //   // updateGymPartnersData(acceptedapproveeUID);
  //   await usersCollection.doc(fireBaseAuth.currentUser!.uid).update({
  //     'pendingApprovals': _pendingApprovalDataList,
  //   }).then(
  //     (value) {
  //       print('admin data updated');
  //       CustomSnackBar.buildSnackbar(
  //           color: const Color(0xff4CB944),
  //           context: context,
  //           iserror: false,
  //           message:
  //               'request from $userName has been approved. You can now exit the page',
  //           textcolor: color_gt_green);
  //     },
  //   ).onError(
  //     (error, stackTrace) {
  //       print('admin data updation failed $error');
  //     },
  //   ); // admin

  //   isApproved = true;
  //   isDetailsUpdating = false;
  //   notifyListeners();
  // }
  // approveUser(
  //     {required int index,
  //     required String validityInMonths,
  //     required String amountPaid}) async {
  //   final membershipExpiry = DateTime.now();
  //   var newDate = DateTime(
  //       membershipExpiry.year,
  //       membershipExpiry.month + int.parse(validityInMonths),
  //       membershipExpiry.day);
  //   await usersCollection!.doc(ApproveeUIDs![index]).update({
  //     'membershipExpiry': newDate,
  //     'enrolledGymDate': DateTime.now(),
  //     'memberShipFeesPaid': int.parse(amountPaid),
  //   }).then(
  //     (value) {
  //       print('user approved');
  //     },
  //   ).onError(
  //     (error, stackTrace) {
  //       print('user approval failed $error');
  //     },
  //   ); // user

  //   await usersCollection!.doc(fireBaseAuth.currentUser!.uid).update({
  //     'pendingApprovals': ApproveeUIDs!.removeAt(index),
  //   }).then(
  //     (value) {
  //       print('admin data updated');
  //     },
  //   ).onError(
  //     (error, stackTrace) {
  //       print('admin data updation failed $error');
  //     },
  //   ); // admin
  // }
  // updateGymPartnersData(String approveeUID) async {
  //   await gymPartnersCollection!
  //       .where('gymPartnerUID', isEqualTo: fireBaseAuth.currentUser!.uid)
  //       .get()
  //       .then(
  //     (value) {
  //       enrollModel =
  //           EnrollModel.fromMap(value.docs[0].data() as Map<String, dynamic>);
  //       print(enrollModel);
  //     },
  //   ).onError(
  //     (error, stackTrace) {
  //       print('enrollmodel data failed $error');
  //     },
  //   );

  //   await gymPartnersCollection!.doc(enrollModel!.UID).get().then(
  //     (value) {
  //       _usersUIDs = (value.data() as Map<String, dynamic>)['users'] ?? [];
  //     },
  //   ).onError(
  //     (error, stackTrace) {
  //       print('failed to fetch users from gym partners $error');
  //     },
  //   );
  //   _usersUIDs.add(approveeUID);
  //   await gymPartnersCollection!
  //       .doc(enrollModel!.UID)
  //       .update({'users': _usersUIDs}).then(
  //     (value) {
  //       print('users data uploaded to ${enrollModel!.gymPartnerGYMName}');
  //     },
  //   ).onError(
  //     (error, stackTrace) {
  //       print(
  //           'users data couldnt upload to  ${enrollModel!.gymPartnerGYMName}');
  //     },
  //   );
  // }

  // Future getDataFromFireStore(int index) {
  //   return usersCollection!.doc(ApproveeUIDs![index]).get();
  // }

  // fetchApproveeDetails(int index) async {
  //   DocumentSnapshot userDoc = await getDataFromFireStore(index);
  //   // WidgetsBinding.instance!.addPostFrameCallback((_) {
  //   // });
  //   userModelData = UserModel.toModel(userDoc);
  //   notifyListeners();
  // }
}
