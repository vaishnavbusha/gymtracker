// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_call_super

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymtracker/constants.dart';

import 'package:gymtracker/models/user_model.dart';
import 'package:gymtracker/providers/providers.dart';
import 'package:gymtracker/widgets/animated_route.dart';

import 'package:gymtracker/widgets/approvals.dart';

import 'package:gymtracker/widgets/generate_qr.dart';
import 'package:gymtracker/views/signin.dart';

import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

import '../widgets/customsnackbar.dart';
import '../widgets/enroll.dart';
import '../widgets/loader.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1A1F25),
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
                      'Profile',
                      style: TextStyle(
                          fontFamily: 'gilroy_bolditalic',
                          color: Color(0xffFED428)),
                    ),
                  ],
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
      extendBody: true,
      body: StreamBuilder(
          stream: fireBaseFireStore
              .collection("appsettings")
              .doc('UserAppSettings')
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData) {
              var snapShotData = snapshot.data;
              final isProfileEnabled = snapShotData!['isProfileEnabled'];
              return (isProfileEnabled)
                  ? StreamBuilder(
                      stream: fireBaseFireStore
                          .collection("users")
                          .doc(Hive.box(miscellaneousDataHIVE).get('uid'))
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final userModelData = UserModel.toModel(
                              snapshot.data as DocumentSnapshot);
                          UserModel.saveUserDataToHIVE(userModelData);
                          Hive.box(miscellaneousDataHIVE).put(
                              'isAwaitingEnrollment',
                              userModelData.isAwaitingEnrollment);
                          Hive.box(miscellaneousDataHIVE).put(
                              'membershipExpiry',
                              userModelData.membershipExpiry);
                          Hive.box(miscellaneousDataHIVE).put(
                              'awaitingRenewal', userModelData.awaitingRenewal);
                          Hive.box(miscellaneousDataHIVE).put(
                              'pendingRenewalsLength',
                              userModelData.pendingRenewals?.length ?? 0);
                          return SingleChildScrollView(
                            //controller: AdjustableScrollController(),
                            physics: AlwaysScrollableScrollPhysics(),
                            child: SafeArea(
                              child: Consumer(builder: (context, ref, child) {
                                return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      !(userModelData.isUser)
                                          ? (userModelData.pendingApprovals !=
                                                      null &&
                                                  userModelData
                                                      .pendingApprovals!
                                                      .isNotEmpty)
                                              ? Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 20.h),
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xff2B3038),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(
                                                                15.r),
                                                        bottomRight:
                                                            Radius.circular(
                                                                15.r),
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10.w,
                                                              vertical: 5.h),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
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
                                                                    fontSize:
                                                                        15.sp),
                                                              ),
                                                              Text(
                                                                userModelData
                                                                    .pendingApprovals!
                                                                    .length
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xffFED428),
                                                                    fontFamily:
                                                                        'gilroy_bolditalic',
                                                                    fontSize:
                                                                        15.sp),
                                                              ),
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                              top: 5.h,
                                                              bottom: 5.h,
                                                            ),
                                                            child:
                                                                ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                elevation: 0,
                                                                onPrimary: Colors
                                                                    .black, //to change text color
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            7.h),
                                                                primary: Color(
                                                                    0xffFED428), // button color
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20.r), // <-- Radius
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                Navigator.push(
                                                                    context,
                                                                    CupertinoPageRoute(
                                                                      builder: (context) =>
                                                                          ApprovalsPage(
                                                                              pendingApprovals: userModelData.pendingApprovals!),
                                                                    )
                                                                    // ScaleRoute(
                                                                    //     page: ApprovalsPage(
                                                                    //         pendingApprovals:
                                                                    //             userModelData.pendingApprovals!)),
                                                                    );
                                                              },
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left: 10
                                                                            .w,
                                                                        right: 10
                                                                            .w),
                                                                child: Text(
                                                                  'View requests',
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          0xff1A1F25),
                                                                      fontSize:
                                                                          15.sp,
                                                                      fontFamily:
                                                                          'gilroy_bold'),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Container()
                                          : Container(),
                                      (userModelData.isAwaitingEnrollment! &&
                                              userModelData.userType ==
                                                  'user' &&
                                              userModelData.enrolledGym != null)
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                bottom: 20.h,
                                              ),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                  color: Color(0xff2B3038),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(15.r),
                                                    bottomRight:
                                                        Radius.circular(15.r),
                                                    // topLeft: Radius.circular(15.r),
                                                    // topRight: Radius.circular(15.r),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 20.h,
                                                      bottom: 20.h,
                                                      left: 5.w,
                                                      right: 5.w),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          'Awaiting approval !  Your request has been sent to ${userModelData.enrolledGym}. Your request will be approved soon...',
                                                          textAlign:
                                                              TextAlign.center,
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
                                              ),
                                            )
                                          : Container(),
                                      (userModelData.isUser)
                                          ? enrollmentNotification(
                                              userModelData.enrolledGym ==
                                                      null ||
                                                  userModelData
                                                      .enrolledGym!.isEmpty,
                                              context)
                                          : Container(),

                                      // Padding(
                                      //   padding: EdgeInsets.symmetric(vertical: 2.h),
                                      //   child: Divider(
                                      //     color: Color(0xff30d5c8).withOpacity(0.3),
                                      //     height: 1.h,
                                      //     thickness: 1,

                                      //   ),
                                      // ),
                                      // profileDataBlock(
                                      //     'UserName', userModelData.userName, false),
                                      // Padding(
                                      //   padding: EdgeInsets.symmetric(vertical: 2.h),
                                      //   child: Divider(
                                      //     color: Color(0xff30d5c8).withOpacity(0.3),
                                      //     height: 1.h,
                                      //     thickness: 1,

                                      //   ),
                                      // ),
                                      newDataBlock(
                                          tagName: 'UserName',
                                          tagData: userModelData.userName,
                                          isEditable: false),
                                      newDataBlock(
                                          tagName: 'Email',
                                          tagData: userModelData.email,
                                          isEditable: false),
                                      //profileDataBlock('Email', userModelData.email, false),
                                      // Padding(
                                      //   padding: EdgeInsets.symmetric(vertical: 2.h),
                                      //   child: Divider(
                                      //     color: Color(0xff30d5c8).withOpacity(0.3),
                                      //     height: 1.h,
                                      //     thickness: 1,
                                      //   ),
                                      // ),
                                      newDataBlock(
                                          tagName: 'DOB',
                                          tagData: userModelData.DOB,
                                          isEditable: false),
                                      //profileDataBlock('DOB', userModelData.DOB, false),
                                      // Padding(
                                      //   padding: EdgeInsets.symmetric(vertical: 2.h),
                                      //   child: Divider(
                                      //     color: Color(0xff30d5c8).withOpacity(0.3),
                                      //     height: 1.h,
                                      //     thickness: 1,
                                      //     // endIndent: 10.w,
                                      //     // indent: 20.w,
                                      //   ),
                                      // ),
                                      newDataBlock(
                                          tagName: 'Phone',
                                          tagData: userModelData.phoneNumber!,
                                          isEditable: false),
                                      // profileDataBlock(
                                      //     'Phone', userModelData.phoneNumber!, false),
                                      (userModelData.enrolledGym != null &&
                                              !userModelData
                                                  .isAwaitingEnrollment!)
                                          ? Column(children: [
                                              // Padding(
                                              //   padding: EdgeInsets.symmetric(vertical: 2.h),
                                              //   child: Divider(
                                              //     color: Color(0xff30d5c8).withOpacity(0.3),
                                              //     height: 1.h,
                                              //     thickness: 1,

                                              //   ),
                                              // ),
                                              newDataBlock(
                                                  tagName:
                                                      (userModelData.isUser)
                                                          ? 'Gym'
                                                          : 'Admin of',
                                                  tagData: userModelData
                                                      .enrolledGym!,
                                                  isEditable: false),
                                              // profileDataBlock(
                                              //     (userModelData.isUser)
                                              //         ? 'Enrolled Gym'
                                              //         : 'Admin of',
                                              //     userModelData.enrolledGym!,
                                              //     false),
                                              // Padding(
                                              //   padding: EdgeInsets.symmetric(vertical: 2.h),
                                              //   child: Divider(
                                              //     color: Color(0xff30d5c8).withOpacity(0.3),
                                              //     height: 1.h,
                                              //     thickness: 1,

                                              //   ),
                                              // ),
                                              newDataBlock(
                                                  tagName: 'Joined',
                                                  tagData: userModelData
                                                      .enrolledGymDate,
                                                  isEditable: false),
                                              // profileDataBlock(
                                              //     (userModelData.isUser)
                                              //         ? 'Joined Gym on'
                                              //         : 'GymPartner since',
                                              //     userModelData.enrolledGymDate,
                                              //     false),
                                              // Padding(
                                              //   padding: EdgeInsets.symmetric(vertical: 2.h),
                                              //   child: Divider(
                                              //     color: Color(0xff30d5c8).withOpacity(0.3),
                                              //     height: 1.h,
                                              //     thickness: 1,

                                              //   ),
                                              // ),
                                              // (userModelData.recentRenewedOn != null)
                                              //     ? profileDataBlock('Membership renewed on',
                                              //         userModelData.recentRenewedOn, false)
                                              //     : Container(),
                                              (userModelData.recentRenewedOn !=
                                                      null)
                                                  ? newDataBlock(
                                                      tagName: 'Renewed',
                                                      tagData: userModelData
                                                          .recentRenewedOn,
                                                      isEditable: false)
                                                  : Container(),
                                              // (userModelData.recentRenewedOn != null)
                                              //     ? Padding(
                                              //         padding:
                                              //             EdgeInsets.symmetric(vertical: 2.h),
                                              //         child: Divider(
                                              //           color: Color(0xff30d5c8)
                                              //               .withOpacity(0.3),
                                              //           height: 1.h,
                                              //           thickness: 1,
                                              //           // endIndent: 10.w,
                                              //           // indent: 20.w,
                                              //         ),
                                              //       )
                                              //     : Container(),
                                              // newDataBlock(
                                              //     tagName: 'Expiry',
                                              //     tagData: userModelData.membershipExpiry,
                                              //     isEditable: false),
                                              membershipExpiryBlock('Expiry',
                                                  userModelData, false, false),
                                              // Padding(
                                              //   padding: EdgeInsets.symmetric(vertical: 2.h),
                                              //   child: Divider(
                                              //     color: Color(0xff30d5c8).withOpacity(0.3),
                                              //     height: 1.h,
                                              //     thickness: 1,

                                              //   ),
                                              // ),
                                              newDataBlock(
                                                  tagName: 'Paid(₹)',
                                                  tagData: userModelData
                                                      .memberShipFeesPaid
                                                      .toString(),
                                                  isEditable: false),
                                            ])
                                          : Container(),
                                      // Padding(
                                      //   padding: EdgeInsets.symmetric(vertical: 2.h),
                                      //   child: Divider(
                                      //     color: Color(0xff30d5c8).withOpacity(0.3),
                                      //     height: 1.h,
                                      //     thickness: 1,

                                      //   ),
                                      // ),
                                      (userModelData.isUser)
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                  top: 20.h, bottom: 10.h),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: RichText(
                                                          text: TextSpan(
                                                            text:
                                                                'To partner up with GymTracker App, kindly e-mail us at  ',
                                                            style: TextStyle(
                                                                color:
                                                                    color_gt_headersTextColorWhite,
                                                                fontSize: 8.sp,
                                                                fontFamily:
                                                                    'gilroy_bolditalic'),
                                                            children: <TextSpan>[
                                                              TextSpan(
                                                                  text:
                                                                      'aquelastudios@gmail.com',
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'gilroy_bolditalic',
                                                                      color: Color(
                                                                          0xffFED428),
                                                                      fontSize:
                                                                          10.sp)),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
                                            )
                                          : Container(),

                                      /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                      Padding(
                                        padding: (userModelData
                                                .isAwaitingEnrollment!)
                                            ? EdgeInsets.symmetric(
                                                horizontal: 84.h,
                                                vertical: 20.h)
                                            : EdgeInsets.only(
                                                left: 70.h,
                                                right: 70.h,
                                                top: 20.h,
                                                bottom: 100.h),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            //onPrimary: Colors.black,  //to change text color
                                            padding: EdgeInsets.symmetric(
                                                vertical: 15.h),
                                            primary: Color(
                                                0xffFED428), // button color
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10.r), // <-- Radius
                                            ),
                                          ),
                                          onPressed: () async {
                                            await signOut();
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.logout_rounded,
                                                color: Color(0xff1A1F25),
                                              ),
                                              SizedBox(width: 10.w),
                                              Text(
                                                'Logout',
                                                style: TextStyle(
                                                    color: Color(0xff1A1F25),
                                                    fontSize: 15.sp,
                                                    fontFamily: 'gilroy_bold'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]);
                              }),
                            ),
                          );
                        } else {
                          return Center(
                              child: Loader(
                            loadercolor: Color(0xffFED428),
                          ));
                        }
                      })
                  : Center(
                      child: Text(
                        snapShotData['profileDisableText'],
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
          }),
    );
  }

  Future<void> signOut() async {
    await fireBaseAuth.signOut();
    Hive.box(userDetailsHIVE).clear();
    Hive.box(miscellaneousDataHIVE).put('isLoggedIn', false);
    Hive.box(maxClickAttemptsHIVE).put('currMonthlyAttendanceCount', null);
    Hive.box(maxClickAttemptsHIVE)
        .put('currAttendanceByDateInCurrentMonthCount', null);
    Hive.box(miscellaneousDataHIVE).put('todaysdate', null);
    Hive.box(miscellaneousDataHIVE).put('isAwaitingEnrollment', false);
    Hive.box(miscellaneousDataHIVE).put('membershipExpiry', null);
    Hive.box(miscellaneousDataHIVE).put('isEnterScanScanned', null);
    Hive.box(miscellaneousDataHIVE).put('awaitingRenewal', false);
    Hive.box(miscellaneousDataHIVE).put('pendingRenewalsLength', null);

    SchedulerBinding.instance?.addPostFrameCallback((_) {
      if (mounted) {
        // Perform updates to the UI
        Navigator.of(context, rootNavigator: true)
            .pushReplacement(CupertinoPageRoute(
          builder: (context) => SignInPage(),
        )
                // ScaleRoute(page: SignInPage())
                );
      }
    });
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

  membershipExpiryBlock(String tagName, UserModel userdata,
      bool enableUpdateButton, bool isEditable) {
    var expiresOn = DateTime(
      userdata.membershipExpiry!.year,
      userdata.membershipExpiry!.month,
      userdata.membershipExpiry!.day,
      userdata.membershipExpiry!.hour,
      userdata.membershipExpiry!.second,
      userdata.membershipExpiry!.millisecond,
    );
    bool isExpired = expiresOn.isBefore(DateTime.now());
    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Container(
              padding: EdgeInsets.only(bottom: 20.w, left: 20.w, top: 20.w),
              width: MediaQuery.of(context).size.width * 0.25,
              decoration: BoxDecoration(
                color: Color(0xff20242A),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  bottomLeft: Radius.circular(20.r),
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.topLeft,
                child: Text(
                  (isExpired) ? 'Expired on   ' : '$tagName   ',
                  style: TextStyle(
                      color: (isExpired) ? Colors.red : Color(0xffFED428),
                      fontFamily: 'gilroy_bold',
                      fontSize: 13.sp),
                ),
              ),
            ),
            Container(
              height: 50.h,
              width: MediaQuery.of(context).size.width * 0.01,
              decoration: BoxDecoration(
                color: Color(0xff20242A),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: Text(
                  ':',
                  style: TextStyle(
                      color: Color(0xffFED428),
                      fontFamily: 'gilroy_bold',
                      fontSize: 13.sp),
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.only(bottom: 20.w, left: 20.w, top: 20.w),
                width: MediaQuery.of(context).size.width * 0.52,
                decoration: BoxDecoration(
                  color: Color(0xff20242A),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.r),
                    bottomRight: Radius.circular(20.r),
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.topLeft,
                  child: Text(
                    DateFormat('dd-MMM-yyyy')
                        .format(userdata.membershipExpiry!),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: (isExpired) ? Colors.red : Colors.white,
                        fontFamily: 'gilroy_bolditalic',
                        fontSize: 14.sp),
                  ),
                ))
          ]),
          Consumer(builder: (context, ref, __) {
            final profileState = ref.watch(Providers.profileControllerProvider);

            return (profileState.isLoading)
                ? Loader(
                    loadercolor: Colors.red,
                  )
                : GestureDetector(
                    onTap: () {
                      (isExpired)
                          ? (userdata.awaitingRenewal!)
                              ? CustomSnackBar.buildSnackbar(
                                  color: Colors.orangeAccent,
                                  context: context,
                                  iserror: true,
                                  message:
                                      'Kindly wait until ${userdata.enrolledGym} accepts your renewal request!',
                                  textcolor: Color(0xff1A1F25),
                                )
                              : profileState.renewRequest(context)
                          : null;
                    },
                    child: CircleAvatar(
                        maxRadius: 24.w,
                        backgroundColor: (isExpired)
                            ? (userdata.awaitingRenewal!)
                                ? Colors.orangeAccent
                                : Colors.red
                            : Color(0xff20242A),
                        child: Icon(
                          (isExpired)
                              ? (userdata.awaitingRenewal!)
                                  ? Icons.hourglass_bottom_rounded
                                  : Icons.autorenew_rounded
                              : Icons.arrow_forward_ios_rounded,
                          size: 16.sp,
                          color: (isExpired)
                              ? (userdata.awaitingRenewal!)
                                  ? Color(0xff1A1F25)
                                  : Colors.white
                              : Color(0xff2B3038),
                        )));
          })
        ],
      ),
    );
  }

  enrollmentNotification(bool isEnrolledToGym, BuildContext ctx) {
    return (isEnrolledToGym)
        ? Padding(
            padding: EdgeInsets.only(bottom: 20.h),
            child: Container(
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
                          color: Color(0xffFED428),
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
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: color_gt_headersTextColorWhite,
                          fontFamily: 'gilroy_regularitalic',
                          fontSize: 12.sp),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 5.h,
                      bottom: 10.h,
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        onPrimary: Colors.black, //to change text color
                        padding: EdgeInsets.symmetric(vertical: 7.h),
                        primary: Color(0xffFED428), // button color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20.r), // <-- Radius
                        ),
                        textStyle: TextStyle(
                            color: Color(0xff1A1F25),
                            fontSize: 15.sp,
                            fontFamily: 'gilroy_bold'),
                      ),
                      onPressed: () {
                        Navigator.push(ctx,
                            CupertinoPageRoute(builder: (ctx) => EnrollPage()));
                        // Navigator.of(context, rootNavigator: true)
                        //     .push(ScaleRoute(page: EnrollPage()));
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
                color: Color(0xff2B3038),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15.r),
                  bottomRight: Radius.circular(15.r),
                  // topLeft: Radius.circular(15.r),
                  // topRight: Radius.circular(15.r),
                ),
              ),
            ),
          )
        : Container();
  }

  newDataBlock(
      {required String tagName,
      required var tagData,
      bool isEditable = false}) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 20.w, left: 20.w, top: 20.w),
                width: MediaQuery.of(context).size.width * 0.25,
                decoration: BoxDecoration(
                  color: Color(0xff20242A),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    bottomLeft: Radius.circular(20.r),
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.topLeft,
                  child: Center(
                    child: Text(
                      '$tagName  ',
                      style: TextStyle(
                          color: Color(0xffFED428),
                          fontFamily: 'gilroy_bold',
                          fontSize: 13.sp),
                    ),
                  ),
                ),
              ),
              Container(
                height: 50.h,
                width: MediaQuery.of(context).size.width * 0.01,
                decoration: BoxDecoration(
                  color: Color(0xff20242A),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  child: Text(
                    ':',
                    style: TextStyle(
                        color: Color(0xffFED428),
                        fontFamily: 'gilroy_bold',
                        fontSize: 13.sp),
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.only(bottom: 20.w, left: 20.w, top: 20.w),
                  width: MediaQuery.of(context).size.width * 0.52,
                  decoration: BoxDecoration(
                    color: Color(0xff20242A),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.r),
                      bottomRight: Radius.circular(20.r),
                    ),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.topLeft,
                    child: Text(
                      (tagData.runtimeType == DateTime)
                          ? DateFormat('dd-MMM-yyyy').format(tagData)
                          : (tagName == 'Paid(₹)')
                              ? '$tagData /-'
                              : tagData,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'gilroy_regularitalic',
                          fontSize: 14.sp),
                    ),
                  ))
            ]),
        CircleAvatar(
            maxRadius: 24.w,
            backgroundColor:
                (isEditable) ? Color(0xffFED428) : Color(0xff20242A),
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16.sp,
              color: (isEditable) ? Color(0xff1A1F25) : Color(0xff2B3038),
            )),
      ]),
    );
  }
}
