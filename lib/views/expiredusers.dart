// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymtracker/widgets/loader.dart';
import 'package:gymtracker/widgets/nointernet_widget.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../controllers/network_controller.dart';
import '../providers/authentication_providers.dart';

class ExpiredUsers extends ConsumerStatefulWidget {
  const ExpiredUsers({Key? key}) : super(key: key);

  @override
  ConsumerState<ExpiredUsers> createState() => _ExpiredUsersState();
}

class _ExpiredUsersState extends ConsumerState<ExpiredUsers> {
  @override
  void initState() {
    getData();

    super.initState();
  }

  getData() async {
    final _expiredUsersState = ref.read(expiredUsersProvider);
    await _expiredUsersState.searchForExpiredUsers(context);
  }

  @override
  Widget build(BuildContext context) {
    var connectivityStatusProvider = ref.watch(connectivityStatusProviders);

    return (connectivityStatusProvider == ConnectivityStatus.isConnected)
        ? GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              appBar: PreferredSize(
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                    child: AppBar(
                      centerTitle: true,
                      title: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Expired User(s)',
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
                preferredSize: const Size(
                  double.infinity,
                  50.0,
                ),
              ),
              backgroundColor: Colors.black,
              extendBody: true,
              body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xff122B32), Colors.black],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Consumer(
                    builder: (context, ref, child) {
                      final _expiredUsersState =
                          ref.watch(expiredUsersProvider);

                      return (_expiredUsersState.isLoading)
                          ? const Center(
                              child: Loader(
                                loadercolor: Color(0xff2D77D0),
                              ),
                            )
                          : (_expiredUsersState.expiredUsersDataList.isEmpty &&
                                  _expiredUsersState.isLoading == false)
                              ? Center(
                                  child: Text(
                                    'No expired user(s) found. Check again later.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 17.sp,
                                        fontFamily: 'gilroy_bolditalic'),
                                  ),
                                )
                              : SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: _expiredUsersState
                                            .expiredUsersDataList.length,
                                        itemBuilder: (context, index) {
                                          return dataWidget(
                                            Gender: _expiredUsersState
                                                .expiredUsersDataList[index]
                                                .gender,
                                            Name: _expiredUsersState
                                                .expiredUsersDataList[index]
                                                .userName,
                                            Phone: _expiredUsersState
                                                .expiredUsersDataList[index]
                                                .phoneNumber
                                                .toString(),
                                            joinedOn: _expiredUsersState
                                                .expiredUsersDataList[index]
                                                .enrolledGymDate,
                                            expiresOn: _expiredUsersState
                                                .expiredUsersDataList[index]
                                                .membershipExpiry,
                                            uid: _expiredUsersState
                                                .expiredUsersDataList[index]
                                                .uid,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                );
                    },
                  ),
                ),
              ),
            ),
          )
        : const NoInternetWidget();
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
        padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
        child: Column(children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white10,
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
                              color: Colors.blue.withOpacity(0.07),
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
    return Consumer(builder: (context, ref, __) {
      final expiredUsersState = ref.watch(expiredUsersProvider);
      final noOfDays = expiredUsersState.calculateNoOfDays(expiresOn);
      final isRequestedForApproval =
          expiredUsersState.isRequestedForApproval(uid);
      return Column(
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
              border: Border.all(width: 1.w, color: Colors.white12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
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
        ],
      );
    });
  }

  getColonSpacing() {
    return Padding(
      padding: EdgeInsets.only(top: 3.h, bottom: 3.h),
      child: Text(
        '  :   ',
        style: TextStyle(
          fontSize: 13.sp,
          color: color_gt_headersTextColorWhite,
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
          color: color_gt_green,
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
          color: color_gt_headersTextColorWhite,
          fontFamily: 'gilroy_bolditalic',
        ),
      ),
    );
  }
}
