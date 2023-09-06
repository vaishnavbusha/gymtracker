// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: const [Color(0xff122B32), Colors.black],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoadingAnimationWidget.beat(
                  color: Colors.red,
                  size: 30,
                ),
                //Loader(loadercolor: Colors.red),
                SizedBox(
                  height: 15.h,
                ),
                Text(
                  'Oops, there\'s no internet connection ',
                  style: TextStyle(
                    fontSize: 17.sp,
                    color: Colors.red,
                    fontFamily: 'gilroy_bolditalic',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
