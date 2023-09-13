import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymtracker/providers/authentication_providers.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
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
    final renewMemberShipState = ref.read(renewMemberShipProvider);
    await renewMemberShipState.getUIDsAwaitingRenewal();
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
                    'Renewal Request(s)',
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
        extendBody: true,
        backgroundColor: Colors.black,
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
          child: Consumer(
            builder: (context, ref, child) {
              final renewMemberShipState = ref.watch(renewMemberShipProvider);

              return (renewMemberShipState.isLoading == false)
                  ? (renewMemberShipState.expiredUsersData.isNotEmpty)
                      ? ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount:
                              renewMemberShipState.expiredUsersData.length,
                          itemBuilder: (context, index) {
                            final renewFamilyState =
                                ref.watch(renewMemberShipFamilyProvider(index));
                            final renewFamilyNotifierState = ref.watch(
                                renewMemberShipFamilyProvider(index).notifier);
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
                                            color: color_gt_textColorBlueGrey
                                                .withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Column(children: [
                                            dataBlock(
                                                tagData: renewMemberShipState
                                                    .expiredUsersData[index]
                                                    .userName,
                                                tagName: 'UserName'),
                                            dataBlock(
                                                tagData: renewMemberShipState
                                                    .expiredUsersData[index]
                                                    .phoneNumber
                                                    .toString(),
                                                tagName: 'Phone'),
                                            dataBlock(
                                                tagData: renewMemberShipState
                                                    .expiredUsersData[index]
                                                    .membershipExpiry,
                                                tagName: 'Expired On'),
                                            dataBlock(
                                                tagData: DateTime.now(),
                                                tagName: 'Approving On'),
                                            dataBlock(
                                                tagData: renewMemberShipState
                                                    .expiredUsersData[index]
                                                    .memberShipFeesPaid,
                                                tagName: 'Previously Paid(₹)'),
                                            customTextField(
                                              controller:
                                                  renewFamilyNotifierState
                                                      .validityController,
                                              isObscure: false,
                                              labeltext: 'validity (in months)',
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
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Consumer(
                                                    builder:
                                                        (context, ref, child) {
                                                      return (renewFamilyState
                                                                  .isDetailsUpdating ==
                                                              false)
                                                          ? ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                //onPrimary: Colors.black,  //to change text color
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            7.h,
                                                                        horizontal:
                                                                            20.w),
                                                                primary: (renewFamilyState
                                                                            .isApproved ==
                                                                        true)
                                                                    ? Colors
                                                                        .grey
                                                                    : color_gt_green, // button color
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10.r), // <-- Radius
                                                                ),
                                                                textStyle: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        15.sp,
                                                                    fontFamily:
                                                                        'gilroy_bold'),
                                                              ),
                                                              onPressed: () {
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
                                                                          renewMemberShipState
                                                                              .expiredUsersData[index],
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
                                                                  ? const Text(
                                                                      'RENEWED')
                                                                  : const Text(
                                                                      'RENEW'),
                                                            )
                                                          : const Loader(
                                                              loadercolor:
                                                                  Colors.red);
                                                    },
                                                  ),
                                                  // Consumer(
                                                  //   builder: (context, ref, child) {
                                                  //     return (renewFamilyState
                                                  //                 .isDetailsUpdating ==
                                                  //             false)
                                                  //         ? ElevatedButton(
                                                  //             style: ElevatedButton
                                                  //                 .styleFrom(
                                                  //               //onPrimary: Colors.black,  //to change text color
                                                  //               padding: EdgeInsets
                                                  //                   .symmetric(
                                                  //                       vertical:
                                                  //                           7.h,
                                                  //                       horizontal:
                                                  //                           20.w),
                                                  //               primary: (renewFamilyState
                                                  //                           .isApproved ==
                                                  //                       true)
                                                  //                   ? Colors.grey
                                                  //                   : color_gt_green, // button color
                                                  //               shape:
                                                  //                   RoundedRectangleBorder(
                                                  //                 borderRadius:
                                                  //                     BorderRadius
                                                  //                         .circular(
                                                  //                             10.r), // <-- Radius
                                                  //               ),
                                                  //               textStyle: TextStyle(
                                                  //                   color: Colors
                                                  //                       .black,
                                                  //                   fontSize: 15.sp,
                                                  //                   fontFamily:
                                                  //                       'gilroy_bold'),
                                                  //             ),
                                                  //             onPressed: () {
                                                  //               if (renewFamilyState
                                                  //                       .isApproved ==
                                                  //                   true) {
                                                  //                 null;
                                                  //               } else {
                                                  //                 final FormState
                                                  //                     form =
                                                  //                     renewFamilyNotifierState
                                                  //                         .formKey
                                                  //                         .currentState!;
                                                  //                 if (form
                                                  //                     .validate()) {
                                                  //                   renewFamilyNotifierState
                                                  //                       .removeUser(
                                                  //                     userModelData:
                                                  //                         renewMemberShipState
                                                  //                                 .expiredUsersData[
                                                  //                             index],
                                                  //                     index: index,
                                                  //                     context:
                                                  //                         context,
                                                  //                   );

                                                  //                   print(
                                                  //                       'form is valid');
                                                  //                 } else {
                                                  //                   print(
                                                  //                       'Form is invalid');
                                                  //                 }
                                                  //                 //ref.watch(enrollControllerProvider).updateEnrollmentInfo();
                                                  //               }
                                                  //             },
                                                  //             child: (renewFamilyState
                                                  //                         .isApproved ==
                                                  //                     true)
                                                  //                 ? const Text(
                                                  //                     'REMOVED !')
                                                  //                 : const Text(
                                                  //                     'REMOVE USER'),
                                                  //           )
                                                  //         : const Loader(
                                                  //             loadercolor:
                                                  //                 Colors.red);
                                                  //   },
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          ]),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 12.h, bottom: 6.h),
                                          child: Divider(
                                            color: color_gt_greenHalfOpacity
                                                .withOpacity(0.3),
                                            height: 1.h,
                                            thickness: 1,
                                            // endIndent: 10.w,
                                            // indent: 20.w,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                            // return dataWidget(
                            //   Gender: renewMemberShipState
                            //       .expiredUsersData[index].gender,
                            //   Name: renewMemberShipState
                            //       .expiredUsersData[index].userName,
                            //   Phone: renewMemberShipState
                            //       .expiredUsersData[index].phoneNumber
                            //       .toString(),
                            //   joinedOn: renewMemberShipState
                            //       .expiredUsersData[index].enrolledGymDate,
                            //   expiresOn: renewMemberShipState
                            //       .expiredUsersData[index].membershipExpiry,
                            // );
                          },
                        )
                      : Center(
                          child: Text(
                            'No Renewal request(s) yet. Kindly check again later !',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17.sp,
                              color: color_gt_green,
                              fontFamily: 'gilroy_bold',
                            ),
                          ),
                        )
                  : const Loader(
                      loadercolor: Colors.green,
                    );
            },
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
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Column(children: [
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Container(
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
      padding: EdgeInsets.only(right: 20),
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
          // Padding(
          //   padding: EdgeInsets.only(top: 15.h),
          //   child: Container(
          //     decoration: BoxDecoration(
          //       color: Colors.red,
          //       borderRadius: BorderRadius.circular(5.r),
          //       border: Border.all(width: 1, color: Colors.white12),
          //     ),
          //     child: Padding(
          //       padding: EdgeInsets.all(6.w),
          //       child: Text(
          //         'Remove Member',
          //         style: TextStyle(
          //           fontSize: 13.sp,
          //           color: color_gt_headersTextColorWhite,
          //           fontFamily: 'gilroy_bolditalic',
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
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
              color: color_gt_green,
              fontFamily: 'gilroy_bold',
            ),
          ),
          Container(
            height: 43.h,
            width: MediaQuery.of(context).size.width * 0.59,
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(width: 1, color: Colors.white12),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 14.h),
              child: Text(
                (tagData.runtimeType == DateTime)
                    ? DateFormat('dd-MMM-yyyy').format(tagData)
                    : tagData.toString(),
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
                primary: color_gt_green,
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
              if (labeltext == 'Amount Paid (₹)') {
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
              fillColor: Colors.white10,
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
                borderSide: const BorderSide(color: Colors.white10),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(
                    color: color_gt_textColorBlueGrey.withOpacity(0.2)),
              ),
              errorStyle: TextStyle(
                  fontFamily: 'gilroy_regularitalic',
                  color: Colors.red[500]!,
                  fontSize: 12.sp),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(color: Colors.white10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(
                    color: color_gt_textColorBlueGrey.withOpacity(0.2)),
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
