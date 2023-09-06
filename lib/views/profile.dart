// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymtracker/constants.dart';

import 'package:gymtracker/models/user_model.dart';

import 'package:gymtracker/widgets/approvals.dart';
import 'package:gymtracker/widgets/generate_qr.dart';
import 'package:gymtracker/views/signin.dart';

import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

import '../widgets/enroll.dart';
import '../widgets/loader.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    //ref.read(profileControllerProvider).getUserData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //ref.watch(profileControllerProvider).getUserData();
    return StreamBuilder(
        stream: fireBaseFireStore
            .collection("users")
            .doc(Hive.box(miscellaneousDataHIVE).get('uid'))
            .snapshots(),
        builder: (context, snapshot) {
          if (!(snapshot.hasData)) {
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
                          'Profile',
                          style: TextStyle(
                              fontFamily: 'gilroy_bold',
                              color: color_gt_green,
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
                    colors: [Color(0xff122B32), Colors.black],
                  ),
                ),
                child: Center(
                  child: Loader(
                    loadercolor: Colors.red,
                  ),
                ),
              ),
            );
          }
          final userModelData =
              UserModel.toModel(snapshot.data as DocumentSnapshot);
          UserModel.saveUserDataToHIVE(userModelData);
          Hive.box(miscellaneousDataHIVE)
              .put('isAwaitingEnrollment', userModelData.isAwaitingEnrollment);

          // final UserModel user = UserModel.toModel(
          //     data); // Gives you the data map
          // return Scaffold(
          //   appBar: AppBar(
          //     title: Text('Document Details'),
          //   ),
          //   body: Column(
          //     children: [
          //       // Text(sighting.type)
          //     ],
          //   ),
          // );
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
                        'Profile',
                        style: TextStyle(
                            fontFamily: 'gilroy_bold',
                            color: color_gt_green,
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
                50.0,
              ),
            ),
            backgroundColor: Colors.black,
            floatingActionButton: !(userModelData.userType == 'user')
                ? FloatingActionButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              QRGenerator(userModelData: userModelData),
                        )),
                    child: Icon(Icons.qr_code_2_rounded),
                    backgroundColor: Colors.green,
                  )
                : Container(),
            extendBody: true,
            body: SingleChildScrollView(
              child: Container(
                //height: double.infinity,
                width: MediaQuery.of(context).size.width,
                //height: MediaQuery.of(context).size.height * 0.87,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xff122B32), Colors.black],
                  ),
                ),
                child: SafeArea(
                  child: Consumer(builder: (context, ref, child) {
                    //final profileState = ref.watch(profileControllerProvider);
                    //profileState.userDataChanges_FirebaseListener();
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          !(userModelData.isUser)
                              ? (userModelData.pendingApprovals!.isNotEmpty)
                                  ? Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Color(0xff2D77D0),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(2),
                                          bottomRight: Radius.circular(2),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.w, vertical: 5.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Pending Approvals :  ',
                                                  style: TextStyle(
                                                      color:
                                                          color_gt_headersTextColorWhite,
                                                      fontFamily:
                                                          'gilroy_regularitalic',
                                                      fontSize: 12.sp),
                                                ),
                                                Text(
                                                  userModelData
                                                      .pendingApprovals!.length
                                                      .toString(),
                                                  style: TextStyle(
                                                      color:
                                                          color_gt_headersTextColorWhite,
                                                      fontFamily:
                                                          'gilroy_bolditalic',
                                                      fontSize: 15.sp),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top: 5.h,
                                                bottom: 5.h,
                                              ),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  elevation: 0,
                                                  onPrimary: Colors
                                                      .black, //to change text color
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 7.h),
                                                  primary:
                                                      color_gt_headersTextColorWhite, // button color
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.r), // <-- Radius
                                                  ),
                                                  textStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15.sp,
                                                      fontFamily:
                                                          'gilroy_bold'),
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ApprovalsPage(
                                                                pendingApprovals:
                                                                    userModelData
                                                                        .pendingApprovals!),
                                                      ));
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 10.w, right: 10.w),
                                                  child: Text(
                                                    'View requests',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container()
                              : Container(),
                          (userModelData.isAwaitingEnrollment &&
                                  userModelData.userType == 'user' &&
                                  userModelData.enrolledGym != null)
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Color(0xff2D77D0),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(2),
                                      bottomRight: Radius.circular(2),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 20.h,
                                        bottom: 20.h,
                                        left: 10.w,
                                        right: 10.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            'Awaiting approval !  Your request has been sent to ${userModelData.enrolledGym}. Your request will be approved soon...',
                                            style: TextStyle(
                                                color:
                                                    color_gt_headersTextColorWhite,
                                                fontSize: 12.sp,
                                                fontFamily:
                                                    'gilroy_regularitalic'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),
                          (userModelData.isUser)
                              ? enrollmentNotification(
                                  userModelData.enrolledGym == null ||
                                      userModelData.enrolledGym!.isEmpty,
                                  context)
                              : Container(),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 13.h),
                            child:
                                displayProfilePic(userModelData.profilephoto!),
                          ),
                          Text(
                            '${userModelData.userName} (${userModelData.userType})',
                            style: TextStyle(
                                color: color_gt_green,
                                fontFamily: 'gilroy_bolditalic',
                                fontSize: 20.sp),
                          ),

                          Padding(
                            padding: EdgeInsets.only(top: 12.h, bottom: 2.h),
                            child: Divider(
                              color: color_gt_greenHalfOpacity.withOpacity(0.3),
                              height: 1.h,
                              thickness: 1,
                              // endIndent: 10.w,
                              // indent: 20.w,
                            ),
                          ),
                          profileDataBlock('Email', userModelData.email, true),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            child: Divider(
                              color: color_gt_greenHalfOpacity.withOpacity(0.3),
                              height: 1.h,
                              thickness: 1,
                              // endIndent: 10.w,
                              // indent: 20.w,
                            ),
                          ),
                          profileDataBlock('DOB', userModelData.DOB, false),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            child: Divider(
                              color: color_gt_greenHalfOpacity.withOpacity(0.3),
                              height: 1.h,
                              thickness: 1,
                              // endIndent: 10.w,
                              // indent: 20.w,
                            ),
                          ),
                          profileDataBlock(
                              'Phone', userModelData.phoneNumber!, true),
                          (userModelData.enrolledGym != null &&
                                  !userModelData.isAwaitingEnrollment)
                              ? Column(children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.h),
                                    child: Divider(
                                      color: color_gt_greenHalfOpacity
                                          .withOpacity(0.3),
                                      height: 1.h,
                                      thickness: 1,
                                      // endIndent: 10.w,
                                      // indent: 20.w,
                                    ),
                                  ),
                                  profileDataBlock('Enrolled Gym',
                                      userModelData.enrolledGym!, true),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.h),
                                    child: Divider(
                                      color: color_gt_greenHalfOpacity
                                          .withOpacity(0.3),
                                      height: 1.h,
                                      thickness: 1,
                                      // endIndent: 10.w,
                                      // indent: 20.w,
                                    ),
                                  ),
                                  profileDataBlock('Joined Gym on',
                                      userModelData.enrolledGymDate, false),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.h),
                                    child: Divider(
                                      color: color_gt_greenHalfOpacity
                                          .withOpacity(0.3),
                                      height: 1.h,
                                      thickness: 1,
                                      // endIndent: 10.w,
                                      // indent: 20.w,
                                    ),
                                  ),
                                  profileDataBlock('MemberShip expiry',
                                      userModelData.membershipExpiry, false),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.h),
                                    child: Divider(
                                      color: color_gt_greenHalfOpacity
                                          .withOpacity(0.3),
                                      height: 1.h,
                                      thickness: 1,
                                      // endIndent: 10.w,
                                      // indent: 20.w,
                                    ),
                                  ),
                                  profileDataBlock(
                                      'Fees Paid(₹)',
                                      userModelData.memberShipFeesPaid
                                          .toString(),
                                      false),
                                ])
                              : Container(),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            child: Divider(
                              color: color_gt_greenHalfOpacity.withOpacity(0.3),
                              height: 1.h,
                              thickness: 1,
                              // endIndent: 10.w,
                              // indent: 20.w,
                            ),
                          ),
                          (userModelData.isUser)
                              ? Padding(
                                  padding:
                                      EdgeInsets.only(top: 20.h, bottom: 10.h),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Align(
                                          alignment: Alignment.center,
                                          child: RichText(
                                            text: TextSpan(
                                              text:
                                                  'To partner up with GymTracker App, kindly e-mail us at  ',
                                              style: TextStyle(
                                                  color:
                                                      color_gt_headersTextColorWhite,
                                                  fontSize: 8.sp,
                                                  fontFamily: 'gilroy_bold'),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text:
                                                        'gymtracker@gmail.com',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'gilroy_regular',
                                                        color: color_gt_green,
                                                        fontSize: 10.sp)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ]),
                                )
                              : Container(),

                          /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 84.h, vertical: 5.h),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                //onPrimary: Colors.black,  //to change text color
                                padding: EdgeInsets.symmetric(vertical: 7.h),
                                primary: color_gt_green, // button color
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(10.r), // <-- Radius
                                ),
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.sp,
                                    fontFamily: 'gilroy_bold'),
                              ),
                              onPressed: () async {
                                await signOut();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.logout_rounded),
                                  Text(
                                    'Logout',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]);
                  }),
                ),
              ),
            ),
          );
        });
  }

  Future<void> signOut() async {
    await fireBaseAuth.signOut();
    await Hive.box(userDetailsHIVE).clear();
    Hive.box(miscellaneousDataHIVE).put('isLoggedIn', false);
    Navigator.of(context, rootNavigator: true)
        .pushReplacement(MaterialPageRoute(builder: (context) => SignInPage()));
  }

  profileDataBlock(String tagName, var tagData, bool enableUpdateButton) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 13.h),
          child: Align(
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                text: '$tagName :  ',
                style: TextStyle(
                    color: color_gt_green,
                    fontSize: 12.sp,
                    fontFamily: 'gilroy_bold'),
                children: <TextSpan>[
                  TextSpan(
                      text: (tagData.runtimeType == DateTime)
                          ? DateFormat('dd-MMM-yyyy').format(tagData)
                          : tagData,
                      style: TextStyle(
                          fontFamily: 'gilroy_regular',
                          color: color_gt_headersTextColorWhite,
                          fontSize: 12.sp)),
                ],
              ),
            ),
          ),
        ),
        (enableUpdateButton)
            ? Padding(
                padding: EdgeInsets.only(right: 13.h),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    //onPrimary: Colors.black,  //to change text color
                    padding: EdgeInsets.symmetric(vertical: 7.h),
                    primary: color_gt_green, // button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r), // <-- Radius
                    ),
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontFamily: 'gilroy_bold'),
                  ),
                  onPressed: () async {
                    //await _signOut();
                  },
                  child: Text('Update'),
                ),
              )
            : Container(
                height: 40.h,
              ),
      ],
    );
  }

  displayProfilePic(String profilePic) {
    //final profileState = ref.watch(profileControllerProvider);
    return Image.network(
      profilePic,
      width: 120.h,
      height: 120.h,
      fit: BoxFit.fill,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
    );
  }

  enrollmentNotification(bool isEnrolledToGym, BuildContext ctx) {
    return (isEnrolledToGym)
        ? Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.only(
                left: 15.h,
                right: 15.h,
              ),
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 10.h,
                    bottom: 5.h,
                  ),
                  child: Text(
                    'Sign-Up for Gym today',
                    style: TextStyle(
                        color: color_gt_headersTextColorWhite,
                        fontFamily: 'gilroy_bold',
                        fontSize: 20.sp),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 10.h,
                    bottom: 5.h,
                  ),
                  child: Text(
                    'Become a member of any of the partnered gym\'s with GymTracker app for keeping track of your gym attendance.',
                    style: TextStyle(
                        color: color_gt_headersTextColorWhite,
                        fontFamily: 'gilroy_regularitalic',
                        fontSize: 12.sp),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 5.h,
                    bottom: 5.h,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      onPrimary: Colors.black, //to change text color
                      padding: EdgeInsets.symmetric(vertical: 7.h),
                      primary: color_gt_headersTextColorWhite, // button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r), // <-- Radius
                      ),
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 15.sp,
                          fontFamily: 'gilroy_bold'),
                    ),
                    onPressed: () {
                      Navigator.push(
                          ctx,
                          MaterialPageRoute(
                            builder: (context) => EnrollPage(),
                          ));
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 2.h, bottom: 2.h, left: 10.w, right: 10.w),
                      child: Text(
                        'Enroll now',
                      ),
                    ),
                  ),
                ),
              ]),
            ),
            decoration: BoxDecoration(
                color: Color(0xff2D77D0),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(2),
                    bottomRight: Radius.circular(2))),
          )
        : Container();
  }
}
