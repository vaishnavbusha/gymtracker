// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gymtracker/constants.dart';
import 'package:gymtracker/views/signup.dart';
import 'package:gymtracker/widgets/loader.dart';

import '../providers/authentication_providers.dart';
import '../widgets/animated_route.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xffFCFCFC), Color(0xff565656)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        //backgroundColor: Colors.black,
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
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: 16.w,
                right: 16.w,
              ),
              child: Form(
                key: _formKey,
                child: Center(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'GymTracker',
                                style: TextStyle(
                                  //foreground: Paint()..shader = linearGradient,
                                  color: Colors.white,
                                  fontFamily: "teko-med",
                                  fontSize: 60.sp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.h),
                          // Padding(
                          //   padding: EdgeInsets.only(top: 20.h),
                          //   child: Row(children: [
                          //     Text(
                          //       'Login',
                          //       style: TextStyle(
                          //         foreground: Paint()..shader = linearGradient,
                          //         //color: Colors.white,
                          //         fontFamily: "teko-med",
                          //         fontSize: 30.sp,
                          //       ),
                          //     ),
                          //   ]),
                          // ),
                          CustomTextFieldSignIn(
                            controller: _emailController,
                            icon: Icons.email,
                            isObscure: false,
                            labeltext: 'Email',
                            tia: TextInputAction.newline,
                          ),
                          CustomTextFieldSignIn(
                            controller: _passwordController,
                            icon: Icons.security_outlined,
                            isObscure: true,
                            labeltext: 'Password',
                            tia: TextInputAction.newline,
                          ),

                          Padding(
                            padding: EdgeInsets.only(
                              top: 17.w,
                            ),
                            child: Consumer(builder: (context, ref, _) {
                              final login = ref.watch(loginProvider);

                              return (login.is_login_details_uploading == false)
                                  ? GestureDetector(
                                      onTap: () {
                                        //validateAndSave();
                                        final FormState form =
                                            _formKey.currentState!;
                                        if (form.validate()) {
                                          login.loginuser(
                                            ctx: context,
                                            email: _emailController.text,
                                            password: _passwordController.text,
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
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 50.h,
                                        decoration: BoxDecoration(
                                          color: color_gt_green,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5.r),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Login',
                                            style: TextStyle(
                                                fontFamily: 'gilroy_bold',
                                                fontSize: 20.sp,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Loader(
                                      loadercolor: color_gt_green,
                                    );
                            }),
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
                          // Padding(
                          //   padding: EdgeInsets.only(
                          //     top: 7.w,
                          //   ),
                          //   child: Container(
                          //     width: MediaQuery.of(context).size.width,
                          //     height: 40.h,
                          //     decoration: BoxDecoration(
                          //       border: Border.all(
                          //         width: 1,
                          //         color: color_gt_green,
                          //         style: BorderStyle.solid,
                          //       ),
                          //       borderRadius: BorderRadius.all(
                          //         Radius.circular(5.r),
                          //       ),
                          //     ),
                          //     child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       children: [
                          //         SvgPicture.asset(
                          //           'assets/images/icons8-google.svg',
                          //           semanticsLabel: 'My SVG Image',
                          //           height: 20,
                          //           width: 20,
                          //         ),
                          //         SizedBox(
                          //           width: 10,
                          //         ),
                          //         Text(
                          //           'Log-in with Google',
                          //           style: TextStyle(
                          //               fontFamily: 'gilroy_bold',
                          //               fontSize: 15.sp,
                          //               color: color_gt_headersTextColorWhite),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          Padding(
                            padding: EdgeInsets.only(top: 27.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Don\'t have an account? ',
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
                                          page: SignUpPage(),
                                        ));
                                    // Navigator.pushReplacement(
                                    //     context,

                                    //     MaterialPageRoute(
                                    //       builder: (context) => SignUpPage(),
                                    //     ));
                                    // Navigator.pushReplacement(
                                    //     context,
                                    //     ScaleRoute(
                                    //       page: ChangeNotifierProvider(
                                    //         create: (context) => RegisterController(),
                                    //         child: RegisterScreen(),
                                    //       ),
                                    //     ));
                                  },
                                  child: Text(
                                    'Sign-up here !',
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
                primary: color_gt_green,
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
            style: TextStyle(
                fontSize: 15.sp,
                fontFamily: 'gilroy_regular',
                color: Colors.white70),
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
                        changeObscurity(ref);
                      },
                      child: (isPassObscure)
                          ? Icon(
                              Icons.visibility_off,
                              color: color_gt_green.withOpacity(0.5),
                            )
                          : Icon(
                              Icons.visibility,
                              color: color_gt_green,
                            ))
                  : GestureDetector(
                      onTap: () {
                        changeObscurity(ref);
                      },
                      child: (isPassObscure)
                          ? Icon(
                              Icons.visibility_off,
                              color: color_gt_green.withOpacity(0.5),
                              size: 0,
                            )
                          : Icon(
                              Icons.visibility,
                              color: color_gt_green,
                              size: 0,
                            ),
                    ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(
                    color: color_gt_textColorBlueGrey.withOpacity(0.2)),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(color: Colors.white10),
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
