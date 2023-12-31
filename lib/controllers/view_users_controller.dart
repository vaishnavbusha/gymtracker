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
  int usersUIDsListLength = 0;

  int lastIndex = 0;
  int limit = 8;
  bool paginationLoading = false;
  bool initialPaginationLoading = true;
  bool hasMoreData = true;
  DocumentSnapshot? lastDocument;
  //final ScrollController _scrollController = ScrollController();

  Future getEnrolledUsersData() async {
    isLoading = true;
    await fireBaseFireStore
        .collection('gympartners')
        .doc(Hive.box(miscellaneousDataHIVE).get('uid'))
        .get()
        .then(
      (value) {
        enrollModel = EnrollModel.fromMap(value.data() as Map<String, dynamic>);
        usersUIDsList = enrollModel!.users!;
        usersUIDsListLength = usersUIDsList.length;
      },
    );
    // for (String uid in usersUIDsList) {
    //   getUsersFromUIDs(uid);
    // }
    print(usersUIDsListLength);
    isLoading = false;
    notifyListeners();
  }

  calculateNoOfDays(var expiresOn) {
    expiresOn = DateTime(
      expiresOn.year,
      expiresOn.month,
      expiresOn.day,
      expiresOn.hour,
      expiresOn.minute,
      expiresOn.second,
      expiresOn.millisecond,
    );
    return (expiresOn.difference(DateTime.now()).inHours / 24).round();
  }

  isExpired(var expiresOn) {
    expiresOn = DateTime(
      expiresOn.year,
      expiresOn.month,
      expiresOn.day,
      expiresOn.hour,
      expiresOn.minute,
      expiresOn.second,
      expiresOn.millisecond,
    );
    return expiresOn.isBefore(DateTime.now());
  }

  bool isRequestedForApproval(String uid) {
    return (Hive.box(userDetailsHIVE).get('usermodeldata') as UserModel)
        .pendingRenewals!
        .contains(uid);
  }

  Future getUsersFromUIDs(String uid) async {
    await fireBaseFireStore.collection('users').doc(uid).get().then(
      (value) {
        UserModel userModel = UserModel.toModel(value);
        enrolledUsersData.add(userModel);
      },
    );

    notifyListeners();
  }

  Future loadInitialUserData() async {
    initialPaginationLoading = true;
    if (usersUIDsListLength <= limit) {
      for (int i = 0; i < usersUIDsList.length; i++) {
        await getUsersFromUIDs(usersUIDsList[i]);
      }
      hasMoreData = false;
    } else {
      if (limit > usersUIDsListLength) {
        //get the whole remaining data from uid's list
        for (int i = lastIndex; i < usersUIDsList.length; i++) {
          await getUsersFromUIDs(usersUIDsList[i]);
        }
      } else if (limit < usersUIDsListLength) {
        for (int i = lastIndex; i < (lastIndex + limit); i++) {
          await getUsersFromUIDs(usersUIDsList[i]);
        }
        lastIndex += limit;
        usersUIDsListLength = usersUIDsListLength - limit;
      }
    }
    initialPaginationLoading = false;
    notifyListeners();
  }

  Future paginatedUsersData() async {
    notifyListeners();
    paginationLoading = true;

    if (limit >= usersUIDsListLength) {
      //get the whole remaining data from uid's list
      for (int i = lastIndex; i < usersUIDsList.length; i++) {
        await getUsersFromUIDs(usersUIDsList[i]);
      }
      hasMoreData = false;
    } else if (limit < usersUIDsListLength) {
      for (int i = lastIndex; i < (lastIndex + limit); i++) {
        await getUsersFromUIDs(usersUIDsList[i]);
      }
      lastIndex += limit;
      usersUIDsListLength = usersUIDsListLength - limit;
    }
    paginationLoading = false;
    notifyListeners();
  }
}
