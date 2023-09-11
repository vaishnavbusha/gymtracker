// ignore_for_file: unnecessary_cast

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gymtracker/constants.dart';
import 'package:gymtracker/models/attendance_display_model.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

class TodaysAttendanceController extends ChangeNotifier {
  //String? gymName;
  bool _disposed = false;
  List attendanceData = [];
  bool isDataAvailable = false;

  bool? isLoading;

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

  // Future getGymName() async {
  //   await fireBaseFireStore
  //       .collection('gympartners')
  //       .doc(Hive.box(miscellaneousDataHIVE).get('uid'))
  //       .get()
  //       .then(
  //     (value) {
  //       gymName = (value.data() as Map<String, dynamic>)['gymPartnerGYMName'];
  //     },
  //   );

  //   notifyListeners();
  // }

  Future fetchTodaysAttendance() async {
    final datetime = DateFormat('dd-MM-yyyy').format(DateTime.now());
    final monthData = DateFormat('MMM').format(DateTime.now());
    isLoading = true;
    int index = 1;
    await fireBaseFireStore
        .collection(Hive.box(userDetailsHIVE).get('usermodeldata').enrolledGym)
        .doc(monthData)
        .collection(datetime)
        .get()
        .then(
      (value) {
        for (var x in value.docs) {
          AttendanceDisplayModel attendanceDisplayModel =
              AttendanceDisplayModel.fromMap(x.data() as Map<String, dynamic>);
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
    if (attendanceData.isEmpty) {
      isDataAvailable = false;
    } else {
      isDataAvailable = true;
    }
    isLoading = false;
    print(attendanceData);
    notifyListeners();
  }
}
