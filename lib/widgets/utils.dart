import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class CustomUtilities {
  static Padding prefixIcon({required String iconName}) {
    return Padding(
      padding: EdgeInsets.all(10.h),
      child: Image.asset(
        "assets/icons/$iconName.png",
        fit: BoxFit.fitHeight,
        height: 8.h,
        color: const Color(0xff7e7d7d).withOpacity(0.7),
      ),
    );
  }

  static Color hexColor({required String colorCode, double opacity = 1}) {
    // String c =
    //     (colorCode.contains('#')) ? colorCode.split('#').last : colorCode;

    return Color(int.parse(
            '0xff${(colorCode.contains('#')) ? colorCode.split('#').last : colorCode}'))
        .withOpacity(opacity);
  }

  static Widget customAnimatedButton({
    double? widthWhileAnimating,
    required BuildContext context,
    required bool condition,
    required Widget trueWidget,
    required Widget falseWidget,
    required Function buttonAction,
    required double buttonHeight,
    int animatedContainerDuration = 200,
    int animatedSwitcherDuration = 0,
    Curve animatedContainerCurveAnimation = Curves.fastEaseInToSlowEaseOut,
    double? buttonRadius,
    Color buttonColor = const Color(0xffFED428),
  }) {
    return Ink(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(buttonRadius ?? 60.r),
        color: buttonColor,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(buttonRadius ?? 60.r),
        onTap: () async => buttonAction(),
        child: AnimatedContainer(
          curve: animatedContainerCurveAnimation,
          height: buttonHeight,
          width: widthWhileAnimating ?? MediaQuery.of(context).size.width,
          duration: Duration(milliseconds: animatedContainerDuration),
          child: AnimatedSwitcher(
            switchInCurve: Curves.fastEaseInToSlowEaseOut,
            switchOutCurve: Curves.fastEaseInToSlowEaseOut,
            duration: Duration(milliseconds: animatedSwitcherDuration),
            child: condition ? trueWidget : falseWidget,
          ),
        ),
      ),
    );
  }

  static customToaster({
    required BuildContext context,
    required String toasterMessage,
    required Color toasterBackgroundColor,
    required Color textColor,
    double? fontSize,
    bool showToastAtBottom = true,
    Duration animationDuration = const Duration(seconds: 1),
    Duration toasterDuration = const Duration(seconds: 4),
    Curve curve = Curves.linearToEaseOut,
    Curve revCurve = Curves.linearToEaseOut,
  }) {
    showToastWidget(
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Container(
          padding: EdgeInsets.all(10.w),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: toasterBackgroundColor,
            borderRadius: BorderRadius.circular(
              10.r,
            ),
          ),
          child: Text(
            toasterMessage,
            style: TextStyle(
              fontSize: fontSize ?? 14.sp,
              color: textColor,
            ),
          ),
        ),
      ),
      context: context,
      animation: StyledToastAnimation.fade,
      reverseAnimation: StyledToastAnimation.fade,
      curve: curve,
      reverseCurve: revCurve,
      position: (showToastAtBottom)
          ? StyledToastPosition.bottom
          : StyledToastPosition.top,
      animDuration: animationDuration,
      duration: toasterDuration,
    );
  }

  static Widget customAnimatedSwitcher({
    // dont forget to mention Key parameters and only then the animation will function.
    int milliSecs = 200,
    required bool condition,
    required Widget trueWidget,
    required Widget falseWidget,
  }) {
    return AnimatedSwitcher(
      duration: Duration(
        milliseconds: milliSecs,
      ),
      child: condition ? trueWidget : falseWidget,
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
