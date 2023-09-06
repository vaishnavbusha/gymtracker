// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymtracker/constants.dart';
import 'package:gymtracker/models/user_model.dart';

import 'package:gymtracker/providers/authentication_providers.dart';
import 'package:gymtracker/views/navigation.dart';
import 'package:gymtracker/views/profile.dart';
import 'package:gymtracker/views/signin.dart';
import 'package:gymtracker/widgets/animated_route.dart';
import 'package:gymtracker/widgets/loader.dart';
import 'package:hive_flutter/adapters.dart';

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
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (Hive.box(miscellaneousDataHIVE).get('isLoggedIn') == null) {
      Hive.box(miscellaneousDataHIVE).put('isLoggedIn', false);
    }
    return ScreenUtilInit(builder: (context, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
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
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 900), () {
      changepage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: Text(
        'GymTracker',
        style: TextStyle(color: Colors.white),
      )),
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

// hiveListenerAuthStatusCheck() {
//   return ValueListenableBuilder<Box<dynamic>>(
//     valueListenable: Hive.box(miscellaneousDataHIVE).listenable(),
//     builder: (context, value, child) {
//       if (value.get('isLoggedIn') == false) {
//         return SignInPage();
//       } else {
//         return NavigationPage();
//       }
//     },
//   );
// }

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
