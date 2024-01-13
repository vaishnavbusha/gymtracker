// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_null_aware_operators
import 'dart:convert';

class AttendanceDisplayModel {
  int? index;
  String? uid;
  String? userName;
  DateTime? scannedDateTime;
  DateTime? exitScannedDateTime;

  AttendanceDisplayModel({
    this.index,
    this.uid,
    this.userName,
    this.scannedDateTime,
    this.exitScannedDateTime,
  });

  AttendanceDisplayModel copyWith({
    int? index,
    String? uid,
    String? userName,
    DateTime? scannedDateTime,
    DateTime? exitScannedDateTime,
  }) {
    return AttendanceDisplayModel(
      index: index ?? this.index,
      uid: uid ?? this.uid,
      userName: userName ?? this.userName,
      scannedDateTime: scannedDateTime ?? this.scannedDateTime,
      exitScannedDateTime: exitScannedDateTime ?? this.exitScannedDateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'index': index,
      'uid': uid,
      'userName': userName,
      'scannedDateTime': scannedDateTime,
      'exitScannedDateTime': exitScannedDateTime,
    };
  }

  factory AttendanceDisplayModel.fromMap(Map<String, dynamic> map) {
    return AttendanceDisplayModel(
      index: map['index'] != null ? map['index'] as int : null,
      uid: map['uid'] != null ? map['uid'] as String : null,
      userName: map['userName'] != null ? map['userName'] as String : null,
      scannedDateTime: map['scannedDateTime'] != null
          ? map['scannedDateTime'].toDate()
          : null,
      exitScannedDateTime: map['exitScannedDateTime'] != null
          ? map['exitScannedDateTime'].toDate()
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AttendanceDisplayModel.fromJson(String source) =>
      AttendanceDisplayModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AttendanceDisplayModel(index: $index, uid: $uid, userName: $userName, scannedDateTime: $scannedDateTime, exitScannedDateTime: $exitScannedDateTime)';
  }

  @override
  bool operator ==(covariant AttendanceDisplayModel other) {
    if (identical(this, other)) return true;

    return other.index == index &&
        other.uid == uid &&
        other.userName == userName &&
        other.scannedDateTime == scannedDateTime &&
        other.exitScannedDateTime == exitScannedDateTime;
  }

  @override
  int get hashCode {
    return index.hashCode ^
        uid.hashCode ^
        userName.hashCode ^
        scannedDateTime.hashCode ^
        exitScannedDateTime.hashCode;
  }
}
