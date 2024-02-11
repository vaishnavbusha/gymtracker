// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/src/size_extension.dart';

class CustomSnackBar {
  CustomSnackBar._();
  static buildSnackbar(
      {required BuildContext context,
      required String message,
      required Color color,
      required Color textcolor,
      required bool iserror}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        // margin: EdgeInsets.only(
        //     left: 10.w,
        //     right: 10.w,
        //     bottom: MediaQuery.of(context).size.height *
        //         0.88), // displays snackbar at the top
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Text(
                    message,
                    textAlign: TextAlign.start,
                    
                    style: TextStyle(
                      fontFamily: 'gilroy_bolditalic',
                      color: textcolor,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
              ],
            ),
            iserror
                ? Icon(
                    Icons.error_outline_rounded,
                    color: textcolor,
                  )
                : Icon(
                    Icons.check_circle_outline_rounded,
                    color: textcolor,
                  ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.r))),
        duration: const Duration(
          milliseconds: 3200,
        ),

        // margin: EdgeInsets.only(
        //     bottom: MediaQuery.of(context).size.height - 100,
        //     right: 20,
        //     left: 20),
      ),
    );
  }
}
