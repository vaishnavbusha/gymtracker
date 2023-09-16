// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_null_comparison

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymtracker/models/user_model.dart';
import 'package:gymtracker/providers/authentication_providers.dart';
import 'package:gymtracker/views/attendance_bydate.dart';
import 'package:gymtracker/views/attendance_bymonth.dart';
import 'package:gymtracker/views/expiredusers.dart';
import 'package:gymtracker/views/renewmembership.dart';
import 'package:gymtracker/views/datatable.dart';
import 'package:gymtracker/views/searchusers.dart';
import 'package:gymtracker/views/today_attendance.dart';
import 'package:gymtracker/views/viewmyusers.dart';
import 'package:gymtracker/widgets/loader.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

import '../constants.dart';

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
    //(!isUser) ? getData() : null;
    // TODO: implement initState
    super.initState();
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
                      color: color_gt_green,
                      fontSize: 20.sp,
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
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xff122B32), Colors.black],
          ),
        ),
        child: SafeArea(
          child: (isUser == false)
              ? Padding(
                  padding:
                      EdgeInsets.only(right: 10, top: 20, bottom: 20, left: 10),
                  child: Center(
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      childAspectRatio: 1.2,
                      padding: EdgeInsets.all(4.w),
                      mainAxisSpacing: 15.0,
                      crossAxisSpacing: 15.0,
                      children: <Widget>[
                        viewButton(' My Users', () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (_) => MyUsers(),
                            ),
                          );
                        }),
                        viewButton('Search User(s)', () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (_) => SearchUsers(),
                            ),
                          );
                        }),
                        viewButton('Expired User(s)', () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (_) => ExpiredUsers(),
                            ),
                          );
                        }),
                        viewButton(' Today\'s attendance', () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (_) => TodaysAttendance(),
                            ),
                          );
                        }),
                        viewButton(' Attendance by date in current month', () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (_) => AttendanceByDate(),
                            ),
                          );
                        }),
                        viewButton(' Attendance monthly basis', () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (_) => AttendanceByMonth(),
                            ),
                          );
                        }),
                        // viewButton('Expired User(s)', () {
                        //   Navigator.of(context, rootNavigator: true).push(
                        //     MaterialPageRoute(
                        //       builder: (_) => RenewMembershipsPage(),
                        //     ),
                        //   );
                        // }),
                        // viewButton('Download Monthly report', () {}),
                        viewButton('Renewal Request(s) ', () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (_) => RenewMembershipsPage(),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                )
              : Container(),
        ),
      ),
    );
  }

  viewButton(String text, Function func) {
    return Material(
      borderRadius: BorderRadius.circular(15.r),
      child: Ink(
        decoration: BoxDecoration(
          color: color_gt_green,
          borderRadius: BorderRadius.circular(15.r),
          //border: Border.all(width: 1, color: Colors.white12),
        ),
        child: InkWell(
          onTap: () => func(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.sp,
                  color: color_gt_headersTextColorWhite,
                  fontFamily: 'gilroy_bolditalic',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
