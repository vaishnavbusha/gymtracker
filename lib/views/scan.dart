// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymtracker/constants.dart';
import 'package:gymtracker/models/user_model.dart';
import 'package:gymtracker/providers/authentication_providers.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanPage extends ConsumerStatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends ConsumerState<ScanPage> {
  // QRViewController? controller;
  // final qrKey = GlobalKey(debugLabel: 'GymTrackerQR');
  // Barcode? barCode;
  // @override
  // void reassemble() async {
  //   super.reassemble();
  //   if (Platform.isAndroid) {
  //     await controller!.pauseCamera();
  //   }
  //   controller!.resumeCamera();
  // }

  // @override
  // void dispose() {
  //   controller?.dispose();
  //   // TODO: implement dispose
  //   super.dispose();
  // }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
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
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              (Hive.box(miscellaneousDataHIVE).get("isAwaitingEnrollment") !=
                      null)
                  ? ValueListenableBuilder<Box<dynamic>>(
                      valueListenable:
                          Hive.box(miscellaneousDataHIVE).listenable(),
                      builder: (context, box, __) {
                        return (box.get('isAwaitingEnrollment'))
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                color: Color(0xff2D77D0),
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: EdgeInsets.all(10.sp),
                                  child: Center(
                                    child: Text(
                                      'Awaiting approval from ${(Hive.box(userDetailsHIVE).get('usermodeldata') as UserModel).enrolledGym}. QR Scanner button has been disabled.',
                                      style: TextStyle(
                                          color: color_gt_headersTextColorWhite,
                                          fontSize: 13.sp,
                                          fontFamily: 'gilroy_regularitalic'),
                                    ),
                                  ),
                                ),
                              )
                            : Container();
                      })
                  : Container(),
              (Hive.box(miscellaneousDataHIVE).get("membershipExpiry") != null)
                  ? ValueListenableBuilder<Box<dynamic>>(
                      valueListenable:
                          Hive.box(miscellaneousDataHIVE).listenable(),
                      builder: (context, box, __) {
                        final date = box.get('membershipExpiry');
                        var expiresOn =
                            DateTime(date.year, date.month, date.day);
                        int days =
                            (expiresOn.difference(DateTime.now()).inHours / 24)
                                .round();

                        return (days < 0)
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
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
                                          fontFamily: 'gilroy_regularitalic'),
                                    ),
                                  ),
                                ),
                              )
                            : Container();
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
                                    final date = box.get('membershipExpiry');

                                    var expiresOn = DateTime(
                                        date.year, date.month, date.day);
                                    int days = (expiresOn
                                                .difference(DateTime.now())
                                                .inHours /
                                            24)
                                        .round();

                                    return ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        //onPrimary: Colors.black,  //to change text color
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 7.h),
                                        primary: (box.get(
                                                    'isAwaitingEnrollment') ||
                                                (days < 0))
                                            ? Colors.grey
                                            : color_gt_green, // button color
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10.r), // <-- Radius
                                        ),
                                        textStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20.sp,
                                            fontFamily: 'gilroy_bold'),
                                      ),
                                      onPressed: () async {
                                        if (box.get('isAwaitingEnrollment') ||
                                            days < 0) {
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
                                  })
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    //onPrimary: Colors.black,  //to change text color
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 7.h),
                                    primary: color_gt_green, // button color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10.r), // <-- Radius
                                    ),
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20.sp,
                                        fontFamily: 'gilroy_bold'),
                                  ),
                                  onPressed: () async {
                                    String barcodeScanRes =
                                        await FlutterBarcodeScanner.scanBarcode(
                                            "#ff6666",
                                            'cancel',
                                            false,
                                            ScanMode.QR);
                                    scanState.getScannedData(
                                        barcodeScanRes, context);
                                    // scanState.validateScannedResult(context);
                                    // x.updateQRButtonClick();
                                    // barCode = null;
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                ),
                        )
                      ]),
                );
              }),
            ],
          ),
        ),
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
