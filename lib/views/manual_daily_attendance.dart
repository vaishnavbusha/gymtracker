// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymtracker/providers/authentication_providers.dart';
import 'package:gymtracker/widgets/nointernet_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../constants.dart';
import '../controllers/network_controller.dart';
import '../models/user_model.dart';
import '../widgets/loader.dart';

class ManualDailyAttendance extends ConsumerStatefulWidget {
  const ManualDailyAttendance({Key? key}) : super(key: key);

  @override
  ConsumerState<ManualDailyAttendance> createState() =>
      _ManualDailyAttendanceState();
}

class _ManualDailyAttendanceState extends ConsumerState<ManualDailyAttendance> {
  TextEditingController? _searchController;
  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var connectivityStatusProvider = ref.watch(connectivityStatusProviders);

    return (connectivityStatusProvider == ConnectivityStatus.isConnected)
        ? GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: (Scaffold(
              appBar: PreferredSize(
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                    child: AppBar(
                      centerTitle: true,
                      title: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Manual Attendance',
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
                preferredSize: const Size(
                  double.infinity,
                  50.0,
                ),
              ),
              backgroundColor: Color(0xff1A1F25),
              extendBody: true,
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 256.w,
                          child: TextField(
                            controller: _searchController,
                            cursorHeight: 18.sp,
                            cursorRadius: Radius.circular(30.r),
                            style: TextStyle(
                                fontSize: 15.sp,
                                fontFamily: 'gilroy_regular',
                                color: Colors.white70),
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xff20242A),
                              floatingLabelStyle: TextStyle(
                                fontFamily: "gilroy_bolditalic",
                                fontSize: 16.sp,
                                color: color_gt_headersTextColorWhite
                                    .withOpacity(0.9),
                              ),
                              labelText: 'Enter username to mark attendance',
                              labelStyle: TextStyle(
                                fontSize: 14.sp,
                                color: color_gt_headersTextColorWhite
                                    .withOpacity(0.75),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                                borderSide: BorderSide(
                                    color: color_gt_textColorBlueGrey
                                        .withOpacity(0.2)),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                                borderSide:
                                    BorderSide(color: Colors.red, width: 0.25),
                              ),
                              errorStyle: TextStyle(
                                  fontFamily: 'gilroy_regularitalic',
                                  color: Colors.red[500]!,
                                  fontSize: 12.sp),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                                borderSide: BorderSide(
                                    color: Color(0xff7e7d7d).withOpacity(0.05)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                                borderSide: BorderSide(
                                    color: Color(0xff7e7d7d).withOpacity(0.05)),
                              ),
                            ),
                          ),
                        ),
                        Consumer(builder: (context, ref, child) {
                          final _searchUsersState =
                              ref.watch(addManualAttendanceProvider);

                          return (!_searchUsersState.isSearchLoading)
                              ? Material(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: Ink(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        color: (_searchController!.text
                                                .trim()
                                                .isNotEmpty)
                                            ? (_searchUsersState
                                                    .isSearchLoading)
                                                ? Color(0xff7E7D7D)
                                                : Color(0xffFED428)
                                            : Colors.grey),
                                    height: 32.h,
                                    width: 65.w,
                                    child: InkWell(
                                      onTap: () async {
                                        print(_searchController!.text
                                            .replaceAll(
                                                RegExp("[ \n\t\r\f]"), '')
                                            .length);
                                        (_searchController!.text
                                                .trim()
                                                .isNotEmpty)
                                            ? (_searchUsersState
                                                    .isSearchLoading)
                                                ? null
                                                : await _searchUsersState
                                                    .searchForAUser(
                                                        _searchController!.text
                                                            .replaceAll(
                                                                RegExp(
                                                                    "[ \n\t\r\f]"),
                                                                ''),
                                                        context)
                                            : null;
                                      },
                                      child: Center(
                                        child: Icon(
                                          Icons.arrow_forward_ios_sharp,
                                          color: Color(0xff1A1F25),
                                          size: 20.r,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Loader(
                                  loadercolor: Color(0xffFED428),
                                );
                        }),
                      ],
                    ),
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      final addManualAttendanceState =
                          ref.watch(addManualAttendanceProvider);
                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                        // Add Your Code here.

                        addManualAttendanceState.checkForInitial();
                      });
                      return (addManualAttendanceState.isSearchLoading)
                          ? Container()
                          : (addManualAttendanceState.userModel != null)
                              ? dataWidget(
                                  Gender: addManualAttendanceState
                                      .userModel!.gender,
                                  Name: addManualAttendanceState
                                      .userModel!.userName,
                                  Phone: addManualAttendanceState
                                      .userModel!.phoneNumber
                                      .toString(),
                                  joinedOn: addManualAttendanceState
                                      .userModel!.enrolledGymDate,
                                  expiresOn: addManualAttendanceState
                                      .userModel!.membershipExpiry,
                                  uid: addManualAttendanceState.userModel!.uid,
                                )
                              : Container();
                    },
                  ),
                ]),
              ),
            )),
          )
        : NoInternetWidget();
  }

  dataWidget({
    required String Name,
    required String Phone,
    required String Gender,
    required var joinedOn,
    required var expiresOn,
    required var uid,
  }) {
    return Padding(
      padding:
          EdgeInsets.only(top: 10.h, bottom: 10.h, left: 10.w, right: 10.w),
      child: Column(children: [
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Color(0xff20242A),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Padding(
                      padding: EdgeInsets.only(right: 7.w),
                      child: Container(
                        height: 85.h,
                        decoration: BoxDecoration(
                            color: (Gender == 'Male')
                                ? Colors.blue.withOpacity(0.07)
                                : Colors.pinkAccent.withOpacity(0.07),
                            borderRadius: BorderRadius.circular(10)),
                        child: Icon(
                          (Gender == 'Male') ? Icons.male : Icons.female,
                          color: (Gender == 'Male')
                              ? Colors.blue
                              : Colors.pinkAccent,
                        ),
                      ),
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          getTagNameTextWidget('Name'),
                          getTagNameTextWidget('Phone'),
                          //getTagNameTextWidget('Gender'),
                          getTagNameTextWidget('Renewed On'),
                          getTagNameTextWidget((Hive.box(miscellaneousDataHIVE)
                                  .get('awaitingRenewal'))
                              ? 'Expired On'
                              : 'Expires On'),
                        ]),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          getColonSpacing(),
                          getColonSpacing(),
                          // getColonSpacing(),
                          getColonSpacing(),
                          getColonSpacing(),
                        ]),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          getTagDataTextWidget(Name),
                          getTagDataTextWidget(Phone),
                          // getTagDataTextWidget(Gender),
                          getTagDataTextWidget(joinedOn),
                          getTagDataTextWidget(expiresOn),
                        ]),
                  ]),
                  expiryInDaysButton(expiresOn, uid),
                ]),
          ),
        ),
      ]),
    );
  }

  expiryInDaysButton(var expiresOn, String uid) {
    final addManualAttendanceState = ref.read(addManualAttendanceProvider);
    final noOfDays = addManualAttendanceState.calculateNoOfDays(expiresOn);
    final isRequestedForApproval =
        addManualAttendanceState.isRequestedForApproval(uid);
    return Padding(
      padding: EdgeInsets.only(right: 20.w),
      child: Consumer(builder: (context, ref, __) {
        final addAttendanceManuallyState =
            ref.read(addManualAttendanceProvider);
        return Container(
          decoration: BoxDecoration(
            color: (noOfDays > 15)
                ? (addAttendanceManuallyState.isEnterScanned!)
                    ? Colors.orange
                    : color_gt_green
                : (noOfDays >= 8)
                    ? Colors.orange
                    : (isRequestedForApproval)
                        ? const Color(0xff2D77D0)
                        : Colors.red,
            borderRadius: BorderRadius.circular(5.r),
            border: Border.all(width: 1, color: Colors.white12),
          ),
          child: (addAttendanceManuallyState.todaysAttendanceMarked! &&
                  addAttendanceManuallyState.todaysAttendanceMarked != null)
              ? Padding(
                  padding: EdgeInsets.all(6.w),
                  child: Text(
                    'marked',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: color_gt_headersTextColorWhite,
                      fontFamily: 'gilroy_bolditalic',
                    ),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(6.w),
                  child: (noOfDays < 0)
                      ? Text(
                          (isRequestedForApproval)
                              ? 'Awaiting Renewal'
                              : 'Expired',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: color_gt_headersTextColorWhite,
                            fontFamily: 'gilroy_bolditalic',
                          ),
                        )
                      : (addAttendanceManuallyState.checkLoading)
                          ? LoadingAnimationWidget.stretchedDots(
                              color: color_gt_headersTextColorWhite,
                              size: 20,
                            )
                          : GestureDetector(
                              onTap: () {
                                (addAttendanceManuallyState.isEnterScanned!)
                                    ? addAttendanceManuallyState
                                        .checkOutTime(context)
                                    : addAttendanceManuallyState
                                        .checkInTime(context);
                              },
                              child: Text(
                                (addAttendanceManuallyState.isEnterScanned!)
                                    ? 'mark Out-Time'
                                    : 'mark In-Time',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: color_gt_headersTextColorWhite,
                                  fontFamily: 'gilroy_bolditalic',
                                ),
                              )),
                ),
        );
      }),
    );
  }

  getColonSpacing() {
    return Padding(
      padding: EdgeInsets.only(top: 3, bottom: 3),
      child: Text(
        '  :   ',
        style: TextStyle(
          fontSize: 13.sp,
          color: Color(0xffFED428),
          fontFamily: 'gilroy_bold',
        ),
      ),
    );
  }

  getTagNameTextWidget(String tagName) {
    return Padding(
      padding: EdgeInsets.only(top: 3, bottom: 3),
      child: Text(
        tagName,
        style: TextStyle(
          fontSize: 13.sp,
          color: Color(0xffFED428),
          fontFamily: 'gilroy_bold',
        ),
      ),
    );
  }

  getTagDataTextWidget(var tagData) {
    return Padding(
      padding: EdgeInsets.only(top: 3, bottom: 3),
      child: Text(
        (tagData.runtimeType == DateTime)
            ? DateFormat('dd-MMM-yyyy').format(tagData)
            : tagData,
        style: TextStyle(
          fontSize: 13.sp,
          color: Color(0xff7E7D7D),
          fontFamily: 'gilroy_bolditalic',
        ),
      ),
    );
  }
}
