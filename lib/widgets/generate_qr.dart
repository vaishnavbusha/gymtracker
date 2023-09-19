// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymtracker/constants.dart';
import 'package:gymtracker/controllers/encrypt_controller.dart';

import 'package:qr_flutter/qr_flutter.dart';

import '../models/user_model.dart';

class QRGenerator extends StatelessWidget {
  final UserModel userModelData;
  QRGenerator({Key? key, required this.userModelData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final QRData =
        '{"uid": "${userModelData.uid}","userName": "${userModelData.userName}", "generatedOn": "${DateTime.now()}"}';

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
                  'QR Code',
                  style: TextStyle(
                      fontFamily: 'gilroy_bold',
                      color: Color(0xff2D77D0),
                      fontSize: 20.sp,
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
          56.0,
        ),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xff122B32), Colors.black],
            ),
          ),
          child: Center(
            child: QrImage(
              foregroundColor: Color(0xff2D77D0),
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
          ),
        ),
      ),
    );
  }
}
