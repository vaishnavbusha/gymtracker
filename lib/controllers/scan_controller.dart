// ignore_for_file: await_only_futures, unnecessary_null_comparison

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gymtracker/constants.dart';
import 'package:gymtracker/models/attendance_model.dart';
import 'package:gymtracker/models/scannedqr_model.dart';
import 'package:gymtracker/models/user_model.dart';
import 'package:gymtracker/widgets/customsnackbar.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../models/enroll_model.dart';

class ScanController extends ChangeNotifier {
  bool isQrEnabled = true;
  UserModel? userModel;
  QRViewController? controller;
  Barcode? barCode;
  bool isQRButtonClicked = false;
  String scannedData = '';
  EnrollModel? enrollModel;
  CollectionReference? gymPartnersCollection;
  ScannedQRModel? scannedQRModel;
  String? uploadStatus;
  bool? isDataUploading = false;
  ScanController() {
    gymPartnersCollection = fireBaseFireStore.collection('gympartners');
  }
  updateQRButtonClick() {
    isQRButtonClicked = !isQRButtonClicked;
    notifyListeners();
  }

  toggleQRButton() {
    final data = Hive.box(userDetailsHIVE).get('usersmodeldata') as UserModel;
    if (data.isAwaitingEnrollment == true) {
      isQrEnabled = false;
    } else {
      isQrEnabled = true;
    }
    notifyListeners();
  }

  Future getScannedData(String scannedData, BuildContext context) async {
    try {
      this.scannedData = scannedData;
      if (kDebugMode) {
        print('scanned data = $scannedData');
      }

      if (scannedData == '-1' || scannedData == '') {
        if (kDebugMode) {
          print('cancelled');
        }
        throw 'Successfully exited the QR Scanner';
      } else {
        var jsonDecodedData = jsonDecode(this.scannedData);

        scannedQRModel = ScannedQRModel.fromMap(jsonDecodedData);

        await validateScannedResult(context);
        //validateScannedResult(context);
        //throw 'Scan a valid QR-code generated by GymPartners.';
      }
    } catch (e) {
      if (e.runtimeType == FormatException) {
        CustomSnackBar.buildSnackbar(
            iserror: true,
            color: Colors.red[500]!,
            context: context,
            message: 'Kindly scan QR code generated by a GymPartner.',
            textcolor: Colors.white);
      } else {
        CustomSnackBar.buildSnackbar(
            iserror: true,
            color: Colors.green[500]!,
            context: context,
            message: e.toString(),
            textcolor: Colors.white);
      }
    }
    notifyListeners();
  }

  Future validateScannedResult(BuildContext context) async {
    isDataUploading = true;
    bool isUserExist = false;
    try {
      userModel = await Hive.box(userDetailsHIVE).get('usermodeldata');
      if (userModel!.isUser == false) {
        throw 'A GymPartner can\'t scan QR.';
      }
      if (userModel!.enrolledGym == null) {
        throw 'You\'re not enrolled with any gym partners, kindly enroll and scan again.';
      }
      if (userModel!.enrolledGym != null &&
          userModel!.membershipExpiry == null) {
        throw 'Your Enrollment request has been sent to ${userModel!.enrolledGym}. Kindly wait until it gets approved.';
      } else {
        if (DateTime.now().isAfter(userModel!.membershipExpiry!)) {
          throw 'Your membership has been expired, contact your gym-partner';
        } else {
          if (userModel!.membershipExpiry!.isAtSameMomentAs(DateTime.now())) {
            if (kDebugMode) {
              print('membership expires today, kindly extend your membership');
            }
          }
          if (kDebugMode) {
            print('not expired');
          }

          await gymPartnersCollection!.doc(scannedQRModel!.uid).get().then(
            (value) {
              EnrollModel enrollModel =
                  EnrollModel.fromMap(value.data() as Map<String, dynamic>);
              isUserExist =
                  (enrollModel.users!.contains(userModel!.uid)) ? true : false;

              if (isUserExist) {
                createNewAttendanceData(enrollModel);
                if (kDebugMode) {
                  print('attendance marked');
                }
                CustomSnackBar.buildSnackbar(
                    iserror: false,
                    color: Colors.green[500]!,
                    context: context,
                    message:
                        'Today\'s (${DateFormat('dd-MM-yyyy').format(DateTime.now())}) attendance has been marked !',
                    textcolor: Colors.white);
              } else {
                CustomSnackBar.buildSnackbar(
                    iserror: true,
                    color: Colors.red[500]!,
                    context: context,
                    message:
                        'You have scanned at ${scannedQRModel!.userName} but you belong to ${userModel!.enrolledGym}. Check your scanned QR code !',
                    textcolor: Colors.white);
              }
            },
          ).onError(
            (error, stackTrace) {
              if (kDebugMode) {
                print(error);
              }
            },
          );
        }
      }
      isDataUploading = false;
    } catch (e) {
      CustomSnackBar.buildSnackbar(
          iserror: true,
          color: Colors.red[500]!,
          context: context,
          message: e.toString(),
          textcolor: Colors.white);
      if (kDebugMode) {
        print(e);
      }
    }

    notifyListeners();
  }

