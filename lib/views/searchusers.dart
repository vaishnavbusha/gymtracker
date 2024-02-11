// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymtracker/widgets/loader.dart';
import 'package:gymtracker/widgets/nointernet_widget.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../controllers/network_controller.dart';
import '../providers/providers.dart';

class SearchUsers extends ConsumerStatefulWidget {
  const SearchUsers({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchUsers> createState() => _SearchUsersState();
}

class _SearchUsersState extends ConsumerState<SearchUsers> {
  TextEditingController? _searchController;
  @override
  void initState() {
    _searchController = TextEditingController();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var connectivityStatusProvider =
        ref.watch(Providers.connectivityStatusProviders);

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
                          'Search User',
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
              body: Padding(
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
                                fillColor: Color(0xff20242A),
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
                                      color:
                                          Color(0xff7e7d7d).withOpacity(0.05)),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 0.25),
                                ),
                                errorStyle: TextStyle(
                                    fontFamily: 'gilroy_regularitalic',
                                    color: Colors.red[500]!,
                                    fontSize: 12.sp),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: BorderSide(
                                      color:
                                          Color(0xff7e7d7d).withOpacity(0.05)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: BorderSide(
                                      color:
                                          Color(0xff7e7d7d).withOpacity(0.05)),
                                ),
                              ),
                            ),
                          ),
                          Consumer(builder: (context, ref, child) {
                            final _searchUsersState =
                                ref.watch(Providers.searchUsersProvider);
                            return (!_searchUsersState.isSearchLoading)
                                ? Material(
                                    borderRadius: BorderRadius.circular(10.r),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          color: (_searchController!.text
                                                  .trim()
                                                  .isNotEmpty)
                                              ? (_searchUsersState
                                                      .isSearchLoading)
                                                  ? Color(0xff7E7D7D)
                                                  : Color(0xffFED428)
                                              : Color(0xff7E7D7D)),
                                      height: 32.h,
                                      width: 65.w,
                                      child: InkWell(
                                        onTap: () async {
                                          print(_searchController!.text
                                              .replaceAll(
                                                  RegExp("[ \n\t\r\f]"), '')
                                              .length);
                                          (_searchController!.text
                                                  .trim()
                                                  .isNotEmpty)
                                              ? (_searchUsersState
                                                      .isSearchLoading)
                                                  ? null
                                                  : _searchUsersState
                                                      .searchForAUser(
                                                          _searchController!
                                                              .text
                                                              .replaceAll(
                                                                  RegExp(
                                                                      "[ \n\t\r\f]"),
                                                                  ''),
                                                          context)
                                              : null;
                                        },
                                        child: Center(
                                          child: Icon(
                                            Icons.arrow_forward_ios_sharp,
                                            color: Color(0xff1A1F25),
                                            size: 20.r,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Loader(
                                    loadercolor: Color(0xffFED428),
                                  );
                          }),
                        ],
                      ),
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        final _searchUsersState =
                            ref.watch(Providers.searchUsersProvider);
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          // Add Your Code here.

                          _searchUsersState.checkForInitial();
                        });
                        return (_searchUsersState.isInitital == true)
                            ? SizedBox()
                            : (_searchUsersState
                                    .searchedUsersDataList.isNotEmpty)
                                ? (_searchUsersState.isSearchLoading)
                                    ? Center(
                                        child: Loader(
                                          loadercolor: Color(0xff2D77D0),
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
                                            uid: _searchUsersState
                                                .searchedUsersDataList[index]
                                                .uid,
                                          );
                                        },
                                      )
                                : Center(
                                    child: Loader(
                                      loadercolor: Color(0xff2D77D0),
                                    ),
                                  );
                      },
                    ),
                  ]),
                ),
              ),
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
                            color: (Gender == 'Male')
                                ? Colors.blue.withOpacity(0.07)
                                : Colors.pinkAccent.withOpacity(0.07),
                            borderRadius: BorderRadius.circular(10.r)),
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
                          //getTagNameTextWidget('Gender'),
                          getTagNameTextWidget('Renewed On'),
                          getTagNameTextWidget('Expires On'),
                        ]),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          getColonSpacing(),
                          getColonSpacing(),
                          // getColonSpacing(),
                          getColonSpacing(),
                          getColonSpacing(),
                        ]),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          getTagDataTextWidget(Name),
                          getTagDataTextWidget(Phone),
                          // getTagDataTextWidget(Gender),
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
  }

  expiryInDaysButton(var expiresOn, String uid) {
    final searchUsersState = ref.read(Providers.searchUsersProvider);
    final noOfDays = searchUsersState.calculateNoOfDays(expiresOn);
    final isRequestedForApproval = searchUsersState.isRequestedForApproval(uid);
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
          ),
          child: Padding(
            padding: EdgeInsets.all(6.r),
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
