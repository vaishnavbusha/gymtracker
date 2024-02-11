// ignore_for_file: non_constant_identifier_names, avoid_print, use_build_context_synchronously

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:gymtracker/constants.dart';
import 'package:gymtracker/models/user_model.dart';

import '../views/signin.dart';
import '../widgets/animated_route.dart';
import '../widgets/customsnackbar.dart';

class SignUpController extends ChangeNotifier {
  late TextEditingController dateController;
  late TextEditingController userNameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late TextEditingController phoneNumberController;
  bool pass_isobscure = true;
  DateTime? pickedDate;
  bool? isInputDateValidFormat;
  bool confirmpass_isobscure = true;
  bool is_register_details_uploading = false;
  String selectedgender = 'Male';
  int no_of_times_profilechanged = 0;
  late File pickedImage =
      File('/data/user/0/com.example.gymtracker/cache/Male.png');
  File? testfile;
  double? width;
  SignUpController(DateTime value) {
    dateController = TextEditingController();
    phoneNumberController = TextEditingController();
    userNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    pickedDate = value;
    // convertImageToFile().then(
    //   (value) {
    //     pickedImage = value;
    //   },
    // );
  }
  changePassObscurity() {
    pass_isobscure = !pass_isobscure;
    notifyListeners();
  }
 changeConfirmPassObscurity() {
    confirmpass_isobscure = !confirmpass_isobscure;
    notifyListeners();
  }

  changegender(String value) async {
    selectedgender = value;
    // pickedImage = await convertImageToFile();
    // if (kDebugMode) {
    //   print(pickedImage);
    // }
    notifyListeners();
  }

  int calculateAge() {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - pickedDate!.year;
    if (pickedDate!.month > currentDate.month) {
      age--;
    } else if (currentDate.month == pickedDate!.month) {
      if (pickedDate!.day > currentDate.day) {
        age--;
      }
    }
    return age;
  }

  // int daysBetween({required DateTime from, required DateTime to}) {
  //   from = DateTime(from.year, from.month, from.day);
  //   to = DateTime(to.year, to.month, to.day);
  //   return (to.difference(from).inHours / 24).round();
  // }

 
  updateDate(DateTime value) {
    pickedDate = value;
    notifyListeners();
  }

  void registerUser({
    required UserModel userModel,
    //File image,
    required BuildContext ctx,
  }) async {
    width = 44.w;
      is_register_details_uploading = true;
    notifyListeners();
    try {
      List userNamesList = [];
      // if (username.isNotEmpty &&
      //     email.isNotEmpty &&
      //     password.isNotEmpty &&
      //     image != null &&
      //     confirmPassword.isNotEmpty) {
      //   if (password != confirmPassword) {
      //     throw ('Re-Confirm entered password !');
      //   }
    
      if (await isUserNameUnique(userModel.userName)) {
        throw '"${userModel.userName}" already exists, try with different name !';
      }

      UserCredential cred = await fireBaseAuth.createUserWithEmailAndPassword(
        email: userModel.email,
        password: passwordController.text.trim(),
      );
      // String downloadurl = await _uploadtoStorage(pickedImage);
      // if (kDebugMode) {
      //   print(downloadurl);
      // }
      userModel = userModel.copyWith(
        uid: cred.user?.uid,
        //profilephoto: downloadurl,
      );
      await fireBaseFireStore
          .collection('usernames_list')
          .doc('uniqueUserNames')
          .get()
          .then(
        (value) {
          userNamesList =
              (value.data() as Map<String, dynamic>)['usernames'] ?? [];
          userNamesList.add(userModel.userName);
        },
      );
      await fireBaseFireStore
          .collection('usernames_list')
          .doc('uniqueUserNames')
          .update({'usernames': userNamesList});
      await fireBaseFireStore
          .collection("users")
          .doc(cred.user!.uid)
          .set(userModel.toJson());

      CustomSnackBar.buildSnackbar(
        context: ctx,
        color: const Color(0xff4CB944),
        message: 'Account Created. Redirecting to sign-in page',
        textcolor: const Color(0xffFDFFFC),
        iserror: false,
      );

      Navigator.pushReplacement(
          ctx,
          CupertinoPageRoute(
            builder: (context) => const SignInPage(),
          )
          // ScaleRoute(
          //   page: const SignInPage(),
          // )
          );
      //}
      // else {
      //   CustomSnackBar.buildSnackbar(
      //     context: ctx,
      //     color: Colors.red[500]!,
      //     message: 'Fill-up all the fields for successful registration.',
      //     textcolor: Color(0xffFDFFFC),
      //     iserror: true,
      //   );

      //   is_register_details_uploading = false;
      // }
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      CustomSnackBar.buildSnackbar(
        context: ctx,
        color: Colors.red[500]!,
        message: e.message!,
        textcolor: const Color(0xffFDFFFC),
        iserror: true,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      CustomSnackBar.buildSnackbar(
        context: ctx,
        color: Colors.red[500]!,
        message: e.toString(),
        textcolor: const Color(0xffFDFFFC),
        iserror: true,
      );
    }
      is_register_details_uploading = false;
    width = MediaQuery.of(ctx).size.width;
    notifyListeners();
  }

  isUserNameUnique(String newUserName) async {
    int y = 0;
    await fireBaseFireStore
        .collection('usernames_list')
        .doc('uniqueUserNames')
        .get()
        .then(
      (value) {
        final List userNamesList =
            (value.data() as Map<String, dynamic>)['usernames'] ?? [];
        for (var x in userNamesList) {
          if (x == newUserName) {
            y = 1;
            break;
          }
        }
      },
    ).onError(
      (error, stackTrace) {
        print('something went wrong');
      },
    );
    return (y == 1) ? true : false;
  }
}
