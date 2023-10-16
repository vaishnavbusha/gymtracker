// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unused_local_variable, deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymtracker/constants.dart';
import 'package:gymtracker/controllers/encrypt_controller.dart';
import 'package:gymtracker/providers/authentication_providers.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

import '../models/user_model.dart';

class QRGenerator extends ConsumerStatefulWidget {
  final UserModel userModelData;
  const QRGenerator({Key? key, required this.userModelData}) : super(key: key);

  @override
  ConsumerState<QRGenerator> createState() => _QRGeneratorState();
}

class _QRGeneratorState extends ConsumerState<QRGenerator> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final qrGeneratorState = ref.watch(qrGeneratorProvider);
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    qrGeneratorState.screenshotController!.capture(pixelRatio: pixelRatio);
    final QRData =
        '{"uid": "${widget.userModelData.uid}","userName": "${widget.userModelData.userName}", "generatedOn": "${DateTime.now()}"}';

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          qrGeneratorState.isGeneratingPDF();
          //_createPDF(context);
        },
        backgroundColor: Color(0xff122B32),
        splashColor: color_gt_textColorBlueGrey,
        child: (qrGeneratorState.isLoading)
            ? LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.white,
                size: 20.sp,
              )
            : Icon(
                Icons.file_download_outlined,
                color: Colors.green,
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
                  child: Text(
                    'QR Code',
                    style: TextStyle(
                        fontFamily: 'gilroy_bold',
                        color: Color(0xff30d5c8),
                        fontSize: 20.sp,
                        fontStyle: FontStyle.normal),
                    textAlign: TextAlign.center,
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
                        QrImage(
                          foregroundColor: Colors.black,
                          // embeddedImage: Image.asset(
                          //   'assets/images/playstore.png',
                          // ).image,
                          // embeddedImageStyle: QrEmbeddedImageStyle(
                          //   size: Size(40, 40),
                          //   color: Colors.red,
                          // ),
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
                              SizedBox(width: 5),
                              Text(
                                'GymTracker',
                                style: TextStyle(
                                    fontFamily: 'gilroy_bolditalic',
                                    color: Colors.black,
                                    fontSize: 25.sp,
                                    fontStyle: FontStyle.normal),
                                textAlign: TextAlign.center,
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
                                fontFamily: 'gilroy_regularitalic',
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
