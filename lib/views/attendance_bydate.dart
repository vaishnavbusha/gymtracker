// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, avoid_print

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymtracker/providers/authentication_providers.dart';
import 'package:gymtracker/views/datatable.dart';
import 'package:gymtracker/widgets/nointernet_widget.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../controllers/network_controller.dart';

class AttendanceByDate extends ConsumerStatefulWidget {
  const AttendanceByDate({Key? key}) : super(key: key);

  @override
  ConsumerState<AttendanceByDate> createState() => _AttendanceByDateState();
}

class _AttendanceByDateState extends ConsumerState<AttendanceByDate> {
  @override
  void initState() {
    getdates();
    print('initstate of attendance by date');
    // TODO: implement initState
    super.initState();
  }

  getdates() async {
    final x = ref.read(attendanceByDateProvider);
    await x.getDatesListFromGymPartner();
  }

  final monthData = DateFormat('MMM').format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    var connectivityStatusProvider = ref.watch(connectivityStatusProviders);
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
                        'Attendance By Date ($monthData)',
                        style: TextStyle(
                            fontFamily: 'gilroy_bold',
                            color: color_gt_green,
                            fontSize: 18.sp,
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
                child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 5.h, left: 10.w, right: 10.w, bottom: 10.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Select Date:  ',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: color_gt_green,
                                fontFamily: 'gilroy_bold',
                              ),
                            ),
                            SizedBox(
                              //height: 44.h,
                              width: 240.w,
                              child: Consumer(builder: (context, ref, child) {
                                final attendanceByDateState =
                                    ref.watch(attendanceByDateProvider);
                                return DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  dropdownColor: color_gt_textColorBlueGrey,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white10,
                                    floatingLabelStyle: TextStyle(
                                      fontFamily: "gilroy_bolditalic",
                                      fontSize: 16.sp,
                                      color: color_gt_headersTextColorWhite
                                          .withOpacity(0.9),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                      borderSide: const BorderSide(
                                          color: Colors.white12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                      borderSide: BorderSide(
                                          color: color_gt_textColorBlueGrey
                                              .withOpacity(0.3)),
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: color_gt_headersTextColorWhite,
                                    fontFamily: 'gilroy_regular',
                                  ),
                                  value: attendanceByDateState.dropdownvalue,
                                  hint: Text(
                                    'Select dates to show data',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      color: color_gt_headersTextColorWhite
                                          .withOpacity(0.7),
                                      fontFamily: 'gilroy_regular',
                                    ),
                                  ),
                                  onChanged: (value) {
                                    attendanceByDateState
                                        .changeselectedDate(value!);
                                  },
                                  items: attendanceByDateState
                                      .availabledatesList
                                      .map((item) {
                                    return DropdownMenuItem<String>(
                                      child: Center(
                                        child: Text(
                                          item,
                                        ),
                                      ),
                                      value: item,
                                    );
                                  }).toList(),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      Consumer(builder: (context, value, child) {
                        final attendanceByDateState =
                            ref.watch(attendanceByDateProvider);
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 90.h),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              //onPrimary: Colors.black,  //to change text color
                              padding: EdgeInsets.symmetric(
                                  vertical: 7.h, horizontal: 10.w),
                              primary: (attendanceByDateState.isDateSelected)
                                  ? color_gt_green
                                  : Colors.grey, // button color
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(10.r), // <-- Radius
                              ),
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.sp,
                                  fontFamily: 'gilroy_bold'),
                            ),
                            onPressed: () async {
                              (attendanceByDateState.isDateSelected)
                                  ? await attendanceByDateState
                                      .getAttendanceListByDate()
                                  : null;
                            },
                            child: Text(
                              'Fetch',
                            ),
                          ),
                        );
                      }),
                      Consumer(builder: (context, val, __) {
                        final attendanceByDateState =
                            ref.watch(attendanceByDateProvider);
                        return Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: (attendanceByDateState
                                  .attendanceData.isNotEmpty)
                              ? SingleChildScrollView(
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  child: SingleChildScrollView(
                                      physics: BouncingScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      child: DataTableWidget(
                                        attendanceData: attendanceByDateState
                                            .attendanceData,
                                      )),
                                )
                              : Container(),
                          //
                        );
                      })
                    ],
                  ),
                  //
                )),
          )
        : NoInternetWidget();
  }
}
