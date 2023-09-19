// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: implementation_imports

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Loader extends StatelessWidget {
  final Color loadercolor;
  const Loader({
    Key? key,
    required this.loadercolor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.rotate(
        angle: math.pi / 4,
        child: Container(
          decoration: BoxDecoration(
              color: loadercolor, borderRadius: BorderRadius.circular(10.r)),
          child: Padding(
            padding: EdgeInsets.all(8.0.w),
            child: Transform.rotate(
              angle: -45 * math.pi / 180,
              child: LoadingAnimationWidget.threeArchedCircle(
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
