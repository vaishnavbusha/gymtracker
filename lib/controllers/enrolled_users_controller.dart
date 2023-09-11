import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gymtracker/constants.dart';
import 'package:gymtracker/models/enroll_model.dart';
import 'package:gymtracker/models/user_model.dart';
import 'package:hive/hive.dart';

class EnrolledUsersNotifier extends ChangeNotifier {
  List<UserModel> enrolledUsersData = [];
  List usersUIDsList = [];
  bool isLoading = true;
  EnrollModel? enrollModel;
  bool hasMore = true;

  int documentLimit = 10;

  DocumentSnapshot? lastDocument;
  final ScrollController _scrollController = ScrollController();
  getEnrolledUsersData() async {
    isLoading = true;
    await fireBaseFireStore
        .collection('gympartners')
        .doc(Hive.box(miscellaneousDataHIVE).get('uid'))
        .get()
        .then(
      (value) {
        enrollModel = EnrollModel.fromMap(value.data() as Map<String, dynamic>);
        usersUIDsList = enrollModel!.users!;
      },
    );
    for (String uid in usersUIDsList) {
      getUsersFromUIDs(uid);
    }
    isLoading = false;
    notifyListeners();
  }

  calculateNoOfDays(var expiresOn) {
    expiresOn = DateTime(expiresOn.year, expiresOn.month, expiresOn.day);
    return (expiresOn.difference(DateTime.now()).inHours / 24).round();
  }

  getUsersFromUIDs(String uid) async {
    await fireBaseFireStore.collection('users').doc(uid).get().then(
      (value) {
        UserModel userModel = UserModel.toModel(value);
        enrolledUsersData.add(userModel);
      },
    );
    print(enrolledUsersData);
    notifyListeners();
  }
}
