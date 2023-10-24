// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_null_comparison

import 'dart:ui';

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

import 'package:hive_flutter/adapters.dart';

import '../constants.dart';
import '../providers/authentication_providers.dart';
import '../widgets/customsnackbar.dart';
import 'add_user_manually.dart';
import 'manual_daily_attendance.dart';

class ExplorePage extends ConsumerStatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends ConsumerState<ExplorePage> {
  bool isUser =
      (Hive.box(userDetailsHIVE).get('usermodeldata') as UserModel).isUser;
  @override
  void initState() {
    if (!isUser) {
      getData();
    }
    //(!isUser) ? getData() : null;
    // TODO: implement initState
    super.initState();
  }

  Future getData() async {
    final globalAppState = ref.read(globalAppProvider);

    await globalAppState.getConstraints();
    //getConstraints();
  }

  @override
  Widget build(BuildContext context) {
    //final enrolledUsersState = ref.watch(enrolledUsersProvider);
    return Scaffold(
      appBar: PreferredSize(
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: AppBar(
              centerTitle: true,
              title: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  (isUser == false) ? 'DashBoard' : 'Exercises',
                  style: TextStyle(
                      fontFamily: 'gilroy_bold',
                      color: Color(0xff30d5c8),
                      fontSize: 22.sp,
                      fontStyle: FontStyle.normal),
                  textAlign: TextAlign.center,
                ),
              ),
              elevation: 0.0,
              backgroundColor: Colors.black.withOpacity(0.5),
            ),
          ),
        ),
        preferredSize: Size(
          double.infinity,
          50.0,
        ),
      ),
      backgroundColor: Colors.black,
      extendBody: true,
      body: Container(
        // width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xff122B32), Colors.black],
          ),
        ),
        child: (isUser == false)
            ? Padding(
                padding: EdgeInsets.only(right: 5.w, left: 5.w),
                child: CustomScrollView(
                  primary: false,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  slivers: [
                    SliverGrid.count(
                      crossAxisCount: 2,
                      childAspectRatio: 1.2,
                      mainAxisSpacing: 15.0,
                      crossAxisSpacing: 15.w,
                      children: <Widget>[
                        viewButton('My User(s)', () {
                          Navigator.of(context, rootNavigator: true).push(
                            ScaleRoute(page: MyUsers()),
                          );
                        }),
                        viewButton('Add user manually', () {
                          Navigator.of(context, rootNavigator: true).push(
                            ScaleRoute(page: AddUserManually()),
                          );
                        }),
                        viewButton('Mark attendance manually', () {
                          Navigator.of(context, rootNavigator: true).push(
                            ScaleRoute(page: ManualDailyAttendance()),
                          );
                        }),
                        viewButton('Search User(s)', () {
                          Navigator.of(context, rootNavigator: true).push(
                            ScaleRoute(page: SearchUsers()),
                          );
                        }),
                        viewButton('Expired User(s)', () {
                          Navigator.of(context, rootNavigator: true).push(
                            ScaleRoute(page: ExpiredUsers()),
                          );
                        }),
                        viewButton(' Today\'s attendance', () {
                          Navigator.of(context, rootNavigator: true).push(
                            ScaleRoute(page: TodaysAttendance()),
                          );
                        }),
                        viewButton('Attendance by date in current month', () {
                          Navigator.of(context, rootNavigator: true).push(
                            ScaleRoute(page: AttendanceByDate()),
                          );
                        }),
                        viewButton('Attendance monthly basis', () {
                          Navigator.of(context, rootNavigator: true).push(
                            ScaleRoute(page: AttendanceByMonth()),
                          );
                        }),
                        (Hive.box(miscellaneousDataHIVE)
                                    .get("pendingRenewalsLength") !=
                                null)
                            ? ValueListenableBuilder<Box<dynamic>>(
                                valueListenable: Hive.box(miscellaneousDataHIVE)
                                    .listenable(),
                                builder: (context, box, __) {
                                  return (box.get('pendingRenewalsLength') > 0)
                                      ? viewButton('Renewal Request(s)', () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .push(
                                            ScaleRoute(
                                                page: RenewMembershipsPage()),
                                          );
                                        })
                                      : Container();
                                })
                            : SizedBox(),
                      ],
                    ),
                  ],
                ),
              )
            : Container(),
      ),
    );
  }

  viewButton(String text, Function func) {
    return Material(
      borderRadius: BorderRadius.circular(15.r),
      child: ValueListenableBuilder<Box<dynamic>>(
          valueListenable: Hive.box(maxClickAttemptsHIVE).listenable(),
          builder: (context, value, child) {
            return Ink(
              decoration: BoxDecoration(
                color: ((text == 'Attendance by date in current month' &&
                            value.get(
                                    'currAttendanceByDateInCurrentMonthCount') <
                                1) ||
                        (text == 'Attendance monthly basis' &&
                            value.get('currMonthlyAttendanceCount') < 1))
                    ? Colors.grey
                    : Color(0xff2D77D0),
                borderRadius: BorderRadius.circular(15.r),
                //border: Border.all(width: 1, color: Colors.white12),
              ),
              child: InkWell(
                onTap: () => ((text == 'Attendance by date in current month' &&
                            value.get(
                                    'currAttendanceByDateInCurrentMonthCount') <
                                1) ||
                        (text == 'Attendance monthly basis' &&
                            value.get('currMonthlyAttendanceCount') < 1))
                    ? CustomSnackBar.buildSnackbar(
                        color: Colors.red[500]!,
                        context: context,
                        message: 'limit exceeded for the day !',
                        textcolor: const Color(0xffFDFFFC),
                        iserror: true,
                      )
                    : func(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: color_gt_headersTextColorWhite,
                          fontFamily: 'gilroy_regularitalic',
                        ),
                      ),
                      (text == 'Renewal Request(s)')
                          ? SizedBox(height: 10.h)
                          : Container(),
                      (text == 'Renewal Request(s)')
                          ? (Hive.box(miscellaneousDataHIVE)
                                      .get("pendingRenewalsLength") !=
                                  null)
                              ? ValueListenableBuilder<Box<dynamic>>(
                                  valueListenable:
                                      Hive.box(miscellaneousDataHIVE)
                                          .listenable(),
                                  builder: (context, box, __) {
                                    return (box.get('pendingRenewalsLength') >
                                            0)
                                        ? Text(
                                            box
                                                .get('pendingRenewalsLength')
                                                .toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              color: Color(0xff9fe2bf),
                                              fontFamily: 'gilroy_bolditalic',
                                            ),
                                          )
                                        : Container();
                                  })
                              : Container()
                          : Container(),
                      (text == 'Attendance by date in current month' ||
                              text == 'Attendance monthly basis')
                          ? ValueListenableBuilder<Box<dynamic>>(
                              valueListenable:
                                  Hive.box(maxClickAttemptsHIVE).listenable(),
                              builder: (context, value, child) {
                                return Padding(
                                  padding: EdgeInsets.only(top: 15.h),
                                  child: Text(
                                    '${(text == 'Attendance by date in current month') ? value.get('currAttendanceByDateInCurrentMonthCount').toString() : value.get('currMonthlyAttendanceCount').toString()} attempt(s) left',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      color: color_gt_headersTextColorWhite,
                                      fontFamily: 'gilroy_bolditalic',
                                    ),
                                  ),
                                );
                              },
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
