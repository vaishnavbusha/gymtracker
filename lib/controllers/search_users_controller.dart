import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gymtracker/models/user_model.dart';
import 'package:hive/hive.dart';

import '../constants.dart';
import '../models/enroll_model.dart';
import '../widgets/customsnackbar.dart';

class SearchUsersController extends ChangeNotifier {
  bool isLoading = true;
  //List usersUIDsList = [];
  bool isSearchLoading = true;
  EnrollModel? enrollModel;
  bool isInitital = true;
  UserModel adminData = Hive.box(userDetailsHIVE).get('usermodeldata');
  List<UserModel> searchedUsersDataList = List<UserModel>.empty(growable: true);
  // Future getEnrolledUIDsList() async {
  //   isLoading = true;
  //   await fireBaseFireStore
  //       .collection('gympartners')
  //       .doc(Hive.box(miscellaneousDataHIVE).get('uid'))
  //       .get()
  //       .then(
  //     (value) {
  //       enrollModel = EnrollModel.fromMap(value.data() as Map<String, dynamic>);
  //       usersUIDsList = enrollModel!.users!;
  //     },
  //   );
  //   isLoading = false;
  //   notifyListeners();
  // }
  checkForInitial() {
    if (searchedUsersDataList.isNotEmpty) {
      isInitital = false;
    } else {
      isInitital = true;
    }
    notifyListeners();
  }

  calculateNoOfDays(var expiresOn) {
    expiresOn = DateTime(expiresOn.year, expiresOn.month, expiresOn.day);
    return (expiresOn.difference(DateTime.now()).inHours / 24).round();
  }

  Future searchForAUser(String userName, BuildContext context) async {
    isSearchLoading = true;
    searchedUsersDataList.clear();
    await fireBaseFireStore
        .collection('users')
        .where('userName', isGreaterThanOrEqualTo: userName)
        .where('enrolledGym', isEqualTo: adminData.enrolledGym)
        .orderBy('userName')
        .get()
        .then(
      (value) {
        if (kDebugMode) {
          print(value.docs);
        }
        for (var x in value.docs) {
          UserModel userModel = UserModel.toModel(x);
          if (kDebugMode) {
            print(userModel);
          }
          searchedUsersDataList.add(userModel);
        }
      },
    ).onError(
      (error, stackTrace) {
        if (kDebugMode) {
          print(error);
        }
        CustomSnackBar.buildSnackbar(
          color: Colors.red[500]!,
          context: context,
          message: 'Something went wrong !',
          textcolor: const Color(0xffFDFFFC),
          iserror: true,
        );
      },
    );
    if (searchedUsersDataList.isEmpty) {
      CustomSnackBar.buildSnackbar(
        color: Colors.red[500]!,
        context: context,
        message: 'Couldn\'t find the user !',
        textcolor: const Color(0xffFDFFFC),
        iserror: true,
      );
    }
    if (kDebugMode) {
      print(searchedUsersDataList);
    }
    isSearchLoading = false;
    notifyListeners();
  }
}
