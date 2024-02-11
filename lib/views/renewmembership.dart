// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymtracker/providers/providers.dart';
import 'package:gymtracker/widgets/nointernet_widget.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../controllers/network_controller.dart';
import '../widgets/loader.dart';

class RenewMembershipsPage extends ConsumerStatefulWidget {
  const RenewMembershipsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<RenewMembershipsPage> createState() =>
      _RenewMembershipsPageState();
}

class _RenewMembershipsPageState extends ConsumerState<RenewMembershipsPage> {
  @override
  void initState() {
    getdata();
    // TODO: implement initState
    super.initState();
  }

  getdata() async {
    final renewMemberShipState = ref.read(Providers.renewMemberShipProvider);
    await renewMemberShipState.getUIDsAwaitingRenewal();
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
                          'Renewal Request(s)',
                          style: TextStyle(
                            fontFamily: 'gilroy_bolditalic',
                            color: Color(0xffFED428),
                          ),
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
              extendBody: true,
              backgroundColor: Color(0xff1A1F25),
              body: Consumer(
                builder: (context, ref, child) {
                  final renewMemberShipState =
                      ref.watch(Providers.renewMemberShipProvider);

                  return (renewMemberShipState.isLoading == false)
                      ? (renewMemberShipState.expiredUsersData.isNotEmpty)
                          ? ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount:
                                  renewMemberShipState.expiredUsersData.length,
                              itemBuilder: (context, index) {
                                final renewFamilyState = ref.watch(
                                    Providers.renewMemberShipFamilyProvider(
                                        index));
                                final renewFamilyNotifierState = ref.watch(
                                    Providers.renewMemberShipFamilyProvider(
                                            index)
                                        .notifier);
                                return Form(
                                  key: renewFamilyNotifierState.formKey,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5.h, horizontal: 10.w),
                                        child: Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Color(0xff7e7d7d)
                                                    .withOpacity(0.09),
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                              ),
                                              child: Column(children: [
                                                dataBlock(
                                                    tagData:
                                                        renewMemberShipState
                                                            .expiredUsersData[
                                                                index]
                                                            .userName,
                                                    tagName: 'UserName'),
                                                dataBlock(
                                                    tagData:
                                                        renewMemberShipState
                                                            .expiredUsersData[
                                                                index]
                                                            .phoneNumber
                                                            .toString(),
                                                    tagName: 'Phone'),
                                                dataBlock(
                                                    tagData:
                                                        renewMemberShipState
                                                            .expiredUsersData[
                                                                index]
                                                            .membershipExpiry,
                                                    tagName: 'Expired On'),
                                                dataBlock(
                                                    tagData: DateTime.now(),
                                                    tagName: 'Approving On'),
                                                dataBlock(
                                                    tagData:
                                                        renewMemberShipState
                                                            .expiredUsersData[
                                                                index]
                                                            .memberShipFeesPaid,
                                                    tagName:
                                                        'Previously Paid(₹)'),
                                                customTextField(
                                                  controller:
                                                      renewFamilyNotifierState
                                                          .validityController,
                                                  isObscure: false,
                                                  labeltext:
                                                      'validity (in months)',
                                                  tia: TextInputAction.next,
                                                ),
                                                customTextField(
                                                  controller:
                                                      renewFamilyNotifierState
                                                          .moneyPaidController,
                                                  isObscure: false,
                                                  labeltext: 'Renewal Fee (₹)',
                                                  tia: TextInputAction.next,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(10.w),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Consumer(
                                                        builder: (context, ref,
                                                            child) {
                                                          return (renewFamilyState
                                                                      .isDetailsUpdating ==
                                                                  false)
                                                              ? ElevatedButton(
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    //onPrimary: Colors.black,  //to change text color
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            7.h,
                                                                        horizontal:
                                                                            20.w),
                                                                    primary: (renewFamilyState.isApproved ==
                                                                            true)
                                                                        ? Color(
                                                                            0xff7e7d7d)
                                                                        : Color(
                                                                            0xffFED428), // button color
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.r), // <-- Radius
                                                                    ),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    if (renewFamilyState
                                                                            .isApproved ==
                                                                        true) {
                                                                      null;
                                                                    } else {
                                                                      final FormState
                                                                          form =
                                                                          renewFamilyNotifierState
                                                                              .formKey
                                                                              .currentState!;
                                                                      if (form
                                                                          .validate()) {
                                                                        renewFamilyNotifierState
                                                                            .renewUser(
                                                                          userModelData:
                                                                              renewMemberShipState.expiredUsersData[index],
                                                                          index:
                                                                              index,
                                                                          context:
                                                                              context,
                                                                        );

                                                                        print(
                                                                            'form is valid');
                                                                      } else {
                                                                        print(
                                                                            'Form is invalid');
                                                                      }
                                                                      //ref.watch(enrollControllerProvider).updateEnrollmentInfo();
                                                                    }
                                                                  },
                                                                  child: (renewFamilyState
                                                                              .isApproved ==
                                                                          true)
                                                                      ? Text(
                                                                          'RENEWED',
                                                                          style: TextStyle(
                                                                              color: Color(0xff1A1F25),
                                                                              fontSize: 15.sp,
                                                                              fontFamily: 'gilroy_bold'),
                                                                        )
                                                                      : Text(
                                                                          'RENEW',
                                                                          style: TextStyle(
                                                                              color: Color(0xff1A1F25),
                                                                              fontSize: 15.sp,
                                                                              fontFamily: 'gilroy_bold'),
                                                                        ),
                                                                )
                                                              : const Loader(
                                                                  loadercolor:
                                                                      Color(
                                                                          0xffFED428),
                                                                );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ]),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Text(
                                'No Renewal request(s) yet. Check again later!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  color: Color(0xff7e7d7d),
                                  fontFamily: 'gilroy_bold',
                                ),
                              ),
                            )
                      : Center(
                          child: Loader(
                            loadercolor: Color(0xffFED428),
                          ),
                        );
                },
              ),
            ),
          )
        : const NoInternetWidget();
  }

  dataWidget(
      {required String Name,
      required String Phone,
      required String Gender,
      required var joinedOn,
      required var expiresOn}) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
      child: Column(children: [
        Padding(
          padding: EdgeInsets.only(left: 10.h, right: 10.h),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(width: 1.w, color: Colors.white12),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10.w),
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
    return Padding(
      padding: EdgeInsets.only(right: 20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.orangeAccent,
              borderRadius: BorderRadius.circular(5.r),
              border: Border.all(width: 1, color: Colors.white12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text(
                'Renew',
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
          fontFamily: 'gilroy_bolditalic',
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

  dataBlock({required String tagName, required var tagData}) {
    return Padding(
      padding: EdgeInsets.all(10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$tagName : ',
            style: TextStyle(
              fontSize: 14.sp,
              color: Color(0xffFED428),
              fontFamily: 'gilroy_bold',
            ),
          ),
          Container(
            width: (tagName == 'Renewal Fee(₹)')
                ? MediaQuery.of(context).size.width * 0.52
                : MediaQuery.of(context).size.width * 0.59,
            decoration: BoxDecoration(
              color: Color(0xff20242A),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                  width: 1, color: Color(0xff7e7d7d).withOpacity(0.05)),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 14.h),
              child: Text(
                (tagData.runtimeType == DateTime)
                    ? DateFormat('dd-MMM-yyyy').format(tagData)
                    : tagData.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: color_gt_headersTextColorWhite,
                  fontFamily: 'gilroy_regular',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  customTextField({
    required TextEditingController controller,
    required TextInputAction tia,
    required String labeltext,
    required bool isObscure,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 10.sp,
        left: 10.w,
        right: 10.w,
        top: 10.sp,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ThemeData().colorScheme.copyWith(
                primary: Color(0xffFED428),
              ),
        ),
        child: Consumer(builder: (context, ref, child) {
          return TextFormField(
            validator: (value) {
              if (labeltext == 'validity (in months)') {
                if (controller.text.isEmpty) {
                  return 'membership validity data can\'t be empty !';
                } else if (int.parse(controller.text) > 12) {
                  return 'kindly enter equal or less than 12 months !';
                }
                return null;
              }
              if (labeltext == 'Renewal Fee (₹)') {
                if (controller.text.isEmpty) {
                  return 'enter the money paid for the membership !';
                }
                return null;
              }
            },
            cursorHeight: 18.sp,
            cursorRadius: Radius.circular(30.r),
            style: TextStyle(
                fontSize: 15.sp,
                fontFamily: 'gilroy_regular',
                color: Colors.white70),
            keyboardType: TextInputType.phone,
            textInputAction: tia,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xff20242A),
              floatingLabelStyle: TextStyle(
                fontFamily: "gilroy_bolditalic",
                fontSize: 16.sp,
                color: color_gt_headersTextColorWhite.withOpacity(0.9),
              ),
              labelText: labeltext,
              labelStyle: TextStyle(
                fontSize: 16.sp,
                color: color_gt_headersTextColorWhite.withOpacity(0.75),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(color: Colors.red, width: 0.25),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide:
                    BorderSide(color: Color(0xff7e7d7d).withOpacity(0.05)),
              ),
              errorStyle: TextStyle(
                  fontFamily: 'gilroy_regularitalic',
                  color: Colors.red[500]!,
                  fontSize: 12.sp),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide:
                    BorderSide(color: Color(0xff7e7d7d).withOpacity(0.05)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide:
                    BorderSide(color: Color(0xff7e7d7d).withOpacity(0.05)),
              ),
            ),
            controller: controller,
            cursorColor: color_gt_textColorBlueGrey,
          );
        }),
      ),
    );
  }
}
