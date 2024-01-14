// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gymtracker/constants.dart';

class PersistentBottomBarScaffold extends StatefulWidget {
  const PersistentBottomBarScaffold({Key? key, required this.items})
      : super(key: key);
  final List<PersistentTabItems> items;
  @override
  State<PersistentBottomBarScaffold> createState() =>
      _PersistentBottomBarScaffoldState();
}

class _PersistentBottomBarScaffoldState
    extends State<PersistentBottomBarScaffold> {
  int _selectedTab = 1;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.items[_selectedTab].navigatorKey.currentState!.canPop()) {
          widget.items[_selectedTab].navigatorKey.currentState!.pop();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: IndexedStack(
          index: _selectedTab,
          children: widget.items.map(
            (page) {
              return Navigator(
                key: page.navigatorKey,
                onGenerateInitialRoutes: (navigator, initialRoute) {
                  return [
                    CupertinoPageRoute(
                      builder: (context) => page.tab,
                    )
                  ];
                },
              );
            },
          ).toList(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white.withOpacity(0.01),
          currentIndex: _selectedTab,
          onTap: (index) {
            if (index == _selectedTab) {
              widget.items[index].navigatorKey.currentState!
                  .popUntil((route) => route.isFirst);
            } else {
              setState(() {
                _selectedTab = index;
              });
            }
          },
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          items: widget.items
              .map(
                (e) => BottomNavigationBarItem(
                    label: e.title,
                    icon: Icon(
                      e.icon,
                      color: _selectedTab == widget.items.indexOf(e)
                          ? Colors.white
                          : Colors.grey,
                    )),
              )
              .toList(),
        ),
      ),
    );
  }
}

class PersistentTabItems {
  late final Widget tab;
  late final GlobalKey<NavigatorState> navigatorKey;
  final String title;
  final IconData icon;
  PersistentTabItems({
    required this.icon,
    required this.navigatorKey,
    required this.tab,
    required this.title,
  });
}
