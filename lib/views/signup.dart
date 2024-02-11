// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, duplicate_ignore, must_be_immutable, non_constant_identifier_names, use_super_parameters

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymtracker/controllers/sign_up_controller.dart';
import 'package:gymtracker/models/user_model.dart';
import 'package:gymtracker/providers/providers.dart';
import 'package:gymtracker/views/signin.dart';
import 'package:gymtracker/widgets/loader.dart';
import 'package:gymtracker/widgets/nointernet_widget.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../controllers/network_controller.dart';
import '../widgets/animated_route.dart';
import '../widgets/utils.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final SignUpController signUpGlobalReadState;
  @override
  void initState() {
    signUpGlobalReadState = ref.read(Providers.signUpControllerProvider);
    super.initState();
  }

  final Shader linearGradient = LinearGradient(
    colors: <Color>[Colors.white, Colors.white54],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  @override
  Widget build(BuildContext context) {
    final connectivityStatusProvider =
        ref.watch(Providers.connectivityStatusProviders);
    return (connectivityStatusProvider == ConnectivityStatus.isConnected)
        ? GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: WillPopScope(
              onWillPop: () => CustomUtilities.onWillPop(
                body: 'Do you want to exit ?',
                context: context,
                notificationName: 'Are you sure?',
              ),
              child: Scaffold(
                //resizeToAvoidBottomInset: false,
                backgroundColor: Color(0xff1A1F25),
                body: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.w,
                  ),
                  child: Form(
                    key: _formKey,
                    child: AnimatedPadding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      child: Center(
                        child: ListView(
                            shrinkWrap: true,
                            physics: AlwaysScrollableScrollPhysics(),
                            children: [
                              Center(
                                child: Column(children: [
                                  Image.asset(
                                    'assets/images/gymtracker_white.png',
                                    height: 80.h,
                                    fit: BoxFit.contain,
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Text(
                                    'REGISTER',
                                    style: TextStyle(
                                      //foreground: Paint()..shader = linearGradient,
                                      //color: Colors.white,
                                      fontFamily: "gilroy_bold",
                                      fontSize: 35.sp,
                                      foreground: Paint()
                                        ..shader = linearGradient,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ]),
                              ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: [
                              //     Text(
                              //       'Register',
                              //       style: TextStyle(
                              //         //foreground: Paint()..shader = linearGradient,
                              //         color: Colors.white,
                              //         fontFamily: "teko-med",
                              //         fontSize: 60.sp,
                              //       ),
                              //     ),
                              //   ],
                              // ),

                              customTextFieldSignUp(
                                controller:
                                    signUpGlobalReadState.userNameController,
                                icon: Icons.contact_page_outlined,
                                isObscure: false,
                                labeltext: 'UserName',
                                iconName: 'idcard',
                                tia: TextInputAction.newline,
                              ),
                              genderDropDown(),
                              BirthYearSelectionWidget(),
                              customTextFieldSignUp(
                                controller:
                                    signUpGlobalReadState.emailController,
                                icon: Icons.email,
                                isObscure: false,
                                labeltext: 'Email',
                                iconName: 'email',
                                tia: TextInputAction.newline,
                              ),

                              customTextFieldSignUp(
                                controller:
                                    signUpGlobalReadState.phoneNumberController,
                                icon: Icons.phone,
                                isObscure: false,
                                labeltext: 'Phone',
                                iconName: 'phone',
                                tia: TextInputAction.newline,
                              ),
                              customTextFieldSignUp(
                                controller:
                                    signUpGlobalReadState.passwordController,
                                icon: Icons.security_outlined,
                                isObscure: true,
                                iconName: 'password_2',
                                labeltext: 'Password',
                                tia: TextInputAction.newline,
                              ),
                              customTextFieldSignUp(
                                controller: signUpGlobalReadState
                                    .confirmPasswordController,
                                icon: Icons.security_outlined,
                                isObscure: true,
                                iconName: 'password_2',
                                labeltext: 'Confirm Password',
                                tia: TextInputAction.done,
                              ),

                              Consumer(builder: (context, ref, child) {
                                final registerprovider = ref
                                    .watch(Providers.signUpControllerProvider);

                                return Padding(
                                  padding: EdgeInsets.only(top: 17.h),
                                  child: InkWell(
                                    onTap: () async {
                                      SystemChannels.textInput
                                          .invokeMethod('TextInput.hide');
                                      final FormState form =
                                          _formKey.currentState!;

                                      if (form.validate()) {
                                        UserModel userData = UserModel(
                                          pendingApprovals: null,
                                          isAwaitingEnrollment: false,
                                          phoneNumber: signUpGlobalReadState
                                              .phoneNumberController.text
                                              .trim(),
                                          DOB: signUpGlobalReadState
                                              .dateController.text,
                                          email: signUpGlobalReadState
                                              .emailController.text
                                              .trim(),
                                          isUser: true,
                                          registeredDate: DateTime.now(),
                                          userName: signUpGlobalReadState
                                              .userNameController.text
                                              .toLowerCase()
                                              .trim(),
                                          userType: userLevels[0]!,
                                          gender:
                                              registerprovider.selectedgender,
                                        );
                                        registerprovider.registerUser(
                                          userModel: userData,
                                          ctx: context,
                                        );
                                      } else {
                                        print('Form is invalid');
                                      }
                                    },
                                    child: (!registerprovider
                                            .is_register_details_uploading)
                                        ? Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 50.h,
                                            decoration: BoxDecoration(
                                              color: Color(0xffFED428),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10.r),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Sign Up',
                                                style: TextStyle(
                                                    fontFamily: 'gilroy_bold',
                                                    fontSize: 20.sp,
                                                    color: Color(0xff1A1F25)),
                                              ),
                                            ),
                                          )
                                        : Padding(
                                            padding: EdgeInsets.only(
                                              top: 17.w,
                                            ),
                                            child: Loader(
                                              loadercolor: Color(0xffFED428),
                                            ),
                                          ),
                                  ),
                                );
                              }),
                              Padding(
                                padding:
                                    EdgeInsets.only(top: 30.h, bottom: 10.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Already have an account? ',
                                      style: TextStyle(
                                        color: color_gt_headersTextColorWhite,
                                        fontSize: 14.sp,
                                        fontFamily: 'gilroy_regularitalic',
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) =>
                                                  SignInPage(),
                                            ));
                                      },
                                      child: Text(
                                        'Sign-in !',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Color(0xffFED428),
                                          fontFamily: 'gilroy_bolditalic',
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              // Padding(
                              //   padding: EdgeInsets.only(
                              //     top: 7.w,
                              //   ),
                              //   child: Row(
                              //       mainAxisAlignment: MainAxisAlignment.center,
                              //       children: [
                              //         Flexible(
                              //             child: Divider(
                              //           color: color_gt_greenHalfOpacity,
                              //           height: 1.h,
                              //           thickness: 1,
                              //           endIndent: 10.w,
                              //           indent: 20.w,
                              //         )),
                              //         Text(
                              //           'or',
                              //           style: TextStyle(
                              //               fontFamily: 'gilroy_regular',
                              //               fontSize: 15.sp,
                              //               color: color_gt_green),
                              //         ),
                              //         Flexible(
                              //             child: Divider(
                              //           color: color_gt_greenHalfOpacity,
                              //           height: 1.h,
                              //           thickness: 1,
                              //           endIndent: 20.w,
                              //           indent: 10.w,
                              //         )),
                              //       ]),
                              // ),
                            ]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        : NoInternetWidget();
  }

  genderDropDown() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 5.w,
        top: 10.w,
      ),
      child: SizedBox(
        //height: 44.h,
        child: Consumer(builder: (context, ref, child) {
          final register = ref.watch(Providers.signUpControllerProvider);
          return Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.blue.shade200,
            ),
            child: DropdownButtonFormField<String>(
              borderRadius: BorderRadius.circular(20.0),
              isExpanded: true,
              dropdownColor: Color(0xff20242A),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xff20242A),
                floatingLabelStyle: TextStyle(
                  fontFamily: "gilroy_bolditalic",
                  fontSize: 16.sp,
                  color: color_gt_headersTextColorWhite.withOpacity(0.9),
                ),
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
                prefixIcon: Icon(
                  (register.selectedgender == 'Male')
                      ? Icons.male_rounded
                      : Icons.female_rounded,
                  color: Color(0xff7e7d7d).withOpacity(0.7),
                ),
              ),
              style: TextStyle(
                fontSize: 16.sp,
                color: color_gt_headersTextColorWhite,
                fontFamily: 'gilroy_regular',
              ),

              value: register.selectedgender,

              hint: Text(
                'Select Gender',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: color_gt_headersTextColorWhite.withOpacity(0.7),
                  fontFamily: 'gilroy_regular',
                ),
              ),
              onChanged: (value) {
                register.changegender(value!);
              },
              // ignore: prefer_const_literals_to_create_immutables
              items: genders.map((item) {
                return DropdownMenuItem<String>(
                  child: Text(item),
                  value: item,
                );
              }).toList(),
            ),
          );
        }),
      ),
    );
  }

  BirthYearSelectionWidget() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 5.sp,
        top: 10.sp,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ThemeData().colorScheme.copyWith(
                primary: Color(0xffFED428),
              ),
        ),
        child: Consumer(builder: (context, ref, child) {
          final signupcontroller =
              ref.watch(Providers.signUpControllerProvider);
          return TextFormField(
            scrollPadding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            validator: (value) {
              return (signupcontroller.calculateAge() < 17)
                  ? 'must be atleast 17 years !'
                  : null;
            },
            // scrollPadding: EdgeInsets.only(
            //     bottom: MediaQuery.of(context).viewInsets.bottom + 15.sp * 4),
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
              fillColor: Color(0xff20242A),
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
                color: Color(0xff7e7d7d).withOpacity(0.7),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: Colors.red.withOpacity(0.05)),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: Colors.red.withOpacity(0.05)),
              ),
              errorStyle: TextStyle(
                  fontFamily: 'gilroy_regularitalic',
                  color: Colors.red[500]!,
                  fontSize: 12.sp),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide:
                    BorderSide(color: Color(0xff7e7d7d).withOpacity(0.05)),
              ),
            ),
            controller: signupcontroller.dateController,
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
                signupcontroller.updateDate(pickedDate);
                print(signupcontroller.calculateAge());

                signupcontroller.dateController.text = dateForDb;
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

  customTextFieldSignUp({
    required TextEditingController controller,
    required TextInputAction tia,
    required String labeltext,
    required bool isObscure,
    required String iconName,
    required IconData icon,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 5.sp,
        top: 12.sp,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ThemeData().colorScheme.copyWith(
                primary: Color(0xffFED428),
              ),
        ),
        child: Consumer(builder: (context, ref, child) {
          final signUpController_var =
              ref.watch(Providers.signUpControllerProvider);
          return TextFormField(
            validator: (value) {
              if (labeltext == 'UserName') {
                if (value!.isEmpty) {
                  return '" Username " can\'t be empty !';
                } else if (value.length > 16) {
                  return 'Cant exceed 16 characters !';
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
              } else if (labeltext == 'Password') {
                if (value!.isEmpty) {
                  return '" password " field can\'t be empty';
                } else if (value.length < 6) {
                  return 'minimum 6 characters required !';
                }
                if (!RegExp(
                        r'^((?=.*\d)(?=.*[a-zA-Z])[a-zA-Z0-9!@\-+()#$%&*]{6,20})$')
                    .hasMatch(value)) {
                  return 'Atleast one letter and one number is must!';
                } else {
                  return null;
                }
              } else if (labeltext == 'Confirm Password') {
                if (value!.isEmpty) {
                  return '" confirm password " field can\'t be empty';
                } else if (!RegExp(
                        r'^((?=.*\d)(?=.*[a-zA-Z])[a-zA-Z0-9!@\-+()#$%&*]{6,20})$')
                    .hasMatch(value)) {
                  return 'minimum 6 characters, atleast one letter and one number is must!';
                } else if (signUpController_var.passwordController.text !=
                    signUpController_var.confirmPasswordController.text) {
                  signUpController_var.passwordController.text = '';
                  signUpController_var.confirmPasswordController.text = '';
                  return 'Re-Confirm the password!';
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
            keyboardType: (labeltext == 'Phone')
                ? TextInputType.phone
                : TextInputType.emailAddress,
            textInputAction: tia,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 14.h, horizontal: 10),
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
              prefixIcon: Padding(
                padding: EdgeInsets.all(10.h),
                child: Image.asset(
                  "assets/icons/$iconName.png",
                  fit: BoxFit.fitHeight,
                  height: 10.h,
                  color: Color(0xff7e7d7d).withOpacity(0.7),
                ),
              ),
              //  Icon(
              //   icon,
              //   color: Color(0xff7e7d7d).withOpacity(0.7),
              // ),
              suffixIcon: (isObscure)
                  ? GestureDetector(
                      onTap: () {
                        (labeltext == "Password")
                            ? ref
                                .read(Providers.signUpControllerProvider)
                                .changePassObscurity()
                            : ref
                                .read(Providers.signUpControllerProvider)
                                .changeConfirmPassObscurity();
                      },
                      child: (labeltext == "Password")
                          ? (signUpController_var.pass_isobscure)
                              ? Icon(
                                  Icons.visibility_off,
                                  color: Color(0xffFED428).withOpacity(0.5),
                                )
                              : Icon(
                                  Icons.visibility,
                                  color: Color(0xffFED428),
                                )
                          : (signUpController_var.confirmpass_isobscure)
                              ? Icon(
                                  Icons.visibility_off,
                                  color: Color(0xffFED428).withOpacity(0.5),
                                )
                              : Icon(
                                  Icons.visibility,
                                  color: Color(0xffFED428),
                                ))
                  : GestureDetector(
                      onTap: () {
                        ref
                            .read(Providers.signUpControllerProvider)
                            .changePassObscurity();
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
                borderSide: BorderSide(
                    color: Color(0xff7e7d7d).withOpacity(0.05), width: 0.5),
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
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
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
