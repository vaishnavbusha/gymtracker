// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gymtracker/constants.dart';
import 'package:gymtracker/providers/authentication_providers.dart';
import 'package:gymtracker/widgets/loader.dart';
import 'package:gymtracker/widgets/nointernet_widget.dart';

import 'package:new_version/new_version.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../controllers/network_controller.dart';

import '../widgets/updatedialog.dart';

class NavigationPage extends ConsumerStatefulWidget {
  const NavigationPage({Key? key}) : super(key: key);

  @override
  ConsumerState<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends ConsumerState<NavigationPage> {
  // PersistentTabController? _controller;
  // bool? isUser;
  @override
  void initState() {
    checkversion();
    ref.read(navigationBarProvider);
    //navigationState.checkUserStatus();
    // isUser =
    //     (Hive.box(userDetailsHIVE).get('usermodeldata') as UserModel).isUser;
    // _controller =
    //     PersistentTabController(initialIndex: navigationState.isUser! ? 1 : 0);
    // TODO: implement initState
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
    // if (status!.storeVersion != status.localVersion) {
    //   showDialog(
    //     context: context,
    //     builder: (ctx) => UpdateDialog(
    //       applink:
    //           'https://play.google.com/store/apps/details?id=com.aquelastudios.calculater',
    //       color: themeController.bgcolor,
    //       description: '',
    //       divider_color: themeController.specialtextcolor,
    //       evaluated_expression_color: themeController.textcolor,
    //       localVersion: status.localVersion,
    //       storeVersion: status.storeVersion,
    //     ),
    //   );
    //   // newversion.showUpdateDialog(
    //   //     context: context,
    //   //     versionStatus: status,
    //   //     dialogTitle: "Update Available!",
    //   //     dismissButtonText: "Exit",
    //   //     dismissAction: () => SystemNavigator.pop(),
    //   //     updateButtonText: "Update",
    //   //     dialogText: "Please update the app from " +
    //   //         "${status.localVersion}" +
    //   //         " to " +
    //   //         "${status.storeVersion}");
    // }
  }

  @override
  Widget build(BuildContext context) {
    final navigationState = ref.watch(navigationBarProvider);
    var connectivityStatusProvider = ref.watch(connectivityStatusProviders);
    return (connectivityStatusProvider == ConnectivityStatus.isConnected)
        ? (navigationState.isDataAvailable && navigationState.isUser != null)
            ? PersistentTabView(
                context,
                controller: navigationState.controller,
                screens: (navigationState.isUser!) ? pagesList : adminPagesList,
                items: (navigationState.isUser!)
                    ? _navBarsItems()
                    : _adminNavBarItems(),
                confineInSafeArea: true,
                backgroundColor: Colors.black87, // Default is Colors.white.
                handleAndroidBackButtonPress: true, // Default is true.
                resizeToAvoidBottomInset:
                    false, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
                stateManagement: true, // Default is true.
                hideNavigationBarWhenKeyboardShows:
                    true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.

                popAllScreensOnTapOfSelectedTab: true,
                popActionScreens: PopActionScreensType.all,
                itemAnimationProperties: ItemAnimationProperties(
                  // Navigation Bar's items animation properties.
                  duration: Duration(milliseconds: 0),
                  curve: Curves.ease,
                ),
                screenTransitionAnimation: ScreenTransitionAnimation(
                  // Screen transition animation on change of selected tab.
                  animateTabTransition: true,
                  curve: Curves.ease,
                  duration: Duration(milliseconds: 200),
                ),
                navBarStyle: NavBarStyle
                    .style12, // Choose the nav bar style with this property.
              )
            : Scaffold(
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
                  child: Center(
                    child: Loader(
                      loadercolor: Color(0xff2D77D0),
                    ),
                  ),
                ),
              )
        : NoInternetWidget();
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      // PersistentBottomNavBarItem(
      //   icon: Icon(Icons.explore),
      //   title: ("explore"),
      //   activeColorPrimary: CupertinoColors.activeBlue,
      //   inactiveColorPrimary: CupertinoColors.systemGrey,
      // ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.qr_code_scanner_rounded),
        title: ("scan"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person),
        title: ("profile"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  List<PersistentBottomNavBarItem> _adminNavBarItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.explore),
        title: ("explore"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person),
        title: ("profile"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }
}

// class NavigationPage extends StatefulWidget {
//   const NavigationPage({Key? key}) : super(key: key);

//   @override
//   State<NavigationPage> createState() => _NavigationPageState();
// }

// class _NavigationPageState extends State<NavigationPage> {
//   int _index = 0;
//   final GlobalKey<NavigatorState> p0 = GlobalKey<NavigatorState>();
//   final GlobalKey<NavigatorState> p1 = GlobalKey<NavigatorState>();
//   final GlobalKey<NavigatorState> p2 = GlobalKey<NavigatorState>();
//   @override
//   Widget build(BuildContext context) {
//     return PersistentBottomBarScaffold(
//       items: [
//         PersistentTabItems(
//           icon: Icons.explore,
//           navigatorKey: p0,
//           tab: pagesList[0],
//           title: 'explore',
//         ),
//         PersistentTabItems(
//           icon: Icons.qr_code_scanner_rounded,
//           navigatorKey: p1,
//           tab: pagesList[1],
//           title: 'scan',
//         ),
//         PersistentTabItems(
//           icon: Icons.explore,
//           navigatorKey: p2,
//           tab: pagesList[2],
//           title: 'profile',
//         ),
//       ],
//     );
//   }
// }

// enum TabItem { explore, scan, profile }

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late CupertinoTabController tabController;
//   final GlobalKey<NavigatorState> p0 = GlobalKey<NavigatorState>();
//   final GlobalKey<NavigatorState> p1 = GlobalKey<NavigatorState>();
//   final GlobalKey<NavigatorState> p2 = GlobalKey<NavigatorState>();
//   @override
//   void initState() {
//     super.initState();
//     tabController = CupertinoTabController(initialIndex: 1);
//   }

//   @override
//   void dispose() {
//     tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final listOfKeys = [p0, p1, p2];
//     return WillPopScope(
//       onWillPop: () async {
//         return !await listOfKeys[tabController.index].currentState!.maybePop();
//       },
//       child: CupertinoTabScaffold(
//         resizeToAvoidBottomInset: true,
//         controller: tabController,
//         tabBuilder: (BuildContext context, int index) {
//           return CupertinoTabView(
//               navigatorKey: listOfKeys[index],
//               builder: (context) {
//                 return SafeArea(child: pagesList[index]);
//               });
//         },
//         tabBar: CupertinoTabBar(
//           //backgroundColor: Colors.black,
//           border: const Border(bottom: BorderSide.none),
//           inactiveColor: color_gt_headersTextColorWhite.withOpacity(0.5),
//           activeColor: color_gt_headersTextColorWhite,
//           items: [
//             BottomNavigationBarItem(
//               activeIcon: Icon(Icons.home),
//               icon: Icon(Icons.home),
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.qr_code_scanner_rounded),
//             ),
//             BottomNavigationBarItem(
//               activeIcon: Icon(Icons.person),
//               icon: Icon(Icons.person_outline),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
