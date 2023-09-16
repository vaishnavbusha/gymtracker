import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymtracker/widgets/loader.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../providers/authentication_providers.dart';

class ExpiredUsers extends ConsumerStatefulWidget {
  const ExpiredUsers({Key? key}) : super(key: key);

  @override
  ConsumerState<ExpiredUsers> createState() => _ExpiredUsersState();
}

class _ExpiredUsersState extends ConsumerState<ExpiredUsers> {
  @override
  void initState() {
    final _expiredUsersState = ref.read(expiredUsersProvider);
    _expiredUsersState.searchForExpiredUsers(context);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                final _expiredUsersState = ref.watch(expiredUsersProvider);

                return (_expiredUsersState.isLoading)
                    ? const Center(
                        child: Loader(
                          loadercolor: Colors.green,
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
                            physics: BouncingScrollPhysics(),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _expiredUsersState
                                      .expiredUsersDataList.length,
                                  itemBuilder: (context, index) {
                                    return dataWidget(
                                      Gender: _expiredUsersState
                                          .expiredUsersDataList[index].gender,
                                      Name: _expiredUsersState
                                          .expiredUsersDataList[index].userName,
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
    );
  }

  dataWidget(
      {required String Name,
      required String Phone,
      required String Gender,
      required var joinedOn,
      required var expiresOn}) {
    return Consumer(builder: (context, ref, __) {
      final noOfDays =
          ref.read(expiredUsersProvider).calculateNoOfDays(expiresOn);
      return Padding(
        padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
        child: Column(children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(width: 1, color: Colors.white12),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getTagNameTextWidget('Name'),
                            getTagNameTextWidget('Phone'),
                            getTagNameTextWidget('Gender'),
                            getTagNameTextWidget('Renewed On'),
                            getTagNameTextWidget('Expires On'),
                          ]),
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          getColonSpacing(),
                          getColonSpacing(),
                          getColonSpacing(),
                          getColonSpacing(),
                          getColonSpacing(),
                        ]),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          getTagDataTextWidget(Name),
                          getTagDataTextWidget(Phone),
                          getTagDataTextWidget(Gender),
                          getTagDataTextWidget(joinedOn),
                          getTagDataTextWidget(expiresOn),
                        ]),
                  ]),
                  expiryInDaysButton(joinedOn, expiresOn),
                ]),
          ),
        ]),
      );
    });
  }

  expiryInDaysButton(var renewedOn, var expiresOn) {
    return Consumer(builder: (context, ref, __) {
      final noOfDays =
          ref.read(expiredUsersProvider).calculateNoOfDays(expiresOn);
      return Padding(
        padding: EdgeInsets.only(right: 20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: (noOfDays > 15)
                    ? color_gt_green
                    : (noOfDays >= 8)
                        ? Colors.orange
                        : Colors.red,
                borderRadius: BorderRadius.circular(5.r),
                border: Border.all(width: 1, color: Colors.white12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  (noOfDays < 0) ? 'Expired' : '$noOfDays day(s)',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: color_gt_headersTextColorWhite,
                    fontFamily: 'gilroy_bolditalic',
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  getColonSpacing() {
    return Padding(
      padding: EdgeInsets.only(top: 3, bottom: 3),
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
      padding: EdgeInsets.only(top: 3, bottom: 3),
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
      padding: EdgeInsets.only(top: 3, bottom: 3),
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
