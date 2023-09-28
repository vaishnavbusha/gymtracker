// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymtracker/widgets/loader.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../providers/authentication_providers.dart';

class AddUserManually extends ConsumerStatefulWidget {
  const AddUserManually({Key? key}) : super(key: key);

  @override
  ConsumerState<AddUserManually> createState() => _AddUserManuallyState();
}

class _AddUserManuallyState extends ConsumerState<AddUserManually> {
  // late TextEditingController _dateController;
  // late TextEditingController _userNameController;
  // late TextEditingController _phoneNumberController;
  // late TextEditingController _emailController;
  // late TextEditingController _moneyPaidController;
  // late TextEditingController _validityController;
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // @override
  // void initState() {
  //   _dateController = TextEditingController();
  //   _phoneNumberController = TextEditingController();
  //   _userNameController = TextEditingController();
  //   _emailController = TextEditingController();
  //   _validityController = TextEditingController();
  //   _moneyPaidController = TextEditingController();

  //   // TODO: implement initState
  //   super.initState();
  // }

  @override
  // void dispose() {
  //   _phoneNumberController.dispose();
  //   _userNameController.dispose();
  //   _emailController.dispose();

  //   // TODO: implement dispose
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final addUserManuallyState = ref.watch(addUserManuallyProvider);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: AppBar(
              centerTitle: true,
              title: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Add User Manually',
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xff122B32), Colors.black],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Center(
                  child: Form(
                    key: addUserManuallyState.formKey,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 10.h, bottom: 10.h, left: 10.h, right: 10.h),
                      child: Column(children: [
                        customTextFieldSignUp(
                            controller: addUserManuallyState.userNameController,
                            icon: Icons.person,
                            isObscure: false,
                            labeltext: 'UserName',
                            tia: TextInputAction.next),
                        Padding(
                          padding: EdgeInsets.only(top: 11.h, bottom: 5.h),
                          child: Consumer(builder: (context, ref, child) {
                            final addUserManuallyState =
                                ref.watch(addUserManuallyProvider);
                            return DropdownButtonFormField<String>(
                              isExpanded: true,
                              dropdownColor: color_gt_textColorBlueGrey,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white10,
                                floatingLabelStyle: TextStyle(
                                  fontFamily: "gilroy_bolditalic",
                                  fontSize: 16.sp,
                                  color: color_gt_headersTextColorWhite
                                      .withOpacity(0.9),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide:
                                      const BorderSide(color: Colors.white12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: BorderSide(
                                      color: color_gt_textColorBlueGrey
                                          .withOpacity(0.3)),
                                ),
                                prefixIcon: Icon(
                                  (addUserManuallyState.selectedgender ==
                                          'Male')
                                      ? Icons.male_rounded
                                      : Icons.female_rounded,
                                  color: color_gt_greenHalfOpacity
                                      .withOpacity(0.7),
                                ),
                              ),
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: color_gt_headersTextColorWhite,
                                fontFamily: 'gilroy_regular',
                              ),
                              value: addUserManuallyState.selectedgender,
                              hint: Text(
                                'Select Gender',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: color_gt_headersTextColorWhite
                                      .withOpacity(0.7),
                                  fontFamily: 'gilroy_regular',
                                ),
                              ),
                              onChanged: (value) {
                                addUserManuallyState.changegender(value!);
                              },
                              items: genders.map((item) {
                                return DropdownMenuItem<String>(
                                  child: Text(item),
                                  value: item,
                                );
                              }).toList(),
                            );
                          }),
                        ),
                        birthYearSelectionWidget(),
                        customTextFieldSignUp(
                            controller: addUserManuallyState.emailController,
                            icon: Icons.email,
                            isObscure: false,
                            labeltext: 'Email',
                            tia: TextInputAction.next),
                        customTextFieldSignUp(
                            controller:
                                addUserManuallyState.phoneNumberController,
                            icon: Icons.phone,
                            isObscure: false,
                            labeltext: 'Phone',
                            tia: TextInputAction.next),
                        customTextFieldSignUp(
                          controller: addUserManuallyState.validityController,
                          icon: Icons.calendar_today_rounded,
                          isObscure: false,
                          labeltext: 'validity (in months)',
                          tia: TextInputAction.next,
                        ),
                        customTextFieldSignUp(
                            controller:
                                addUserManuallyState.moneyPaidController,
                            icon: Icons.attach_money_rounded,
                            isObscure: false,
                            labeltext: 'Membership fees (₹)',
                            tia: TextInputAction.done),
                        Padding(
                          padding: EdgeInsets.only(top: 10.h),
                          child: Consumer(builder: (context, ref, __) {
                            final adduserManuallyProvider =
                                ref.watch(addUserManuallyProvider);
                            return (adduserManuallyProvider.isDataUploading)
                                ? Loader(
                                    loadercolor: Colors.green,
                                  )
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      //onPrimary: Colors.black,  //to change text color
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10.h, horizontal: 20.w),
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
                                    onPressed: () async {
                                      SystemChannels.textInput
                                          .invokeMethod('TextInput.hide');
                                      final FormState form =
                                          addUserManuallyState
                                              .formKey.currentState!;
                                      if (form.validate()) {
                                        print('form is valid');
                                        await adduserManuallyProvider.addUser(
                                          context: context,
                                        );
                                      } else {
                                        print('Form is invalid');
                                      }
                                    },
                                    child: Text('ADD USER'),
                                  );
                          }),
                        )
                      ]),
                    ),
                  ),
                )),
          ),
        ),
      ),
    );
  }

