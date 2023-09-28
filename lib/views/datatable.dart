// ignore_for_file: must_be_immutable, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../models/attendance_display_model.dart';

class DataTableWidget extends StatefulWidget {
  List attendanceData;
  DataTableWidget({Key? key, required this.attendanceData}) : super(key: key);

  @override
  State<DataTableWidget> createState() => _DataTableWidgetState();
}

class _DataTableWidgetState extends State<DataTableWidget> {
  @override
  void initState() {
    super.initState();
  }

  List<DataRow>? rowDatavar;
  var isAscending = true;
  var sortColumnIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<DataRow> rowDatavar = returnRowData(widget.attendanceData);
    return Theme(
      data: Theme.of(context).copyWith(
          iconTheme:
              Theme.of(context).iconTheme.copyWith(color: color_gt_green)),
      child: DataTable(
        border: TableBorder.all(
            color: color_gt_textColorBlueGrey,
            borderRadius: BorderRadius.circular(10)),
        headingRowColor: MaterialStateProperty.all(Colors.white10),
        sortAscending: isAscending,
        sortColumnIndex: sortColumnIndex,
        dataRowHeight: 40.h,
        headingTextStyle: TextStyle(
          fontSize: 13.sp,
          color: color_gt_green,
          fontFamily: 'gilroy_bold',
        ),
        columns: <DataColumn>[
          DataColumn(
            label: const Text(
              'S.No',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            onSort: (columnIndex, ascending) {
              print("columnIndex:$columnIndex");
              print("ascending:$ascending");
              setState(() {
                sortColumnIndex = columnIndex;
                isAscending = ascending;
              });
            },
          ),
          DataColumn(
            label: const Text(
              'UserName',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            onSort: (columnIndex, ascending) {
              print("columnIndex:$columnIndex");
              print("ascending:$ascending");
              setState(() {
                sortColumnIndex = columnIndex;
                isAscending = ascending;
                if (ascending) {
                  widget.attendanceData
                      .sort((a, b) => a.userName.compareTo(b.userName));
                } else {
                  widget.attendanceData
                      .sort((a, b) => b.userName.compareTo(a.userName));
                }
              });
            },
          ),
          DataColumn(
            label: const Text(
              'Time-in',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            onSort: (columnIndex, ascending) {
              print("columnIndex:$columnIndex");
              print("ascending:$ascending");
              setState(() {
                sortColumnIndex = columnIndex;
                isAscending = ascending;
                if (isAscending) {
                  widget.attendanceData.sort(
                      (a, b) => a.scannedDateTime.compareTo(b.scannedDateTime));
                } else {
                  widget.attendanceData.sort(
                      (a, b) => b.scannedDateTime.compareTo(a.scannedDateTime));
                }
              });
            },
          ),
          const DataColumn(
            label: Text(
              'Time-out',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            // onSort: (columnIndex, ascending) {
            //   print("columnIndex:$columnIndex");
            //   print("ascending:$ascending");
            //   setState(() {
            //     sortColumnIndex = columnIndex;
            //     isAscending = ascending;
            //     if (isAscending) {
            //       widget.attendanceData.sort((a, b) =>
            //           a.exitScannedDateTime.compareTo(b.exitScannedDateTime));
            //     } else {
            //       widget.attendanceData.sort((a, b) =>
            //           b.exitScannedDateTime.compareTo(a.exitScannedDateTime));
            //     }
            //   });
            // },
          ),
        ],
        rows: rowDatavar,
      ),
    );
  }

  void onSort(int columnIndex, bool isAscending) {
    setState(() {});
  }

  returnRowData(List rowData) {
    List<DataRow> dataRowvar = [];

    for (AttendanceDisplayModel attendanceDisplayModel in rowData) {
      final timeIn = DateFormat.jm()
          .format(attendanceDisplayModel.scannedDateTime!)
          .toString();
      final timeoutdata = attendanceDisplayModel.exitScannedDateTime ?? 'NA';
      String timeOut;
      if (timeoutdata != 'NA') {
        timeOut = DateFormat.jm().format(timeoutdata as DateTime).toString();
      } else {
        timeOut = 'NA';
      }

      final y = DataRow(
        cells: [
          DataCell(
            Center(
              child: Text(
                attendanceDisplayModel.index.toString(),
                style: TextStyle(
                  fontSize: 13.sp,
                  color: color_gt_headersTextColorWhite,
                  fontFamily: 'gilroy_bold',
                ),
              ),
            ),
          ),
          DataCell(
            Center(
              child: Text(
                attendanceDisplayModel.userName!,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: color_gt_headersTextColorWhite,
                  fontFamily: 'gilroy_regularitalic',
                ),
              ),
            ),
          ),
          DataCell(
            Center(
              child: Text(
                timeIn,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: color_gt_headersTextColorWhite,
                  fontFamily: 'gilroy_regularitalic',
                ),
              ),
            ),
          ),
          DataCell(
            Center(
              child: Text(
                timeOut,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: (timeOut == 'NA')
                      ? Colors.red
                      : color_gt_headersTextColorWhite,
                  fontFamily: (timeOut == 'NA')
                      ? 'gilroy_bolditalic'
                      : 'gilroy_regularitalic',
                ),
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
