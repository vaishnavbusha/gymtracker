// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../models/attendance_model.dart';
import '../models/enroll_model.dart';
import '../models/user_model.dart';
import '../widgets/customsnackbar.dart';

class AddManualAttendanceNotifier extends ChangeNotifier {
  bool isLoading = true;
  //List usersUIDsList = [];
  bool isSearchLoading = false;
  EnrollModel? enrollModel;
  bool checkLoading = false;
  bool isInitital = true;
  UserModel? userModel;
  bool? isEnterScanned;
  bool? todaysAttendanceMarked = false;
  UserModel adminData = Hive.box(userDetailsHIVE).get('usermodeldata');
  checkForInitial() {
    if (userModel != null) {
      isInitital = false;
    } else {
      isInitital = true;
    }
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

  Future searchForAUser(String userName, BuildContext context) async {
    isSearchLoading = true;
    userModel = null;
    todaysAttendanceMarked = false;
    isEnterScanned = null;
    await fireBaseFireStore
        .collection('users')
        .where('userName', isEqualTo: userName.toLowerCase())
        .where('enrolledGym', isEqualTo: adminData.enrolledGym)
        .get()
        .then(
      (value) {
        if (value.docs.isEmpty) {
          isSearchLoading = false;
          throw 'User not found !';
        } else {
          userModel = UserModel.toModel(value.docs[0]);

          bool isExpiredvar = isExpired(userModel!.membershipExpiry);
          if (isExpiredvar) {
            isSearchLoading = false;
            throw 'Your account has been expired !';
          } else {
            checkInOrOutTime();
          }
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
          message: error.toString(),
          textcolor: const Color(0xffFDFFFC),
          iserror: true,
        );
      },
    );
    notifyListeners();
  }

  Future checkInOrOutTime() async {
    final datetime = DateFormat('dd-MM-yyyy').format(DateTime.now());
    final monthData = DateFormat('MMM').format(DateTime.now());
    await FirebaseFirestore.instance
        .collection(userModel!.enrolledGym!)
        .doc(monthData)
        .collection(datetime)
        .doc(userModel!.uid)
        .get()
        .then(
      (value) {
        if (value.exists) {
          if ((value.data() as Map<String, dynamic>)['exitScannedDateTime'] !=
              null) {
            todaysAttendanceMarked = true;
            isEnterScanned = false;
          } else {
            todaysAttendanceMarked = false;
            isEnterScanned = true;
          }
        } else {
          todaysAttendanceMarked = false;
          isEnterScanned = false;
        }
      },
    );
    isSearchLoading = false;
    notifyListeners();
  }

  checkInTime(BuildContext context) async {
    checkLoading = true;
    final datetime = DateFormat('dd-MM-yyyy').format(DateTime.now());
    final monthData = DateFormat('MMM').format(DateTime.now());
    AttendanceModel attendanceModel = AttendanceModel(
        scannedDateTime: DateTime.now(), userName: userModel!.userName);
    await fireBaseFireStore
        .collection(userModel!.enrolledGym!)
        .doc(monthData)
        .set({}, SetOptions(merge: true));
    final snapShot = FirebaseFirestore.instance
        .collection(userModel!.enrolledGym!)
        .doc(monthData);

    List getListOfDates = await snapShot.get().then(
      (value) {
        return (value.data()!.containsKey('datesList'))
            ? (value.data() as Map<String, dynamic>)['datesList']
            : null;
      },
    );
    if (getListOfDates == null) {
      List x = [];
      x.add(datetime);
      await snapShot.set({'datesList': x});
    } else {
      if (!getListOfDates.contains(datetime)) {
        getListOfDates.add(datetime);
        await snapShot.update({'datesList': getListOfDates});
      }
    }

    await snapShot
        .collection(datetime)
        .doc(userModel!.uid)
        .set(attendanceModel.toMap());
    final entryList = Hive.box(manualAttendanceEntryListHIVE)
        .get('manualEntryData', defaultValue: []);
    entryList.add(userModel!.userName);
    Hive.box(manualAttendanceEntryListHIVE).put('manualEntryData', entryList);
    CustomSnackBar.buildSnackbar(
        iserror: false,
        color: Colors.green[500]!,
        context: context,
        message:
            '${userModel!.userName}\'s (${DateFormat('dd-MM-yyyy').format(DateTime.now())}) entry (time-in) has been marked !',
        textcolor: Colors.white);
    print(Hive.box(manualAttendanceEntryListHIVE)
        .get('manualEntryData', defaultValue: []));
    isEnterScanned = true;
    checkLoading = false;
    notifyListeners();
  }

  checkOutTime(BuildContext context) async {
    checkLoading = true;
    final datetime = DateFormat('dd-MM-yyyy').format(DateTime.now());
    final monthData = DateFormat('MMM').format(DateTime.now());
    await FirebaseFirestore.instance
        .collection(userModel!.enrolledGym!)
        .doc(monthData)
        .collection(datetime)
        .doc(userModel!.uid)
        .update({'exitScannedDateTime': DateTime.now()});
    //isEnterScanScanned = false;
    todaysAttendanceMarked = true;
    checkLoading = false;
    isEnterScanned = false;
    CustomSnackBar.buildSnackbar(
        iserror: false,
        color: Colors.green[500]!,
        context: context,
        message:
            '${userModel!.userName}\'s (${DateFormat('dd-MM-yyyy').format(DateTime.now())}) exit (out-time) has been marked !',
        textcolor: Colors.white);
    notifyListeners();
  }
}
