// ignore_for_file: unused_local_variable, non_constant_identifier_names, avoid_print

import 'package:flutter/cupertino.dart';
import 'package:gymtracker/constants.dart';
import 'package:gymtracker/models/enroll_model.dart';
import 'package:hive/hive.dart';

import '../models/attendance_display_model.dart';

class AttendanceByMonthController extends ChangeNotifier {
  //String? _gymName;
  List allEnrolledUsers = [];
  List availabledatesList = [];
  List availableMonths = [];
  String? dropdownvalue;
  EnrollModel? enrollModel;
  List columnData = ['S.No', 'UserName'];
  //List<Map<String, List>> attendanceData = [];
  List<Map<String, List>> attendanceDataUIDsOnly = [];
  List<Map<String, List>> attendanceDataDateTimeOnly = [];
  List<Map<String, List>> attendanceDataExitDateTimeOnly = [];
  List<Map<String, String>> usersDataUIDs_names = [];
  List attendanceByRow = [];
  //final String monthData = DateFormat('MMM').format(DateTime.now());

  getGymPartnerDetails() async {
    await fireBaseFireStore
        .collection('gympartners')
        .doc(Hive.box(miscellaneousDataHIVE).get('uid'))
        .get()
        .then(
      (value) {
        enrollModel = EnrollModel.fromMap(value.data() as Map<String, dynamic>);
        // _gymName = enrollModel!.gymPartnerGYMName!;
        allEnrolledUsers = enrollModel!.users!;
      },
    );
    await getAvailableMonths();
    notifyListeners();
  }

  Future getUserData() async {
    for (String uid in allEnrolledUsers) {
      await fireBaseFireStore.collection('users').doc(uid).get().then(
        (value) {
          usersDataUIDs_names.add(
              {value.id: (value.data() as Map<String, dynamic>)['userName']});
        },
      );
    }
    notifyListeners();
  }

  changeselectedMonth(String monthValue) {
    //selectedIndexOfGymPartnersData = gymNames.indexOf(newValue);

    dropdownvalue = monthValue;
    //attendanceData.clear();
    attendanceDataDateTimeOnly.clear();
    usersDataUIDs_names.clear();
    attendanceDataExitDateTimeOnly.clear();
    attendanceDataUIDsOnly.clear();
    attendanceByRow.clear();
    getDatesListFromGymPartner();
    notifyListeners();
  }

  Future getAvailableMonths() async {
    await fireBaseFireStore
        .collection(Hive.box(userDetailsHIVE).get('usermodeldata').enrolledGym)
        .get()
        .then(
      (value) {
        for (var x in value.docs) {
          availableMonths.add(x.id);
        }
      },
    );
    notifyListeners();
  }

  Future getDatesListFromGymPartner() async {
    await fireBaseFireStore
        .collection(Hive.box(userDetailsHIVE).get('usermodeldata').enrolledGym)
        .doc(dropdownvalue)
        .get()
        .then(
      (value) {
        availabledatesList =
            (value.data() as Map<String, dynamic>)['datesList'];
      },
    );

    for (var element in availabledatesList) {
      columnData.add(element);
    }
    await getUserData();
    notifyListeners();
  }

  Future getWholeAttendanceByMonthData() async {
    // int index = 1;
    for (String x in availabledatesList) {
      await fireBaseFireStore
          .collection(
              Hive.box(userDetailsHIVE).get('usermodeldata').enrolledGym)
          .doc(dropdownvalue)
          .collection(x)
          .get()
          .then(
        (value) {
          List tempData = [];
          List tempUIDData = [];
          List tempPerUIDScannedDateTime = [];
          List tempPerUIDTime_out = [];
          List tempNamesData = [];
          for (var doc in value.docs) {
            AttendanceDisplayModel attendanceDisplayModel =
                AttendanceDisplayModel.fromMap(doc.data());

            attendanceDisplayModel = attendanceDisplayModel.copyWith(
              uid: doc.id,
              // index: index,
            );
            //index++;
            tempData.add(attendanceDisplayModel);
            tempUIDData.add(attendanceDisplayModel.uid);
            tempPerUIDScannedDateTime
                .add(attendanceDisplayModel.scannedDateTime);
            tempPerUIDTime_out.add(attendanceDisplayModel.exitScannedDateTime);
            tempNamesData.add(attendanceDisplayModel.userName);
          }
          //attendanceData.add({x: tempData});
          attendanceDataUIDsOnly.add({x: tempUIDData});
          attendanceDataDateTimeOnly.add({x: tempPerUIDScannedDateTime});
          attendanceDataExitDateTimeOnly.add({x: tempPerUIDTime_out});
        },
      );
    }

    await attendanceByRowFunction();
    notifyListeners();
  }

  Future attendanceByRowFunction() async {
    final data = [];
    int bufferindex = 0;
    for (String userID in allEnrolledUsers) {
      final userName = usersDataUIDs_names[bufferindex][userID];
      List tempdata = [];
      for (String date in availabledatesList) {
        Map<String, List> attendanceUIDsMapatIndex =
            attendanceDataUIDsOnly[availabledatesList.indexOf(date)];

        List attendanceUIDsListPerDate = attendanceUIDsMapatIndex[date]!;

        Map<String, List> attendanceDateTimeMapAtIndex =
            attendanceDataDateTimeOnly[availabledatesList.indexOf(date)];

        List attendanceDateTimeListPerDate =
            attendanceDateTimeMapAtIndex[date]!;

        Map<String, List> attendanceDateTimeExitMapAtIndex =
            attendanceDataExitDateTimeOnly[availabledatesList.indexOf(date)];

        List attendanceDateTimeExitListPerDate =
            attendanceDateTimeExitMapAtIndex[date]!;

        List scanInOutData = ['', ''];
        if (attendanceUIDsListPerDate.contains(userID)) {
          int index =
              attendanceUIDsListPerDate.indexWhere((item) => item == userID);
          scanInOutData[0] = attendanceDateTimeListPerDate[index];
          //tempdata.add(attendanceDateTimeListPerDate[index]);
        } else {
          scanInOutData[0] = null;
          //tempdata.add(null);
        }
        if (attendanceUIDsListPerDate.contains(userID)) {
          int index =
              attendanceUIDsListPerDate.indexWhere((item) => item == userID);
          scanInOutData[1] = attendanceDateTimeExitListPerDate[index];
          print(scanInOutData[1]);
        } else {
          scanInOutData[1] = null;
        }

        tempdata.add(scanInOutData.toList());
      }
      attendanceByRow.add([userName, ...tempdata]);
      bufferindex++;
    }
    //print(attendanceByRow);
    notifyListeners();
  }
}
