// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymtracker/widgets/loader.dart';
import 'package:gymtracker/widgets/nointernet_widget.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../constants.dart';
import '../controllers/network_controller.dart';
import '../providers/authentication_providers.dart';

class MyUsers extends ConsumerStatefulWidget {
  MyUsers({Key? key}) : super(key: key);

  @override
  ConsumerState<MyUsers> createState() => _MyUsersState();
}

class _MyUsersState extends ConsumerState<MyUsers> {
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  getData() async {
    final viewUsersState = ref.read(enrolledUsersProvider);
    await viewUsersState.getEnrolledUsersData();
    await viewUsersState.loadInitialUserData();
  }

  @override
  Widget build(BuildContext context) {
    var connectivityStatusProvider = ref.watch(connectivityStatusProviders);

    return (connectivityStatusProvider == ConnectivityStatus.isConnected)
        ? Scaffold(
            appBar: PreferredSize(
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: AppBar(
                    centerTitle: true,
                    title: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'My GymMembers',
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
            body: Center(
              child: Consumer(builder: (context, ref, child) {
                final enrolledUsersState = ref.watch(enrolledUsersProvider);

                return (enrolledUsersState.isLoading == false &&
                        enrolledUsersState.initialPaginationLoading == false)
                    ? SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount:
                                  enrolledUsersState.enrolledUsersData.length,
                              itemBuilder: (context, index) {
                                return dataWidget(
                                  Gender: enrolledUsersState
                                      .enrolledUsersData[index].gender,
                                  Name: enrolledUsersState
                                      .enrolledUsersData[index].userName,
                                  Phone: enrolledUsersState
                                      .enrolledUsersData[index].phoneNumber
                                      .toString(),
                                  joinedOn: enrolledUsersState
                                          .enrolledUsersData[index]
                                          .recentRenewedOn ??
                                      '',
                                  expiresOn: enrolledUsersState
                                      .enrolledUsersData[index]
                                      .membershipExpiry,
                                  uid: enrolledUsersState
                                      .enrolledUsersData[index].uid,
                                );
                              },
                            ),
                            (enrolledUsersState.paginationLoading)
                                ? LoadingAnimationWidget.staggeredDotsWave(
                                    color: Colors.redAccent,
                                    size: 30,
                                  )
                                : (enrolledUsersState.hasMoreData)
                                    ? InkWell(
                                        onTap: () async {
                                          (enrolledUsersState.hasMoreData)
                                              ? (enrolledUsersState
                                                      .paginationLoading)
                                                  ? null
                                                  : await enrolledUsersState
                                                      .paginatedUsersData()
                                              : null;
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(10.w),
                                          child: Container(
                                            padding: EdgeInsets.all(10.w),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.r)),
                                              color: enrolledUsersState
                                                      .paginationLoading
                                                  ? Color(0xff7E7D7D)
                                                  : Color(0xffFED428),
                                            ),
                                            child: Text(
                                              'load more',
                                              style: TextStyle(
                                                  color:
                                                      color_gt_headersTextColorWhite,
                                                  fontSize: 13.sp,
                                                  fontFamily:
                                                      'gilroy_bolditalic'),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: EdgeInsets.all(10.h),
                                        child: Text(
                                          'All users have been fetched.',
                                          style: TextStyle(
                                              color: Colors.orange,
                                              fontSize: 13.sp,
                                              fontFamily: 'gilroy_bolditalic'),
                                        ),
                                      ),
                          ],
                        ),
                      )
                    : Loader(
                        loadercolor: Color(0xffFED428),
                      );
              }),
            ),
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
    return Consumer(builder: (context, ref, __) {
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
                            // getTagNameTextWidget('Gender'),
                            getTagNameTextWidget('Renewed On'),
                            getTagNameTextWidget('Expires On'),
                          ]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getColonSpacing(),
                            getColonSpacing(),
                            //getColonSpacing(),
                            getColonSpacing(),
                            getColonSpacing(),
                          ]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getTagDataTextWidget(Name),
                            getTagDataTextWidget(Phone),
                            //getTagDataTextWidget(Gender),
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
    });
  }

  expiryInDaysButton(var expiresOn, String uid) {
    final enrolledUsersState = ref.read(enrolledUsersProvider);
    final noOfDays = enrolledUsersState.calculateNoOfDays(expiresOn);
    final isRequestedForApproval =
        enrolledUsersState.isRequestedForApproval(uid);
    return Padding(
      padding: EdgeInsets.only(right: 20.w),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: (noOfDays > 15)
                  ? color_gt_green
                  : (noOfDays >= 8)
                      ? Colors.orange
                      : (isRequestedForApproval)
                          ? const Color(0xff2D77D0)
                          : Colors.red,
              borderRadius: BorderRadius.circular(5.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(6.w),
              child: Text(
                (noOfDays < 0)
                    ? (isRequestedForApproval)
                        ? 'Awaiting Renewal'
                        : 'Expired'
                    : '$noOfDays day(s)',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: color_gt_headersTextColorWhite,
                  fontFamily: 'gilroy_bolditalic',
                ),
              ),
            ),
          ),
          // (noOfDays < 0)
          //     ? Padding(
          //         padding: EdgeInsets.only(top: 15.h),
          //         child: Container(
          //           decoration: BoxDecoration(
          //             color: Colors.red,
          //             borderRadius: BorderRadius.circular(5.r),
          //             border: Border.all(width: 1, color: Colors.white12),
          //           ),
          //           child: Padding(
          //             padding: const EdgeInsets.all(6.0),
          //             child: Text(
          //               'Remove',
          //               style: TextStyle(
          //                 fontSize: 13.sp,
          //                 color: color_gt_headersTextColorWhite,
          //                 fontFamily: 'gilroy_bolditalic',
          //               ),
          //             ),
          //           ),
          //         ),
          //       )
          //     : Container(),
        ],
      ),
    );
  }

  getColonSpacing() {
    return Padding(
      padding: EdgeInsets.only(top: 3.h, bottom: 3.h),
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
      padding: EdgeInsets.only(top: 3.h, bottom: 3.h),
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
      padding: EdgeInsets.only(top: 3.h, bottom: 3.h),
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
