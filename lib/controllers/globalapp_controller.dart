import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../models/gympartner_constraints_model.dart';
import '../models/user_model.dart';

class GlobalAppNotifier extends ChangeNotifier {
  GymPartnerConstraints? gymPartnerConstraints;

  Future getConstraints() async {
    final userData =
        Hive.box(userDetailsHIVE).get('usermodeldata') as UserModel;

    final todaysdate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    if (!userData.isUser) {
      await fireBaseFireStore
          .collection(userData.enrolledGym!)
          .doc('constraints')
          .get()
          .then(
        (value) {
          gymPartnerConstraints = GymPartnerConstraints.fromMap(
              value.data() as Map<String, dynamic>);
          print(gymPartnerConstraints);
        },
      );
      print(Hive.box(miscellaneousDataHIVE).get('todaysdate'));
      if (Hive.box(miscellaneousDataHIVE).get('todaysdate') != todaysdate &&
          (Hive.box(miscellaneousDataHIVE).get('todaysdate') != null)) {
        print('hive date today date same');
        Hive.box(miscellaneousDataHIVE).put('todaysdate', todaysdate);
        Hive.box(maxClickAttemptsHIVE).put(
            'currAttendanceByDateInCurrentMonthCount',
            gymPartnerConstraints!.maxAttendanceByDateInCurrentMonthCount);
        Hive.box(maxClickAttemptsHIVE).put('currMonthlyAttendanceCount',
            gymPartnerConstraints!.maxMonthlyAttendanceCount);
        await fireBaseFireStore
            .collection(userData.enrolledGym!)
            .doc('constraints')
            .update({
          'currMonthlyAttendanceCount':
              gymPartnerConstraints!.maxMonthlyAttendanceCount,
          'currAttendanceByDateInCurrentMonthCount':
              gymPartnerConstraints!.maxAttendanceByDateInCurrentMonthCount,
        }).onError(
          (error, stackTrace) {
            print(error);
          },
        );
      } else {
        Hive.box(miscellaneousDataHIVE).put('todaysdate', todaysdate);
        Hive.box(maxClickAttemptsHIVE).put(
            'currAttendanceByDateInCurrentMonthCount',
            gymPartnerConstraints!.currAttendanceByDateInCurrentMonthCount);
        Hive.box(maxClickAttemptsHIVE).put('currMonthlyAttendanceCount',
            gymPartnerConstraints!.currMonthlyAttendanceCount);
      }
    }
  }
}
