// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names, avoid_print, prefer_const_constructors
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';

// import '../widgets/customsnackbar.dart';

// class Register {
//   String selectedgender;
//   int no_of_times_profilechanged;
//   File? pickedImage;
//   File? testfile;
//   Register({
//     this.no_of_times_profilechanged = 0,
//     this.pickedImage,
//     required this.selectedgender,
//     this.testfile,
//   });

//   Register copyWith({
//     String? selectedgender,
//     bool? pass_isobscure,
//     bool? confirmpass_isobscure,
//     int? no_of_times_profilechanged,
//     File? pickedImage,
//     File? testfile,
//   }) {
//     return Register(
//       no_of_times_profilechanged:
//           no_of_times_profilechanged ?? this.no_of_times_profilechanged,
//       pickedImage: pickedImage ?? this.pickedImage,
//       testfile: testfile ?? this.testfile,
//       selectedgender: '',
//     );
//   }

//   @override
//   String toString() {
//     return 'Register(no_of_times_profilechanged: $no_of_times_profilechanged, pickedImage: $pickedImage, testfile: $testfile)';
//   }
// }

// class RegisterNotifier extends StateNotifier<Register> {
//   RegisterNotifier()
//       : super(Register(
//           selectedgender: 'Male',
//           no_of_times_profilechanged: 0,
//         ));

//   changegender(String value) async {
//     state.selectedgender = value;
//     state.pickedImage = await convertImageToFile();
//     print(state.pickedImage);
//   }

//   changeToDefaultProfilePhoto(BuildContext ctx) async {
//     state.no_of_times_profilechanged = 1;
//     CustomSnackBar.buildSnackbar(
//       context: ctx,
//       color: Colors.red[500]!,
//       message: 'You have de-selected your profile picture!',
//       textcolor: Color(0xffFDFFFC),
//       iserror: true,
//     );
//     print(await convertImageToFile());
//     state.pickedImage = await convertImageToFile();
//   }

//   Future<File> convertImageToFile() async {
//     var bytes =
//         await rootBundle.load('assets/images/${state.selectedgender}.png');
//     String tempPath = (await getTemporaryDirectory()).path;
//     File file = File('$tempPath/${state.selectedgender}.png');
//     await file.writeAsBytes(
//         bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
//     return file;
//   }

//   void pickimage(BuildContext ctx) async {
//     final pickedimage =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedimage != null) {
//       state.no_of_times_profilechanged = state.no_of_times_profilechanged + 1;
//       CustomSnackBar.buildSnackbar(
//         context: ctx,
//         color: Color(0xff4CB944),
//         message: 'You have successfuly selected your profile picture!',
//         textcolor: Color(0xffFDFFFC),
//         iserror: true,
//       );
//       state.pickedImage = (File(pickedimage.path));
//     }

//     print(state.pickedImage);
//   }
//   Future<String> _uploadtoStorage(File image) async {
//     Reference ref = firebasestorage
//         .ref()
//         .child('profilepics')
//         .child(firebaseauth.currentUser.uid);
//     UploadTask uploadtask = ref.putFile(image);
//     TaskSnapshot snap = await uploadtask;
//     String downloadurl = await snap.ref.getDownloadURL();
//     notifyListeners();
//     return downloadurl;
//   }
// }
