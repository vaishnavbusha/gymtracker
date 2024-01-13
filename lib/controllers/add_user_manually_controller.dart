import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gymtracker/constants.dart';
import 'package:gymtracker/models/user_model.dart';
import 'package:hive/hive.dart';

import '../widgets/customsnackbar.dart';

class AddUserManuallyNotifier extends ChangeNotifier {
  bool isDataUploading = false;
  String selectedgender = 'Male';
  DateTime? pickedDate;
  late TextEditingController dateController;
  late TextEditingController userNameController;
  late TextEditingController phoneNumberController;
  late TextEditingController emailController;
  late TextEditingController moneyPaidController;
  late TextEditingController validityController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  changegender(String value) async {
    selectedgender = value;
    // pickedImage = await convertImageToFile();
    // if (kDebugMode) {
    //   print(pickedImage);
    // }
    notifyListeners();
  }

  AddUserManuallyNotifier(DateTime value) {
    pickedDate = value;
    dateController = TextEditingController();
    phoneNumberController = TextEditingController();
    userNameController = TextEditingController();
    emailController = TextEditingController();
    validityController = TextEditingController();
    moneyPaidController = TextEditingController();
    // convertImageToFile().then(
    //   (value) {
    //     pickedImage = value;
    //   },
    // );
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

  updateDate(DateTime value) {
    pickedDate = value;
    notifyListeners();
  }

  Future addUser({
    required BuildContext context,
  }) async {
    List _usersList = [];
    List _uniqueUserNames = [];
    notifyListeners();
    isDataUploading = true;
    final UserModel adminData = Hive.box(userDetailsHIVE).get('usermodeldata');
    final membershipExpiry = DateTime.now();
    var newDate = DateTime(
      membershipExpiry.year,
      membershipExpiry.month + int.parse(validityController.text),
      membershipExpiry.day,
      membershipExpiry.hour,
      membershipExpiry.minute,
      membershipExpiry.second,
      membershipExpiry.millisecond,
    );

    try {
      await fireBaseFireStore
          .collection('gympartners')
          .doc(adminData.uid)
          .get()
          .then(
        (value) async {
          List userNamesList = [];
          if (await isUserNameUnique(
              userNameController.text.toLowerCase().trim())) {
            throw '"${userNameController.text}" already exists, try with different name !';
          }
          final fireStoreData = (value.data() as Map<String, dynamic>);
          _usersList = fireStoreData['users'] ?? [];
          //_uniqueUserNames = fireStoreData['uniqueUserNames'] ?? [];
          UserCredential cred =
              await fireBaseAuth.createUserWithEmailAndPassword(
                  email: emailController.text,
                  password: userNameController.text +
                      '@' +
                      phoneNumberController.text);
          UserModel user = UserModel(
            email: emailController.text,
            gender: selectedgender,
            isUser: true,
            pendingApprovals: null,
            DOB: pickedDate.toString(),
            phoneNumber: phoneNumberController.text,
            registeredDate: DateTime.now(),
            userName: userNameController.text.toLowerCase().trim(),
            userType: 'user',
            isManuallyRegisteredByAdmin: true,
            awaitingRenewal: false,
            enrolledGym: adminData.enrolledGym,
            enrolledGymDate: DateTime.now(),
            enrolledGymOwnerName: adminData.enrolledGymOwnerName,
            enrolledGymOwnerUID: adminData.enrolledGymOwnerUID,
            isAwaitingEnrollment: false,
            memberShipFeesPaid: int.parse(moneyPaidController.text),
            membershipExpiry: newDate,
            pendingRenewals: null,
            recentRenewedOn: DateTime.now(),
            uid: cred.user!.uid,
          );
          _usersList.add(cred.user!.uid);
          _uniqueUserNames.add(userNameController.text);
          await fireBaseFireStore
              .collection('gympartners')
              .doc(adminData.uid)
              .update({
            'users': _usersList,
            'uniqueUserNames': _uniqueUserNames,
          });
          await fireBaseFireStore
              .collection('usernames_list')
              .doc('uniqueUserNames')
              .get()
              .then(
            (value) {
              userNamesList =
                  (value.data() as Map<String, dynamic>)['usernames'] ?? [];
              userNamesList.add(userNameController.text.toLowerCase().trim());
            },
          );
          await fireBaseFireStore
              .collection('usernames_list')
              .doc('uniqueUserNames')
              .update({'usernames': userNamesList});
          await fireBaseFireStore
              .collection('users')
              .doc(cred.user!.uid)
              .set(user.toJson())
              .then(
            (value) {
              if (kDebugMode) {
                print('added successfully !');
              }
              clearAllControllers();
              CustomSnackBar.buildSnackbar(
                context: context,
                color: const Color(0xff4CB944),
                message: '${userNameController.text} created successfully !',
                textcolor: const Color(0xffFDFFFC),
                iserror: false,
              );
            },
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        CustomSnackBar.buildSnackbar(
          context: context,
          color: Colors.red[500]!,
          message: "Email already in use !",
          textcolor: const Color(0xffFDFFFC),
          iserror: true,
        );
      }
    } catch (e) {
      CustomSnackBar.buildSnackbar(
        context: context,
        color: Colors.red[500]!,
        message: e.toString(),
        textcolor: const Color(0xffFDFFFC),
        iserror: true,
      );
    }

    isDataUploading = false;
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

  clearAllControllers() {
    phoneNumberController.text = '';
    userNameController.text = '';
    emailController.text = '';
    dateController.text = '';
    validityController.text = '';
    moneyPaidController.text = '';
    notifyListeners();
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    userNameController.dispose();
    emailController.dispose();
    dateController.dispose();
    validityController.dispose();
    moneyPaidController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
