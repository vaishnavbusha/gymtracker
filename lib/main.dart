// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymtracker/constants.dart';
import 'package:gymtracker/models/user_model.dart';

import 'package:gymtracker/views/signin.dart';
import 'package:gymtracker/views/tabview_navigation.dart';

import 'package:hive_flutter/adapters.dart';

import 'models/gympartner_constraints_model.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent.withOpacity(0.1),
    systemNavigationBarColor: Color(0x00FFFFFF),
    systemNavigationBarContrastEnforced: false, // transparent status bar
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox(userDetailsHIVE);
  await Hive.openBox(miscellaneousDataHIVE);
  await Hive.openBox(maxClickAttemptsHIVE);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  GymPartnerConstraints? gymPartnerConstraints;

  @override
  Widget build(BuildContext context) {
    if (Hive.box(miscellaneousDataHIVE).get('isLoggedIn') == null) {
      Hive.box(miscellaneousDataHIVE).put('isLoggedIn', false);
    }
    return ScreenUtilInit(builder: (context, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GymTracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
      );
    });
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  UserModel? userModel;
  @override
  void initState() {
    super.initState();
    userModel = (Hive.box(userDetailsHIVE).get('usermodeldata') as UserModel);

    Timer(Duration(milliseconds: 1000), () {
      changepage();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Color> x = <Color>[Colors.white, Colors.white54];
    final Shader linearGradient = LinearGradient(
      colors: const <Color>[Colors.white, Colors.white54],
    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

    return Scaffold(
      backgroundColor: Color(0xff1A1F25),
      body: Stack(
        children: [
          Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              ShaderMask(
                  shaderCallback: (bounds) {
                    return linearGradient;
                  },
                  child: Image.asset(
                    'assets/images/playstore.png',
                    height: 100.h,
                    fit: BoxFit.contain,
                  ),
                  blendMode: BlendMode.srcATop),
              (userModel != null && userModel!.enrolledGym != null)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${userModel!.enrolledGym}',
                          style: TextStyle(
                              fontFamily: 'gilroy_bolditalic',
                              fontSize: 35.sp,
                              foreground: Paint()..shader = linearGradient),
                        ),
                        Text(
                          'Partnered with GymTracker',
                          style: TextStyle(
                            fontFamily: 'gilroy_regularitalic',
                            fontSize: 10.sp,
                            foreground: Paint()..shader = linearGradient,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      'GymTracker',
                      style: TextStyle(
                          fontFamily: 'gilroy_bolditalic',
                          fontSize: 35.sp,
                          foreground: Paint()..shader = linearGradient),
                    ),
            ]),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'from',
                      style: TextStyle(
                          fontFamily: 'gilroy_bolditalic',
                          color: Color(0xff7E7D7D)),
                    ),
                    Text(
                      'Aquela Studios',
                      style: TextStyle(
                          fontFamily: 'gilroy_bolditalic',
                          color: Color(0xffFED428),
                          fontSize: 20.sp),
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  void changepage() async {
    if (Hive.box(miscellaneousDataHIVE).get('isLoggedIn')) {
      final userdataJSON = await fireBaseFireStore
          .collection('users')
          .doc(Hive.box(miscellaneousDataHIVE).get('uid'))
          .get();
      UserModel.saveUserDataToHIVE(UserModel.toModel(userdataJSON));
    }
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => ValueListenableBuilder<Box<dynamic>>(
        valueListenable: Hive.box(miscellaneousDataHIVE).listenable(),
        builder: (context, value, child) {
          if (value.get('isLoggedIn') == false) {
            return SignInPage();
          } else {
            return NavigationScreen();
          }
        },
      ),
    ));
  }
}

hiveListenerAuthStatusCheck() {
  return ValueListenableBuilder<Box<dynamic>>(
    valueListenable: Hive.box(miscellaneousDataHIVE).listenable(),
    builder: (context, value, child) {
      if (value.get('isLoggedIn') == false) {
        return SignInPage();
      } else {
        return NavigationScreen();
      }
    },
  );
}
