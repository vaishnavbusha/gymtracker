// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../constants.dart';
import '../models/user_model.dart';
import '../views/signin.dart';
import '../widgets/customsnackbar.dart';

class ProfileController extends ChangeNotifier {
  late UserModel userModelData;
  bool isLoading = false;
  getUserData() {
    userModelData = Hive.box(userDetailsHIVE).get('usermodeldata');
  }

  Future<void> signOut(BuildContext context) async {
    await fireBaseAuth.signOut();
    await Hive.box(miscellaneousDataHIVE).put('isLoggedIn', false);
    await Hive.box(miscellaneousDataHIVE).put('isAwaitingEnrollment', null);
    await Hive.box(miscellaneousDataHIVE).put('membershipExpiry', null);
    await Hive.box(userDetailsHIVE).clear();
    Navigator.of(context, rootNavigator: true).pushReplacement(
        CupertinoPageRoute(builder: (context) => const SignInPage()));
  }

  Future renewRequest(BuildContext context) async {
    isLoading = true;
    final userModelData =
        (Hive.box(userDetailsHIVE).get('usermodeldata') as UserModel);
    List pendingRenewalsData = [];
    //should update respective admins' pendingRenewals field and should give notification that the request has been sent.
    await fireBaseFireStore
        .collection('users')
        .doc(userModelData.enrolledGymOwnerUID)
        .get()
        .then(
      (value) {
        pendingRenewalsData =
            (value.data() as Map<String, dynamic>)['pendingRenewals'] ?? [];
      },
    ).onError(
      (error, stackTrace) {
        if (kDebugMode) {
          print('fetching pending renewals failed $error');
        }
      },
    );
    pendingRenewalsData.add(userModelData.uid);
    await fireBaseFireStore
        .collection('users')
        .doc(userModelData.enrolledGymOwnerUID)
        .update({
      'pendingRenewals': pendingRenewalsData,
    }).then(
      (value) {
        if (kDebugMode) {
          print('admin data for pendingRenewals updated');
        }
      },
    ).onError(
      (error, stackTrace) {
        if (kDebugMode) {
          print('updating pending renewals failed $error');
        }
      },
    );
    await fireBaseFireStore.collection('users').doc(userModelData.uid).update({
      'awaitingRenewal': true,
    }).then(
      (value) {
        if (kDebugMode) {
          print('user data for awaitingRenewal updated to true');
        }
      },
    ).onError(
      (error, stackTrace) {
        if (kDebugMode) {
          print('updating awaitingRenewal  failed $error');
        }
      },
    );
    CustomSnackBar.buildSnackbar(
        color: const Color(0xff4CB944),
        context: context,
        iserror: false,
        message:
            'Renewal request has been sent to ${userModelData.enrolledGymOwnerName}',
        textcolor: color_gt_headersTextColorWhite);
    isLoading = false;
    notifyListeners();
  }

  userDataChanges_FirebaseListener() {
    String collPath = 'users';
    String docPath = userModelData.uid!;

    DocumentReference documentReference =
        fireBaseFireStore.collection(collPath).doc(docPath);

    documentReference.snapshots().listen((snapshot) {
      if (kDebugMode) {
        print(snapshot.data);
      }
    });
  }
}
