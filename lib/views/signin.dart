// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable, use_super_parameters

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:gymtracker/constants.dart';
import 'package:gymtracker/controllers/sign_in_controller.dart';
import 'package:gymtracker/views/signup.dart';
import 'package:gymtracker/widgets/loader.dart';
import 'package:gymtracker/widgets/nointernet_widget.dart';
import 'package:gymtracker/widgets/utils.dart';

import '../controllers/network_controller.dart';
import '../providers/providers.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final LoginController loginGlobalReadState;
  @override
  void initState() {
    loginGlobalReadState = ref.read(Providers.loginProvider);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
                        duration: Duration(milliseconds: 250,),
                        curve: Curves.easeInOut,
                        child: Center(
                          child: SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                  SizedBox(height: 30.h,),
                                Container(
                                  height: 80.h,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        'assets/images/gymtracker_white.png',
                                      ),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  child: Text(
                                    'LOGIN',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: "gilroy_bold",
                                      fontSize: 36.sp,
                                      foreground: Paint()
                                        ..shader = linearGradient,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                CustomTextFieldSignIn(
                                  controller:
                                      loginGlobalReadState.emailController,
                                  icon: Icons.email,
                                  isObscure: false,
                                  labeltext: 'Email',
                                  iconName: 'email',
                                  tia: TextInputAction.next,
                                ),
                                CustomTextFieldSignIn(
                                  controller:
                                      loginGlobalReadState.passwordController,
                                  icon: Icons.security_outlined,
                                  isObscure: true,
                                  labeltext: 'Password',
                                  iconName: 'password_2',
                                  tia: TextInputAction.done,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 10.h,
                                  ),
                                  child: Consumer(builder: (context, ref, _) {
                                    final isLoginDetailsUploadingProgressState =
                                        ref.watch(
                                            Providers.loginProvider.select(
                                      (value) =>
                                          value.is_login_details_uploading,
                                    ));
                                    final state =
                                        ref.watch(Providers.loginProvider);
                                    return Ink(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(60.r),
                                        color: Color(0xffFED428),
                                      ),
                                      child: InkWell(
                                        borderRadius:
                                            BorderRadius.circular(60.r),
                                        onTap: () async {
                                          SystemChannels.textInput.invokeMethod(
                                            'TextInput.hide',
                                          );
                                          final FormState form =
                                              _formKey.currentState!;
                                          if (form.validate()) {
                                            await ref
                                                .read(Providers.loginProvider)
                                                .loginuser(
                                                  ctx: context,
                                                );
                                          } else {
                                            print('Form is invalid');
                                          }
                                        },
                                        child: AnimatedContainer(
                                          curve: Curves.fastEaseInToSlowEaseOut,
                                          height: 47.h,
                                          width: state.width ??
                                              MediaQuery.of(context).size.width,
                                          duration: Duration(milliseconds: 250),
                                          child: AnimatedSwitcher(
                                            switchInCurve:
                                                Curves.fastEaseInToSlowEaseOut,
                                            switchOutCurve:
                                                Curves.fastEaseInToSlowEaseOut,
                                            duration:
                                                Duration(milliseconds: 0),
                                            child:
                                                (isLoginDetailsUploadingProgressState ==
                                                        false)
                                                    ? Text(
                                                        'Sign In',
                                                           key: Key('1'),
                                                        style: TextStyle(
                                                          fontSize: 20.sp,
                                                          fontFamily:
                                                              'gilroy_bold',
                                                        ),
                                                      )
                                                    : Loader(
                                                        loadercolor:
                                                            Color(0xffFED428),
                                                               key: Key('2'),
                                                            
                                                      ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    //signInState.isResetPasswordLoading = false;
                                    showModalBottomSheet(
                                      isScrollControlled: true,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30.r),
                                          topRight: Radius.circular(30.r),
                                        ),
                                      ),
                                      backgroundColor: Color(0xff1A1F25),
                                      builder: (context) {
                                        return CustmoModalBottomSheetNew();
                                        //modalbottomsheet(context);
                                      },
                                      context: context,
                                    );
                                  },
                                  child: Text(
                                    'Forgot password ?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Color(0xffFED428),
                                        fontFamily: 'gilroy_bolditalic'),
                                  ),
                                ),
                                SizedBox(
                                  height: 30.h,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                bottomNavigationBar: customNavBar(),
                backgroundColor: Color(0xff1A1F25),
                resizeToAvoidBottomInset: false,
            
              ),
            ),
          )
        : NoInternetWidget();
  }

  customNavBar(){
    return  Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h,),
      child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account? ',
                        style: TextStyle(
                          color: color_gt_headersTextColorWhite,
                          fontSize: 14.sp,
                          fontFamily: 'gilroy_regularitalic',
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          Navigator.pushReplacement(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => SignUpPage(),
                              ));
                        },
                        child: Text(
                          'Sign-up here !',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Color(0xffFED428),
                            fontFamily: 'gilroy_bolditalic',
                          ),
                        ),
                      )
                    ],
                  ),
    );
  }
}

