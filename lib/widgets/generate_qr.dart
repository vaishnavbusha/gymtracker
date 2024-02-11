// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unused_local_variable, deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymtracker/constants.dart';
import 'package:gymtracker/controllers/encrypt_controller.dart';
import 'package:gymtracker/providers/providers.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

import '../models/user_model.dart';

class QRGenerator extends ConsumerStatefulWidget {
  final UserModel userModelData =
      Hive.box(userDetailsHIVE).get('usermodeldata');
  QRGenerator({Key? key}) : super(key: key);

  @override
  ConsumerState<QRGenerator> createState() => _QRGeneratorState();
}

class _QRGeneratorState extends ConsumerState<QRGenerator> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final qrGeneratorState = ref.watch(Providers.qrGeneratorProvider);
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    qrGeneratorState.screenshotController!.capture(pixelRatio: pixelRatio);
    final QRData =
        '{"uid": "${widget.userModelData.uid}","userName": "${widget.userModelData.userName}", "generatedOn": "${DateTime.now()}"}';

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          qrGeneratorState.isGeneratingPDF();
        },
        backgroundColor: Color(0xff1A1F25),
        splashColor: color_gt_textColorBlueGrey,
        child: (qrGeneratorState.isLoading)
            ? LoadingAnimationWidget.staggeredDotsWave(
                color: Color(0xffFED428),
                size: 20.sp,
              )
            : Icon(
                Icons.share_rounded,
                color: Color(0xffFED428),
                size: 30,
              ),
      ),
      appBar: PreferredSize(
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
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
                        'QR Code',
                        style: TextStyle(
                          fontFamily: 'gilroy_bolditalic',
                          color: Color(0xffFED428),
                        ),
                      ),
                    ],
                  ),
                ),
                elevation: 0.0,
                backgroundColor: Colors.black),
          ),
        ),
        preferredSize: Size(
          double.infinity,
          56.0,
        ),
      ),
      backgroundColor: Colors.white.withOpacity(0.9),
      body: SafeArea(
        child: Center(
          child: Screenshot(
            controller: qrGeneratorState.screenshotController!,
            child: Stack(
              children: [
                Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        QrImageView(
                          foregroundColor: Colors.black,
                          data: EncryptController.encryptData(QRData),
                          version: QrVersions.auto,
                          size: 300,
                          gapless: true,
                          errorStateBuilder: (cxt, err) {
                            return Center(
                              child: Text(
                                'Uh oh! Something went wrong...',
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        ),
                        // QrImage(
                        //   foregroundColor: Colors.black,
                        //   data: EncryptController.encryptData(QRData),
                        //   version: QrVersions.auto,
                        //   size: 300,
                        //   gapless: true,
                        //   errorStateBuilder: (cxt, err) {
                        //     return Center(
                        //       child: Text(
                        //         'Uh oh! Something went wrong...',
                        //         textAlign: TextAlign.center,
                        //       ),
                        //     );
                        //   },
                        // ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.black),
                                child: Padding(
                                  padding: EdgeInsets.all(3.0),
                                  child: Image.asset(
                                    'assets/images/playstore.png',
                                    height: 30.h,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 5.h),
                              SizedBox(
                                height: 30.h,
                                child: Stack(
                                  children: [
                                    Text(
                                      'GymTracker',
                                      style: TextStyle(
                                          fontFamily: 'gilroy_bolditalic',
                                          color: Colors.black,
                                          fontSize: 25.sp,
                                          fontStyle: FontStyle.normal),
                                      textAlign: TextAlign.center,
                                    ),
                                    Positioned(
                                      bottom: 3.h,
                                      right: 0,
                                      child: Text(
                                        'by AquelaStudios.',
                                        style: TextStyle(
                                            fontFamily: 'gilroy_bolditalic',
                                            color: Colors.black,
                                            fontSize: 7.sp,
                                            fontStyle: FontStyle.normal),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                      ]),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'from',
                            style: TextStyle(
                                fontFamily: 'gilroy_regular',
                                color: color_gt_textColorBlueGrey),
                          ),
                          Text(
                            'Aquela Studios',
                            style: TextStyle(
                                fontFamily: 'gilroy_bolditalic',
                                color: Colors.black,
                                fontSize: 20.sp),
                          ),
                        ]),
                  ),
                ),
                // (_imageFile == null)
                //     ? Container()
                //     : Image.memory(_imageFile!, height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Future<void> _createPDF(BuildContext context) async {
  //   final UserModel adminData = Hive.box(userDetailsHIVE).get('usermodeldata');
  //   PdfDocument document = PdfDocument();
  //   final page = document.pages.add();
  //   page.graphics.drawString(adminData.enrolledGym!,
  //       PdfStandardFont(PdfFontFamily.helvetica, 25, style: PdfFontStyle.bold),
  //       bounds: Rect.fromLTWH(0, 0, MediaQuery.of(context).size.width, 50),
  //       format: PdfStringFormat(alignment: PdfTextAlignment.center));
  //   List<int> bytes = await document.save();
  //   document.dispose();

  //   saveAndLaunchFile(bytes, 'file.pdf');
  // }

  // Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
  //   final path = (await getExternalStorageDirectory())!.path;
  //   final file = File('$path/$fileName');
  //   await file.writeAsBytes(bytes, flush: true);
  //   OpenFile.open('$path/$fileName');
  // }
}
