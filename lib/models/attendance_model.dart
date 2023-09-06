// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_null_aware_operators
import 'dart:convert';

class AttendanceModel {
  String? userName;
  DateTime? scannedDateTime;
  AttendanceModel({
    this.userName,
    this.scannedDateTime,
  });

  AttendanceModel copyWith({
    String? userName,
    DateTime? scannedDateTime,
  }) {
    return AttendanceModel(
      userName: userName ?? this.userName,
      scannedDateTime: scannedDateTime ?? this.scannedDateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userName': userName,
      'scannedDateTime': scannedDateTime,
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      userName: map['userName'] != null ? map['userName'] as String : null,
      scannedDateTime: map['scannedDateTime'] != null
          ? map['scannedDateTime'].toDate()
          : null,
    );
  }

  // String toJson() => json.encode(toMap());

  factory AttendanceModel.fromJson(String source) =>
      AttendanceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'AttendanceModel(userName: $userName, scannedDateTime: $scannedDateTime)';

  @override
  bool operator ==(covariant AttendanceModel other) {
    if (identical(this, other)) return true;

    return other.userName == userName &&
        other.scannedDateTime == scannedDateTime;
  }

  @override
  int get hashCode => userName.hashCode ^ scannedDateTime.hashCode;

  String toJson() => json.encode(toMap());
}
