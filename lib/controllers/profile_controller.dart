// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../constants.dart';
import '../models/user_model.dart';
import '../views/signin.dart';

class ProfileController extends ChangeNotifier {
  late UserModel userModelData;

  getUserData() {
    userModelData = Hive.box(userDetailsHIVE).get('usermodeldata');
  }

  Future<void> signOut(BuildContext context) async {
    await fireBaseAuth.signOut();
    await Hive.box(userDetailsHIVE).clear();
    Hive.box(miscellaneousDataHIVE).put('isLoggedIn', false);
    Navigator.of(context, rootNavigator: true).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignInPage()));
  }

  userDataChanges_FirebaseListener() {
    String collPath = 'users';
    String docPath = userModelData.uid!;

    DocumentReference documentReference =
        fireBaseFireStore.collection(collPath).doc(docPath);

    documentReference.snapshots().listen((snapshot) {
      print(snapshot.data);
    });
  }
}
