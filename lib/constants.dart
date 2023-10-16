// ignore_for_file: non_constant_identifier_names, prefer_const_declarations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gymtracker/views/explore.dart';
import 'package:gymtracker/views/profile.dart';
import 'package:gymtracker/views/scan.dart';

Map<int, String> userLevels = {
  0: 'user',
  1: 'admin',
  2: 'creator',
};
List<String> genders = ['Male', 'Female'];
Color color_gt_green = const Color(0xff20B05E);
Color color_gt_greenHalfOpacity = const Color(0xff20B05E).withOpacity(0.5);
Color color_gt_headersTextColorWhite = Colors.white;
Color color_gt_textColorBlueGrey = Colors.blueGrey;
final fireBaseAuth = FirebaseAuth.instance;
final fireBaseFireStore = FirebaseFirestore.instance;

const IconData customRupeeIcon = IconData(0xf05db, fontFamily: 'MaterialIcons');
final pagesList = [
  //const ExplorePage(),
  const ScanPage(),
  const ProfilePage(),
];
final adminPagesList = [
  const ExplorePage(),
  const ProfilePage(),
];
final userDetailsHIVE = 'userINFO';
final miscellaneousDataHIVE = 'appDATA';
final maxClickAttemptsHIVE = 'maxClickAttempts';
final int maxAttendanceByDateInCurrentMonthCount = 7;
final int maxMonthlyAttendanceCount = 3;
