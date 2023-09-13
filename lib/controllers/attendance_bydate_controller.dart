import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gymtracker/constants.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../models/attendance_display_model.dart';

class AttendanceByDateController extends ChangeNotifier {
  List attendanceData = [];
  List availabledatesList = [];
  //String? _gymName;
  bool _disposed = false;
  bool isDateSelected = false;
  String? dropdownvalue;
  List<DataRow> dataRowvar = [];
  var isAscending = true;
  var sortColumnIndex = 1;
  final String monthData = DateFormat('MMM').format(DateTime.now());

  bool? isLoading;
  AttendanceByDateController() {
    //getDatesListFromGymPartner();
    //initialiseGymPartnerCollection();
  }
  sortColumn(bool isAscending, int sortColumnIndex) {
    this.isAscending = isAscending;
    this.sortColumnIndex = sortColumnIndex;
    print('$sortColumnIndex,$isAscending');
    notifyListeners();
  }
  // Future getGymName() async {
  //   isLoading = true;
  //   await fireBaseFireStore
  //       .collection('gympartners')
  //       .doc(Hive.box(miscellaneousDataHIVE).get('uid'))
  //       .get()
  //       .then(
  //     (value) {
  //       _gymName = (value.data() as Map<String, dynamic>)['gymPartnerGYMName'];
  //     },
  //   );
  //   isLoading = false;
  //   await getDatesListFromGymPartner();
  //   notifyListeners();
  // }

  changeselectedDate(String newValue) {
    //selectedIndexOfGymPartnersData = gymNames.indexOf(newValue);

    dropdownvalue = newValue;

    if (dropdownvalue!.isNotEmpty) {
      isDateSelected = true;
    }
    attendanceData.clear();

    notifyListeners();
  }

  Future getDatesListFromGymPartner() async {
    await fireBaseFireStore
        .collection(Hive.box(userDetailsHIVE).get('usermodeldata').enrolledGym)
        .doc(monthData)
        .get()
        .then(
      (value) {
        availabledatesList =
            (value.data() as Map<String, dynamic>)['datesList'];
      },
    );
    print(availabledatesList);
    notifyListeners();
  }

  Future getAttendanceListByDate() async {
    int index = 1;
    await fireBaseFireStore
        .collection(Hive.box(userDetailsHIVE).get('usermodeldata').enrolledGym)
        .doc(monthData)
        .collection(dropdownvalue!)
        .get()
        .then(
      (value) {
        for (var x in value.docs) {
          AttendanceDisplayModel attendanceDisplayModel =
              AttendanceDisplayModel.fromMap(x.data());
          print(attendanceDisplayModel);
          attendanceDisplayModel = attendanceDisplayModel.copyWith(
            uid: x.id,
            index: index,
          );
          attendanceData.add(attendanceDisplayModel);
          index++;
        }
      },
    );
    print(attendanceData);
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
