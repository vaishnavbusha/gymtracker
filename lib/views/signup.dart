// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, duplicate_ignore, must_be_immutable, non_constant_identifier_names

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
import '../widgets/customsnackbar.dart';

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
    // TODO: implement initState
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
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final connectivityStatusProvider = ref.watch(connectivityStatusProviders);
    return (connectivityStatusProvider == ConnectivityStatus.isConnected)
        ? GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              body: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xff122B32), Colors.black],
                  ),
                ),
                child: SafeArea(
                  child: Container(
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 16.w,
                            right: 16.w,
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Register',
                                      style: TextStyle(
                                        //foreground: Paint()..shader = linearGradient,
                                        color: Colors.white,
                                        fontFamily: "teko-med",
                                        fontSize: 60.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                // Center(
                                //   child: Consumer(builder: (context, ref, child) {
                                //     final register =
                                //         ref.watch(signUpControllerProvider);
                                //     return Stack(
                                //       // ignore: prefer_const_literals_to_create_immutables
                                //       children: [
                                //         CircleAvatar(
                                //           radius: 70.w,
                                //           backgroundImage: (register
                                //                       .no_of_times_profilechanged !=
                                //                   0)
                                //               ? Image.file(register.pickedImage).image
                                //               : AssetImage(
                                //                   'assets/images/${register.selectedgender}.png'),
                                //         ),
                                //         Positioned(
                                //           bottom: -10.w,
                                //           left: 85.w,
                                //           child: IconButton(
                                //             onPressed: () {
                                //               register.pickimage(context);
                                //             },
                                //             icon: Icon(
                                //               Icons.add_a_photo,
                                //               color: Colors.white,
                                //             ),
                                //           ),
                                //         ),
                                //         (register.no_of_times_profilechanged != 0)
                                //             ? Positioned(
                                //                 top: -5.w,
                                //                 left: 100.w,
                                //                 child: IconButton(
                                //                   onPressed: () {
                                //                     register
                                //                         .changeToDefaultProfilePhoto(
                                //                             context);
                                //                   },
                                //                   icon: Icon(
                                //                     Icons.cancel_rounded,
                                //                     color: Colors.red,
                                //                     size: 25.w,
                                //                   ),
                                //                 ),
                                //               )
                                //             : SizedBox(),
                                //       ],
                                //     );
                                //   }),
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
                                    child: Consumer(
                                        builder: (context, ref, child) {
                                      final register =
                                          ref.watch(signUpControllerProvider);
                                      return DropdownButtonFormField<String>(
                                        isExpanded: true,
                                        dropdownColor:
                                            color_gt_textColorBlueGrey,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white10,
                                          floatingLabelStyle: TextStyle(
                                            fontFamily: "gilroy_bolditalic",
                                            fontSize: 16.sp,
                                            color:
                                                color_gt_headersTextColorWhite
                                                    .withOpacity(0.9),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                            borderSide: const BorderSide(
                                                color: Colors.white12),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                            borderSide: BorderSide(
                                                color:
                                                    color_gt_textColorBlueGrey
                                                        .withOpacity(0.3)),
                                          ),
                                          prefixIcon: Icon(
                                            (register.selectedgender == 'Male')
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

                                        value: register.selectedgender,

                                        hint: Text(
                                          'Select Gender',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            color:
                                                color_gt_headersTextColorWhite
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

                                  return InkWell(
                                    onTap: () async {
                                      SystemChannels.textInput
                                          .invokeMethod('TextInput.hide');
                                      final FormState form =
                                          _formKey.currentState!;

                                      if (form.validate()) {
                                        UserModel userData = UserModel(
                                          pendingApprovals: null,
                                          isAwaitingEnrollment: false,
                                          phoneNumber:
                                              _phoneNumberController.text,
                                          DOB: _dateController.text,
                                          email: _emailController.text,
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
                                          password: _passwordController.text,
                                          ctx: context,
                                        );
                                      } else {
                                        print('Form is invalid');
                                      }
                                    },
                                    child: (!registerprovider
                                            .is_register_details_uploading)
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                              top: 17.w,
                                            ),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 50.h,
                                              decoration: BoxDecoration(
                                                color: color_gt_green,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(5.r),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Sign Up',
                                                  style: TextStyle(
                                                      fontFamily: 'gilroy_bold',
                                                      fontSize: 20.sp,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Padding(
                                            padding: EdgeInsets.only(
                                              top: 17.w,
                                            ),
                                            child: Loader(
                                                loadercolor: color_gt_green),
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
                                      EdgeInsets.only(top: 15.h, bottom: 15.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Already have an account? ',
                                        style: TextStyle(
                                          color: color_gt_headersTextColorWhite,
                                          fontSize: 14.sp,
                                          fontFamily: 'gilroy_regular',
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pushReplacement(
                                              context,
                                              ScaleRoute(
                                                page: SignInPage(),
                                              ));
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
                                            color: color_gt_green,
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
                primary: color_gt_green,
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
}
