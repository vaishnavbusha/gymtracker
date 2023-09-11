// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable, unnecessary_null_comparison

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymtracker/controllers/todays_attendance_controller.dart';
import 'package:gymtracker/models/attendance_display_model.dart';
import 'package:gymtracker/providers/authentication_providers.dart';
import 'package:gymtracker/widgets/loader.dart';
import 'package:intl/intl.dart';

import '../constants.dart';

class TodaysAttendance extends ConsumerStatefulWidget {
  const TodaysAttendance({Key? key}) : super(key: key);

  @override
  ConsumerState<TodaysAttendance> createState() => _TodaysAttendanceState();
}

class _TodaysAttendanceState extends ConsumerState<TodaysAttendance> {
  @override
  void initState() {
    getData();
    //x.getGymName(widget.gymName);
    // TODO: implement initState
    super.initState();
  }

  getData() async {
    TodaysAttendanceController x = ref.read(todaysAttendanceProvider);

    //await x.getGymName();
    await x.fetchTodaysAttendance();
  }

  @override
  Widget build(BuildContext context) {
    final todaysAttendanceState = ref.watch(todaysAttendanceProvider);
    final datetime = DateFormat('dd-MM-yyyy').format(DateTime.now());
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
                    'Today\'s Attendance ($datetime)',
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
            child: (!todaysAttendanceState.isLoading!)
                ? Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: (todaysAttendanceState.isDataAvailable)
                        ? SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            child: getDataTableWidget(
                                todaysAttendanceState.attendanceData))
                        : Center(
                            child: Text(
                              'No data yet, kindly check again later.',
                              style: TextStyle(
                                fontSize: 20.sp,
                                color: color_gt_headersTextColorWhite,
                                fontFamily: 'gilroy_bold',
                              ),
                            ),
                          )
                    //
                    )
                : Loader(
                    loadercolor: Colors.green,
                  )));
  }

  getDataTableWidget(List rowData) {
    List columnHeadings = ['S.No', 'UserName', 'marked at'];
    List<DataRow> rowDatavar = returnRowData(rowData);

    return DataTable(
      border: TableBorder.all(
          color: color_gt_textColorBlueGrey,
          borderRadius: BorderRadius.circular(10)),
      headingRowColor: MaterialStateProperty.all(Colors.white10),
      sortColumnIndex: 1,
      sortAscending: true,
      dataRowHeight: 40,
      headingTextStyle: TextStyle(
        fontSize: 13.sp,
        color: color_gt_green,
        fontFamily: 'gilroy_bold',
      ),
      columns: columnHeadings.map((columnName) {
        return DataColumn(
          onSort: (columnIndex, ascending) {
            setState(() {
              rowData.sort((a, b) => a.userName.compareTo(b.userName));
            });
          },
          label: Text(
            columnName,
          ),
        );
      }).toList(),
      rows: rowDatavar,
    );
  }

  returnRowData(List rowData) {
    List<DataRow> dataRowvar = [];

    for (AttendanceDisplayModel attendanceDisplayModel in rowData) {
      final time = DateFormat.jm()
          .format(attendanceDisplayModel.scannedDateTime!)
          .toString();
      final y = DataRow(
        cells: [
          DataCell(
            Text(
              attendanceDisplayModel.index.toString(),
              style: TextStyle(
                fontSize: 13.sp,
                color: color_gt_headersTextColorWhite,
                fontFamily: 'gilroy_bold',
              ),
            ),
          ),
          DataCell(
            Text(
              attendanceDisplayModel.userName!,
              style: TextStyle(
                fontSize: 13.sp,
                color: color_gt_headersTextColorWhite,
                fontFamily: 'gilroy_regularitalic',
              ),
            ),
          ),
          DataCell(
            Text(
              time,
              style: TextStyle(
                fontSize: 13.sp,
                color: color_gt_headersTextColorWhite,
                fontFamily: 'gilroy_regularitalic',
              ),
            ),
          ),
        ],
      );
      dataRowvar.add(y);
    }
    return dataRowvar;
  }
}
