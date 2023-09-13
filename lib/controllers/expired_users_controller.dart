import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../constants.dart';
import '../models/user_model.dart';
import '../widgets/customsnackbar.dart';

class ExpiredUsersController extends ChangeNotifier {
  bool isLoading = true;
  final UserModel _adminData = Hive.box(userDetailsHIVE).get('usermodeldata');
  List<UserModel> expiredUsersDataList = List<UserModel>.empty(growable: true);

  calculateNoOfDays(var expiresOn) {
    expiresOn = DateTime(expiresOn.year, expiresOn.month, expiresOn.day);
    return (expiresOn.difference(DateTime.now()).inHours / 24).round();
  }

  Future searchForExpiredUsers(BuildContext context) async {
    isLoading = true;
    expiredUsersDataList.clear();
    await fireBaseFireStore
        .collection('users')
        .where('enrolledGym', isEqualTo: _adminData.enrolledGym)
        .where('membershipExpiry', isLessThan: DateTime.now())
        .get()
        .then(
      (value) {
        print(value.docs);

        for (var x in value.docs) {
          UserModel userModel = UserModel.toModel(x);
          if (kDebugMode) {
            print(userModel);
          }
          expiredUsersDataList.add(userModel);
        }
      },
    ).onError(
      (error, stackTrace) {
        print(error);

        CustomSnackBar.buildSnackbar(
          color: Colors.red[500]!,
          context: context,
          message: 'Something went wrong !',
          textcolor: const Color(0xffFDFFFC),
          iserror: true,
        );
      },
    );

    if (kDebugMode) {
      print(expiredUsersDataList);
    }
    isLoading = false;
    notifyListeners();
  }
}
