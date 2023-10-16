// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymtracker/constants.dart';
import 'package:gymtracker/models/user_model.dart';

import 'package:gymtracker/views/navigation.dart';

import 'package:gymtracker/views/signin.dart';

import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

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

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final userData = Hive.box(userDetailsHIVE).get('usermodeldata') as UserModel;
  @override
  void initState() {
    if (!userData.isUser) {
      getConstraints();
    }
    // TODO: implement initState
    super.initState();
  }

  Future getConstraints() async {
    await fireBaseFireStore
        .collection(userData.enrolledGym!)
        .doc('constraints')
        .get()
        .then(
      (value) {
        final data = value.data() as Map<String, dynamic>;
      },
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (Hive.box(miscellaneousDataHIVE).get('isLoggedIn') == null) {
      Hive.box(miscellaneousDataHIVE).put('isLoggedIn', false);
    }
    final todaysdate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    if (!userData.isUser) {
      if (Hive.box(miscellaneousDataHIVE).get('todaysdate') == null ||
          Hive.box(miscellaneousDataHIVE).get('todaysdate') != todaysdate) {
        // Hive.box(miscellaneousDataHIVE)
        //     .put('isTodaysAttendanceMarkCompleted', null);

        Hive.box(miscellaneousDataHIVE).put('todaysdate', todaysdate);
        Hive.box(maxClickAttemptsHIVE).put(
            'maxAttendanceByDateInCurrentMonthCount',
            maxAttendanceByDateInCurrentMonthCount);
        Hive.box(maxClickAttemptsHIVE)
            .put('maxMonthlyAttendanceCount', maxMonthlyAttendanceCount);
      }
    }
    // if (Hive.box(miscellaneousDataHIVE).get('isAwaitingEnrollment') == null) {
    //   Hive.box(miscellaneousDataHIVE).put('isAwaitingEnrollment',
    //       Hive.box(userDetailsHIVE).get('usermodeldata').isAwaitingEnrollment);
    // }
    // if (Hive.box(miscellaneousDataHIVE).get('membershipExpiry') == null) {
    //   Hive.box(miscellaneousDataHIVE).put('membershipExpiry',
    //       Hive.box(userDetailsHIVE).get('usermodeldata').membershipExpiry);
    // }
    return ScreenUtilInit(builder: (context, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GymTracker',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
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
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 1000), () {
      changepage();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Color> x = <Color>[Colors.white, Colors.white54];
    final Shader linearGradient = LinearGradient(
      colors: <Color>[Colors.white, Colors.white54],
    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
    return Scaffold(
      backgroundColor: Colors.black,
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
        child: Stack(
          children: [
            Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                    // SizedBox(
                    //   //color: Colors.blue.withOpacity(0.2),
                    //   height: 100.h,
                    //   child: Image.asset(
                    //     'assets/images/playstore.png',
                    //     color: Colors.white,
                    //   ),
                    // ),
                    Text(
                      'GymTracker',
                      style: TextStyle(
                          fontFamily: 'gilroy_bolditalic',
                          fontSize: 35.sp,
                          foreground: Paint()..shader = linearGradient),
                    ),
                  ]),
            ),
            Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'from',
                      style: TextStyle(
                          fontFamily: 'gilroy_regular',
                          color: color_gt_textColorBlueGrey),
                    ),
                    Text(
                      'Aquela Studios',
                      style: TextStyle(
                          fontFamily: 'gilroy_regular',
                          color: color_gt_green,
                          fontSize: 20.sp),
                    ),
                  ]),
            ),
          ],
        ),
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
            return NavigationPage();
          }
        },
      ),
    ));
  }
}

// class GymTracker extends StatelessWidget {
//   const GymTracker({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return hiveListenerAuthStatusCheck();
//     // return Consumer(
//     //   builder: (context, ref, child) {
//     //     final authState = ref.watch(authChangesProvider)..checkUserStatus();

//     //     return authState.isLoggedIn ? ProfilePage() : SignInPage();
//     //   },
//     // );
//   }
// }

hiveListenerAuthStatusCheck() {
  return ValueListenableBuilder<Box<dynamic>>(
    valueListenable: Hive.box(miscellaneousDataHIVE).listenable(),
    builder: (context, value, child) {
      if (value.get('isLoggedIn') == false) {
        return SignInPage();
      } else {
        return NavigationPage();
      }
    },
  );
}

// Widget checkAuthStatus() {
//   return StreamBuilder(
//     stream: fireBaseAuth.authStateChanges(),
//     builder: (context, AsyncSnapshot<User?> userData) {
//       if (userData.connectionState == ConnectionState.active) {
//         return (userData.data != null) ? NavigationPage() : SignInPage();
//       } else {
//         return Loader(
//           loadercolor: color_gt_green,
//         );
//       }
//     },
//   );
// }
