// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymtracker/models/user_model.dart';
import 'package:gymtracker/notifiers/approval_notifier.dart';
import 'package:gymtracker/widgets/loader.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../providers/authentication_providers.dart';

class TestApprovalsPage extends ConsumerStatefulWidget {
  List pendingApprovals;
  TestApprovalsPage({Key? key, required this.pendingApprovals})
      : super(key: key);

  @override
  ConsumerState<TestApprovalsPage> createState() => _TestApprovalsPageState();
}

class _TestApprovalsPageState extends ConsumerState<TestApprovalsPage> {
  @override
  void initState() {
    //getDetailsFromController();
    // final approvalState = ref.read(approvalControllerProvider);

    // approvalState.getApproveeUID(widget.pendingApprovals);
    // approvalState.getAllUsersDataFromFireStore();
    getDetailsFromController();
    // TODO: implement initState
    super.initState();
  }

  void getDetailsFromController() {
    ref.read(approvalControllerProvider)
      ..getApproveeUID(widget.pendingApprovals)
      ..getAllUsersDataFromFireStore();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final approvalState = ref.watch(approvalControllerProvider);

    //approvalState.getAllUsersDataFromFireStore();
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
                    'Pending Approvals',
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
            56.0,
          ),
        ),
        backgroundColor: Colors.black,
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
          child: ListView.builder(
            itemCount: approvalState.usersModelData.length,
            itemBuilder: (context, index) {
              final testApprovalState = ref.watch(testApprovalProvider(index));
              final testApprovalNotifierState =
                  ref.watch(testApprovalProvider(index).notifier);
              return Consumer(builder: (context, ref, __) {
                return Form(
                  key: testApprovalNotifierState.formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 5.h, horizontal: 10.w),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color:
                                    color_gt_textColorBlueGrey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(children: [
                                dataApprovalBlock(
                                    tagData: (approvalState
                                            .usersModelData[index] as UserModel)
                                        .userName,
                                    tagName: 'UserName'),
                                dataApprovalBlock(
                                    tagData: (approvalState
                                            .usersModelData[index] as UserModel)
                                        .phoneNumber
                                        .toString(),
                                    tagName: 'Phone'),
                                dataApprovalBlock(
                                    tagData: (approvalState
                                            .usersModelData[index] as UserModel)
                                        .enrolledGymDate,
                                    tagName: 'Submited On'),
                                dataApprovalBlock(
                                    tagData: DateTime.now(),
                                    tagName: 'Approving On'),
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme:
                                        ThemeData().colorScheme.copyWith(
                                              primary: color_gt_green,
                                            ),
                                  ),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (testApprovalNotifierState
                                          .validityController.text.isEmpty) {
                                        return 'membership validity data can\'t be empty !';
                                      }
                                      return null;
                                    },
                                    cursorHeight: 18.sp,
                                    cursorRadius: Radius.circular(30.r),
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        fontFamily: 'gilroy_regular',
                                        color: Colors.white70),
                                    keyboardType: TextInputType.phone,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white10,
                                      floatingLabelStyle: TextStyle(
                                        fontFamily: "gilroy_bolditalic",
                                        fontSize: 16.sp,
                                        color: color_gt_headersTextColorWhite
                                            .withOpacity(0.9),
                                      ),
                                      labelText: 'validity (in months)',
                                      labelStyle: TextStyle(
                                        fontSize: 16.sp,
                                        color: color_gt_headersTextColorWhite
                                            .withOpacity(0.75),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        borderSide: const BorderSide(
                                            color: Colors.white10),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        borderSide: BorderSide(
                                            color: color_gt_textColorBlueGrey
                                                .withOpacity(0.2)),
                                      ),
                                      errorStyle: TextStyle(
                                          fontFamily: 'gilroy_regularitalic',
                                          color: Colors.red[500]!,
                                          fontSize: 12.sp),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        borderSide: const BorderSide(
                                            color: Colors.white10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        borderSide: BorderSide(
                                            color: color_gt_textColorBlueGrey
                                                .withOpacity(0.2)),
                                      ),
                                    ),
                                    controller: testApprovalNotifierState
                                        .validityController,
                                    cursorColor: color_gt_textColorBlueGrey,
                                  ),
                                ),
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme:
                                        ThemeData().colorScheme.copyWith(
                                              primary: color_gt_green,
                                            ),
                                  ),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (testApprovalNotifierState
                                          .moneyPaidController.text.isEmpty) {
                                        return 'enter the money paid for the membership !';
                                      }
                                      return null;
                                    },
                                    cursorHeight: 18.sp,
                                    cursorRadius: Radius.circular(30.r),
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        fontFamily: 'gilroy_regular',
                                        color: Colors.white70),
                                    keyboardType: TextInputType.phone,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white10,
                                      floatingLabelStyle: TextStyle(
                                        fontFamily: "gilroy_bolditalic",
                                        fontSize: 16.sp,
                                        color: color_gt_headersTextColorWhite
                                            .withOpacity(0.9),
                                      ),
                                      labelText: 'Amount Paid (₹)',
                                      labelStyle: TextStyle(
                                        fontSize: 16.sp,
                                        color: color_gt_headersTextColorWhite
                                            .withOpacity(0.75),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        borderSide: const BorderSide(
                                            color: Colors.white10),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        borderSide: BorderSide(
                                            color: color_gt_textColorBlueGrey
                                                .withOpacity(0.2)),
                                      ),
                                      errorStyle: TextStyle(
                                          fontFamily: 'gilroy_regularitalic',
                                          color: Colors.red[500]!,
                                          fontSize: 12.sp),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        borderSide: const BorderSide(
                                            color: Colors.white10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        borderSide: BorderSide(
                                            color: color_gt_textColorBlueGrey
                                                .withOpacity(0.2)),
                                      ),
                                    ),
                                    controller: testApprovalNotifierState
                                        .moneyPaidController,
                                    cursorColor: color_gt_textColorBlueGrey,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10.w),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      //onPrimary: Colors.black,  //to change text color
                                      padding: EdgeInsets.symmetric(
                                          vertical: 7.h, horizontal: 20.w),
                                      primary: color_gt_green, // button color
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10.r), // <-- Radius
                                      ),
                                      textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.sp,
                                          fontFamily: 'gilroy_bold'),
                                    ),
                                    onPressed: () {
                                      final FormState form =
                                          testApprovalNotifierState
                                              .formKey.currentState!;

                                      if (form.validate()) {
                                        // approvalState.approveUser(
                                        //     amountPaid:
                                        //         _moneyPaidController!.text,
                                        //     index: index,
                                        //     validityInMonths:
                                        //         _validityController!.text);
                                        print('form is valid');
                                      } else {
                                        print('Form is invalid');
                                      }
                                      //ref.watch(enrollControllerProvider).updateEnrollmentInfo();
                                    },
                                    child: Text(
                                      'APPROVE',
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 12.h, bottom: 6.h),
                              child: Divider(
                                color:
                                    color_gt_greenHalfOpacity.withOpacity(0.3),
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
              });
            },
          ),
        ),
      ),
    );
  }

  // customTextField({
  //   //required TextEditingController controller,
  //   required TextInputAction tia,
  //   required String labeltext,
  //   required bool isObscure,
  // }) {
  //   return Padding(
  //     padding: EdgeInsets.only(
  //       bottom: 10.sp,
  //       left: 10.w,
  //       right: 10.w,
  //       top: 10.sp,
  //     ),
  //     child: Theme(
  //       data: Theme.of(context).copyWith(
  //         colorScheme: ThemeData().colorScheme.copyWith(
  //               primary: color_gt_green,
  //             ),
  //       ),
  //       child: Consumer(builder: (context, ref, child) {
  //         return TextFormField(
  //           validator: (value) {
  //             if (labeltext == 'validity (in months)') {
  //               if (controller.text.isEmpty) {
  //                 return 'membership validity data can\'t be empty !';
  //               } else if (int.parse(controller.text) > 12) {
  //                 return 'kindly enter equal or less than 12 months !';
  //               }
  //               return null;
  //             }
  //             if (labeltext == 'Amount Paid (₹)') {
  //               if (controller.text.isEmpty) {
  //                 return 'enter the money paid for the membership !';
  //               }
  //               return null;
  //             }
  //             return null;
  //           },
  //           cursorHeight: 18.sp,
  //           cursorRadius: Radius.circular(30.r),
  //           style: TextStyle(
  //               fontSize: 15.sp,
  //               fontFamily: 'gilroy_regular',
  //               color: Colors.white70),
  //           keyboardType: TextInputType.phone,
  //           textInputAction: tia,
  //           decoration: InputDecoration(
  //             filled: true,
  //             fillColor: Colors.white10,
  //             floatingLabelStyle: TextStyle(
  //               fontFamily: "gilroy_bolditalic",
  //               fontSize: 16.sp,
  //               color: color_gt_headersTextColorWhite.withOpacity(0.9),
  //             ),
  //             labelText: labeltext,
  //             labelStyle: TextStyle(
  //               fontSize: 16.sp,
  //               color: color_gt_headersTextColorWhite.withOpacity(0.75),
  //             ),
  //             errorBorder: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(10.r),
  //               borderSide: const BorderSide(color: Colors.white10),
  //             ),
  //             focusedErrorBorder: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(10.r),
  //               borderSide: BorderSide(
  //                   color: color_gt_textColorBlueGrey.withOpacity(0.2)),
  //             ),
  //             errorStyle: TextStyle(
  //                 fontFamily: 'gilroy_regularitalic',
  //                 color: Colors.red[500]!,
  //                 fontSize: 12.sp),
  //             enabledBorder: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(10.r),
  //               borderSide: const BorderSide(color: Colors.white10),
  //             ),
  //             focusedBorder: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(10.r),
  //               borderSide: BorderSide(
  //                   color: color_gt_textColorBlueGrey.withOpacity(0.2)),
  //             ),
  //           ),
  //           controller: controller,
  //           cursorColor: color_gt_textColorBlueGrey,
  //         );
  //       }),
  //     ),
  //   );
  // }

  dataApprovalBlock({required String tagName, required var tagData}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
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
            width: MediaQuery.of(context).size.width * 0.65,
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
                    : tagData,
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
}

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key? key,
    required TextEditingController controller,
    required TextInputAction tia,
    required String labeltext,
    required bool isObscure,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
