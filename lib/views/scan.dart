// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymtracker/constants.dart';
import 'package:gymtracker/models/user_model.dart';
import 'package:gymtracker/providers/providers.dart';
import 'package:gymtracker/widgets/loader.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ScanPage extends ConsumerStatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends ConsumerState<ScanPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    if ((Hive.box(miscellaneousDataHIVE).get("membershipExpiry") != null)) {
      getData();
    }
    super.initState();
  }

  getData() async {
    await ref.read(Providers.scanControllerProvider).initialCheckInOrOutTime();
  }

  @override
  Widget build(BuildContext context) {
    final globalScanState = ref.watch(Providers.scanControllerProvider);
    return Scaffold(
      backgroundColor: Color(0xff1A1F25),
      extendBody: true,
      appBar: PreferredSize(
        child: AppBar(
            centerTitle: true,
            title: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/gymtracker_white.png',
                    height: 15.h,
                    fit: BoxFit.contain,
                  ),
                  Text(
                    'Scanner',
                    style: TextStyle(
                      fontFamily: 'gilroy_bolditalic',
                      color: Color(0xffFED428),
                    ),
                  ),
                ],
              ),
            ),
            elevation: 0.0,
            backgroundColor: Colors.black.withOpacity(0.5)),
        preferredSize: Size(
          double.infinity,
          50.0,
        ),
      ),
      body: StreamBuilder(
        stream: fireBaseFireStore
            .collection("appsettings")
            .doc('UserAppSettings')
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            var snapShotData = snapshot.data;
            final isScanEnabled = snapShotData!['isScanEnabled'];
            return (isScanEnabled)
                ? (globalScanState.isDataReady)
                    ? SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            (Hive.box(miscellaneousDataHIVE)
                                        .get("isAwaitingEnrollment") !=
                                    null)
                                ? ValueListenableBuilder<Box<dynamic>>(
                                    valueListenable:
                                        Hive.box(miscellaneousDataHIVE)
                                            .listenable(),
                                    builder: (context, box, __) {
                                      return (box.get('isAwaitingEnrollment') !=
                                                  null &&
                                              box.get('isAwaitingEnrollment') ==
                                                  true)
                                          ? Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.07,
                                              decoration: BoxDecoration(
                                                color: Color(0xff2B3038),
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(15.r),
                                                  bottomRight:
                                                      Radius.circular(15.r),
                                                ),
                                              ),
                                              alignment: Alignment.topCenter,
                                              child: Padding(
                                                padding: EdgeInsets.all(10.sp),
                                                child: Center(
                                                  child: Text(
                                                    'Awaiting approval from ${(Hive.box(userDetailsHIVE).get('usermodeldata') as UserModel).enrolledGym}. QR Scanner button has been disabled.',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color:
                                                            color_gt_headersTextColorWhite,
                                                        fontSize: 13.sp,
                                                        fontFamily:
                                                            'gilroy_regularitalic'),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container();
                                    })
                                : Container(),
                            (Hive.box(miscellaneousDataHIVE)
                                        .get("membershipExpiry") !=
                                    null)
                                ? ValueListenableBuilder<Box<dynamic>>(
                                    valueListenable:
                                        Hive.box(miscellaneousDataHIVE)
                                            .listenable(),
                                    builder: (context, box, __) {
                                      final date = box.get('membershipExpiry');
                                      int? days;
                                      if (date == null) {
                                        return Container();
                                      } else {
                                        var expiresOn = DateTime(
                                            date.year, date.month, date.day);
                                        days = (expiresOn
                                                    .difference(DateTime.now())
                                                    .inHours /
                                                24)
                                            .round();
                                      }

                                      return (days < 0)
                                          ? Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                color: Color(0xff7e7d7d),
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(15.r),
                                                  bottomRight:
                                                      Radius.circular(15.r),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(15.h),
                                                child: Center(
                                                  child: Text(
                                                    (Hive.box(miscellaneousDataHIVE)
                                                            .get(
                                                                'awaitingRenewal'))
                                                        ? 'Renewal request sent to ${(Hive.box(userDetailsHIVE).get('usermodeldata') as UserModel).enrolledGym}. QR scanner will be enabled post approval.'
                                                        : 'Your membership with ${(Hive.box(userDetailsHIVE).get('usermodeldata') as UserModel).enrolledGym} has been expired, kindly renew your membership from profile page to start using the QR feature.',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13.sp,
                                                        fontFamily:
                                                            'gilroy_regularitalic'),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container();
                                    })
                                : Container(),
                            (globalScanState.isEnterScanned)
                                ? Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(15.r),
                                        bottomRight: Radius.circular(15.r),
                                      ),
                                      color: Colors.orange.withOpacity(0.5),
                                    ),
                                    alignment: Alignment.topCenter,
                                    child: Padding(
                                      padding: EdgeInsets.all(15.sp),
                                      child: Center(
                                        child: Text(
                                          'Today\'s entry time has been marked, kindly re-scan the QR for marking exit-time before leaving the gym.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13.sp,
                                              fontFamily:
                                                  'gilroy_regularitalic'),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                            (globalScanState.todaysAttendanceMarked)
                                ? Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(15.r),
                                        bottomRight: Radius.circular(15.r),
                                      ),
                                    ),
                                    alignment: Alignment.topCenter,
                                    child: Padding(
                                      padding: EdgeInsets.all(15.sp),
                                      child: Center(
                                        child: Text(
                                          "Today's both time-in and time-out has been marked. Scanner will be re-enabled tomorrow.",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13.sp,
                                              fontFamily:
                                                  'gilroy_regularitalic'),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                            Consumer(builder: (context, ref, __) {
                              final scanState =
                                  ref.watch(Providers.scanControllerProvider);
                              return (scanState.isSearchLoading &&
                                      (Hive.box(miscellaneousDataHIVE)
                                              .get("membershipExpiry") !=
                                          null))
                                  ? Center(
                                      child: Loader(
                                        loadercolor: Color(0xffFED428),
                                      ),
                                    )
                                  : Flexible(
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 80.w),
                                              child: (Hive.box(
                                                              miscellaneousDataHIVE)
                                                          .get(
                                                              "membershipExpiry") !=
                                                      null)
                                                  ? ValueListenableBuilder<
                                                          Box<dynamic>>(
                                                      valueListenable: Hive.box(
                                                              miscellaneousDataHIVE)
                                                          .listenable(),
                                                      builder:
                                                          (context, box, __) {
                                                        final date = box.get(
                                                            'membershipExpiry');

                                                        //DateTime? expiresOn;
                                                        bool? isExpired;
                                                        if (date == null) {
                                                          return Container();
                                                        } else {
                                                          isExpired = scanState
                                                              .isExpired(date);
                                                        }

                                                        return ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            //onPrimary: Colors.black,  //to change text color
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        45.w,
                                                                    vertical:
                                                                        12.h),
                                                            primary: (isExpired!)
                                                                ? Colors.red
                                                                : (box.get('isAwaitingEnrollment') == true || scanState.todaysAttendanceMarked
                                                                    // ||
                                                                    // box.get('isTodaysAttendanceMarkCompleted') ==
                                                                    //     true
                                                                    )
                                                                    ? Color(0xff2B3038)
                                                                    : (scanState.isEnterScanned)
                                                                        ? Colors.orange.withOpacity(0.85)
                                                                        : Color(0xffFED428), // button color
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.r), // <-- Radius
                                                            ),
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 20.sp,
                                                                fontFamily:
                                                                    'gilroy_bold'),
                                                          ),
                                                          onPressed: () async {
                                                            if (box.get('isAwaitingEnrollment') ||
                                                                    isExpired! ||
                                                                    scanState
                                                                        .todaysAttendanceMarked
                                                                // ||
                                                                // box.get('isTodaysAttendanceMarkCompleted') ==
                                                                //     true
                                                                ) {
                                                              null;
                                                            } else {
                                                              String
                                                                  barcodeScanRes =
                                                                  await FlutterBarcodeScanner.scanBarcode(
                                                                      "#ff6666",
                                                                      'cancel',
                                                                      false,
                                                                      ScanMode
                                                                          .QR);
                                                              await scanState
                                                                  .getScannedData(
                                                                      barcodeScanRes,
                                                                      context);
                                                            }
                                                          },
                                                          child: (box.get(
                                                                      'isAwaitingEnrollment') ==
                                                                  true)
                                                              ? Text(
                                                                  'Awaiting Approval',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        17.sp,
                                                                    color:
                                                                        color_gt_headersTextColorWhite,
                                                                    fontFamily:
                                                                        'gilroy_bolditalic',
                                                                  ),
                                                                )
                                                              : (isExpired)
                                                                  ? Padding(
                                                                      padding: EdgeInsets
                                                                          .all(8
                                                                              .h),
                                                                      child:
                                                                          Text(
                                                                        (box.get('awaitingRenewal') ==
                                                                                true)
                                                                            ? 'Pending'
                                                                            : 'Expired',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              18.sp,
                                                                          color:
                                                                              Colors.white,
                                                                          fontFamily:
                                                                              'gilroy_bolditalic',
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceAround,
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .qr_code_scanner_rounded,
                                                                          size:
                                                                              30.w,
                                                                          color: (scanState.todaysAttendanceMarked)
                                                                              ? Color(0xffFED428)
                                                                              : Color(0xff1A1F25),
                                                                        ),
                                                                        (scanState.todaysAttendanceMarked)
                                                                            ? Padding(
                                                                                padding: EdgeInsets.all(6.w),
                                                                                child: Text(
                                                                                  'marked',
                                                                                  style: TextStyle(
                                                                                    fontSize: 17.sp,
                                                                                    color: Color(0xffFED428),
                                                                                    fontFamily: 'gilroy_bolditalic',
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            : (scanState.checkLoading)
                                                                                ? LoadingAnimationWidget.stretchedDots(
                                                                                    color: Color(0xff1A1F25),
                                                                                    size: 20,
                                                                                  )
                                                                                : Text(
                                                                                    (scanState.isEnterScanned) ? 'Out-Time' : 'Scan QR',
                                                                                    style: TextStyle(
                                                                                      fontSize: 18.sp,
                                                                                      color: Color(0xff1A1F25),
                                                                                      fontFamily: 'gilroy_bolditalic',
                                                                                    ),
                                                                                  ),
                                                                      ],
                                                                    ),
                                                        );
                                                      })
                                                  : ValueListenableBuilder<
                                                          Box<dynamic>>(
                                                      valueListenable: Hive.box(
                                                              miscellaneousDataHIVE)
                                                          .listenable(),
                                                      builder:
                                                          (context, box, __) {
                                                        return ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            //onPrimary: Colors.black,  //to change text color
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        25.w,
                                                                    vertical:
                                                                        7.h),
                                                            primary: (box.get(
                                                                    'isAwaitingEnrollment')
                                                                //     ||
                                                                // box.get('isTodaysAttendanceMarkCompleted') ==
                                                                //     true
                                                                )
                                                                ? Color(
                                                                    0xff2B3038)
                                                                : Color(
                                                                    0xffFED428), // button color
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.r), // <-- Radius
                                                            ),
                                                            textStyle: TextStyle(
                                                                color: Color(
                                                                    0xff1A1F25),
                                                                fontSize: 20.sp,
                                                                fontFamily:
                                                                    'gilroy_bolditalic'),
                                                          ),
                                                          onPressed: () async {
                                                            if (box.get(
                                                                'isAwaitingEnrollment')) {
                                                              null;
                                                            } else {
                                                              String
                                                                  barcodeScanRes =
                                                                  await FlutterBarcodeScanner.scanBarcode(
                                                                      "#ff6666",
                                                                      'cancel',
                                                                      false,
                                                                      ScanMode
                                                                          .QR);
                                                              scanState
                                                                  .getScannedData(
                                                                      barcodeScanRes,
                                                                      context);
                                                            }
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .qr_code_scanner_rounded,
                                                                  size: 30.w,
                                                                  color: (box.get(
                                                                          'isAwaitingEnrollment'))
                                                                      ? Colors
                                                                          .grey
                                                                      : Color(
                                                                          0xff1A1F25),
                                                                ),
                                                                SizedBox(
                                                                    width:
                                                                        10.w),
                                                                ValueListenableBuilder<
                                                                        Box<
                                                                            dynamic>>(
                                                                    valueListenable:
                                                                        Hive.box(miscellaneousDataHIVE)
                                                                            .listenable(),
                                                                    builder:
                                                                        (context,
                                                                            box,
                                                                            __) {
                                                                      return Text(
                                                                        'Scan QR',
                                                                        style: TextStyle(
                                                                            color: (box.get('isAwaitingEnrollment'))
                                                                                ? Colors.grey
                                                                                : Color(0xff1A1F25),
                                                                            fontSize: 20.sp,
                                                                            fontFamily: 'gilroy_bolditalic'),
                                                                      );
                                                                    }),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                            ),
                                          ]),
                                    );
                            }),
                          ],
                        ),
                      )
                    : Center(
                        child: Loader(
                          loadercolor: Color(0xffFED428),
                        ),
                      )
                : Center(
                    child: Text(
                      snapShotData['scanDisableText'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0xff7E7D7D),
                          fontSize: 20.sp,
                          fontFamily: 'gilroy_bolditalic'),
                    ),
                  );
          } else {
            return Center(
                child: Loader(
              loadercolor: Color(0xffFED428),
            ));
          }
        },
      ),
    );
  }
}
