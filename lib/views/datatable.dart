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
    // TODO: implement initState
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
        dataRowHeight: 40,
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
              'marked at',
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