// email
// username
// enrolledgym
// enrolledgymdate - atuto
// ownername
// owneruid
// gender
// feespaid
// expiry
// phoennyumber
// renewedon
// registredate
  customTextFieldSignUp({
    required TextEditingController controller,
    required TextInputAction tia,
    required String labeltext,
    required bool isObscure,
    IconData? icon,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 5.sp,
        top: 12.sp,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ThemeData().colorScheme.copyWith(
                primary: color_gt_green,
              ),
        ),
        child: Consumer(builder: (context, ref, child) {
          final signUpController_var = ref.watch(signUpControllerProvider);
          return TextFormField(
            validator: (value) {
              if (labeltext == 'UserName') {
                if (value!.isEmpty) {
                  return '" Username " can\'t be empty !';
                } else {
                  return null;
                }
              } else if (labeltext == 'Email') {
                if (value!.isEmpty) {
                  return '" Email " field can\'t be empty !';
                } else if (!RegExp(
                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                    .hasMatch(value)) {
                  return '"Email" is badly formatted !';
                } else {
                  return null;
                }
              } else if (labeltext == 'Phone') {
                if (value!.isEmpty) {
                  return '" phone number " can\'t be empty !';
                } else if (!RegExp(r"^[0-9]{10}$").hasMatch(value)) {
                  return 'should contain 10 digits !';
                } else {
                  return null;
                }
              } else if (labeltext == 'validity (in months)') {
                if (controller.text.isEmpty) {
                  return 'membership validity data can\'t be empty !';
                } else if (int.parse(controller.text) > 12) {
                  return 'kindly enter equal or less than 12 months !';
                }
                return null;
              } else if (labeltext == 'Membership fees (₹)') {
                if (controller.text.isEmpty) {
                  return 'enter the money paid for the membership !';
                }
                return null;
              }
            },
            cursorHeight: 18.sp,
            cursorRadius: Radius.circular(30.r),
            obscureText: (isObscure)
                ? (labeltext == "Password")
                    ? signUpController_var.pass_isobscure
                    : signUpController_var.confirmpass_isobscure
                : false,
            style: TextStyle(
                fontSize: 15.sp,
                fontFamily: 'gilroy_regular',
                color: Colors.white70),
            keyboardType: (labeltext == 'Phone' ||
                    labeltext == 'validity (in months)' ||
                    labeltext == 'Membership fees (₹)')
                ? TextInputType.phone
                : TextInputType.emailAddress,
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
              prefixIcon: Icon(
                icon,
                color: color_gt_headersTextColorWhite.withOpacity(0.7),
              ),
              suffixIcon: (isObscure)
                  ? GestureDetector(
                      onTap: () {
                        (labeltext == "Password")
                            ? signUpController_var.changePassObscurity()
                            : signUpController_var.changeConfirmPassObscurity();
                      },
                      child: (labeltext == "Password")
                          ? (signUpController_var.pass_isobscure)
                              ? Icon(
                                  Icons.visibility_off,
                                  color: color_gt_greenHalfOpacity,
                                )
                              : Icon(
                                  Icons.visibility,
                                  color: color_gt_green,
                                )
                          : (signUpController_var.confirmpass_isobscure)
                              ? Icon(
                                  Icons.visibility_off,
                                  color: color_gt_greenHalfOpacity,
                                )
                              : Icon(
                                  Icons.visibility,
                                  color: color_gt_green,
                                ))
                  : GestureDetector(
                      onTap: () {
                        signUpController_var.changePassObscurity();
                      },
                      child: (signUpController_var.pass_isobscure)
                          ? Icon(
                              Icons.visibility_off,
                              size: 0,
                            )
                          : Icon(
                              Icons.visibility,
                              size: 0,
                            ),
                    ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(color: Colors.red, width: 0.5),
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

  birthYearSelectionWidget() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 5.sp,
        top: 10.sp,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ThemeData().colorScheme.copyWith(
                primary: color_gt_green,
              ),
        ),
        child: Consumer(builder: (context, ref, child) {
          final addUserManuallyState = ref.watch(addUserManuallyProvider);
          return TextFormField(
            validator: (value) {
              return (addUserManuallyState.calculateAge() < 17)
                  ? 'must be atleast 17 years !'
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
              labelText: 'Date of Birth',
              labelStyle: TextStyle(
                fontSize: 16.sp,
                color: color_gt_headersTextColorWhite.withOpacity(0.75),
              ),
              prefixIcon: Icon(
                Icons.cake_outlined,
                color: color_gt_headersTextColorWhite.withOpacity(0.7),
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
            controller: addUserManuallyState.dateController,
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
                String dateForDisplay = convertDateToDisplayFormat(pickedDate);
                String dateForDb = DateFormat('dd-MM-yyyy').format(pickedDate);
                addUserManuallyState.updateDate(pickedDate);
                print(addUserManuallyState.calculateAge());

                addUserManuallyState.dateController.text = dateForDb;
              }
            },
          );
        }),
      ),
    );
  }

  DateTime updatedInitialDateForPicker(pickeddate) {
    return (pickeddate == null) ? DateTime.now() : pickeddate;
  }

  String convertDateToDbFormat(DateTime dt) {
    // convert datetime obj to database compatible date format
    return DateFormat('dd-MM-yyyy').format(dt);
  }

  String convertDateToDisplayFormat(DateTime dt) {
    // convert datetime obj to display compatible date format
    return DateFormat('dd-MM-yyyy').format(dt);
  }

  bool checkMonthLimit(String dateForDisplay) {
    // Dart dateformat is stupid. It will convert month 15 to january. so we need to do extra verifications
    return int.parse(dateForDisplay.split("-")[0]) <= 12;
  }

  bool checkYearLength(String dateForDisplay) {
    // Dart dateformat is stupid. year "2" becomes 0002 which is BS.
    return dateForDisplay.split("-")[2].length == 4;
  }
}
