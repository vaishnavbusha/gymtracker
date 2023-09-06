import 'package:flutter/cupertino.dart';
import 'package:gymtracker/constants.dart';
import 'package:hive/hive.dart';

class AuthController extends ChangeNotifier {
  late Box userDetails;
  late Box appData;
  late bool isLoggedIn;
  AuthController() {
    userDetails = Hive.box(userDetailsHIVE);
    appData = Hive.box(miscellaneousDataHIVE);
    isLoggedIn = appData.get('isLoggedIn');
  }
  checkUserStatus() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (userDetails.isEmpty) {
        isLoggedIn = false;
        appData.put('isLoggedIn', isLoggedIn);
      } else {
        isLoggedIn = true;
        appData.put('isLoggedIn', isLoggedIn);
      }
      notifyListeners();
    });

    // notifyListeners();
  }
}
