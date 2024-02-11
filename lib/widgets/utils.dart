import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomUtilities {
  static Padding prefixIcon({required String iconName}) {
    return Padding(
      padding: EdgeInsets.all(10.h),
      child: Image.asset(
        "assets/icons/$iconName.png",
        fit: BoxFit.fitHeight,
        height: 10.h,
        color: const Color(0xff7e7d7d).withOpacity(0.7),
      ),
    );
  }

  static onWillPop({
    required BuildContext context,
    required String notificationName,
    required String body,
  }) {
    return (showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.only(
            // left: 10.w,
            // right: 10.w,
            ),
        actionsPadding: const EdgeInsets.all(0),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 10.h,
            ),
            Text(
              notificationName,
              style: TextStyle(
                color: Colors.grey,
                fontFamily: 'gilroy_bold',
                fontSize: 18.sp,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              body,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14.sp,
                fontFamily: 'gilroy_regular',
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Container(
              color: Color(0xff7e7d7d).withOpacity(0.5),
              height: 1.h,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(false),
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    height: 40.h,
                    child: Center(
                      child: Text(
                        'No',
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'gilroy_bold',
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 40.h,
                color: const Color(0xff7e7d7d).withOpacity(0.5),
                width: 1.w,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => SystemNavigator.pop(),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                        color: const Color(0xffEB5757).withOpacity(0.2),
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10.r))),
                    child: Center(
                      child: Text(
                        'Yes',
                        style: TextStyle(
                          color: const Color(0xffEB5757),
                          fontFamily: 'gilroy_bold',
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    ));
  }
}
