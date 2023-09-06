import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymtracker/controllers/attendance_bydate_controller.dart';
import 'package:gymtracker/controllers/enrolled_users_controller.dart';
import 'package:gymtracker/controllers/profile_controller.dart';
import 'package:gymtracker/controllers/scan_controller.dart';
import 'package:gymtracker/controllers/sign_in_controller.dart';
import 'package:gymtracker/controllers/sign_up_controller.dart';
import 'package:gymtracker/controllers/todays_attendance_controller.dart';
import 'package:gymtracker/notifiers/approval_notifier.dart';

import 'package:gymtracker/notifiers/login_notifier.dart';
import 'package:gymtracker/notifiers/register_notifier.dart';

import '../controllers/approval_controller.dart';
import '../controllers/attendance_bymonth_controller.dart';
import '../controllers/auth_controller.dart';
import '../controllers/enroll_controller.dart';
import '../controllers/navigationbar_controller.dart';
import '../controllers/network_controller.dart';

final connectivityStatusProviders = StateNotifierProvider((ref) {
  return ConnectivityStatusNotifier();
});
final signInpasswordObscurityProvider =
    StateProvider.autoDispose<bool>((ref) => true);
// final registerProvider =
//     StateNotifierProvider.autoDispose<RegisterNotifier, Register>(
//   (ref) => RegisterNotifier(),
// );
final signUpControllerProvider = ChangeNotifierProvider.autoDispose(
  (ref) => SignUpController(DateTime.now()),
);
final loginProvider = ChangeNotifierProvider.autoDispose(
  (ref) => LoginController(),
);
final navigationBarProvider = ChangeNotifierProvider.autoDispose(
  (ref) => NavigationBarController(),
);

final authChangesProvider = ChangeNotifierProvider(
  (ref) => AuthController(),
);
// final profileControllerProvider = ChangeNotifierProvider(
//   (ref) => ProfileController(),
// );
final scanControllerProvider = ChangeNotifierProvider.autoDispose(
  (ref) => ScanController(),
);
final enrollControllerProvider = ChangeNotifierProvider.autoDispose(
  (ref) => EnrollController(),
);
final approvalControllerProvider = ChangeNotifierProvider.autoDispose(
  (ref) => ApprovalController(),
);
final testApprovalProvider = StateNotifierProvider.family
    .autoDispose<ApprovalNotifier, ApprovalState, int>(
  (ref, id) {
    return ApprovalNotifier(ApprovalState(), id);
  },
);
final enrolledUsersProvider = ChangeNotifierProvider.autoDispose(
  (ref) {
    return EnrolledUsersNotifier();
  },
);
final todaysAttendanceProvider = ChangeNotifierProvider.autoDispose(
  (ref) {
    return TodaysAttendanceController();
  },
);
final attendanceByDateProvider = ChangeNotifierProvider.autoDispose(
  (ref) {
    return AttendanceByDateController();
  },
);
final attendanceByMonthProvider = ChangeNotifierProvider.autoDispose(
  (ref) {
    return AttendanceByMonthController();
  },
);

// final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>(
//   (ref) => LoginNotifier(),
// );

// final futureLoginButtonProvider = FutureProvider<UserCredential>(
//   (ref) async {
//     final logindetails = ref.watch(loginProvider);
//     final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: logindetails.email, password: logindetails.password);
//     return user;
//     //         FirebaseAuth.instance
//     //     .signInWithEmailAndPassword(
//     //         email: logindetails.email, password: logindetails.password)
//     //     .then(
//     //   (value) {
//     //     return value;
//     //   },
//     // );
//   },
// );
