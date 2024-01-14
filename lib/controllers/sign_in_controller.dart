// ignore_for_file: non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gymtracker/models/user_model.dart';
import 'package:gymtracker/views/navigation.dart';
import 'package:gymtracker/views/tabview_navigation.dart';
import 'package:gymtracker/widgets/animated_route.dart';
import 'package:gymtracker/widgets/customsnackbar.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../models/gympartner_constraints_model.dart';

class LoginController extends ChangeNotifier {
  bool pass_isobscure = true;

  bool is_login_details_uploading = false;

  bool isResetPasswordLoading = false;
  //String auth;
  changeObscurity() {
    pass_isobscure = !pass_isobscure;
    //is_login_details_uploading = !is_login_details_uploading;
    notifyListeners();
  }

  Future loginuser(
      {required String email,
      required String password,
      required BuildContext ctx}) async {
    notifyListeners();
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        is_login_details_uploading = true;
        final creds = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email.trim(), password: password.trim());
        is_login_details_uploading = false;
        await storeUserDetailsToHive(creds.user!.uid);
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          CustomSnackBar.buildSnackbar(
            color: const Color(0xff4CB944),
            context: ctx,
            message: 'Login Success. Redirecting...',
            textcolor: const Color(0xffFDFFFC),
            iserror: false,
          );
          // ... show the culprit SnackBar here.
        });
        // final todaysdate = DateFormat('dd-MM-yyyy').format(DateTime.now());
        // Hive.box(miscellaneousDataHIVE).put('todaysdate', todaysdate);
        //await getConstraints();
        Navigator.pushReplacement(
            ctx,
            CupertinoPageRoute(builder: (context) => const NavigationScreen(),)
            // ScaleRoute(
            //   page: const NavigationScreen(),
            // )
            );
        notifyListeners();
      }
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('ecode =' + e.code);
      }
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'unknown') {
        CustomSnackBar.buildSnackbar(
          color: Colors.red[500]!,
          context: ctx,
          message: 'wrong email/password, try again !',
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
    if (userModelData.userType == 'shunin') {
      fireBaseAuth.signOut();
      throw 'Privileged user\'s can\'t sign-in here, sign-in failed !';
    } else {
      UserModel.saveUserDataToHIVE(userModelData);

      Hive.box(miscellaneousDataHIVE)
          .put('isAwaitingEnrollment', userModelData.isAwaitingEnrollment);
      Hive.box(miscellaneousDataHIVE)
          .put('membershipExpiry', userModelData.membershipExpiry);
      Hive.box(miscellaneousDataHIVE)
          .put('awaitingRenewal', userModelData.awaitingRenewal);
    }
  }

  Future resetPassword(String _emailID, BuildContext context) async {
    notifyListeners();
    isResetPasswordLoading = true;
    try {
      bool isUserExists = await fireBaseFireStore
          .collection('users')
          .where('email', isEqualTo: _emailID)
          .get()
          .then(
        (value) {
          return value.docs.isNotEmpty ? true : false;
        },
      );
      if (!isUserExists) {
        throw 'Check your entered email-ID. No user found.';
      }
      await fireBaseAuth.sendPasswordResetEmail(email: _emailID).then(
        (value) {
          Navigator.pop(context);
          CustomSnackBar.buildSnackbar(
            color: Colors.green,
            context: context,
            message: 'Email sent to $_emailID for password reset',
            textcolor: const Color(0xffFDFFFC),
            iserror: false,
          );
        },
      ).onError(
        (error, stackTrace) {
          throw 'Something went wrong, try again later !';
        },
      );
    } catch (e) {
      Navigator.pop(context);
      CustomSnackBar.buildSnackbar(
        color: Colors.red[500]!,
        context: context,
        message: e.toString(),
        textcolor: const Color(0xffFDFFFC),
        iserror: false,
      );
    }
    isResetPasswordLoading = true;
    notifyListeners();
  }

  // Future getConstraints() async {
  //   print('adds');
  //   GymPartnerConstraints? gymPartnerConstraints;
  //   final userData =
  //       Hive.box(userDetailsHIVE).get('usermodeldata') as UserModel;
  //   final todaysdate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  //   if (!userData.isUser) {
  //     print('heeyaw');
  //     await fireBaseFireStore
  //         .collection(userData.enrolledGym!)
  //         .doc('constraints')
  //         .get()
  //         .then(
  //       (value) {
  //         gymPartnerConstraints = GymPartnerConstraints.fromMap(
  //             value.data() as Map<String, dynamic>);
  //         print(gymPartnerConstraints);
  //       },
  //     );

  //     if (Hive.box(miscellaneousDataHIVE).get('todaysdate') == null) {
  //       Hive.box(maxClickAttemptsHIVE).put(
  //           'currAttendanceByDateInCurrentMonthCount',
  //           gymPartnerConstraints!.currAttendanceByDateInCurrentMonthCount);
  //       Hive.box(maxClickAttemptsHIVE).put('currMonthlyAttendanceCount',
  //           gymPartnerConstraints!.currMonthlyAttendanceCount);
  //     } else if (Hive.box(miscellaneousDataHIVE).get('todaysdate') !=
  //         todaysdate) {
  //       // Hive.box(miscellaneousDataHIVE)
  //       //     .put('isTodaysAttendanceMarkCompleted', null);
  //       print('constraint func');
  //       Hive.box(miscellaneousDataHIVE).put('todaysdate', todaysdate);
  //       Hive.box(maxClickAttemptsHIVE).put(
  //           'currAttendanceByDateInCurrentMonthCount',
  //           gymPartnerConstraints!.maxAttendanceByDateInCurrentMonthCount);
  //       Hive.box(maxClickAttemptsHIVE).put('currMonthlyAttendanceCount',
  //           gymPartnerConstraints!.maxMonthlyAttendanceCount);
  //       // await fireBaseFireStore
  //       //     .collection(userData.enrolledGym!)
  //       //     .doc('constraints')
  //       //     .update({
  //       //   'currMonthlyAttendanceCount':
  //       //       gymPartnerConstraints!.maxMonthlyAttendanceCount,
  //       //   'currAttendanceByDateInCurrentMonthCount':
  //       //       gymPartnerConstraints!.maxAttendanceByDateInCurrentMonthCount,
  //       // }).onError(
  //       //   (error, stackTrace) {
  //       //     print(error);
  //       //   },
  //       // );
  //       // Hive.box(maxClickAttemptsHIVE).put(
  //       //     'maxAttendanceByDateInCurrentMonthCount',
  //       //     maxAttendanceByDateInCurrentMonthCount);
  //       // Hive.box(maxClickAttemptsHIVE)
  //       //     .put('maxMonthlyAttendanceCount', maxMonthlyAttendanceCount);
  //     } else {
  //       Hive.box(maxClickAttemptsHIVE).put(
  //           'currAttendanceByDateInCurrentMonthCount',
  //           gymPartnerConstraints!.currAttendanceByDateInCurrentMonthCount);
  //       Hive.box(maxClickAttemptsHIVE).put('currMonthlyAttendanceCount',
  //           gymPartnerConstraints!.currMonthlyAttendanceCount);
  //     }
  //   }
  //   notifyListeners();
  // }
}
