// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_null_comparison, must_call_super

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:gymtracker/models/user_model.dart';

import 'package:gymtracker/views/attendance_bydate.dart';
import 'package:gymtracker/views/attendance_bymonth.dart';
import 'package:gymtracker/views/expiredusers.dart';
import 'package:gymtracker/views/renewmembership.dart';

import 'package:gymtracker/views/searchusers.dart';
import 'package:gymtracker/views/today_attendance.dart';
import 'package:gymtracker/views/viewmyusers.dart';
import 'package:gymtracker/widgets/animated_route.dart';
import 'package:gymtracker/widgets/generate_qr.dart';

import 'package:hive_flutter/adapters.dart';

import '../constants.dart';
import '../models/gympartner_constraints.dart';
import '../providers/providers.dart';
import '../widgets/customsnackbar.dart';
import '../widgets/loader.dart';
import 'add_user_manually.dart';
import 'manual_daily_attendance.dart';

class ExplorePage extends ConsumerStatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends ConsumerState<ExplorePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool isUser =
      (Hive.box(userDetailsHIVE).get('usermodeldata') as UserModel).isUser;
  @override
  void initState() {
    if (!isUser) {
      getData();
    }

    super.initState();
  }

  Future getData() async {
    final globalAppState = ref.read(Providers.globalAppProvider);

    await globalAppState.getConstraints();
    //getConstraints();
  }

  UserModel userModel = Hive.box(userDetailsHIVE).get('usermodeldata');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          child: AppBar(
            centerTitle: true,
            title: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/gymtracker_white.png',
                    height: 15.h,
                    fit: BoxFit.contain,
                  ),
                  Text(
                    (isUser == false) ? 'DashBoard' : 'Exercises',
                    style: TextStyle(
                      fontFamily: 'gilroy_bolditalic',
                      color: Color(0xffFED428),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            elevation: 0.0,
            backgroundColor: Colors.black.withOpacity(0.5),
          ),
          preferredSize: Size(
            double.infinity,
            50.0,
          ),
        ),
        backgroundColor: Color(0xff1A1F25),
        extendBody: true,
        body: StreamBuilder(
          stream: fireBaseFireStore
              .collection("appsettings")
              .doc('AdminAppSettings')
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData) {
              var snapShotData = snapshot.data;
              final isDashBoardEnabled = snapShotData!['isDashBoardEnabled'];
              return (isDashBoardEnabled)
                  ? (isUser == false)
                      ? Padding(
                          padding: EdgeInsets.only(right: 5.w, left: 5.w),
                          child: Center(
                            child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: StreamBuilder(
                                  stream: fireBaseFireStore
                                      .collection(userModel.enrolledGym!)
                                      .doc('constraints')
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<DocumentSnapshot>
                                          snapshot) {
                                    if (snapshot.hasData) {
                                      Map<String, dynamic> data = snapshot.data!
                                          .data() as Map<String, dynamic>;
                                      GymPartnerConstraints
                                          gymPartnerConstraints =
                                          GymPartnerConstraints.fromMap(data);
                                      return (gymPartnerConstraints
                                              .isDataAccessible!)
                                          ? Center(
                                              child: Column(children: [
                                                dataBar(
                                                  isAccessible:
                                                      gymPartnerConstraints
                                                          .isQRcodeAccessible!,
                                                  featureCaption:
                                                      'A custom QR code generated for Gym Partners to make their members mark their attendance',
                                                  featureName: 'View QR code',
                                                  pic: Icons.qr_code_2,
                                                  func: () {
                                                    (gymPartnerConstraints
                                                            .isQRcodeAccessible!)
                                                        ? Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .push(
                                                                CupertinoPageRoute(
                                                            builder: (context) =>
                                                                QRGenerator(),
                                                          )
                                                                // ScaleRoute(
                                                                //     page:
                                                                //         QRGenerator(),
                                                                //         ),
                                                                )
                                                        : CustomSnackBar
                                                            .buildSnackbar(
                                                            color: Colors.red,
                                                            context: context,
                                                            message:
                                                                'QR generator has been disabled.',
                                                            textcolor:
                                                                const Color(
                                                                    0xffFDFFFC),
                                                            iserror: true,
                                                          );
                                                  },
                                                  isIcon: true,
                                                  height: 45,
                                                  bottomVal: -8,
                                                  rightVal: -8,
                                                ),
                                                dataBar(
                                                  isAccessible:
                                                      (gymPartnerConstraints
                                                          .isViewUsersAccessible!),
                                                  featureCaption:
                                                      'All the registered gym members can be viewed here.',
                                                  featureName: 'View User(s)',
                                                  pic:
                                                      'assets/images/view-users.png',
                                                  func: () {
                                                    (gymPartnerConstraints
                                                            .isViewUsersAccessible!)
                                                        ? Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .push(
                                                                CupertinoPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    MyUsers(),
                                                          )
                                                                // ScaleRoute(
                                                                //     page:
                                                                //         MyUsers()),
                                                                )
                                                        : CustomSnackBar
                                                            .buildSnackbar(
                                                            color: Colors.red,
                                                            context: context,
                                                            message:
                                                                'View users has been disabled.',
                                                            textcolor:
                                                                const Color(
                                                                    0xffFDFFFC),
                                                            iserror: true,
                                                          );
                                                  },
                                                  isIcon: false,
                                                ),
                                                dataBar(
                                                    isAccessible:
                                                        (gymPartnerConstraints
                                                            .isAddUserManuallyAccessible!),
                                                    featureCaption:
                                                        'Register a user and get him enrolled to the gym manually.',
                                                    featureName:
                                                        'Add User Manually',
                                                    pic:
                                                        'assets/images/view-users.png',
                                                    func: () {
                                                      (gymPartnerConstraints
                                                              .isAddUserManuallyAccessible!)
                                                          ? Navigator.of(
                                                                  context,
                                                                  rootNavigator:
                                                                      true)
                                                              .push(
                                                                  CupertinoPageRoute(
                                                              builder: (context) =>
                                                                  AddUserManually(),
                                                            )
                                                                  // ScaleRoute(
                                                                  //     page:
                                                                  //         AddUserManually(),),
                                                                  )
                                                          : CustomSnackBar
                                                              .buildSnackbar(
                                                              color: Colors.red,
                                                              context: context,
                                                              message:
                                                                  'Adding users manually has been disabled.',
                                                              textcolor:
                                                                  const Color(
                                                                      0xffFDFFFC),
                                                              iserror: true,
                                                            );
                                                    },
                                                    isIcon: true),
                                                dataBar(
                                                  isAccessible:
                                                      (gymPartnerConstraints
                                                          .isMarkAttendanceManuallyAccessible!),
                                                  featureCaption:
                                                      'This feature lets an admin to search for a gym member mark their attendance.',
                                                  featureName:
                                                      'Mark Attendance Manually',
                                                  pic:
                                                      'assets/images/manualattendance.png',
                                                  isIcon: false,
                                                  height: 40,
                                                  bottomVal: -2,
                                                  rightVal: -2,
                                                  func: () {
                                                    (gymPartnerConstraints
                                                            .isMarkAttendanceManuallyAccessible!)
                                                        ? Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .push(
                                                                CupertinoPageRoute(
                                                            builder: (context) =>
                                                                ManualDailyAttendance(),
                                                          )
                                                                // ScaleRoute(
                                                                //     page:
                                                                //         ManualDailyAttendance()),
                                                                )
                                                        : CustomSnackBar
                                                            .buildSnackbar(
                                                            color: Colors.red,
                                                            context: context,
                                                            message:
                                                                'Marking attendance manually has been disabled.',
                                                            textcolor:
                                                                const Color(
                                                                    0xffFDFFFC),
                                                            iserror: true,
                                                          );
                                                  },
                                                ),
                                                dataBar(
                                                  isAccessible:
                                                      (gymPartnerConstraints
                                                          .isSearchUserAccessible!),
                                                  featureCaption:
                                                      'Search for the enrolled gym members to get their detailed info.',
                                                  featureName: 'Search User',
                                                  pic: Icons.search,
                                                  isIcon: true,
                                                  height: 50,
                                                  bottomVal: -12,
                                                  rightVal: -10,
                                                  func: () {
                                                    (gymPartnerConstraints
                                                            .isSearchUserAccessible!)
                                                        ? Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .push(
                                                                CupertinoPageRoute(
                                                            builder: (context) =>
                                                                SearchUsers(),
                                                          )
                                                                // ScaleRoute(
                                                                //     page:
                                                                //         SearchUsers()),
                                                                )
                                                        : CustomSnackBar
                                                            .buildSnackbar(
                                                            color: Colors.red,
                                                            context: context,
                                                            message:
                                                                'Search users has been disabled.',
                                                            textcolor:
                                                                const Color(
                                                                    0xffFDFFFC),
                                                            iserror: true,
                                                          );
                                                  },
                                                ),
                                                dataBar(
                                                  isAccessible:
                                                      (gymPartnerConstraints
                                                          .isExpiredUsersAccessible!),
                                                  featureCaption:
                                                      'All the Gym-Members whose membership had been expired can be viewed here.',
                                                  featureName:
                                                      'Expired User(s)',
                                                  pic:
                                                      'assets/images/expired-usesr.png',
                                                  func: () {
                                                    (gymPartnerConstraints
                                                            .isExpiredUsersAccessible!)
                                                        ? Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .push(
                                                                CupertinoPageRoute(
                                                            builder: (context) =>
                                                                ExpiredUsers(),
                                                          )
                                                                // ScaleRoute(
                                                                //     page:
                                                                //         ExpiredUsers()),
                                                                )
                                                        : CustomSnackBar
                                                            .buildSnackbar(
                                                            color: Colors.red,
                                                            context: context,
                                                            message:
                                                                'Viewing of Expired users has been disabled.',
                                                            textcolor:
                                                                const Color(
                                                                    0xffFDFFFC),
                                                            iserror: true,
                                                          );
                                                  },
                                                  isIcon: false,
                                                  bottomVal: -5,
                                                  rightVal: -1,
                                                  height: 40,
                                                ),
                                                dataBar(
                                                  isAccessible:
                                                      (gymPartnerConstraints
                                                          .isTodaysAttendanceAccessible!),
                                                  featureCaption:
                                                      'Gym members who marked their attendance today can be viewed here.',
                                                  featureName:
                                                      'Today\'s Attendance',
                                                  pic:
                                                      'assets/images/todays_attendance.png',
                                                  func: () {
                                                    (gymPartnerConstraints
                                                            .isTodaysAttendanceAccessible!)
                                                        ? Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .push(
                                                                CupertinoPageRoute(
                                                            builder: (context) =>
                                                                TodaysAttendance(),
                                                          )
                                                                // ScaleRoute(
                                                                //     page:
                                                                //         TodaysAttendance()),
                                                                )
                                                        : CustomSnackBar
                                                            .buildSnackbar(
                                                            color: Colors.red,
                                                            context: context,
                                                            message:
                                                                'Viewing today\'s attendance has been disabled.',
                                                            textcolor:
                                                                const Color(
                                                                    0xffFDFFFC),
                                                            iserror: true,
                                                          );
                                                  },
                                                  isIcon: false,
                                                  height: 40,
                                                  bottomVal: -2,
                                                  rightVal: -2,
                                                ),
                                                dataBar(
                                                  isAccessible:
                                                      (gymPartnerConstraints
                                                          .isDateWiseAttendanceAccessible!),
                                                  featureCaption:
                                                      'Choosing the specific date from the drop down allows to view the attendance for that respective date.',
                                                  featureName:
                                                      'DateWise Attendance',
                                                  pic:
                                                      'assets/images/datewise-attendance.png',
                                                  func: () {
                                                    (gymPartnerConstraints
                                                            .isDateWiseAttendanceAccessible!)
                                                        ? Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .push(
                                                                CupertinoPageRoute(
                                                            builder: (context) =>
                                                                AttendanceByDate(),
                                                          )
                                                                // ScaleRoute(
                                                                //     page:
                                                                //         AttendanceByDate(),),
                                                                )
                                                        : CustomSnackBar
                                                            .buildSnackbar(
                                                            color: Colors.red,
                                                            context: context,
                                                            message:
                                                                'Date-wise attendance viewing has been disabled.',
                                                            textcolor:
                                                                const Color(
                                                                    0xffFDFFFC),
                                                            iserror: true,
                                                          );
                                                  },
                                                  isIcon: false,
                                                  height: 40,
                                                  bottomVal: -2,
                                                  rightVal: -2,
                                                ),
                                                dataBar(
                                                  isAccessible:
                                                      (gymPartnerConstraints
                                                          .isMonthWiseAttendanceAccessible!),
                                                  featureCaption:
                                                      'Choosing the specific month from the drop down allows to view the attendance for that respective month.',
                                                  featureName:
                                                      'MonthWise Attendance',
                                                  pic:
                                                      'assets/images/month-wise-attendance.png',
                                                  func: () {
                                                    (gymPartnerConstraints
                                                            .isMonthWiseAttendanceAccessible!)
                                                        ? Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .push(
                                                                CupertinoPageRoute(
                                                            builder: (context) =>
                                                                AttendanceByMonth(),
                                                          )
                                                                // ScaleRoute(
                                                                //     page:
                                                                //         AttendanceByMonth()),
                                                                )
                                                        : CustomSnackBar
                                                            .buildSnackbar(
                                                            color: Colors.red,
                                                            context: context,
                                                            message:
                                                                'Month-wise attendance viewing has been disabled.',
                                                            textcolor:
                                                                const Color(
                                                                    0xffFDFFFC),
                                                            iserror: true,
                                                          );
                                                  },
                                                  isIcon: false,
                                                  height: 40,
                                                  bottomVal: -2,
                                                  rightVal: -2,
                                                ),
                                                dataBar(
                                                  isAccessible:
                                                      (gymPartnerConstraints
                                                          .isRenewUsersAccessible!),
                                                  featureCaption:
                                                      'Users whose membership got expired can be renewed here.',
                                                  featureName: 'Renew User(s)',
                                                  func: () {
                                                    (gymPartnerConstraints
                                                            .isRenewUsersAccessible!)
                                                        ? Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .push(
                                                                CupertinoPageRoute(
                                                            builder: (context) =>
                                                                RenewMembershipsPage(),
                                                          )
                                                                // ScaleRoute(
                                                                //     page:
                                                                //         RenewMembershipsPage()),
                                                                )
                                                        : CustomSnackBar
                                                            .buildSnackbar(
                                                            color: Colors.red,
                                                            context: context,
                                                            message:
                                                                'Renewal of users has been disabled.',
                                                            textcolor:
                                                                const Color(
                                                                    0xffFDFFFC),
                                                            iserror: true,
                                                          );
                                                  },
                                                  pic:
                                                      'assets/images/renew-user.png',
                                                  isIcon: false,
                                                  height: 50,
                                                  bottomVal: -2,
                                                  rightVal: -2,
                                                ),
                                                SizedBox(
                                                  height: 90.h,
                                                ),
                                              ]),
                                            )
                                          : SizedBox(
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              child: Center(
                                                child: Text(
                                                  'Data access has been disabled. Kindly contact your supervisor.',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Color(0xff7E7D7D),
                                                      fontSize: 20.sp,
                                                      fontFamily:
                                                          'gilroy_bolditalic'),
                                                ),
                                              ),
                                            );
                                    } else {
                                      return Center(
                                          child: Loader(
                                        loadercolor: Color(0xffFED428),
                                      ));
                                    }
                                  }),
                            ),
                          ),
                        )
                      : Container()
                  : Center(
                      child: Text(
                        snapShotData['dashBoardDisableText'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xff7E7D7D),
                            fontSize: 20.sp,
                            fontFamily: 'gilroy_bolditalic'),
                      ),
                    );
            } else {
              return Center(
                  child: Loader(
                loadercolor: Color(0xffFED428),
              ));
            }
          },
        ));
  }

  dataBar({
    required String featureName,
    required String featureCaption,
    required var pic,
    required bool isIcon,
    required bool isAccessible,
    required Function func,
    double bottomVal = -22,
    double rightVal = -1,
    double height = 50,
  }) {
    return ValueListenableBuilder<Box<dynamic>>(
        valueListenable: Hive.box(maxClickAttemptsHIVE).listenable(),
        builder: (context, value, child) {
          return Padding(
            padding: EdgeInsets.only(top: 15.h),
            child: InkWell(
              borderRadius: BorderRadius.circular(15.r),
              onTap: () => ((featureName == 'DateWise Attendance' &&
                          value.get('currAttendanceByDateInCurrentMonthCount') <
                              1) ||
                      (featureName == 'MonthWise Attendance' &&
                          value.get('currMonthlyAttendanceCount') < 1))
                  ? CustomSnackBar.buildSnackbar(
                      color: Colors.red[500]!,
                      context: context,
                      message: 'limit exceeded for the day !',
                      textcolor: const Color(0xffFDFFFC),
                      iserror: true,
                    )
                  : func(),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.77,
                      height: 90.h,
                      decoration: BoxDecoration(
                        color: (isAccessible)
                            ? ((featureName == 'DateWise Attendance' &&
                                        value.get(
                                                'currAttendanceByDateInCurrentMonthCount') <
                                            1) ||
                                    (featureName == 'MonthWise Attendance' &&
                                        value.get(
                                                'currMonthlyAttendanceCount') <
                                            1))
                                ? Color(0xff7E7D7D).withOpacity(0.5)
                                : Color(0xff2B3038)
                            : Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.r),
                          bottomLeft: Radius.circular(15.r),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 15.w),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        featureName,
                                        style: TextStyle(
                                            fontSize: 17.sp,
                                            color: Colors.white,
                                            fontFamily: 'gilroy_bolditalic'),
                                      ),
                                    ),
                                    (featureName == 'DateWise Attendance' ||
                                            featureName ==
                                                'MonthWise Attendance')
                                        ? ValueListenableBuilder<Box<dynamic>>(
                                            valueListenable:
                                                Hive.box(maxClickAttemptsHIVE)
                                                    .listenable(),
                                            builder: (context, value, child) {
                                              return FittedBox(
                                                fit: BoxFit.scaleDown,
                                                alignment: Alignment.topCenter,
                                                child: Text(
                                                  ' - [${(featureName == 'DateWise Attendance') ? value.get('currAttendanceByDateInCurrentMonthCount').toString() : value.get('currMonthlyAttendanceCount').toString()} left]',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 17.sp,
                                                      color: (value.get(
                                                                      'currAttendanceByDateInCurrentMonthCount') <
                                                                  1 ||
                                                              value.get(
                                                                      'currMonthlyAttendanceCount') <
                                                                  1)
                                                          ? Colors.red
                                                          : Color(0xffFED428),
                                                      fontFamily:
                                                          'gilroy_bolditalic'),
                                                ),
                                              );
                                            })
                                        : Container()
                                  ],
                                ),
                                SizedBox(height: 2.h),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: Text(
                                    featureCaption,
                                    style: TextStyle(
                                        fontSize: 11.sp,
                                        color: Colors.white.withOpacity(0.5),
                                        fontFamily: 'gilroy_regularitalic'),
                                  ),
                                ),
                              ],
                            ),
                            (isIcon)
                                ? (featureName == 'Add User Manually')
                                    ? Positioned(
                                        bottom: -11,
                                        right: -5,
                                        child: Icon(
                                          Icons.person_add_rounded,
                                          color: Color(0xff1A1F25),
                                          size: 50.h,
                                        ),
                                      )
                                    : Positioned(
                                        bottom: bottomVal,
                                        right: rightVal,
                                        child: Icon(
                                          pic,
                                          color: Color(0xff1A1F25),
                                          size: height.h,
                                        ),
                                      )
                                : Positioned(
                                    bottom: bottomVal,
                                    right: rightVal,
                                    child: Image.asset(
                                      pic,
                                      height: height.h,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.12,
                      height: 90.h,
                      decoration: BoxDecoration(
                        color: (isAccessible)
                            ? ((featureName == 'DateWise Attendance' &&
                                        value.get(
                                                'currAttendanceByDateInCurrentMonthCount') <
                                            1) ||
                                    (featureName == 'MonthWise Attendance' &&
                                        value.get(
                                                'currMonthlyAttendanceCount') <
                                            1))
                                ? Color(0xff7E7D7D).withOpacity(0.5)
                                : Color(0xff2B3038)
                            : Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15.r),
                          bottomRight: Radius.circular(15.r),
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Color(0xffFED428),
                        size: 18.w,
                      ),
                    )
                  ]),
            ),
          );
        });
  }
}
