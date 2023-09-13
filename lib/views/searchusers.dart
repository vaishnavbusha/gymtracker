// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymtracker/widgets/loader.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../providers/authentication_providers.dart';

class SearchUsers extends StatefulWidget {
  const SearchUsers({Key? key}) : super(key: key);

  @override
  State<SearchUsers> createState() => _SearchUsersState();
}

class _SearchUsersState extends State<SearchUsers> {
  TextEditingController? _searchController;
  @override
  void initState() {
    _searchController = TextEditingController();
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
                    'Search User',
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
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 256.w,
                        child: TextField(
                          controller: _searchController,
                          cursorHeight: 18.sp,
                          cursorRadius: Radius.circular(30.r),
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontFamily: 'gilroy_regular',
                              color: Colors.white70),
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white10,
                            floatingLabelStyle: TextStyle(
                              fontFamily: "gilroy_bolditalic",
                              fontSize: 16.sp,
                              color: color_gt_headersTextColorWhite
                                  .withOpacity(0.9),
                            ),
                            labelText: 'Search User',
                            labelStyle: TextStyle(
                              fontSize: 16.sp,
                              color: color_gt_headersTextColorWhite
                                  .withOpacity(0.75),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(
                                  color: color_gt_textColorBlueGrey
                                      .withOpacity(0.2)),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide:
                                  const BorderSide(color: Colors.white10),
                            ),
                            errorStyle: TextStyle(
                                fontFamily: 'gilroy_regularitalic',
                                color: Colors.red[500]!,
                                fontSize: 12.sp),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide:
                                  const BorderSide(color: Colors.white10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(
                                  color: color_gt_textColorBlueGrey
                                      .withOpacity(0.2)),
                            ),
                          ),
                        ),
                      ),
                      Consumer(builder: (context, ref, child) {
                        final _searchUsersState =
                            ref.watch(searchUsersProvider);
                        return Material(
                          borderRadius: BorderRadius.circular(10.r),
                          child: Ink(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                color: (_searchController!.text.isNotEmpty)
                                    ? color_gt_green
                                    : Colors.grey),
                            height: 32.h,
                            width: 65.w,
                            child: InkWell(
                              onTap: () async {
                                (_searchController!.text.isNotEmpty)
                                    ? await _searchUsersState.searchForAUser(
                                        _searchController!.text, context)
                                    : null;
                              },
                              child: Center(
                                child: Icon(
                                  Icons.arrow_forward_ios_sharp,
                                  color: Colors.white,
                                  size: 20.r,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                Consumer(
                  builder: (context, ref, child) {
                    final _searchUsersState = ref.watch(searchUsersProvider);
                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                      // Add Your Code here.

                      _searchUsersState.checkForInitial();
                    });
                    return (_searchUsersState.isInitital == true)
                        ? SizedBox()
                        : (_searchUsersState.searchedUsersDataList.isNotEmpty)
                            ? (_searchUsersState.isSearchLoading)
                                ? Center(
                                    child: Loader(
                                      loadercolor: Colors.green,
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: _searchUsersState
                                        .searchedUsersDataList.length,
                                    itemBuilder: (context, index) {
                                      return dataWidget(
                                        Gender: _searchUsersState
                                            .searchedUsersDataList[index]
                                            .gender,
                                        Name: _searchUsersState
                                            .searchedUsersDataList[index]
                                            .userName,
                                        Phone: _searchUsersState
                                            .searchedUsersDataList[index]
                                            .phoneNumber
                                            .toString(),
                                        joinedOn: _searchUsersState
                                            .searchedUsersDataList[index]
                                            .enrolledGymDate,
                                        expiresOn: _searchUsersState
                                            .searchedUsersDataList[index]
                                            .membershipExpiry,
                                      );
                                    },
                                  )
                            : Center(
                                child: Loader(
                                  loadercolor: Colors.green,
                                ),
                              );
                  },
                ),
              ]),
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
          ref.read(searchUsersProvider).calculateNoOfDays(expiresOn);
      return Padding(
        padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
        child: Column(children: [
          Container(
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
        ]),
      );
    });
  }

  expiryInDaysButton(var renewedOn, var expiresOn) {
    return Consumer(builder: (context, ref, __) {
      final noOfDays =
          ref.read(searchUsersProvider).calculateNoOfDays(expiresOn);
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
