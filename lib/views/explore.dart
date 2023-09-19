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
                  padding: EdgeInsets.only(
                      right: 10.w, top: 20.h, bottom: 20.h, left: 10.w),
                  child: Center(
                    child: GridView.count(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      childAspectRatio: 1.2,
                      padding: EdgeInsets.all(4.w),
                      mainAxisSpacing: 15.0,
                      crossAxisSpacing: 15.0,
                      children: <Widget>[
                        viewButton(' My Users', () {
                          Navigator.of(context, rootNavigator: true).push(
                            ScaleRoute(page: MyUsers()),
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
                        // viewButton('Expired User(s)', () {
                        //   Navigator.of(context, rootNavigator: true).push(
                        //     MaterialPageRoute(
                        //       builder: (_) => RenewMembershipsPage(),
                        //     ),
                        //   );
                        // }),
                        // viewButton('Download Monthly report', () {}),
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
                            : Container(),
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
          color: Color(0xff2D77D0),
          borderRadius: BorderRadius.circular(15.r),
          //border: Border.all(width: 1, color: Colors.white12),
        ),
        child: InkWell(
          onTap: () => func(),
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
                                Hive.box(miscellaneousDataHIVE).listenable(),
                            builder: (context, box, __) {
                              return (box.get('pendingRenewalsLength') > 0)
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
