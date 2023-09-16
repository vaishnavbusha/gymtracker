// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_null_aware_operators
import 'dart:convert';

class AttendanceModel {
  String? userName;
  DateTime? scannedDateTime;
  DateTime? exitScannedDateTime;
  AttendanceModel({
    this.userName,
    this.scannedDateTime,
    this.exitScannedDateTime,
  });

  AttendanceModel copyWith({
    String? userName,
    DateTime? scannedDateTime,
    DateTime? exitScannedDateTime,
  }) {
    return AttendanceModel(
      userName: userName ?? this.userName,
      scannedDateTime: scannedDateTime ?? this.scannedDateTime,
      exitScannedDateTime: exitScannedDateTime ?? this.exitScannedDateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userName': userName,
      'scannedDateTime': scannedDateTime,
      'exitScannedDateTime': exitScannedDateTime,
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      userName: map['userName'] != null ? map['userName'] as String : null,
      scannedDateTime: map['scannedDateTime'] != null
          ? map['scannedDateTime'].toDate()
          : null,
      exitScannedDateTime: map['exitScannedDateTime'] != null
          ? map['exitScannedDateTime'].toDate()
          : null,
    );
  }

  // String toJson() => json.encode(toMap());

  factory AttendanceModel.fromJson(String source) =>
      AttendanceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'AttendanceModel(userName: $userName, scannedDateTime: $scannedDateTime, exitScannedDateTime: $exitScannedDateTime)';

  @override
  bool operator ==(covariant AttendanceModel other) {
    if (identical(this, other)) return true;

    return other.userName == userName &&
        other.scannedDateTime == scannedDateTime &&
        other.exitScannedDateTime == exitScannedDateTime;
  }

  @override
  int get hashCode =>
      userName.hashCode ^
      scannedDateTime.hashCode ^
      exitScannedDateTime.hashCode;

  String toJson() => json.encode(toMap());
}
