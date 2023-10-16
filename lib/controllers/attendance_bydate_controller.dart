// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:gymtracker/constants.dart';
import 'package:gymtracker/models/gympartner_constraints_model.dart';
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
  final adminData = Hive.box(userDetailsHIVE).get('usermodeldata');
  bool isDataLoading = false;
  bool isDateDataLoading = true;
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
    isDateDataLoading = true;
    await fireBaseFireStore
        .collection(Hive.box(userDetailsHIVE).get('usermodeldata').enrolledGym)
        .doc(monthData)
        .get()
        .then(
      (value) {
        availabledatesList =
            (value.data() as Map<String, dynamic>)['datesList'] ?? [];
      },
    );
    print(availabledatesList);
    isDateDataLoading = false;
    notifyListeners();
  }

  Future getAttendanceListByDate() async {
    Hive.box(maxClickAttemptsHIVE).put(
        'currAttendanceByDateInCurrentMonthCount',
        Hive.box(maxClickAttemptsHIVE)
                .get('currAttendanceByDateInCurrentMonthCount') -
            1);
    final currAttendanceByDateInCurrentMonthCount =
        Hive.box(maxClickAttemptsHIVE)
            .get('currAttendanceByDateInCurrentMonthCount');
    await fireBaseFireStore
        .collection(adminData.enrolledGym!)
        .doc('constraints')
        .update({
      'currAttendanceByDateInCurrentMonthCount':
          currAttendanceByDateInCurrentMonthCount
    }).onError(
      (error, stackTrace) {
        print(error);
      },
    );
    notifyListeners();
    isDataLoading = true;

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
    isDateSelected = false;
    isDataLoading = false;
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
