// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:gymtracker/constants.dart';
import 'package:gymtracker/views/signup.dart';
import 'package:gymtracker/widgets/loader.dart';
import 'package:gymtracker/widgets/nointernet_widget.dart';

import '../controllers/network_controller.dart';
import '../providers/authentication_providers.dart';
import '../widgets/animated_route.dart';
import '../widgets/customsnackbar.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  late TextEditingController _passwordResetEmailController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _passwordResetEmailController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
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
            child: Scaffold( resizeToAvoidBottomInset: false,
          floatingActionButtonLocation:  FloatingActionButtonLocation.centerFloat,
floatingActionButton:           Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Don\'t have an account? ',
                                      style: TextStyle(
                                        color: color_gt_headersTextColorWhite,
                                        fontSize: 14.sp,
                                        fontFamily: 'gilroy_bolditalic',
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        Navigator.pushReplacement(
                                            context,
                                            CupertinoPageRoute(builder: (context) => SignUpPage(),)
                                            // ScaleRoute(
                                            //   page: SignUpPage(),
                                            // )
                                            );
                                      },
                                      child: Text(
                                        'Sign-up here !',
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          color: Color(0xffFED428),
                                          fontFamily: 'gilroy_bolditalic',
                                        ),
                                      ),
                                    )
                                  ],
                                ),
              //resizeToAvoidBottomInset: false,
              body: Container(
               
                color: Color(0xff1A1F25),
              
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/gymtracker_white.png',
                                height: 80.h,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Text(
                                'LOGIN',
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
                              SizedBox(height: 15.h),
                             
                              CustomTextFieldSignIn(
                                controller: _emailController,
                                icon: Icons.email,
                                isObscure: false,
                                labeltext: 'Email',
                                tia: TextInputAction.next,
                              ),
                              CustomTextFieldSignIn(
                                controller: _passwordController,
                                icon: Icons.security_outlined,
                                isObscure: true,
                                labeltext: 'Password',
                                tia: TextInputAction.done,
                              ),
                                        
                              Consumer(builder: (context, ref, _) {
                                  final login = ref.watch(loginProvider);
                                        
                                  return (login
                                        .is_login_details_uploading ==
                                    false)
                                ? GestureDetector(
                                    onTap: () async {
                                      SystemChannels.textInput
                                          .invokeMethod(
                                              'TextInput.hide',);
                                      //validateAndSave();
                                      final FormState form =
                                          _formKey.currentState!;
                                      if (form.validate()) {
                                        await login.loginuser(
                                          ctx: context,
                                          email:
                                              _emailController.text,
                                          password:
                                              _passwordController
                                                  .text,
                                        );
                                      } else {
                                        print('Form is invalid');
                                      }
                                      // login.loginuser(
                                      //   ctx: context,
                                      //   email: _emailController.text,
                                      //   password: _passwordController.text,
                                      // );
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context)
                                          .size
                                          .width,
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                        color: Color(0xffFED428),
                                        borderRadius:
                                            BorderRadius.all(
                                          Radius.circular(10.r),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Sign In',
                                          style: TextStyle(
                                              fontFamily:
                                                  'gilroy_bold',
                                              fontSize: 21.sp,
                                              color: Color(
                                                  0xff1A1F25)),
                                        ),
                                      ),
                                    ),
                                  )
                                : Loader(
                                    loadercolor: Color(0xffFED428),
                                  );
                                }),
                              Consumer(builder: (context, ref, __) {
                                final signInState =
                                    ref.watch(loginProvider);
                                        
                                return InkWell(
                                  onTap: () {
                                    signInState.isResetPasswordLoading =
                                        false;
                                    showModalBottomSheet(
                                      isScrollControlled: true,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft:
                                                  Radius.circular(30.r),
                                              topRight:
                                                  Radius.circular(30.r)),
                                        ),
                                        backgroundColor:
                                            Color(0xff1A1F25),
                                        builder: (context) {
                                          return CustmoModalBottomSheetNew(); 
                                          modalbottomsheet(
                                              context);
                                        },
                                        context: context,);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 15.h, bottom: 10.h),
                                    child: Text(
                                      'Forgot password ?',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 13.sp,
                                          color: Color(0xffFED428),
                                          fontFamily:
                                              'gilroy_bolditalic'),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
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

  Widget modalbottomsheet(BuildContext context) {
    print(MediaQuery.of(context).viewInsets.bottom);
    //var textscaler = MediaQuery.of(context).textScaleFactor;
    return SingleChildScrollView(padding: EdgeInsets.only(
       bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Wrap(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 2.h, bottom: 10.h),
                    ),
                    Container(
                      width: 35.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.r),
                          color: Color(0xffFED428)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.h, bottom: 10.h),
                      child: Text(
                        'Forgot Password',
                        style: TextStyle(
                          fontFamily: 'gilroy_bold',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Divider(
                    //   height: 1,
                    //   color: Colors.white24,
                    // ),
                    CustomTextFieldSignIn(
                      controller: _passwordResetEmailController,
                      icon: Icons.email,
                      isObscure: false,
                      labeltext: 'Email',
                      tia: TextInputAction.done,
                    ),
                    Consumer(builder: (context, ref, __) {
                      final signInState = ref.watch(loginProvider);
                      return Padding(
                        padding: EdgeInsets.only(top: 12.h, bottom: 12.h),
                        child: (signInState.isResetPasswordLoading)
                            ? Loader(
                                loadercolor: Colors.green,
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  onPrimary: Color(
                                      0xff1A1F25), //to change text color
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10.h, horizontal: 20.h),
                                  primary: Color(0xffFED428), // button color
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
                                  if (_passwordResetEmailController
                                      .text.isEmpty) {
                                    Navigator.pop(context);
                                    CustomSnackBar.buildSnackbar(
                                      color: Colors.red[500]!,
                                      context: context,
                                      message:
                                          'Enter email-ID for resetting your password !',
                                      textcolor: const Color(0xffFDFFFC),
                                      iserror: false,
                                    );
                                    _passwordResetEmailController.text = '';
                                  } else {
                                    await signInState.resetPassword(
                                        _passwordResetEmailController.text,
                                        context);
                                    _passwordResetEmailController.text = '';
                                  }
                                  //await signOut();
                                },
                                child: Text(
                                  'Reset Password',
                                ),
                              ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustmoModalBottomSheetNew extends StatefulWidget {
  const CustmoModalBottomSheetNew({super.key});

  @override
  State<CustmoModalBottomSheetNew> createState() => _CustmoModalBottomSheetNewState();
}

class _CustmoModalBottomSheetNewState extends State<CustmoModalBottomSheetNew> {
   late TextEditingController _passwordResetEmailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).viewInsets.bottom);
    return SingleChildScrollView(
      child: AnimatedPadding(  duration: Duration(milliseconds: 250,),
      curve: Curves.decelerate,
        padding: EdgeInsets.only(
       bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Wrap(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30.r),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Consumer(
                    builder: (context,ref,__) {
                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 2.h, bottom: 10.h),
                          ),
                          Container(
                            width: 35.w,
                            height: 4.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.r),
                                color: Color(0xffFED428)),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 15.h, bottom: 10.h),
                            child: Text(
                              'Forgot Password',
                              style: TextStyle(
                                fontFamily: 'gilroy_bold',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          // Divider(
                          //   height: 1,
                          //   color: Colors.white24,
                          // ),
                          CustomTextFieldSignIn(
                            controller: _passwordResetEmailController,
                            icon: Icons.email,
                            isObscure: false,
                            labeltext: 'Email',
                            tia: TextInputAction.done,
                          ),
                          Consumer(builder: (context, ref, __) {
                            final signInState = ref.watch(loginProvider);
                            return Padding(
                              padding: EdgeInsets.only(top: 12.h, bottom: 12.h),
                              child: (signInState.isResetPasswordLoading)
                                  ? Loader(
                                      loadercolor: Colors.green,
                                    )
                                  : ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        onPrimary: Color(
                                            0xff1A1F25), //to change text color
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.h, horizontal: 20.h),
                                        primary: Color(0xffFED428), // button color
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
                                        if (_passwordResetEmailController
                                            .text.isEmpty) {
                                          Navigator.pop(context);
                                          CustomSnackBar.buildSnackbar(
                                            color: Colors.red[500]!,
                                            context: context,
                                            message:
                                                'Enter email-ID for resetting your password !',
                                            textcolor: const Color(0xffFDFFFC),
                                            iserror: false,
                                          );
                                          _passwordResetEmailController.text = '';
                                        } else {
                                          await signInState.resetPassword(
                                              _passwordResetEmailController.text,
                                              context);
                                          _passwordResetEmailController.text = '';
                                        }
                                        //await signOut();
                                      },
                                      child: Text(
                                        'Reset Password',
                                      ),
                                    ),
                            );
                          }),
                        ],
                      );
                    }
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class CustomTextFieldSignIn extends StatelessWidget {
  TextEditingController controller;
  TextInputAction tia;
  String labeltext;
  bool isObscure;

  IconData icon;

  CustomTextFieldSignIn(
      {Key? key,
      required this.controller,
      required this.tia,
      required this.labeltext,
      required this.isObscure,
      required this.icon,
      required})
      : super(key: key);
  changeObscurity(WidgetRef ref) {
    ref.read(signInpasswordObscurityProvider.notifier).update(
          (state) => !state,
        );
  }

  @override
  Widget build(BuildContext context) {
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
          bool isPassObscure = ref.watch(signInpasswordObscurityProvider);
          return TextFormField(
           
            validator: (value) {
              if (labeltext == 'Email') {
                if (value!.isEmpty) {
                  // ignore: unnecessary_string_escapes
                  return '"Email" field can\'t be empty !';
                } else if (!RegExp(
                        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                    .hasMatch(value)) {
                  return '"Email" is badly formatted !';
                } else {
                  return null;
                }
              } else if (labeltext == 'Password') {
                if (value!.isEmpty) {
                  return '"password" field can\'t be empty';
                } else {
                  return null;
                }
              }
            },
         
            cursorHeight: 18.sp,
            cursorRadius: Radius.circular(30.r),
            obscureText: (isObscure) ? isPassObscure : false,
            style: TextStyle(decorationThickness: 0,
                fontSize: 15.sp,
                fontFamily: 'gilroy_regular',
                color: Colors.white70,),
            textInputAction: tia, autocorrect: false,
 enableSuggestions: false,
            decoration: InputDecoration(
              
              contentPadding: EdgeInsets.symmetric(vertical: 14.h,horizontal: 10),
              filled: true,
              //fillColor: Colors.white10,
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
              
              suffixIcon:(labeltext=='Email') ? null:  (isObscure)
                  ? GestureDetector(
                      onTap: () {
                        changeObscurity(ref);
                      },
                      child: (isPassObscure)
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
                        changeObscurity(ref);
                      },
                      child: (isPassObscure)
                          ? Icon(
                              Icons.visibility_off,
                              color: Color(0xffFED428).withOpacity(0.5),
                              size: 0,
                            )
                          : Icon(
                              Icons.visibility,
                              color: Color(0xffFED428),
                              size: 0,
                            ),
                    ),
     border: InputBorder.none,
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide:
                    BorderSide(color: Color(0xff7e7d7d).withOpacity(0.05)),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: Colors.red, width: 0.25),
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
            controller: controller,
            cursorColor:  Color(0xff7e7d7d).withOpacity(0.05),
          );
        }),
      ),
    );
  }

  Future<void> returnDialog({
    required BuildContext context,
    required String notificationText,
  }) async {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r), color: Colors.black87),
          height: 100.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 14.h),
                child: Text(
                  notificationText,
                  style: TextStyle(
                    fontFamily: 'gilroy_bold',
                    color: Colors.red.withOpacity(0.6),
                    fontSize: 22.sp,
                  ),
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.only(bottom: 7.h, top: 2.h),
              //   child: Text.rich(TextSpan(
              //       text: 'NOTE: ',
              //       style: TextStyle(
              //         fontFamily: 'gilroy_bolditalic',
              //         color: honolulu,
              //       ),
              //       children: <InlineSpan>[
              //         TextSpan(
              //           text: 'click on \'yes\' to update wallpaper.',
              //           style: TextStyle(
              //               fontFamily: 'gilroy_regularitalic',
              //               color: honolulu.withOpacity(0.8),
              //               fontWeight: FontWeight.bold),
              //         )
              //       ])),
              // ),
              Divider(
                color: Colors.white24,
                indent: 20.w,
                endIndent: 20.w,
                height: 2.h,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.r),
                      bottomRight: Radius.circular(20.r),
                      topLeft: Radius.circular(0.r),
                      topRight: Radius.circular(0.r),
                    ),
                    color: Colors.black.withOpacity(1)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // FlatButton(
                    //   highlightColor: Colors.white10,
                    //   onPressed: () {
                    //     Navigator.pop(context);
                    //   },
                    //   child: Text(
                    //     'NO',
                    //     style: TextStyle(
                    //       fontFamily: 'gilroy_bold',
                    //       color: color_gt_green,
                    //       fontSize: 15.sp,
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 50.h,
                    //   child: VerticalDivider(
                    //     color: Colors.white24,
                    //     thickness: 0.5,
                    //     indent: 10,
                    //     endIndent: 9,
                    //   ),
                    // ),
                    // FlatButton(
                    //   highlightColor: Colors.white10,
                    //   onPressed: () async {
                    //     Navigator.of(context).pop();
                    //     // firebaseauth.signOut();
                    //     // Navigator.pushReplacement(
                    //     //     context,
                    //     //     ScaleRoute(
                    //     //       page: ChangeNotifierProvider(
                    //     //         create: (context) => LoginController(),
                    //     //         child: LoginScreen(),
                    //     //       ),
                    //     //     ));
                    //   },
                    //   child: Text(
                    //     'YES',
                    //     style: TextStyle(
                    //       fontFamily: 'gilroy_bold',
                    //       color: color_gt_green,
                    //       fontSize: 15.sp,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
