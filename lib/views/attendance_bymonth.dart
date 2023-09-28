// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymtracker/providers/authentication_providers.dart';
import 'package:gymtracker/widgets/loader.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../controllers/network_controller.dart';
import '../widgets/nointernet_widget.dart';

class AttendanceByMonth extends ConsumerStatefulWidget {
  const AttendanceByMonth({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<AttendanceByMonth> createState() => _AttendanceByMonthState();
}

class _AttendanceByMonthState extends ConsumerState<AttendanceByMonth> {
  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  getData() async {
    final attendanceByMonthState = ref.read(attendanceByMonthProvider);
    attendanceByMonthState.getGymPartnerDetails();
    //await attendanceByMonthState.getAvailableMonths();
    // await attendanceByMonthState.getDatesListFromGymPartner();
    // await attendanceByMonthState.getWholeAttendanceByMonthData();
  }

  @override
  Widget build(BuildContext context) {
    var connectivityStatusProvider = ref.watch(connectivityStatusProviders);

    //attendanceByMonthState.getGymDetails(widget.enrolledUsers, widget.gymName);
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
                        'Attendance By Month',
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
              child: Column(children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.h, vertical: 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        //height: 35.h,
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Consumer(builder: (context, ref, child) {
                          final attendanceByMonthState =
                              ref.watch(attendanceByMonthProvider);
                          return DropdownButtonFormField<String>(
                            isExpanded: true,
                            menuMaxHeight: 250.h,
                            dropdownColor: color_gt_textColorBlueGrey,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 3.h,
                              ),
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
                                borderSide:
                                    const BorderSide(color: Colors.white12),
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
                            value: attendanceByMonthState.dropdownvalue,
                            hint: Text(
                              'Select month',
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: color_gt_headersTextColorWhite
                                    .withOpacity(0.7),
                                fontFamily: 'gilroy_regular',
                              ),
                            ),
                            onChanged: (value) {
                              attendanceByMonthState
                                  .changeselectedMonth(value!);
                            },
                            items: attendanceByMonthState.availableMonths
                                .map((item) {
                              return DropdownMenuItem<String>(
                                child: Center(
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                      fontFamily: 'gilroy_bolditalic',
                                    ),
                                  ),
                                ),
                                value: item,
                              );
                            }).toList(),
                          );
                        }),
                      ),
                      Consumer(builder: (context, value, child) {
                        final attendanceByMonthState =
                            ref.watch(attendanceByMonthProvider);
                        return (attendanceByMonthState.isDataLoading)
                            ? Loader(
                                loadercolor: Color(0xff2D77D0),
                              )
                            : Material(
                                borderRadius: BorderRadius.circular(10.r),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    color:
                                        (attendanceByMonthState.isMonthSelected)
                                            ? color_gt_green
                                            : Colors.grey,
                                  ),
                                  height: 32.h,
                                  width: 65.w,
                                  child: InkWell(
                                    onTap: () async {
                                      (attendanceByMonthState.dropdownvalue !=
                                                  null &&
                                              attendanceByMonthState
                                                  .attendanceByRow.isEmpty)
                                          ? (attendanceByMonthState
                                                  .isDataLoading)
                                              ? null
                                              : await attendanceByMonthState
                                                  .getWholeAttendanceByMonthData()
                                          : null;
                                    },
                                    child: Center(
                                      child: Icon(
                                        Icons.arrow_forward_ios_sharp,
                                        color: Colors.white,
                                        size: 20.r,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                      }),
                    ],
                  ),
                ),
                Center(
                  child: Consumer(builder: (context, val, __) {
                    final attendanceByMonthState =
                        ref.watch(attendanceByMonthProvider);
                    return Padding(
                      padding: EdgeInsets.only(top: 20.h),
                      child: (attendanceByMonthState.attendanceByRow.isNotEmpty)
                          ? SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              child: SingleChildScrollView(
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  child: getDataTableWidget(
                                      attendanceByMonthState.attendanceByRow,
                                      attendanceByMonthState.columnData)),
                            )
                          : Container(),
                      //
                    );
                  }),
                )
              ]),
            ),
          )
        : NoInternetWidget();
  }

  getDataTableWidget(List rowData, List columnData) {
    //List columnHeadings = ['S.No', 'UserName', 'marked at'];
    List<DataRow> rowDatavar = [];
    int index = 1;
    for (List data in rowData) {
      rowDatavar.add(returnRowData(data, index));
      index++;
    }

    return DataTable(
      border: TableBorder.all(
          color: color_gt_textColorBlueGrey,
          borderRadius: BorderRadius.circular(10.r)),
      headingRowColor: MaterialStateProperty.all(Colors.white10),
      sortColumnIndex: 1,
      sortAscending: true,
      dataRowHeight: 40,
      headingTextStyle: TextStyle(
        fontSize: 13.sp,
        color: color_gt_green,
        fontFamily: 'gilroy_bold',
      ),
      columns: columnData.map((columnName) {
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

  returnRowData(List rowData, int index) {
    final y = DataRow(cells: DataCellsList(rowData, index));

    return y;
  }

  List<DataCell> DataCellsList(List rowData, int index) {
    List<DataCell> cellsData = [];
    cellsData.add(
      DataCell(
        Text(
          index.toString(),
          style: TextStyle(
            fontSize: 13.sp,
            color: color_gt_headersTextColorWhite,
            fontFamily: 'gilroy_bold',
          ),
        ),
      ),
    );
    for (var e in rowData) {
      var x;
      if (e.runtimeType == String) {
        x = e;
      } else if (e.runtimeType == List) {
        //print(e);
        List temp = [];
        for (var i in e) {
          if (i.runtimeType == DateTime) {
            temp.add(DateFormat.jm().format(i).toString());
          } else {
            temp.add('-');
          }
        }
        x = temp.join('   |   ');
      }
      cellsData.add(DataCellWidget(x));
    }
    return cellsData;
  }

  DataCell DataCellWidget(String data) {
    return DataCell(
      Center(
        child: Text(
          data.toString(),
          style: TextStyle(
            fontSize: 13.sp,
            color: color_gt_headersTextColorWhite,
            fontFamily: 'gilroy_bold',
          ),
        ),
      ),
    );
  }
}