class CustmoModalBottomSheetNew extends ConsumerStatefulWidget {
  const CustmoModalBottomSheetNew({super.key});

  @override
  ConsumerState<CustmoModalBottomSheetNew> createState() =>
      _CustmoModalBottomSheetNewState();
}

class _CustmoModalBottomSheetNewState
    extends ConsumerState<CustmoModalBottomSheetNew> {
  late final LoginController loginGlobalReadState;
  @override
  void initState() {
    loginGlobalReadState = ref.read(Providers.loginProvider);
    loginGlobalReadState.passwordResetEmailController.clear();
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AnimatedPadding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        duration: Duration(
          milliseconds: 250,
        ),
        curve: Curves.elasticInOut,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Consumer(builder: (context, ref, __) {
                return Form(
                  key: _formKey,
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
                            fontSize: 26.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // Divider(
                      //   height: 1,
                      //   color: Colors.white24,
                      // ),
                      CustomTextFieldSignIn(
                        controller: loginGlobalReadState
                            .passwordResetEmailController,
                        icon: Icons.email,
                        isObscure: false,
                        labeltext: 'Email',
                        iconName: 'email',
                        tia: TextInputAction.done,
                      ),
                      Consumer(builder: (context, ref, __) {
                        final isResetPasswordLoadingState =
                            ref.watch(Providers.loginProvider.select(
                          (value) => value.isResetPasswordLoading,
                        ));
                        return Padding(
                          padding: EdgeInsets.only(bottom: 14.h),
                          child: (isResetPasswordLoadingState)
                              ? Loader(
                                  loadercolor: Colors.green,
                                )
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    onPrimary: Color(
                                        0xff1A1F25), //to change text color
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.h, horizontal: 20.h),
                                    primary:
                                        Color(0xffFED428), // button color
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
                                    SystemChannels.textInput.invokeMethod(
                                      'TextInput.hide',
                                    );
                                    //validateAndSave();
                                    final FormState form =
                                        _formKey.currentState!;
                                    if (form.validate()) {
                                      await loginGlobalReadState
                                          .resetPassword(context);
                                    } else {
                                      print('Form is invalid');
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
                );
              }),
            ),
          ),
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
  String iconName;
  IconData icon;

  CustomTextFieldSignIn({
    Key? key,
    required this.controller,
    required this.tia,
    required this.labeltext,
    required this.isObscure,
    required this.icon,
    required this.iconName,
  }) : super(key: key);
  changeObscurity(WidgetRef ref) {
    ref.read(Providers.signInpasswordObscurityProvider.notifier).update(
          (state) => !state,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 14.w,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ThemeData().colorScheme.copyWith(
                primary: Color(0xffFED428),
              ),
        ),
        child: Consumer(builder: (context, ref, child) {
          bool isPassObscure =
              ref.watch(Providers.signInpasswordObscurityProvider);
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
                  return '"password" field can\'t be empty !';
                } else {
                  return null;
                }
              }
              return null;
            },
            cursorRadius: Radius.circular(30.r),
            obscureText: (isObscure) ? isPassObscure : false,
            style: TextStyle(
              decorationThickness: 0,
              fontSize: 16.sp,
              fontFamily: 'gilroy_regular',
              color: Colors.white70,
            ),
            textInputAction: tia,
            autocorrect: false,
            enableSuggestions: false,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
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

              prefixIcon: CustomUtilities.prefixIcon(iconName: iconName),

              suffixIcon: (labeltext == 'Email')
                  ? null
                  : (isObscure)
                      ? GestureDetector(
                          onTap: () {
                            changeObscurity(ref);
                          },
                          child: AnimatedSwitcher(
                            duration: Duration(
                              milliseconds: 200,
                            ),
                            child: (isPassObscure)
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
                      : GestureDetector(
                          onTap: () {
                            changeObscurity(ref);
                          },
                          child: AnimatedSwitcher(
                            duration: Duration(
                              milliseconds: 200,
                            ),
                            child: (isPassObscure)
                                ? Icon(
                                    Icons.visibility_off,
                                    key: Key('1'),
                                    color: Color(0xffFED428).withOpacity(0.5),
                                    size: 0,
                                  )
                                : Icon(
                                    Icons.visibility,
                                    key: Key('2'),
                                    color: Color(0xffFED428),
                                    size: 0,
                                  ),
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
                  fontSize: 14.sp),
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
            cursorColor: Color(0xff7e7d7d).withOpacity(0.05),
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
