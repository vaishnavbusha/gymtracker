// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

import 'package:gymtracker/constants.dart';

part 'user_model.g.dart';

// ignore_for_file: non_constant_identifier_names
@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String userType = 'user';
  @HiveField(1)
  String userName;
  @HiveField(2)
  String? uid;
  @HiveField(3)
  bool? isManuallyRegisteredByAdmin;
  @HiveField(4)
  String email;
  @HiveField(5)
  String gender;
  @HiveField(6)
  String DOB;
  @HiveField(7)
  bool isUser;
  @HiveField(8)
  DateTime? registeredDate;
  @HiveField(9)
  String? enrolledGym;
  @HiveField(10)
  DateTime? enrolledGymDate;

  @HiveField(11)
  DateTime? membershipExpiry;
  @HiveField(12)
  String? phoneNumber;
  @HiveField(13)
  bool? isAwaitingEnrollment;
  @HiveField(14)
  List? pendingApprovals;
  @HiveField(15)
  int? memberShipFeesPaid;
  @HiveField(16)
  DateTime? recentRenewedOn;
  @HiveField(17)
  List? pendingRenewals;
  @HiveField(18)
  String? enrolledGymOwnerName;
  @HiveField(19)
  String? enrolledGymOwnerUID;
  @HiveField(20)
  bool? awaitingRenewal;

  UserModel({
    required this.userType,
    required this.userName,
    this.uid,
    this.isManuallyRegisteredByAdmin = false,
    required this.email,
    required this.gender,
    required this.DOB,
    required this.isUser,
    required this.registeredDate,
    this.enrolledGym,
    this.enrolledGymDate,
    this.membershipExpiry,
    required this.phoneNumber,
    this.isAwaitingEnrollment = false,
    required this.pendingApprovals,
    this.memberShipFeesPaid,
    this.recentRenewedOn,
    this.pendingRenewals,
    this.enrolledGymOwnerName,
    this.enrolledGymOwnerUID,
    this.awaitingRenewal = false,
  });

  @override
  String toString() {
    return 'UserModel(userType: $userType, userName: $userName, uid: $uid, isManuallyRegisteredByAdmin: $isManuallyRegisteredByAdmin, email: $email, gender: $gender, DOB: $DOB, isUser: $isUser, registeredDate: $registeredDate, enrolledGym: $enrolledGym, enrolledGymDate: $enrolledGymDate, membershipExpiry: $membershipExpiry, phoneNumber: $phoneNumber, isAwaitingEnrollment: $isAwaitingEnrollment, pendingApprovals: $pendingApprovals, memberShipFeesPaid: $memberShipFeesPaid, recentRenewedOn: $recentRenewedOn, pendingRenewals: $pendingRenewals, enrolledGymOwnerName: $enrolledGymOwnerName, enrolledGymOwnerUID: $enrolledGymOwnerUID, awaitingRenewal: $awaitingRenewal)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.userType == userType &&
        other.userName == userName &&
        other.uid == uid &&
        other.isManuallyRegisteredByAdmin == isManuallyRegisteredByAdmin &&
        other.email == email &&
        other.gender == gender &&
        other.DOB == DOB &&
        other.isUser == isUser &&
        other.registeredDate == registeredDate &&
        other.enrolledGym == enrolledGym &&
        other.enrolledGymDate == enrolledGymDate &&
        other.membershipExpiry == membershipExpiry &&
        other.phoneNumber == phoneNumber &&
        other.isAwaitingEnrollment == isAwaitingEnrollment &&
        other.pendingApprovals == pendingApprovals &&
        other.memberShipFeesPaid == memberShipFeesPaid &&
        other.recentRenewedOn == recentRenewedOn &&
        other.pendingRenewals == pendingRenewals &&
        other.enrolledGymOwnerName == enrolledGymOwnerName &&
        other.enrolledGymOwnerUID == enrolledGymOwnerUID &&
        other.awaitingRenewal == awaitingRenewal;
  }

  @override
  int get hashCode {
    return userType.hashCode ^
        userName.hashCode ^
        uid.hashCode ^
        isManuallyRegisteredByAdmin.hashCode ^
        email.hashCode ^
        gender.hashCode ^
        DOB.hashCode ^
        isUser.hashCode ^
        registeredDate.hashCode ^
        enrolledGym.hashCode ^
        enrolledGymDate.hashCode ^
        membershipExpiry.hashCode ^
        phoneNumber.hashCode ^
        isAwaitingEnrollment.hashCode ^
        pendingApprovals.hashCode ^
        memberShipFeesPaid.hashCode ^
        recentRenewedOn.hashCode ^
        pendingRenewals.hashCode ^
        enrolledGymOwnerName.hashCode ^
        enrolledGymOwnerUID.hashCode ^
        awaitingRenewal.hashCode;
  }

  Map<String, dynamic> toJson() {
    return {
      'userType': userType,
      'userName': userName,
      'uid': uid,
      'email': email,
      'gender': gender,
      'DOB': DOB,
      'isUser': isUser,
      'registeredDate': registeredDate,
      'enrolledGym': enrolledGym,
      'enrolledGymDate': enrolledGymDate,
      'membershipExpiry': membershipExpiry,
      // 'profilephoto': profilephoto,
      'phoneNumber': phoneNumber,
      'pendingApprovals': pendingApprovals,
      'isAwaitingEnrollment': isAwaitingEnrollment,
      'memberShipFeesPaid': memberShipFeesPaid,
      'recentRenewedOn': recentRenewedOn,
      'pendingRenewals': pendingRenewals,
      'awaitingRenewal': awaitingRenewal,
      'enrolledGymOwnerName': enrolledGymOwnerName,
      'enrolledGymOwnerUID': enrolledGymOwnerUID,
      'isManuallyRegisteredByAdmin': isManuallyRegisteredByAdmin,
    };
  }

  static UserModel toModel(DocumentSnapshot data) {
    final mapData = data.data() as Map<String, dynamic>;
    return UserModel(
      awaitingRenewal: mapData['awaitingRenewal'],
      pendingApprovals: mapData['pendingApprovals'],
      isAwaitingEnrollment: mapData['isAwaitingEnrollment'],
      phoneNumber: mapData['phoneNumber'],
      //  profilephoto: mapData['profilephoto'],
      DOB: mapData['DOB'],
      email: mapData['email'],
      enrolledGymOwnerName: mapData['enrolledGymOwnerName'],
      enrolledGymOwnerUID: mapData['enrolledGymOwnerUID'],
      gender: mapData['gender'],
      isUser: mapData['isUser'],
      registeredDate: mapData['registeredDate'].toDate(),
      uid: mapData['uid'],
      userName: mapData['userName'],

      userType: mapData['userType'],
      enrolledGym: mapData['enrolledGym'],
      pendingRenewals: mapData['pendingRenewals'],
      isManuallyRegisteredByAdmin: mapData['isManuallyRegisteredByAdmin'],
      memberShipFeesPaid: mapData['memberShipFeesPaid'],
      enrolledGymDate: (mapData['enrolledGymDate'] == null)
          ? null
          : mapData['enrolledGymDate'].toDate(),
      membershipExpiry: (mapData['membershipExpiry'] == null)
          ? null
          : mapData['membershipExpiry'].toDate(),
      recentRenewedOn: (mapData['recentRenewedOn'] == null)
          ? null
          : mapData['recentRenewedOn'].toDate(),
    );
  }

