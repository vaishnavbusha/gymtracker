// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymtracker/constants.dart';
import 'package:gymtracker/models/user_model.dart';
import 'package:gymtracker/providers/authentication_providers.dart';
import 'package:gymtracker/widgets/loader.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class ScanPage extends ConsumerStatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends ConsumerState<ScanPage> {
  @override
  void initState() {
    final datetime = DateFormat('dd-MM-yyyy').format(DateTime.now());
    if (Hive.box(miscellaneousDataHIVE).get('isEnterScanScanned') == null) {
      getData();
    }
    if (datetime != Hive.box(miscellaneousDataHIVE).get('scannedDate')) {
      Hive.box(miscellaneousDataHIVE).put('scannedDate', null);
      Hive.box(miscellaneousDataHIVE).put('isEnterScanScanned', false);
    }
    // TODO: implement initState
    super.initState();
  }

  getData() async {
    await ref.read(scanControllerProvider).checkForEntryScannedFromFireBase();
  }

  @override
  Widget build(BuildContext context) {
    final globalScanState = ref.watch(scanControllerProvider);
    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      appBar: PreferredSize(
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: AppBar(
              centerTitle: true,
              title: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Scanner',
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
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: const [Color(0xff122B32), Colors.black],
          ),
        ),
        child: (globalScanState.isDataReady)
            ? SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    (Hive.box(miscellaneousDataHIVE)
                                .get("isAwaitingEnrollment") !=
                            null)
                        ? ValueListenableBuilder<Box<dynamic>>(
                            valueListenable:
                                Hive.box(miscellaneousDataHIVE).listenable(),
                            builder: (context, box, __) {
                              return (box.get('isAwaitingEnrollment') != null &&
                                      box.get('isAwaitingEnrollment') == true)
                                  ? Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      color: Color(0xff2D77D0),
                                      alignment: Alignment.topCenter,
                                      child: Padding(
                                        padding: EdgeInsets.all(10.sp),
                                        child: Center(
                                          child: Text(
                                            'Awaiting approval from ${(Hive.box(userDetailsHIVE).get('usermodeldata') as UserModel).enrolledGym}. QR Scanner button has been disabled.',
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
                    (Hive.box(miscellaneousDataHIVE).get("membershipExpiry") !=
                            null)
                        ? ValueListenableBuilder<Box<dynamic>>(
                            valueListenable:
                                Hive.box(miscellaneousDataHIVE).listenable(),
                            builder: (context, box, __) {
                              final date = box.get('membershipExpiry');
                              int? days;
                              if (date == null) {
                                return Container();
                              } else {
                                var expiresOn =
                                    DateTime(date.year, date.month, date.day);
                                days = (expiresOn
                                            .difference(DateTime.now())
                                            .inHours /
                                        24)
                                    .round();
                              }

                              return (days < 0)
                                  ? Container(
                                      width: MediaQuery.of(context).size.width,
                                      color: Color(0xff2D77D0),
                                      alignment: Alignment.topCenter,
                                      child: Padding(
                                        padding: EdgeInsets.all(10.sp),
                                        child: Center(
                                          child: Text(
                                            (Hive.box(miscellaneousDataHIVE)
                                                    .get('awaitingRenewal'))
                                                ? 'Renewal request sent to ${(Hive.box(userDetailsHIVE).get('usermodeldata') as UserModel).enrolledGym}. QR scanner will be enabled post approval.'
                                                : 'Your membership with ${(Hive.box(userDetailsHIVE).get('usermodeldata') as UserModel).enrolledGym} has been expired, kindly renew your membership to start using the QR feature.',
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
                    (Hive.box(miscellaneousDataHIVE)
                                .get("isEnterScanScanned") !=
                            null)
                        ? ValueListenableBuilder<Box<dynamic>>(
                            valueListenable:
                                Hive.box(miscellaneousDataHIVE).listenable(),
                            builder: (context, box, __) {
                              final bool = box.get('isEnterScanScanned');
                              // var expiresOn =
                              //     DateTime(date.year, date.month, date.day);
                              // int days =
                              //     (expiresOn.difference(DateTime.now()).inHours / 24)
                              //         .round();

                              // return (days < 0)
                              //     ?
                              return (bool ||
                                      globalScanState.isEnterScanScanned!)
                                  ? Container(
                                      width: MediaQuery.of(context).size.width,
                                      color: Colors.orange.withOpacity(0.5),
                                      alignment: Alignment.topCenter,
                                      child: Padding(
                                        padding: EdgeInsets.all(15.sp),
                                        child: Center(
                                          child: Text(
                                            'Today\'s entry time has been marked, kindly re-scan the QR for marking exit-time before leaving the gym.',
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
                              //: Container();
                            })
                        : Container(),
                    Consumer(builder: (context, ref, __) {
                      final scanState = ref.watch(scanControllerProvider);
                      return Flexible(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 90.w),
                                child: (Hive.box(miscellaneousDataHIVE)
                                            .get("membershipExpiry") !=
                                        null)
                                    ? ValueListenableBuilder<Box<dynamic>>(
                                        valueListenable:
                                            Hive.box(miscellaneousDataHIVE)
                                                .listenable(),
                                        builder: (context, box, __) {
                                          final date =
                                              box.get('membershipExpiry');
                                          DateTime? expiresOn;
                                          bool? isExpired;
                                          if (date == null) {
                                            return Container();
                                          } else {
                                            expiresOn = DateTime(
                                              date.year,
                                              date.month,
                                              date.day,
                                              date.hour,
                                              date.minute,
                                              date.second,
                                              date.millisecond,
                                            );
                                            // int days = (expiresOn
                                            //             .difference(DateTime.now())
                                            //             .inHours /
                                            //         24)
                                            //     .round();
                                            isExpired = expiresOn
                                                .isBefore(DateTime.now());
                                          }

                                          return ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              //onPrimary: Colors.black,  //to change text color
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 7.h),
                                              primary: (box.get(
                                                              'isAwaitingEnrollment') ==
                                                          true ||
                                                      (isExpired))
                                                  ? Colors.grey
                                                  : (Hive.box(miscellaneousDataHIVE)
                                                              .get(
                                                                  "isEnterScanScanned") ||
                                                          scanState
                                                              .isEnterScanScanned!)
                                                      ? Colors.orange
                                                          .withOpacity(0.85)
                                                      : color_gt_green, // button color
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.r), // <-- Radius
                                              ),
                                              textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20.sp,
                                                  fontFamily: 'gilroy_bold'),
                                            ),
                                            onPressed: () async {
                                              if (box.get(
                                                      'isAwaitingEnrollment') ||
                                                  isExpired!) {
                                                null;
                                              } else {
                                                String barcodeScanRes =
                                                    await FlutterBarcodeScanner
                                                        .scanBarcode(
                                                            "#ff6666",
                                                            'cancel',
                                                            false,
                                                            ScanMode.QR);
                                                await scanState.getScannedData(
                                                    barcodeScanRes, context);

                                                // scanState.validateScannedResult(context);
                                                // x.updateQRButtonClick();
                                                // barCode = null;
                                              }
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                (scanState.isDataUploading!)
                                                    ? Loader(
                                                        loadercolor:
                                                            Colors.green,
                                                      )
                                                    : Icon(
                                                        Icons
                                                            .qr_code_scanner_rounded,
                                                        size: 40.w,
                                                      ),
                                                SizedBox(width: 10.w),
                                                Text(
                                                  'Scan QR',
                                                ),
                                              ],
                                            ),
                                          );
                                        })
                                    : ValueListenableBuilder<Box<dynamic>>(
                                        valueListenable:
                                            Hive.box(miscellaneousDataHIVE)
                                                .listenable(),
                                        builder: (context, box, __) {
                                          return ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              //onPrimary: Colors.black,  //to change text color
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 7.h),
                                              primary: (box.get(
                                                      'isAwaitingEnrollment'))
                                                  ? Colors.grey
                                                  : color_gt_green, // button color
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.r), // <-- Radius
                                              ),
                                              textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20.sp,
                                                  fontFamily: 'gilroy_bold'),
                                            ),
                                            onPressed: () async {
                                              if (box.get(
                                                  'isAwaitingEnrollment')) {
                                                null;
                                              } else {
                                                String barcodeScanRes =
                                                    await FlutterBarcodeScanner
                                                        .scanBarcode(
                                                            "#ff6666",
                                                            'cancel',
                                                            false,
                                                            ScanMode.QR);
                                                scanState.getScannedData(
                                                    barcodeScanRes, context);
                                                // scanState.validateScannedResult(context);
                                                // x.updateQRButtonClick();
                                                // barCode = null;
                                              }
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.qr_code_scanner_rounded,
                                                  size: 40.w,
                                                ),
                                                SizedBox(width: 10.w),
                                                Text(
                                                  'Scan QR',
                                                ),
                                              ],
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
                loadercolor: Color(0xff2D77D0),
              )),
      ),
    );
    // final scanState = ref.watch(scanControllerProvider);
    // return Scaffold(
    //   extendBody: true,
    //   body: Container(
    //       width: MediaQuery.of(context).size.width,
    //       height: MediaQuery.of(context).size.height,
    //       decoration: BoxDecoration(
    //         gradient: LinearGradient(
    //           begin: Alignment.topLeft,
    //           end: Alignment.bottomRight,
    //           colors: [Color(0xff122B32), Colors.black],
    //         ),
    //       ),
    //       child: (scanState.isQRButtonClicked == true)
    //           ? Stack(
    //               alignment: Alignment.center,
    //               children: [
    //                 buildQrView(context),
    //                 (barCode != null) ? Text('${barCode!.code}') : Container(),
    //                 Positioned(
    //                   bottom: 20,
    //                   child: Padding(
    //                     padding: EdgeInsets.symmetric(horizontal: 90.w),
    //                     child: ElevatedButton(
    //                       style: ElevatedButton.styleFrom(
    //                         //onPrimary: Colors.black,  //to change text color
    //                         padding: EdgeInsets.symmetric(
    //                             horizontal: 10, vertical: 7.h),
    //                         primary: Colors.red[500], // button color
    //                         shape: RoundedRectangleBorder(
    //                           borderRadius:
    //                               BorderRadius.circular(60.r), // <-- Radius
    //                         ),
    //                         textStyle: TextStyle(
    //                             color: Colors.black,
    //                             fontSize: 20.sp,
    //                             fontFamily: 'gilroy_bold'),
    //                       ),
    //                       onPressed: () {
    //                         scanState.updateQRButtonClick();
    //                       },
    //                       child: Row(
    //                         mainAxisAlignment: MainAxisAlignment.center,
    //                         children: [
    //                           Icon(
    //                             Icons.close_rounded,
    //                             size: 40.w,
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             )
    //           : Center(
    //               child: buildQRButton(),
    //             )),
    // );
  }
}
//   buildQRButton() {
//     final x = ref.watch(scanControllerProvider);
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 90.w),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           //onPrimary: Colors.black,  //to change text color
//           padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7.h),
//           primary: color_gt_green, // button color
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10.r), // <-- Radius
//           ),
//           textStyle: TextStyle(
//               color: Colors.black, fontSize: 20.sp, fontFamily: 'gilroy_bold'),
//         ),
//         onPressed: () {
//           x.updateQRButtonClick();
//           barCode = null;
//         },
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.qr_code_scanner_rounded,
//               size: 40.w,
//             ),
//             SizedBox(width: 10.w),
//             Text(
//               'dont use',
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   buildQrView(BuildContext context) {
//     return QRView(
//       key: qrKey,
//       onQRViewCreated: onQRViewCreated,
//       overlay: QrScannerOverlayShape(
//         cutOutSize: MediaQuery.of(context).size.width * 0.6,
//         borderWidth: 5,
//         borderLength: 20,
//         borderRadius: 10,
//         borderColor: color_gt_green,
//       ),
//     );
//   }

//   void onQRViewCreated(QRViewController controller) {
//     setState(() {
//       this.controller = controller;
//     });
//     controller.scannedDataStream.listen(
//       (barCode) => setState(() {
//         this.barCode = barCode;
//         print('barcode data = ${barCode.code}');
//       }),
//     );
//   }
// }
