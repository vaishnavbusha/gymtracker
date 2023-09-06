// ignore_for_file: await_only_futures

import 'package:flutter/cupertino.dart';
import 'package:gymtracker/constants.dart';
import 'package:hive/hive.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../models/user_model.dart';

class NavigationBarController extends ChangeNotifier {
  bool _disposed = false;
  int curr_index = 1;
  bool? isUser;
  bool isDataAvailable = false;
  PersistentTabController? controller;
  NavigationBarController() {
    checkUserStatus();
  }

  checkUserStatus() async {
    isDataAvailable = false;
    final userBox = await Hive.box(userDetailsHIVE).get('usermodeldata');
    print('userbox = $userBox');
    isUser = userBox.isUser;
    isDataAvailable = true;
    initialiseController();
    notifyListeners();
  }

  initialiseController() {
    controller = PersistentTabController(initialIndex: isUser! ? 1 : 0);
    notifyListeners();
  }

  changeCurrentIndex(int value) {
    curr_index = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
}
