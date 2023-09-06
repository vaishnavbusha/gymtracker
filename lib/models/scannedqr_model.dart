// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_null_aware_operators, prefer_if_null_operators
import 'dart:convert';

import 'package:intl/intl.dart';

class ScannedQRModel {
  String? uid;
  String? userName;
  DateTime? generatedOn;
  ScannedQRModel({
    this.uid,
    this.userName,
    this.generatedOn,
  });

  ScannedQRModel copyWith({
    String? uid,
    String? userName,
    DateTime? generatedOn,
  }) {
    return ScannedQRModel(
      uid: uid ?? this.uid,
      userName: userName ?? this.userName,
      generatedOn: generatedOn ?? this.generatedOn,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'userName': userName,
      'generatedOn': generatedOn,
    };
  }

  factory ScannedQRModel.fromMap(Map<String, dynamic> map) {
    return ScannedQRModel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      userName: map['userName'] != null ? map['userName'] as String : null,
      generatedOn: map['generatedOn'] != null
          ? DateFormat("yyyy-MM-dd hh:mm:ss").parse(map['generatedOn'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ScannedQRModel.fromJson(String source) =>
      ScannedQRModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ScannedQRModel(uid: $uid, userName: $userName, generatedOn: $generatedOn)';

  @override
  bool operator ==(covariant ScannedQRModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.userName == userName &&
        other.generatedOn == generatedOn;
  }

  @override
  int get hashCode => uid.hashCode ^ userName.hashCode ^ generatedOn.hashCode;
}
