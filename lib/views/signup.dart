// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, duplicate_ignore, must_be_immutable, non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymtracker/models/user_model.dart';
import 'package:gymtracker/providers/authentication_providers.dart';
import 'package:gymtracker/views/signin.dart';
import 'package:gymtracker/widgets/loader.dart';
import 'package:gymtracker/widgets/nointernet_widget.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../controllers/network_controller.dart';
import '../widgets/animated_route.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  late TextEditingController _dateController;
  late TextEditingController _userNameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _phoneNumberController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _dateController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _userNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _dateController.dispose();
    _phoneNumberController.dispose();
    _userNameController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  final Shader linearGradient = LinearGradient(
    colors: <Color>[Colors.white, Colors.white54],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  @override
  Widget build(BuildContext context) {
    final connectivityStatusProvider = ref.watch(connectivityStatusProviders);
    return (connectivityStatusProvider == ConnectivityStatus.isConnected)
        ? GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              backgroundColor: Color(0xff1A1F25),
              body: SafeArea(
                child: Container(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 16.w,
                          right: 16.w,
                          top: 15.h,
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                controller: _userNameController,
                                icon: Icons.contact_page_outlined,
                                isObscure: false,
                                labeltext: 'UserName',
                                tia: TextInputAction.newline,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: 5.w,
                                  top: 10.w,
                                ),
                                child: SizedBox(
                                  //height: 44.h,
                                  child:
                                      Consumer(builder: (context, ref, child) {
                                    final register =
                                        ref.watch(signUpControllerProvider);
                                    return DropdownButtonFormField<String>(
                                      isExpanded: true,
                                      dropdownColor: color_gt_textColorBlueGrey,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Color(0xff20242A),
                                        floatingLabelStyle: TextStyle(
                                          fontFamily: "gilroy_bolditalic",
                                          fontSize: 16.sp,
                                          color: color_gt_headersTextColorWhite
                                              .withOpacity(0.9),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          borderSide: BorderSide(
                                              color: Color(0xff7e7d7d)
                                                  .withOpacity(0.05)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          borderSide: BorderSide(
                                              color: Color(0xff7e7d7d)
                                                  .withOpacity(0.05)),
                                        ),
                                        prefixIcon: Icon(
                                          (register.selectedgender == 'Male')
                                              ? Icons.male_rounded
                                              : Icons.female_rounded,
                                          color: Color(0xff7e7d7d)
                                              .withOpacity(0.7),
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
                                          color: color_gt_headersTextColorWhite
                                              .withOpacity(0.7),
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
                                    );
                                  }),
                                ),
                              ),
                              BirthYearSelectionWidget(),
                              customTextFieldSignUp(
                                controller: _emailController,
                                icon: Icons.email,
                                isObscure: false,
                                labeltext: 'Email',
                                tia: TextInputAction.newline,
                              ),

                              customTextFieldSignUp(
                                controller: _phoneNumberController,
                                icon: Icons.phone,
                                isObscure: false,
                                labeltext: 'Phone',
                                tia: TextInputAction.newline,
                              ),
                              customTextFieldSignUp(
                                controller: _passwordController,
                                icon: Icons.security_outlined,
                                isObscure: true,
                                labeltext: 'Password',
                                tia: TextInputAction.newline,
                              ),
                              customTextFieldSignUp(
                                controller: _confirmPasswordController,
                                icon: Icons.security_outlined,
                                isObscure: true,
                                labeltext: 'Confirm Password',
                                tia: TextInputAction.done,
                              ),
                              Consumer(builder: (context, ref, child) {
                                final registerprovider =
                                    ref.watch(signUpControllerProvider);

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
                                          phoneNumber: _phoneNumberController
                                              .text
                                              .trim(),
                                          DOB: _dateController.text,
                                          email: _emailController.text.trim(),
                                          isUser: true,
                                          registeredDate: DateTime.now(),
                                          userName: _userNameController.text
                                              .toLowerCase()
                                              .trim(),
                                          userType: userLevels[0]!,
                                          gender:
                                              registerprovider.selectedgender,
                                        );
                                        registerprovider.registerUser(
                                          userModel: userData,
                                          password:
                                              _passwordController.text.trim(),
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
                              Padding(
                                padding:
                                    EdgeInsets.only(top: 20.h, bottom: 20.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Already have an account? ',
                                      style: TextStyle(
                                        color: color_gt_headersTextColorWhite,
                                        fontSize: 14.sp,
                                        fontFamily: 'gilroy_bolditalic',
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                            context,
                                            CupertinoPageRoute(builder: (context) => SignInPage(),)
                                            // ScaleRoute(
                                            //   page: SignInPage(),
                                            // )
                                            );
                                        // Navigator.pushReplacement(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //       builder: (context) => SignInPage(),
                                        //     ));
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
          final signupcontroller = ref.watch(signUpControllerProvider);
          return TextFormField(
            validator: (value) {
              return (signupcontroller.calculateAge() < 17)
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
                borderSide:
                    BorderSide(color: Color(0xff7e7d7d).withOpacity(0.05)),
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
                    BorderSide(color: Colors.transparent,),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide:
                    BorderSide(color: Color(0xff7e7d7d).withOpacity(0.05)),
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
                String dateForDisplay = convertDateToDisplayFormat(pickedDate);
                String dateForDb = DateFormat('dd-MM-yyyy').format(pickedDate);
                signupcontroller.updateDate(pickedDate);
                print(signupcontroller.calculateAge());

                _dateController.text = dateForDb;
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
          final signUpController_var = ref.watch(signUpControllerProvider);
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
                } else if (_passwordController.text !=
                    _confirmPasswordController.text) {
                  _passwordController.text = '';
                  _confirmPasswordController.text = '';
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
            decoration: InputDecoration( contentPadding: EdgeInsets.symmetric(vertical: 14.h,horizontal: 10),
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
              prefixIcon: Icon(
                icon,
                color: Color(0xff7e7d7d).withOpacity(0.7),
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
                borderSide:
                    BorderSide(color:Colors.transparent,),
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
