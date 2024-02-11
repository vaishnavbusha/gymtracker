// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:gymtracker/providers/providers.dart';
import 'package:gymtracker/widgets/loader.dart';

import '../constants.dart';

class EnrollPage extends ConsumerStatefulWidget {
  const EnrollPage({Key? key}) : super(key: key);

  @override
  ConsumerState<EnrollPage> createState() => _EnrollPageState();
}

class _EnrollPageState extends ConsumerState<EnrollPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final enrollState = ref.watch(Providers.enrollControllerProvider);
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
                  'Enroll',
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
        preferredSize: Size(
          double.infinity,
          56.0,
        ),
      ),
      backgroundColor: Color(0xff1A1F25),
      body: (enrollState.gymPartnersData.isNotEmpty)
          ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                padding: EdgeInsets.only(
                    top: 25.h, left: 10.w, right: 10.w, bottom: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Gym Partner:  ',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Color(0xffFED428),
                        fontFamily: 'gilroy_bold',
                      ),
                    ),
                    SizedBox(
                      //height: 44.h,
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: DropdownButtonFormField<String>(
                        dropdownColor: Color(0xff2B3038),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xff20242A),
                          floatingLabelStyle: TextStyle(
                            fontFamily: "gilroy_bolditalic",
                            fontSize: 16.sp,
                            color:
                                color_gt_headersTextColorWhite.withOpacity(0.9),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(
                                color: Color(0xff7e7d7d).withOpacity(0.05)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(
                                color: Color(0xff7e7d7d).withOpacity(0.05)),
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: color_gt_headersTextColorWhite,
                          fontFamily: 'gilroy_regular',
                        ),
                        value: enrollState.dropdownvalue,
                        hint: Text(
                          'Select gym names',
                          style: TextStyle(
                            fontSize: 15.sp,
                            color:
                                color_gt_headersTextColorWhite.withOpacity(0.7),
                            fontFamily: 'gilroy_regular',
                          ),
                        ),
                        onChanged: (value) {
                          enrollState.changeEnrollGymName(value!);
                        },
                        items: enrollState.gymNames.map((item) {
                          return DropdownMenuItem<String>(
                            child: Center(
                              child: Text(
                                item,
                              ),
                            ),
                            value: item,
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 25.h, left: 10.w, right: 10.w, bottom: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Gym Owner:  ',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Color(0xffFED428),
                        fontFamily: 'gilroy_bold',
                      ),
                    ),
                    Container(
                      height: 43.h,
                      width: MediaQuery.of(context).size.width * 0.65,
                      decoration: BoxDecoration(
                        color: Color(0xff20242A),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                            width: 1,
                            color: Color(0xff7e7d7d).withOpacity(0.05)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 14.h),
                        child: Text(
                          '${enrollState.gymPartnersData[enrollState.selectedIndexOfGymPartnersData].gymPartnerName}',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: color_gt_headersTextColorWhite,
                            fontFamily: 'gilroy_regular',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Consumer(builder: (context, ref, child) {
                final enrollcontroller =
                    ref.watch(Providers.enrollControllerProvider);
                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 80.h, vertical: 30.h),
                  child: (enrollcontroller.isLoading == false)
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            onPrimary: !(enrollcontroller.isEnrolled)
                                ? Colors.black
                                : Colors.white
                                    .withOpacity(0.5), //to change text color
                            padding: EdgeInsets.symmetric(vertical: 15.h),
                            primary: !(enrollcontroller.isEnrolled)
                                ? Color(0xffFED428)
                                : Colors.grey.withOpacity(0.5), // button color
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10.r), // <-- Radius
                            ),
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 15.sp,
                                fontFamily: 'gilroy_bold'),
                          ),
                          onPressed: () {
                            (enrollcontroller.isEnrolled)
                                ? null
                                : enrollcontroller
                                    .updateEnrollmentInfo(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.fitness_center_rounded),
                              SizedBox(width: 10.w),
                              Text(
                                'Enroll Now !',
                              ),
                            ],
                          ),
                        )
                      : Loader(
                          loadercolor: Color(0xffFED428),
                        ),
                );
              }),
            ])
          : Loader(
              loadercolor: Color(0xffFED428),
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
        ref.watch(Providers.testApprovalProvider(widget.index).notifier);
    return AnimatedContainer(
      duration: Duration(
        milliseconds: 500,
      ),
      curve: Curves.fastLinearToSlowEaseIn,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.r))),
        //backgroundColor: Color(widget.color),
        backgroundColor: Color(0xff1A1F25),
        title: Text(
          "Remove Approval Request",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'gilroy_bold',
            color: Color(0xffFED428),
          ),
        ),
        content: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Are you sure want to remove ',
                style: TextStyle(
                  fontFamily: 'gilroy_regular',
                  color: Color(0xff7E7D7D),
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
                    fontFamily: 'gilroy_regular', color: Color(0xff7E7D7D)),
              ),
            ],
          ),
        ),
        // actions: <Widget>[
        //   // ignore: deprecated_member_use
        //   Padding(
        //     padding: EdgeInsets.only(bottom: 5.h),
        //     child: FlatButton(
        //       onPressed: () {
        //         Navigator.of(context).pop();
        //       },
        //       child: Text(
        //         "NO",
        //         style: TextStyle(
        //             fontFamily: 'gilroy_regular',
        //             fontWeight: FontWeight.bold,
        //             color: Colors.white),
        //       ),
        //     ),
        //   ),
        //   Padding(
        //     padding: EdgeInsets.only(right: 8.w, bottom: 5.h),
        //     child: FlatButton(
        //       minWidth: 50,
        //       shape: const RoundedRectangleBorder(
        //           borderRadius: BorderRadius.all(Radius.circular(10.0))),
        //       color: Colors.red,
        //       onPressed: () async {
        //         await approveButtonNotifierState.removeUser(
        //           approveeUID: widget.uid,
        //           context: context,
        //         );
        //         Navigator.of(context).pop();
        //       },
        //       child: Text(
        //         "REMOVE",
        //         style: TextStyle(
        //             fontFamily: 'gilroy_regular',
        //             fontWeight: FontWeight.bold,
        //             color: Colors.white),
        //       ),
        //     ),
        //   ),
        // ],
      ),
    );
  }
}
