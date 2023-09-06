// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymtracker/models/enroll_model.dart';
import 'package:gymtracker/providers/authentication_providers.dart';
import 'package:gymtracker/widgets/loader.dart';

import '../constants.dart';

class EnrollPage extends ConsumerStatefulWidget {
  const EnrollPage({Key? key}) : super(key: key);

  @override
  ConsumerState<EnrollPage> createState() => _EnrollPageState();
}

class _EnrollPageState extends ConsumerState<EnrollPage> {
  //List<EnrollModel> gymPartnersData = [];
  //<String> gymNames = [];
  //CollectionReference? _collectionData;
  //String dropdownvalue = 'choose';
  @override
  void initState() {
    //_collectionData = fireBaseFireStore.collection("gympartners");
    // getGymPartnersDetails();
    //ref.read(profileControllerProvider).getUserData();
    // TODO: implement initState
    super.initState();
  }

  // getGymPartnersDetails() async {
  //   QuerySnapshot querySnapshot = await _collectionData!.get();
  //   final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  //   gymPartnersData = allData.map(
  //     (e) {
  //       final x = e as Map<String, dynamic>;
  //       return EnrollModel.fromMap(x);
  //     },
  //   ).toList();
  //   for (EnrollModel x in gymPartnersData) {
  //     gymNames.add(x.gymPartnerGYMName!);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final enrollState = ref.watch(enrollControllerProvider);
    return Scaffold(
      appBar: PreferredSize(
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: AppBar(
              centerTitle: true,
              title: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Enroll',
                  style: TextStyle(
                      fontFamily: 'gilroy_bold',
                      color: color_gt_green,
                      fontSize: 20.sp,
                      fontStyle: FontStyle.normal),
                  textAlign: TextAlign.center,
                ),
              ),
              elevation: 0.0,
              backgroundColor: Colors.black.withOpacity(0.5),
            ),
          ),
        ),
        preferredSize: Size(
          double.infinity,
          56.0,
        ),
      ),
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
        child: (enrollState.gymPartnersData.isNotEmpty)
            ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: 25.h, left: 10.w, right: 10.w, bottom: 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Gym Partner:  ',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: color_gt_green,
                          fontFamily: 'gilroy_bold',
                        ),
                      ),
                      SizedBox(
                        height: 44.h,
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: DropdownButtonFormField<String>(
                          dropdownColor: color_gt_textColorBlueGrey,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white10,
                            floatingLabelStyle: TextStyle(
                              fontFamily: "gilroy_bolditalic",
                              fontSize: 16.sp,
                              color: color_gt_headersTextColorWhite
                                  .withOpacity(0.9),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide:
                                  const BorderSide(color: Colors.white12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(
                                  color: color_gt_textColorBlueGrey
                                      .withOpacity(0.3)),
                            ),
                            // prefixIcon: Icon(
                            //   (register.selectedgender == 'Male')
                            //       ? Icons.male_rounded
                            //       : Icons.female_rounded,
                            //   color: color_gt_greenHalfOpacity
                            //       .withOpacity(0.7),
                            // ),
                          ),
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: color_gt_headersTextColorWhite,
                            fontFamily: 'gilroy_regular',
                          ),

                          value: enrollState.dropdownvalue,

                          hint: Text(
                            'Select gym names',
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: color_gt_headersTextColorWhite
                                  .withOpacity(0.7),
                              fontFamily: 'gilroy_regular',
                            ),
                          ),
                          onChanged: (value) {
                            enrollState.changeEnrollGymName(value!);
                          },
                          // ignore: prefer_const_literals_to_create_immutables
                          items: enrollState.gymNames.map((item) {
                            return DropdownMenuItem<String>(
                              child: Center(
                                child: Text(
                                  item,
                                ),
                              ),
                              value: item,
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 25.h, left: 10.w, right: 10.w, bottom: 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Gym Owner:  ',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: color_gt_green,
                          fontFamily: 'gilroy_bold',
                        ),
                      ),
                      Container(
                        height: 43.h,
                        width: MediaQuery.of(context).size.width * 0.65,
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(width: 1, color: Colors.white12),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 14.h),
                          child: Text(
                            '${enrollState.gymPartnersData[enrollState.selectedIndexOfGymPartnersData].gymPartnerName}',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: color_gt_headersTextColorWhite,
                              fontFamily: 'gilroy_regular',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Consumer(builder: (context, ref, child) {
                  final enrollcontroller = ref.watch(enrollControllerProvider);
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 84.h, vertical: 40.h),
                    child: (enrollcontroller.isLoading == false)
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              onPrimary: !(enrollcontroller.isEnrolled)
                                  ? Colors.black
                                  : Colors.white
                                      .withOpacity(0.5), //to change text color
                              padding: EdgeInsets.symmetric(vertical: 7.h),
                              primary: !(enrollcontroller.isEnrolled)
                                  ? color_gt_green
                                  : Colors.grey
                                      .withOpacity(0.5), // button color
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(10.r), // <-- Radius
                              ),
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.sp,
                                  fontFamily: 'gilroy_bold'),
                            ),
                            onPressed: () {
                              (enrollcontroller.isEnrolled)
                                  ? null
                                  : enrollcontroller
                                      .updateEnrollmentInfo(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.fitness_center_rounded),
                                SizedBox(width: 10.w),
                                Text(
                                  'Enroll Now !',
                                ),
                              ],
                            ),
                          )
                        : Loader(loadercolor: Colors.blue),
                  );
                }),
              ])
            : Loader(loadercolor: Colors.red),
      ),
    );
  }
}
