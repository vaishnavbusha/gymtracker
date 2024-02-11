// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, use_key_in_widget_constructors, implementation_imports

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:gymtracker/views/explore.dart';
import 'package:gymtracker/views/profile.dart';
import 'package:gymtracker/views/scan.dart';
import 'package:new_version/new_version.dart';

import '../controllers/network_controller.dart';
import '../providers/providers.dart';
import '../widgets/loader.dart';
import '../widgets/nointernet_widget.dart';
import '../widgets/updatedialog.dart';

class NavigationScreen extends ConsumerStatefulWidget {
  const NavigationScreen();
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

final bucketglobal = PageStorageBucket();

class _NavigationScreenState extends ConsumerState<NavigationScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabcontroller;
  // @override
  // bool get wantKeepAlive => true;
  @override
  void initState() {
    checkversion();
    ref.read(Providers.navigationBarProvider);
    tabcontroller = TabController(length: 2, vsync: this);

    super.initState();
  }

  void checkversion() async {
    final newversion = NewVersion(androidId: "com.aquelastudios.gymtracker");
    final status = await newversion.getVersionStatus();
    if (status != null) {
      if (status.canUpdate) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (ctx) => WillPopScope(
            onWillPop: () async => false,
            child: UpdateDialog(
              applink:
                  'https://play.google.com/store/apps/details?id=com.aquelastudios.gymtracker',
              color: 0xff122B32,
              description: '',
              divider_color: 0xFFF05454,
              evaluated_expression_color: 0xff2D77D0,
              localVersion: status.localVersion,
              storeVersion: status.storeVersion,
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    tabcontroller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navigationState = ref.watch(Providers.navigationBarProvider);
    var connectivityStatusProvider =
        ref.watch(Providers.connectivityStatusProviders);
    return (connectivityStatusProvider == ConnectivityStatus.isConnected)
        ? (navigationState.isDataAvailable && navigationState.isUser != null)
            ? Scaffold(
                body: Stack(
                  children: [
                    TabBarView(
                      controller: tabcontroller,
                      children: [
                        (navigationState.isUser!) ? ScanPage() : ExplorePage(),
                        ProfilePage(),
                      ],
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(80.r),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(80.r),
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                                  child: Column(
                                    children: [
                                      Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: TabBar(
                                            controller: tabcontroller,
                                            unselectedLabelColor:
                                                Color(0xffFED428)
                                                    .withOpacity(0.2),
                                            labelColor: Color(0xffFED428),
                                            labelStyle: TextStyle(
                                              fontFamily: 'gilroy_regular',
                                              fontSize: 13.sp,
                                            ),
                                            indicator: BoxDecoration(
                                              color: Colors.black
                                                  .withOpacity(0.15),
                                              borderRadius:
                                                  BorderRadius.circular(80.r),
                                            ),
                                            tabs: [
                                              Padding(
                                                padding: EdgeInsets.all(10),
                                                child: Icon((navigationState
                                                        .isUser!)
                                                    ? Icons
                                                        .qr_code_scanner_rounded
                                                    : Icons.explore),
                                              ),
                                              Icon(
                                                Icons.person,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Scaffold(
                backgroundColor: Color(0xff1A1F25),
                body: Center(
                  child: Loader(
                    loadercolor: Color(0xffFED428),
                  ),
                ),
              )
        : NoInternetWidget();
  }
}
