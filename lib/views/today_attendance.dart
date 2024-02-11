// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable, unnecessary_null_comparison

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymtracker/controllers/todays_attendance_controller.dart';
import 'package:gymtracker/providers/providers.dart';
import 'package:gymtracker/views/datatable.dart';
import 'package:gymtracker/widgets/loader.dart';
import 'package:gymtracker/widgets/nointernet_widget.dart';
import 'package:intl/intl.dart';
import '../controllers/network_controller.dart';

class TodaysAttendance extends ConsumerStatefulWidget {
  const TodaysAttendance({Key? key}) : super(key: key);

  @override
  ConsumerState<TodaysAttendance> createState() => _TodaysAttendanceState();
}

class _TodaysAttendanceState extends ConsumerState<TodaysAttendance> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    TodaysAttendanceController x = ref.read(Providers.todaysAttendanceProvider);

    //await x.getGymName();
    await x.fetchTodaysAttendance();
  }

  @override
  Widget build(BuildContext context) {
    final todaysAttendanceState = ref.watch(Providers.todaysAttendanceProvider);
    final datetime = DateFormat('dd-MM-yyyy').format(DateTime.now());
    var connectivityStatusProvider =
        ref.watch(Providers.connectivityStatusProviders);

    return (connectivityStatusProvider == ConnectivityStatus.isConnected)
        ? Scaffold(
            appBar: PreferredSize(
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: AppBar(
                    centerTitle: true,
                    title: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Today\'s Attendance ($datetime)',
                        style: TextStyle(
                          fontFamily: 'gilroy_bolditalic',
                          color: Color(0xffFED428),
                        ),
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
            backgroundColor: Color(0xff1A1F25),
            body: (!todaysAttendanceState.isLoading!)
                ? Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: (todaysAttendanceState.isDataAvailable)
                        ? SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                child: DataTableWidget(
                                  attendanceData:
                                      todaysAttendanceState.attendanceData,
                                )),
                          )
                        : Center(
                            child: Text(
                              'No data yet, kindly check again later.',
                              style: TextStyle(
                                fontSize: 20.sp,
                                color: Color(0xff7E7D7D),
                                fontFamily: 'gilroy_bolditalic',
                              ),
                            ),
                          )
                    //
                    )
                : Loader(
                    loadercolor: Color(0xffFED428),
                  ),
          )
        : NoInternetWidget();
  }
}
