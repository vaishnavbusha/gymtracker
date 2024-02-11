// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, avoid_print

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymtracker/providers/providers.dart';
import 'package:gymtracker/views/datatable.dart';
import 'package:gymtracker/widgets/loader.dart';
import 'package:gymtracker/widgets/nointernet_widget.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../controllers/network_controller.dart';
import '../widgets/customsnackbar.dart';

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

    super.initState();
  }

  getdates() async {
    final x = ref.read(Providers.attendanceByDateProvider);
    await x.getDatesListFromGymPartner();
  }

  final monthData = DateFormat('MMM').format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    final attendanceByDateState = ref.watch(Providers.attendanceByDateProvider);
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
                        'Date-Wise Attendance ($monthData)',
                        style: TextStyle(
                          fontFamily: 'gilroy_bolditalic',
                          color: Color(0xffFED428),
                        ),
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
            backgroundColor: Color(0xff1A1F25),
            body: (attendanceByDateState.isDateDataLoading)
                ? const Center(
                    child: Loader(
                      loadercolor: Color(0xffFED428),
                    ),
                  )
                : (attendanceByDateState.availabledatesList.isEmpty &&
                        attendanceByDateState.isDateDataLoading == false)
                    ? Center(
                        child: Text(
                          'No dates available yet. Check again later.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 17.sp,
                              fontFamily: 'gilroy_bolditalic'),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 5.h,
                                  left: 10.w,
                                  right: 10.w,
                                  bottom: 10.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Select Date:  ',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Color(0xffFED428),
                                      fontFamily: 'gilroy_bold',
                                    ),
                                  ),
                                  SizedBox(
                                    //height: 44.h,
                                    width: 240.w,
                                    child: ValueListenableBuilder<Box<dynamic>>(
                                        valueListenable:
                                            Hive.box(maxClickAttemptsHIVE)
                                                .listenable(),
                                        builder: (context, val, child) {
                                          return Consumer(
                                              builder: (context, ref, child) {
                                            final attendanceByDateState =
                                                ref.watch(Providers
                                                    .attendanceByDateProvider);
                                            return DropdownButtonFormField<
                                                String>(
                                              menuMaxHeight: 250.h,
                                              isExpanded: true,
                                              dropdownColor: Color(0xff2B3038),
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Color(0xff20242A),
                                                floatingLabelStyle: TextStyle(
                                                  fontFamily:
                                                      "gilroy_bolditalic",
                                                  fontSize: 16.sp,
                                                  color:
                                                      color_gt_headersTextColorWhite
                                                          .withOpacity(0.9),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                  borderSide: BorderSide(
                                                      color: Color(0xff7e7d7d)
                                                          .withOpacity(0.05)),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                  borderSide: BorderSide(
                                                      color: Color(0xff7e7d7d)
                                                          .withOpacity(0.05)),
                                                ),
                                              ),
                                              style: TextStyle(
                                                fontSize: 13.sp,
                                                color:
                                                    color_gt_headersTextColorWhite,
                                                fontFamily: 'gilroy_regular',
                                              ),
                                              value: attendanceByDateState
                                                  .dropdownvalue,
                                              hint: Text(
                                                'Select dates to show data',
                                                style: TextStyle(
                                                  fontSize: 15.sp,
                                                  color:
                                                      color_gt_headersTextColorWhite
                                                          .withOpacity(0.7),
                                                  fontFamily: 'gilroy_regular',
                                                ),
                                              ),
                                              onChanged: (value) {
                                                val.get('currAttendanceByDateInCurrentMonthCount') <
                                                        1
                                                    ? CustomSnackBar
                                                        .buildSnackbar(
                                                        color: Colors.red[500]!,
                                                        context: context,
                                                        message:
                                                            'limit exceeded for the day !',
                                                        textcolor: const Color(
                                                            0xffFDFFFC),
                                                        iserror: true,
                                                      )
                                                    : attendanceByDateState
                                                        .changeselectedDate(
                                                            value!);
                                              },
                                              items: attendanceByDateState
                                                  .availabledatesList
                                                  .map((item) {
                                                return DropdownMenuItem<String>(
                                                  child: Center(
                                                    child: Text(
                                                      item,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'gilroy_bolditalic',
                                                      ),
                                                    ),
                                                  ),
                                                  value: item,
                                                );
                                              }).toList(),
                                            );
                                          });
                                        }),
                                  ),
                                ],
                              ),
                            ),
                            Consumer(builder: (context, value, child) {
                              final attendanceByDateState =
                                  ref.watch(Providers.attendanceByDateProvider);
                              return (attendanceByDateState.isDataLoading)
                                  ? Loader(
                                      loadercolor: Color(0xffFED428),
                                    )
                                  : Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 90.h),
                                      child: ValueListenableBuilder<
                                              Box<dynamic>>(
                                          valueListenable:
                                              Hive.box(maxClickAttemptsHIVE)
                                                  .listenable(),
                                          builder: (context, value, child) {
                                            return ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                //onPrimary: Colors.black,  //to change text color
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 7.h,
                                                    horizontal: 10.w),
                                                primary: (value.get(
                                                            'currAttendanceByDateInCurrentMonthCount') <
                                                        1)
                                                    ? Colors.grey
                                                    : (attendanceByDateState
                                                            .isDateSelected)
                                                        ? Color(0xffFED428)
                                                        : Colors
                                                            .grey, // button color
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r), // <-- Radius
                                                ),
                                                textStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15.sp,
                                                    fontFamily: 'gilroy_bold'),
                                              ),
                                              onPressed: () async {
                                                (value.get('currAttendanceByDateInCurrentMonthCount') <
                                                        1)
                                                    ? CustomSnackBar
                                                        .buildSnackbar(
                                                        color: Colors.red[500]!,
                                                        context: context,
                                                        message:
                                                            'limit exceeded for the day !',
                                                        textcolor: const Color(
                                                            0xffFDFFFC),
                                                        iserror: true,
                                                      )
                                                    : (attendanceByDateState
                                                            .isDateSelected)
                                                        ? (attendanceByDateState
                                                                .isDataLoading)
                                                            ? null
                                                            : attendanceByDateState
                                                                .getAttendanceListByDate()
                                                        : null;
                                              },
                                              child: Text(
                                                'Fetch',
                                                style: TextStyle(
                                                    color: Color(0xff1A1F25),
                                                    fontSize: 15.sp,
                                                    fontFamily: 'gilroy_bold'),
                                              ),
                                            );
                                          }),
                                    );
                            }),
                            Consumer(builder: (context, val, __) {
                              final attendanceByDateState =
                                  ref.watch(Providers.attendanceByDateProvider);
                              return Padding(
                                padding: EdgeInsets.only(top: 20.h),
                                child: (attendanceByDateState
                                        .attendanceData.isNotEmpty)
                                    ? SingleChildScrollView(
                                        physics: BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        child: SingleChildScrollView(
                                            physics: BouncingScrollPhysics(),
                                            scrollDirection: Axis.vertical,
                                            child: DataTableWidget(
                                              attendanceData:
                                                  attendanceByDateState
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
                      ),
          )
        : NoInternetWidget();
  }
}