//mapData['enrolledGymDate']
  DateTime checkNullForEnrolledGymDate(dynamic data) {
    return (data == null) ? null : data.toDate();
  }

  static saveUserDataToHIVE(UserModel userModel) async {
    Hive.box(userDetailsHIVE).put('usermodeldata', userModel);
    Hive.box(miscellaneousDataHIVE)
        .put('uid', await Hive.box(userDetailsHIVE).get('usermodeldata').uid);
    Hive.box(miscellaneousDataHIVE).put('isLoggedIn', true);
  }

  UserModel copyWith({
    String? userType,
    String? userName,
    String? uid,
    bool? isManuallyRegisteredByAdmin,
    String? email,
    String? gender,
    String? DOB,
    bool? isUser,
    DateTime? registeredDate,
    String? enrolledGym,
    DateTime? enrolledGymDate,
    DateTime? membershipExpiry,
    String? phoneNumber,
    bool? isAwaitingEnrollment,
    List? pendingApprovals,
    int? memberShipFeesPaid,
    DateTime? recentRenewedOn,
    List? pendingRenewals,
    String? enrolledGymOwnerName,
    String? enrolledGymOwnerUID,
    bool? awaitingRenewal,
  }) {
    return UserModel(
      userType: userType ?? this.userType,
      userName: userName ?? this.userName,
      uid: uid ?? this.uid,
      isManuallyRegisteredByAdmin:
          isManuallyRegisteredByAdmin ?? this.isManuallyRegisteredByAdmin,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      DOB: DOB ?? this.DOB,
      isUser: isUser ?? this.isUser,
      registeredDate: registeredDate ?? this.registeredDate,
      enrolledGym: enrolledGym ?? this.enrolledGym,
      enrolledGymDate: enrolledGymDate ?? this.enrolledGymDate,
      membershipExpiry: membershipExpiry ?? this.membershipExpiry,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isAwaitingEnrollment: isAwaitingEnrollment ?? this.isAwaitingEnrollment,
      pendingApprovals: pendingApprovals ?? this.pendingApprovals,
      memberShipFeesPaid: memberShipFeesPaid ?? this.memberShipFeesPaid,
      recentRenewedOn: recentRenewedOn ?? this.recentRenewedOn,
      pendingRenewals: pendingRenewals ?? this.pendingRenewals,
      enrolledGymOwnerName: enrolledGymOwnerName ?? this.enrolledGymOwnerName,
      enrolledGymOwnerUID: enrolledGymOwnerUID ?? this.enrolledGymOwnerUID,
      awaitingRenewal: awaitingRenewal ?? this.awaitingRenewal,
    );
  }
}