  void createNewAttendanceData(EnrollModel enrollModel) async {
    final datetime = DateFormat('dd-MM-yyyy').format(DateTime.now());
    final monthData = DateFormat('MMM').format(DateTime.now());
    //checkDocuement(enrollModel, monthData, datetime);
    testCheckDocument(enrollModel, monthData, datetime);
    // try {
    //   await fireBaseFireStore
    //       .collection(enrollModel.gymPartnerGYMName!)
    //       .doc(monthData)
    //       .collection('morning')
    //       .doc(datetime)
    //       .update(
    //     {
    //       '${userModel!.uid}.uid': attendanceModel.userName,
    //       "${userModel!.uid}.scannedDateTime": attendanceModel.scannedDateTime,
    //     },
    //   );
    // } catch (e) {
    //   print(e);
    // }
  }

  testCheckDocument(
      EnrollModel enrollModel, String monthdata, String datetime) async {
    AttendanceModel attendanceModel = AttendanceModel(
        scannedDateTime: DateTime.now(), userName: userModel!.userName);
    final snapShot = await FirebaseFirestore.instance
        .collection(enrollModel.gymPartnerGYMName!)
        .doc(monthdata);
    // final snapShot = await FirebaseFirestore.instance
    //     .collection(enrollModel.gymPartnerGYMName!)
    //     .doc(monthdata)
    //     .collection(datetime)
    //     .get();
    List getListOfDates = await snapShot.get().then(
      (value) {
        return (value.data()!.containsKey('datesList'))
            ? (value.data() as Map<String, dynamic>)['datesList']
            : null;
      },
    );
    if (getListOfDates == null) {
      List x = [];
      x.add(datetime);
      await snapShot.set({'datesList': x});
    } else {
      if (!getListOfDates.contains(datetime)) {
        getListOfDates.add(datetime);
        await snapShot.set({'datesList': getListOfDates});
      }
    }
    await snapShot
        .collection(datetime)
        .doc(Hive.box(miscellaneousDataHIVE).get("uid"))
        .set(attendanceModel.toMap());
    // if (snapShot == null || snapShot.docs.isEmpty) {
    //   // docuement is not exist

    // } else {
    //   print("id is already exist");
    //   await FirebaseFirestore.instance
    //       .collection(enrollModel.gymPartnerGYMName!)
    //       .doc(monthdata)
    //       .collection("3-09-2023")
    //       .doc(Hive.box(miscellaneousDataHIVE).get("uid"))
    //       .update(attendanceModel.toMap());
    // }
  }

  checkDocuement(
      EnrollModel enrollModel, String monthdata, String datetime) async {
    AttendanceModel attendanceModel = AttendanceModel(
        scannedDateTime: DateTime.now(), userName: userModel!.userName);
    final snapShot = await FirebaseFirestore.instance
        .collection(enrollModel.gymPartnerGYMName!)
        .doc(monthdata)
        .collection(datetime)
        .doc('usersData')
        .get();

    if (snapShot == null || !snapShot.exists) {
      // docuement is not exist
      await FirebaseFirestore.instance
          .collection(enrollModel.gymPartnerGYMName!)
          .doc(monthdata)
          .collection(datetime)
          .doc('usersData')
          .set({'${userModel!.uid}': attendanceModel.toMap()});
    } else {
      if (kDebugMode) {
        print("id is already exist");
      }
      await FirebaseFirestore.instance
          .collection(enrollModel.gymPartnerGYMName!)
          .doc(monthdata)
          .collection(datetime)
          .doc('usersData')
          .update({'${userModel!.uid}': attendanceModel.toMap()});
    }
  }
  // void onQRViewCreated(QRViewController controller) {
  //   this.controller = controller;

  //   controller.scannedDataStream.listen((barCode) => this.barCode = barCode);
  //   notifyListeners();
  // }
}
