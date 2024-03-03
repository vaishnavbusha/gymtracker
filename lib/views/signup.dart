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
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0.0;
    final connectivityStatusProvider =
        ref.watch(Providers.connectivityStatusProviders);
    if ((connectivityStatusProvider == ConnectivityStatus.isConnected)) {
      return GestureDetector(
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
            resizeToAvoidBottomInset: false,
            backgroundColor: Color(0xff1A1F25),
            body: SafeArea(
              child: Padding(
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
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(children: [
                          SizedBox(
                            height: 10.h,
                          ),
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
                                  foreground: Paint()..shader = linearGradient,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ]),
                          ),
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
                            controller: signUpGlobalReadState.emailController,
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
                            controller:
                                signUpGlobalReadState.confirmPasswordController,
                            icon: Icons.security_outlined,
                            isObscure: true,
                            iconName: 'password_2',
                            labeltext: 'Confirm Password',
                            tia: TextInputAction.done,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 17.h),
                            child: Consumer(builder: (context, ref, child) {
                              final registerprovider =
                                  ref.watch(Providers.signUpControllerProvider);
                              return CustomUtilities.customAnimatedButton(
                                  buttonHeight: 47.h,
                                  widthWhileAnimating: registerprovider.width,
                                  condition: (!registerprovider
                                      .is_register_details_uploading),
                                  context: context,
                                  falseWidget: Loader(
                                    loadercolor: Color(0xffFED428),
                                    key: Key('2'),
                                  ),
                                  trueWidget: Text(
                                    'Sign Up',
                                    key: Key('1'),
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontFamily: 'gilroy_bold',
                                    ),
                                  ),
                                  buttonAction: () async {
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
                                        gender: registerprovider.selectedgender,
                                      );
                                      registerprovider.registerUser(
                                        userModel: userData,
                                        ctx: context,
                                      );
                                    } else {
                                      print('Form is invalid');
                                    }
                                  });
                            }),
                          ),
                          // Consumer(builder: (context, ref, child) {
                          //   final registerprovider = ref.watch(
                          //       Providers.signUpControllerProvider);

                          //   return Padding(
                          //     padding: EdgeInsets.only(top: 17.h),
                          //     child: InkWell(
                          //       onTap: () async {
                          //         SystemChannels.textInput
                          //             .invokeMethod('TextInput.hide');
                          //         final FormState form =
                          //             _formKey.currentState!;

                          //         if (form.validate()) {
                          //           UserModel userData = UserModel(
                          //             pendingApprovals: null,
                          //             isAwaitingEnrollment: false,
                          //             phoneNumber: signUpGlobalReadState
                          //                 .phoneNumberController.text
                          //                 .trim(),
                          //             DOB: signUpGlobalReadState
                          //                 .dateController.text,
                          //             email: signUpGlobalReadState
                          //                 .emailController.text
                          //                 .trim(),
                          //             isUser: true,
                          //             registeredDate: DateTime.now(),
                          //             userName: signUpGlobalReadState
                          //                 .userNameController.text
                          //                 .toLowerCase()
                          //                 .trim(),
                          //             userType: userLevels[0]!,
                          //             gender:
                          //                 registerprovider.selectedgender,
                          //           );
                          //           registerprovider.registerUser(
                          //             userModel: userData,
                          //             ctx: context,
                          //           );
                          //         } else {
                          //           print('Form is invalid');
                          //         }
                          //       },
                          //       child: (!registerprovider
                          //               .is_register_details_uploading)
                          //           ? Container(
                          //               width: MediaQuery.of(context)
                          //                   .size
                          //                   .width,
                          //               height: 50.h,
                          //               decoration: BoxDecoration(
                          //                 color: Color(0xffFED428),
                          //                 borderRadius: BorderRadius.all(
                          //                   Radius.circular(10.r),
                          //                 ),
                          //               ),
                          //               child: Center(
                          //                 child: Text(
                          //                   'Sign Up',
                          //                   style: TextStyle(
                          //                       fontFamily: 'gilroy_bold',
                          //                       fontSize: 20.sp,
                          //                       color: Color(0xff1A1F25)),
                          //                 ),
                          //               ),
                          //             )
                          //           : Padding(
                          //               padding: EdgeInsets.only(
                          //                 top: 17.w,
                          //               ),
                          //               child: Loader(
                          //                 loadercolor: Color(0xffFED428),
                          //               ),
                          //             ),
                          //     ),
                          //   );
                          // }),
                          SizedBox(
                            height: 50.h,
                          ),
                          // isKeyboardOpen ? null : customBottomNav(),
                        ]),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            //bottomSheet: customBottomNav(),
            bottomNavigationBar: isKeyboardOpen ? null : customBottomNav(),
          ),
        ),
      );
    } else {
      return NoInternetWidget();
    }
  }

  customBottomNav() {
    return Container(
      color: Color(0xff1A1F25),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: 20.h,
          top: 20.h,
        ),
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
                      builder: (context) => SignInPage(),
                    ));
              },
              child: Text(
                'Sign-in here !',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Color(0xffFED428),
                  fontFamily: 'gilroy_bolditalic',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  genderDropDown() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 5.w,
        top: 10.w,
      ),
      child: Consumer(builder: (context, ref, child) {
        final register = ref.watch(Providers.signUpControllerProvider);
        return DecoratedBox(
          decoration: ShapeDecoration(
            color: Color(0xff20242A),
            shape: RoundedRectangleBorder(
              // side: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.cyan),
              borderRadius: BorderRadius.all(
                Radius.circular(
                  10.r,
                ),
              ),
            ),
          ),
          child: Stack(
            children: [
              Container(
                height: 47.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              Positioned(
                  left: 10.w,
                  top: 0,
                  bottom: 0,
                  child: AnimatedSwitcher(
                    duration: Duration(
                      milliseconds: 250,
                    ),
                    child: (register.selectedgender == 'Male')
                        ? Icon(
                            Icons.male_outlined,
                            color: Color(0xff7e7d7d).withOpacity(0.7),
                            key: Key('1'),
                          )
                        : Icon(
                            Icons.female_outlined,
                            color: Color(0xff7e7d7d).withOpacity(0.7),
                            key: Key('1'),
                          ),
                  )),
              Positioned(
                top: 0,
                bottom: 0,
                right: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.83,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      borderRadius: BorderRadius.circular(10.0),
                      isExpanded: true,
                      isDense: true,
                      dropdownColor: Color(0xff20242A),
                      padding: EdgeInsets.symmetric(
                          vertical: 12.h, horizontal: 10.w),
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: color_gt_headersTextColorWhite.withOpacity(0.75),
                        fontFamily: 'gilroy_regular',
                      ),

                      value: register.selectedgender,

                      hint: Text(
                        'Select Gender',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color:
                              color_gt_headersTextColorWhite.withOpacity(0.7),
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
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  BirthYearSelectionWidget() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 5.sp,
        top: 10.sp,
      ),
      child: Consumer(builder: (context, ref, child) {
        final signupcontroller = ref.watch(Providers.signUpControllerProvider);
        return TextFormField(
          // scrollPadding: EdgeInsets.only(
          //     bottom: MediaQuery.of(context).viewInsets.bottom),
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
            color: Colors.white70,
          ),
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
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
              initialDate: signupcontroller.pickedDateTime ?? DateTime.now(),
              firstDate: DateTime(
                  1900), //DateTime.now() - not to allow to choose before today.
              lastDate: DateTime(2025),
              builder: (context, child) {
                return Theme(
                  data: ThemeData.dark().copyWith(
                    colorScheme: const ColorScheme.dark(
                      onPrimary: Color(0xff1A1F25), // selected text color
                      onSurface: Color(0xffFED428), // default text color
                      primary: Color(0xffFED428), // circle color
                    ),
                    dialogTheme: DialogTheme(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            16.0), // this is the border radius of the picker
                      ),
                    ),
                    dialogBackgroundColor: Colors.black,
                    textTheme: TextTheme(
                      headlineMedium: TextStyle(
                        fontFamily: 'teko-reg',
                        fontSize: 25.sp,
                      ), // fri, feb 23
                      bodyLarge: TextStyle(
                        fontFamily: 'gilroy_bold',
                        fontSize: 13.sp,
                      ), // year
                      titleMedium: TextStyle(
                        fontFamily: 'gilroy_bold',
                      ), // s m t w t f s
                      bodySmall: TextStyle(
                        fontFamily: 'gilroy_bold',
                        fontSize: 14.sp,
                      ), // dates
                      titleSmall: TextStyle(
                        fontFamily: 'gilroy_bold',
                        fontSize: 14.sp,
                      ), // january 2024
                      labelSmall: TextStyle(
                        fontFamily: 'gilroy_bold',
                        fontSize: 16.sp,
                      ), // select date
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        textStyle: TextStyle(
                            color: Color(0xffFED428),
                            fontWeight: FontWeight.normal,
                            fontSize: 14.sp,
                            fontFamily: 'gilroy_bold'),
                        primary: Color(0xffFED428), // color of button's letters
                        // backgroundColor: Color(0xff1A1F25), // Background color
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            // color: Colors.black,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (pickedDate != null) {
              print(pickedDate);
              signupcontroller.pickedDateTime = pickedDate;
              String dateForDisplay = convertDateToDisplayFormat(pickedDate);
              String dateForDb = DateFormat('dd-MM-yyyy').format(pickedDate);
              signupcontroller.updateDate(pickedDate);
              print(signupcontroller.calculateAge());

              signupcontroller.dateController.text = dateForDb;
            }
          },
        );
      }),
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
            cursorWidth: 1.5,
            // cursorHeight: 18.sp,
            cursorRadius: Radius.circular(30.r),
            obscureText: (isObscure)
                ? (labeltext == "Password")
                    ? signUpController_var.pass_isobscure
                    : signUpController_var.confirmpass_isobscure
                : false,
            style: TextStyle(
                decorationThickness: 0,
                fontSize: 16.sp,
                fontFamily: 'gilroy_regular',
                color: Colors.white70),
            keyboardType: (labeltext == 'Phone')
                ? TextInputType.phone
                : TextInputType.emailAddress,
            autocorrect: false,
            enableSuggestions: false,
            textInputAction: tia,
            inputFormatters: (labeltext == 'Phone')
                ? [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ]
                : [],
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: 12.h,
                horizontal: 10.w,
              ),
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
              prefixIcon: CustomUtilities.prefixIcon(iconName: iconName),
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
                          ? AnimatedSwitcher(
                              duration: Duration(
                                milliseconds: 200,
                              ),
                              child: (signUpController_var.pass_isobscure)
                                  ? Icon(
                                      Icons.visibility_off,
                                      key: Key('1'),
                                      color: Color(0xffFED428).withOpacity(0.5),
                                    )
                                  : Icon(
                                      Icons.visibility,
                                      key: Key('2'),
                                      color: Color(0xffFED428),
                                    ))
                          : AnimatedSwitcher(
                              switchInCurve: Curves.fastEaseInToSlowEaseOut,
                              switchOutCurve: Curves.fastEaseInToSlowEaseOut,
                              duration: Duration(
                                milliseconds: 200,
                              ),
                              child: (signUpController_var
                                      .confirmpass_isobscure)
                                  ? Icon(
                                      Icons.visibility_off,
                                      key: Key('1'),
                                      color: Color(0xffFED428).withOpacity(0.5),
                                    )
                                  : Icon(
                                      Icons.visibility,
                                      key: Key('2'),
                                      color: Color(0xffFED428),
                                    ),
                            ),
                    )
                  : SizedBox(),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(
                    color: Color(0xffFE4A49).withOpacity(0.3), width: 0.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: Colors.red.withOpacity(0.05)),
              ),
              errorStyle: TextStyle(
                  fontFamily: 'gilroy_regularitalic',
                  color: CustomUtilities.hexColor(
                    colorCode: '#FE4A49',
                  ),
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
                  return '"password" field can\'t be empty';
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
                  return '"confirm password" field can\'t be empty';
                } else if (!RegExp(
                        r'^((?=.*\d)(?=.*[a-zA-Z])[a-zA-Z0-9!@\-+()#$%&*]{6,20})$')
                    .hasMatch(value)) {
                  return 'minimum 6 characters, atleast one letter and one number is must!';
                } else if (signUpController_var.passwordController.text !=
                    signUpController_var.confirmPasswordController.text) {
                  signUpController_var.confirmPasswordController.clear();
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
          );
        }),
      ),
    );
  }
}
