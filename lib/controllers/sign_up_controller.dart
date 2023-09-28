// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:gymtracker/constants.dart';
import 'package:gymtracker/models/user_model.dart';

import '../views/signin.dart';
import '../widgets/animated_route.dart';
import '../widgets/customsnackbar.dart';

class SignUpController extends ChangeNotifier {
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
  SignUpController(DateTime value) {
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

  changeConfirmPassObscurity() {
    confirmpass_isobscure = !confirmpass_isobscure;
    notifyListeners();
  }

  updateDate(DateTime value) {
    pickedDate = value;
    notifyListeners();
  }

  void registerUser({
    required UserModel userModel,
    required String password,
    //File image,
    required BuildContext ctx,
  }) async {
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
      is_register_details_uploading = true;
      if (await isUserNameUnique(userModel.userName)) {
        throw '"${userModel.userName}" already exists, try with different name !';
      }

      UserCredential cred = await fireBaseAuth.createUserWithEmailAndPassword(
          email: userModel.email, password: password);
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
      is_register_details_uploading = false;

      CustomSnackBar.buildSnackbar(
        context: ctx,
        color: const Color(0xff4CB944),
        message: 'Account Created. Redirecting to sign-in page',
        textcolor: const Color(0xffFDFFFC),
        iserror: false,
      );

      Navigator.pushReplacement(
          ctx,
          ScaleRoute(
            page: const SignInPage(),
          ));
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
      is_register_details_uploading = false;
      notifyListeners();
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
      is_register_details_uploading = false;
    }
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
  // changeToDefaultProfilePhoto(BuildContext ctx) async {
  //   no_of_times_profilechanged = 0;
  //   CustomSnackBar.buildSnackbar(
  //     context: ctx,
  //     color: Colors.red[500]!,
  //     message: 'You have de-selected your profile picture!',
  //     textcolor: const Color(0xffFDFFFC),
  //     iserror: true,
  //   );
  //   print(await convertImageToFile());
  //   pickedImage = await convertImageToFile();
  //   notifyListeners();
  // }

  // Future<File> convertImageToFile() async {
  //   var bytes = await rootBundle.load('assets/images/$selectedgender.png');
  //   String tempPath = (await getTemporaryDirectory()).path;
  //   File file = File('$tempPath/$selectedgender.png');
  //   await file.writeAsBytes(
  //       bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));

  //   notifyListeners();
  //   return file;
  // }

  // void pickimage(BuildContext ctx) async {
  //   final pickedimage = await ImagePicker().pickImage(
  //       source: ImageSource.gallery,
  //       maxHeight: 480,
  //       maxWidth: 640,
  //       imageQuality: 50);
  //   if (pickedimage != null) {
  //     no_of_times_profilechanged++;
  //     CustomSnackBar.buildSnackbar(
  //       context: ctx,
  //       color: const Color(0xff4CB944),
  //       message: 'You have successfuly selected your profile picture!',
  //       textcolor: const Color(0xffFDFFFC),
  //       iserror: true,
  //     );
  //     pickedImage = (File(pickedimage.path));
  //   }
  //   notifyListeners();
  //   print(pickedImage);
  // }

  // Future<String> _uploadtoStorage(File image) async {
  //   Reference ref = fireBaseStorage
  //       .ref()
  //       .child('profilepics')
  //       .child(FirebaseAuth.instance.currentUser!.uid);
  //   UploadTask uploadtask = ref.putFile(image);
  //   TaskSnapshot snap = await uploadtask;
  //   String downloadurl = await snap.ref.getDownloadURL();
  //   notifyListeners();
  //   return downloadurl;
  // }
}
