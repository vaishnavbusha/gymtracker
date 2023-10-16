// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

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

class ApprovalsPage extends ConsumerStatefulWidget {
  List pendingApprovals;
  ApprovalsPage({Key? key, required this.pendingApprovals}) : super(key: key);

  @override
  ConsumerState<ApprovalsPage> createState() => _ApprovalsPageState();
}

class _ApprovalsPageState extends ConsumerState<ApprovalsPage> {
  // TextEditingController? _validityController;
  // TextEditingController? _moneyPaidController;
  late TextEditingController _dateController;
  @override
  void initState() {
    _dateController = TextEditingController();
    // _validityController = TextEditingController();
    // _moneyPaidController = TextEditingController();
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
      ..getConstraintDetails()
      ..getApproveeUID(widget.pendingApprovals)
      ..getAllUsersDataFromFireStore();
    //..get_isApprovalMembershipStartDateEditable();
  }

  @override
  void dispose() {
    // _validityController?.dispose();
    // _moneyPaidController?.dispose();
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
          child: (approvalState.isDataLoading!)
              ? Center(
                  child: Loader(loadercolor: Colors.blue),
                )
              : ListView.builder(
                  itemCount: approvalState.usersModelData.length,
                  itemBuilder: (context, index) {
                    return Consumer(builder: (context, ref, __) {
                      final approveButtonState =
                          ref.watch(testApprovalProvider(index));
                      final approveButtonNotifierState =
                          ref.watch(testApprovalProvider(index).notifier);
                      return Form(
                        key: approveButtonNotifierState.formKey,
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
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(children: [
                                      dataApprovalBlock(
                                          tagData: (approvalState
                                                      .usersModelData[index]
                                                  as UserModel)
                                              .userName,
                                          tagName: 'UserName'),
                                      dataApprovalBlock(
                                          tagData: (approvalState
                                                      .usersModelData[index]
                                                  as UserModel)
                                              .phoneNumber
                                              .toString(),
                                          tagName: 'Phone'),
                                      dataApprovalBlock(
                                          tagData: (approvalState
                                                      .usersModelData[index]
                                                  as UserModel)
                                              .enrolledGymDate,
                                          tagName: 'Submited On'),
                                      // approvalState.isDateEditable!
                                      //     ? birthYearSelectionWidget((approvalState
                                      //             .usersModelData[index] as UserModel)
                                      //         .enrolledGymDate!)
                                      //     : dataApprovalBlock(
                                      //         tagData:
                                      //             (approvalState.usersModelData[index]
                                      //                     as UserModel)
                                      //                 .enrolledGymDate,
                                      //         tagName: 'Submited On'),
                                      (approvalState.isPlanStartDateEnabled!)
                                          ? membershipStartDateWidget()
                                          : dataApprovalBlock(
                                              tagData: DateTime.now(),
                                              tagName: 'Approving On'),

                                      customTextField(
                                        controller: approveButtonNotifierState
                                            .validityController,
                                        isObscure: false,
                                        labeltext: 'validity (in months)',
                                        tia: TextInputAction.next,
                                      ),
                                      customTextField(
                                        controller: approveButtonNotifierState
                                            .moneyPaidController,
                                        isObscure: false,
                                        labeltext: 'Membership fees (₹)',
                                        tia: TextInputAction.next,
                                      ),
                                      (approveButtonState.isDetailsUpdating ==
                                                  false ||
                                              approveButtonState
                                                      .isRemovalUpdating ==
                                                  false)
                                          ? Padding(
                                              padding: EdgeInsets.all(10.w),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Consumer(
                                                    builder:
                                                        (context, ref, child) {
                                                      return ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          //onPrimary: Colors.black,  //to change text color
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 7.h,
                                                                  horizontal:
                                                                      20.w),
                                                          primary: (approveButtonState
                                                                          .isRemoved ==
                                                                      true ||
                                                                  approveButtonState
                                                                          .isApproved ==
                                                                      true)
                                                              ? Colors.grey
                                                              : color_gt_green, // button color
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(10
                                                                        .r), // <-- Radius
                                                          ),
                                                          textStyle: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15.sp,
                                                              fontFamily:
                                                                  'gilroy_bold'),
                                                        ),
                                                        onPressed: () {
                                                          if (approveButtonState
                                                                      .isRemoved ==
                                                                  true ||
                                                              approveButtonState
                                                                      .isApproved ==
                                                                  true) {
                                                            null;
                                                          } else {
                                                            final FormState
                                                                form =
                                                                approveButtonNotifierState
                                                                    .formKey
                                                                    .currentState!;
                                                            if (form
                                                                .validate()) {
                                                              approveButtonNotifierState
                                                                  .approveUser(
                                                                approveeUID:
                                                                    approvalState
                                                                        .usersModelData[
                                                                            index]
                                                                        .uid,
                                                                index: index,
                                                                context:
                                                                    context,
                                                                userName: approvalState
                                                                    .usersModelData[
                                                                        index]
                                                                    .userName,
                                                                memberShipStartDate:
                                                                    (approvalState
                                                                            .isPlanStartDateEnabled!)
                                                                        ? approvalState
                                                                            .pickedDate
                                                                        : null,
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
                                                        child: (approveButtonState
                                                                    .isApproved ==
                                                                true)
                                                            ? Text('APPROVED')
                                                            : Text('APPROVE'),
                                                      );
                                                    },
                                                  ),
                                                  Consumer(
                                                    builder:
                                                        (context, ref, child) {
                                                      return ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          //onPrimary: Colors.black,  //to change text color
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 7.h,
                                                                  horizontal:
                                                                      20.w),
                                                          primary: (approveButtonState
                                                                          .isRemoved ==
                                                                      true ||
                                                                  approveButtonState
                                                                          .isApproved ==
                                                                      true)
                                                              ? Colors.grey
                                                              : Colors
                                                                  .red, // button color
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(10
                                                                        .r), // <-- Radius
                                                          ),
                                                          textStyle: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15.sp,
                                                              fontFamily:
                                                                  'gilroy_bold'),
                                                        ),
                                                        onPressed: () {
                                                          if (approveButtonState
                                                                      .isRemoved ==
                                                                  true ||
                                                              approveButtonState
                                                                      .isApproved ==
                                                                  true) {
                                                            null;
                                                          } else {
                                                            showDialog(
                                                              context: context,
                                                              builder: (ctx) =>
                                                                  RemoveButtonDialog(
                                                                index: index,
                                                                username: (approvalState
                                                                            .usersModelData[index]
                                                                        as UserModel)
                                                                    .userName,
                                                                uid: (approvalState
                                                                            .usersModelData[index]
                                                                        as UserModel)
                                                                    .uid!,
                                                              ),
                                                            );

                                                            // final FormState form =
                                                            //     approveButtonNotifierState
                                                            //         .formKey
                                                            //         .currentState!;
                                                            // if (form.validate()) {

                                                            //   print('form is valid');
                                                            // } else {
                                                            //   print(
                                                            //       'Form is invalid');
                                                            // }
                                                            //ref.watch(enrollControllerProvider).updateEnrollmentInfo();
                                                          }
                                                        },
                                                        child: (approveButtonState
                                                                    .isRemoved ==
                                                                true)
                                                            ? Text('REMOVED')
                                                            : Text('REMOVE'),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Loader(loadercolor: Colors.blue),
                                    ]),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 12.h, bottom: 6.h),
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
                    });
                  },
                ),
        ),
      ),
    );
  }

  membershipStartDateWidget() {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.h, top: 10.h, left: 10.w, right: 10.w),
      child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ThemeData().colorScheme.copyWith(
                primary: color_gt_green,
              ),
        ),
        child: Consumer(builder: (context, ref, child) {
          final approvalState = ref.watch(approvalControllerProvider);
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Start Date : ',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: color_gt_green,
                  fontFamily: 'gilroy_bold',
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.65,
                child: TextFormField(
                  validator: (value) {
                    return (value!.isEmpty)
                        ? 'Plan start date cannot be empty'
                        : null;
                  },
                  enableInteractiveSelection: false,
                  showCursor: false,
                  keyboardType: TextInputType.none,
                  cursorHeight: 18.sp,
                  cursorRadius: Radius.circular(30.r),
                  style: TextStyle(
                      fontSize: 15.sp,
                      fontFamily: 'gilroy_regular',
                      color: Colors.white70),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white10,
                    floatingLabelStyle: TextStyle(
                      fontFamily: "gilroy_bolditalic",
                      fontSize: 16.sp,
                      color: color_gt_headersTextColorWhite.withOpacity(0.9),
                    ),
                    labelText: 'Membership start date',
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
                  controller: _dateController,
                  cursorColor: color_gt_textColorBlueGrey,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDatePickerMode: DatePickerMode.year,
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(
                          1900), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      print(pickedDate);
                      String dateForDisplay =
                          convertDateToDisplayFormat(pickedDate);
                      String dateForDb =
                          DateFormat('dd-MM-yyyy').format(pickedDate);
                      approvalState.updateDate(pickedDate);

                      _dateController.text = dateForDb;
                    }
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  String convertDateToDisplayFormat(DateTime dt) {
    // convert datetime obj to display compatible date format
    return DateFormat('dd-MM-yyyy').format(dt);
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
              if (labeltext == 'Membership fees (₹)') {
                if (controller.text.isEmpty) {
                  return 'enter the money paid for the membership !';
                } else if (int.parse(controller.text) > 50000) {
                  return 'Can\'t exceed ₹50,000 !';
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
              // prefixIcon: Icon(
              //   icon,
              //   color: color_gt_headersTextColorWhite.withOpacity(0.7),
              // ),
              // suffixIcon: (isObscure)
              //     ? GestureDetector(
              //         onTap: () {
              //           (labeltext == "Password")
              //               ? signUpController_var.changePassObscurity()
              //               : signUpController_var.changeConfirmPassObscurity();
              //         },
              //         child: (labeltext == "Password")
              //             ? (signUpController_var.pass_isobscure)
              //                 ? Icon(
              //                     Icons.visibility_off,
              //                     color: color_gt_greenHalfOpacity,
              //                   )
              //                 : Icon(
              //                     Icons.visibility,
              //                     color: color_gt_green,
              //                   )
              //             : (signUpController_var.confirmpass_isobscure)
              //                 ? Icon(
              //                     Icons.visibility_off,
              //                     color: color_gt_greenHalfOpacity,
              //                   )
              //                 : Icon(
              //                     Icons.visibility,
              //                     color: color_gt_green,
              //                   ))
              //     : GestureDetector(
              //         onTap: () {
              //           signUpController_var.changePassObscurity();
              //         },
              //         child: (signUpController_var.pass_isobscure)
              //             ? Icon(
              //                 Icons.visibility_off,
              //                 size: 0,
              //               )
              //             : Icon(
              //                 Icons.visibility,
              //                 size: 0,
              //               ),
              //       ),
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

class RemoveButtonDialog extends ConsumerStatefulWidget {
  int index;
  String username;
  String uid;
  RemoveButtonDialog({
    Key? key,
    required this.index,
    required this.username,
    required this.uid,
  }) : super(key: key);

  @override
  ConsumerState<RemoveButtonDialog> createState() => _RemoveButtonDialogState();
}

class _RemoveButtonDialogState extends ConsumerState<RemoveButtonDialog> {
  @override
  Widget build(BuildContext context) {
    final approveButtonNotifierState =
        ref.watch(testApprovalProvider(widget.index).notifier);
    return AnimatedContainer(
      duration: Duration(
        milliseconds: 500,
      ),
      curve: Curves.fastLinearToSlowEaseIn,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.r))),
        //backgroundColor: Color(widget.color),
        backgroundColor: Colors.black,
        title: Text(
          "Remove ${widget.username}",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'gilroy_bold',
            color: Colors.white,
          ),
        ),
        content: RichText(
          textAlign: TextAlign.justify,
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Are you sure want to remove ',
                style: TextStyle(
                  fontFamily: 'gilroy_regular',
                  color: Colors.white,
                ),
              ),
              TextSpan(
                text: "\"${widget.username}\"",
                style:
                    TextStyle(fontFamily: 'gilroy_bold', color: Colors.white),
              ),
              TextSpan(
                text: ' approval request ?',
                style: TextStyle(
                  fontFamily: 'gilroy_regular',
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          // ignore: deprecated_member_use
          Padding(
            padding: EdgeInsets.only(bottom: 5.h),
            child: FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "NO",
                style: TextStyle(
                    fontFamily: 'gilroy_regular',
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 8.w, bottom: 5.h),
            child: FlatButton(
              minWidth: 50,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              color: Colors.red,
              onPressed: () async {
                await approveButtonNotifierState.removeUser(
                  approveeUID: widget.uid,
                  context: context,
                );
                Navigator.of(context).pop();
              },
              child: Text(
                "REMOVE",
                style: TextStyle(
                    fontFamily: 'gilroy_regular',
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
