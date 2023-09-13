// ignore_for_file: non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gymtracker/models/user_model.dart';
import 'package:gymtracker/views/navigation.dart';
import 'package:gymtracker/widgets/animated_route.dart';
import 'package:gymtracker/widgets/customsnackbar.dart';
import 'package:hive_flutter/adapters.dart';

import '../constants.dart';

class LoginController extends ChangeNotifier {
  bool pass_isobscure = true;

  bool is_login_details_uploading = false;
  //String auth;
  changeObscurity() {
    pass_isobscure = !pass_isobscure;
    //is_login_details_uploading = !is_login_details_uploading;
    notifyListeners();
  }

  loginuser(
      {required String email,
      required String password,
      required BuildContext ctx}) async {
    notifyListeners();
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        is_login_details_uploading = true;
        final creds = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        is_login_details_uploading = false;
        await storeUserDetailsToHive(creds.user!.uid);
        CustomSnackBar.buildSnackbar(
          color: const Color(0xff4CB944),
          context: ctx,
          message: 'Login Success. Redirecting...',
          textcolor: const Color(0xffFDFFFC),
          iserror: false,
        );
        Navigator.pushReplacement(
            ctx,
            ScaleRoute(
              page: const NavigationPage(),
            ));
        notifyListeners();
      }
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e.code);
      }
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        CustomSnackBar.buildSnackbar(
          color: Colors.red[500]!,
          context: ctx,
          message: 'wrong username/password, try again !',
          textcolor: const Color(0xffFDFFFC),
          iserror: true,
        );
      } else {
        CustomSnackBar.buildSnackbar(
          color: Colors.red[500]!,
          context: ctx,
          message: e.message!,
          textcolor: const Color(0xffFDFFFC),
          iserror: true,
        );
      }
      if (kDebugMode) {
        print(e.toString());
      }
      is_login_details_uploading = false;
    } catch (e) {
      CustomSnackBar.buildSnackbar(
        color: Colors.red[500]!,
        context: ctx,
        message: e.toString(),
        textcolor: const Color(0xffFDFFFC),
        iserror: true,
      );
      if (kDebugMode) {
        print(e.toString());
      }
      is_login_details_uploading = false;
    }
    notifyListeners();
  }

  Future storeUserDetailsToHive(String uid) async {
    final userdataJSON =
        await fireBaseFireStore.collection('users').doc(uid).get();
    if (kDebugMode) {
      print('jsondata = $userdataJSON');
    }
    UserModel userModelData = UserModel.toModel(userdataJSON);
    UserModel.saveUserDataToHIVE(userModelData);

    Hive.box(miscellaneousDataHIVE)
        .put('isAwaitingEnrollment', userModelData.isAwaitingEnrollment);
    Hive.box(miscellaneousDataHIVE)
        .put('membershipExpiry', userModelData.membershipExpiry);
    Hive.box(miscellaneousDataHIVE)
        .put('awaitingRenewal', userModelData.awaitingRenewal);
  }
}
