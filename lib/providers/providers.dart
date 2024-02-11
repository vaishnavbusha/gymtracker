import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymtracker/controllers/add_manual_attendance_controller.dart';
import 'package:gymtracker/controllers/add_user_manually_controller.dart';
import 'package:gymtracker/controllers/attendance_bydate_controller.dart';
import 'package:gymtracker/controllers/expired_users_controller.dart';
import 'package:gymtracker/controllers/globalapp_controller.dart';
import 'package:gymtracker/controllers/qr_generator_controller.dart';
import 'package:gymtracker/controllers/search_users_controller.dart';
import 'package:gymtracker/controllers/view_users_controller.dart';
import 'package:gymtracker/controllers/profile_controller.dart';
import 'package:gymtracker/controllers/renew_controller.dart';
import 'package:gymtracker/controllers/scan_controller.dart';
import 'package:gymtracker/controllers/sign_in_controller.dart';
import 'package:gymtracker/controllers/sign_up_controller.dart';
import 'package:gymtracker/controllers/todays_attendance_controller.dart';
import 'package:gymtracker/notifiers/approval_notifier.dart';

import 'package:gymtracker/notifiers/renew_notifier.dart';

import '../controllers/approval_controller.dart';
import '../controllers/attendance_bymonth_controller.dart';
import '../controllers/auth_controller.dart';
import '../controllers/enroll_controller.dart';
import '../controllers/navigationbar_controller.dart';
import '../controllers/network_controller.dart';

class Providers {
  static final connectivityStatusProviders = StateNotifierProvider((ref) {
    return ConnectivityStatusNotifier();
  });
  static final signInpasswordObscurityProvider =
      StateProvider.autoDispose<bool>((ref) => true);
// final registerProvider =
//     StateNotifierProvider.autoDispose<RegisterNotifier, Register>(
//   (ref) => RegisterNotifier(),
// );
  static final signUpControllerProvider = ChangeNotifierProvider.autoDispose(
    (ref) => SignUpController(DateTime.now()),
  );
  static final loginProvider = ChangeNotifierProvider.autoDispose(
    (ref) => LoginController(),
  );
  static final navigationBarProvider = ChangeNotifierProvider.autoDispose(
    (ref) => NavigationBarController(),
  );

  static final authChangesProvider = ChangeNotifierProvider(
    (ref) => AuthController(),
  );
  static final profileControllerProvider = ChangeNotifierProvider(
    (ref) => ProfileController(),
  );
  static final scanControllerProvider = ChangeNotifierProvider.autoDispose(
    (ref) => ScanController(),
  );
  static final enrollControllerProvider = ChangeNotifierProvider.autoDispose(
    (ref) => EnrollController(),
  );
  static final approvalControllerProvider = ChangeNotifierProvider.autoDispose(
    (ref) => ApprovalController(),
  );
  static final testApprovalProvider = StateNotifierProvider.family
      .autoDispose<ApprovalNotifier, ApprovalState, int>(
    (ref, id) {
      return ApprovalNotifier(ApprovalState(), id);
    },
  );

  static final enrolledUsersProvider = ChangeNotifierProvider.autoDispose(
    (ref) {
      return EnrolledUsersNotifier();
    },
  );
  static final todaysAttendanceProvider = ChangeNotifierProvider.autoDispose(
    (ref) {
      return TodaysAttendanceController();
    },
  );
  static final attendanceByDateProvider = ChangeNotifierProvider.autoDispose(
    (ref) {
      return AttendanceByDateController();
    },
  );
  static final renewMemberShipProvider = ChangeNotifierProvider.autoDispose(
    (ref) {
      return RenewMemberShipController();
    },
  );
  static final renewMemberShipFamilyProvider =
      StateNotifierProvider.family.autoDispose<RenewNotifer, RenewState, int>(
    (ref, id) {
      return RenewNotifer(RenewState(), id);
    },
  );
  static final attendanceByMonthProvider = ChangeNotifierProvider.autoDispose(
    (ref) {
      return AttendanceByMonthController();
    },
  );
  static final searchUsersProvider = ChangeNotifierProvider.autoDispose(
    (ref) {
      return SearchUsersController();
    },
  );
  static final expiredUsersProvider = ChangeNotifierProvider.autoDispose(
    (ref) {
      return ExpiredUsersController();
    },
  );
  static final addUserManuallyProvider = ChangeNotifierProvider.autoDispose(
    (ref) {
      return AddUserManuallyNotifier(DateTime.now());
    },
  );
  static final addManualAttendanceProvider = ChangeNotifierProvider.autoDispose(
    (ref) {
      return AddManualAttendanceNotifier();
    },
  );
  static final qrGeneratorProvider = ChangeNotifierProvider.autoDispose(
    (ref) {
      return QRGeneratorNotifier();
    },
  );
  static final globalAppProvider = ChangeNotifierProvider(
    (ref) {
      return GlobalAppNotifier();
    },
  );
}

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
