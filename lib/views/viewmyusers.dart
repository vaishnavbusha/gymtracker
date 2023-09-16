// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymtracker/widgets/loader.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../constants.dart';
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
                  'My GymMembers',
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
        child: Center(
          child: Consumer(builder: (context, ref, child) {
            final enrolledUsersState = ref.watch(enrolledUsersProvider);
            print(enrolledUsersState.isLoading);
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
                                  .enrolledUsersData[index].enrolledGymDate,
                              expiresOn: enrolledUsersState
                                  .enrolledUsersData[index].membershipExpiry,
                            );
                          },
                        ),
                        (!enrolledUsersState.paginationLoading)
                            ? (enrolledUsersState.hasMoreData)
                                ? GestureDetector(
                                    onTap: () async {
                                      (enrolledUsersState.hasMoreData)
                                          ? await enrolledUsersState
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
                                          color: Colors.green,
                                        ),
                                        child: Text(
                                          'load more',
                                          style: TextStyle(
                                              color:
                                                  color_gt_headersTextColorWhite,
                                              fontSize: 13.sp,
                                              fontFamily: 'gilroy_bolditalic'),
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
                                  )
                            : LoadingAnimationWidget.staggeredDotsWave(
                                color: Colors.redAccent,
                                size: 30,
                              ),
                      ],
                    ),
                  )
                : Loader(
                    loadercolor: Colors.green,
                  );
          }),
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
    final noOfDays =
        ref.read(enrolledUsersProvider).calculateNoOfDays(expiresOn);
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Column(children: [
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: noOfDays < 0 ? Colors.white30 : Colors.white10,
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
        ),
      ]),
    );
  }

  expiryInDaysButton(var renewedOn, var expiresOn) {
    final noOfDays =
        ref.read(enrolledUsersProvider).calculateNoOfDays(expiresOn);

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
