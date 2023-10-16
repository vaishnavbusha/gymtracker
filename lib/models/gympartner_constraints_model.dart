// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class GymPartnerConstraints {
  int? maxAttendanceByDateInCurrentMonthCount;
  int? maxMonthlyAttendanceCount;
  int? currAttendanceByDateInCurrentMonthCount;
  int? currMonthlyAttendanceCount;
  GymPartnerConstraints({
    this.maxAttendanceByDateInCurrentMonthCount,
    this.maxMonthlyAttendanceCount,
    this.currAttendanceByDateInCurrentMonthCount,
    this.currMonthlyAttendanceCount,
  });

  GymPartnerConstraints copyWith({
    int? maxAttendanceByDateInCurrentMonthCount,
    int? maxMonthlyAttendanceCount,
    int? currAttendanceByDateInCurrentMonthCount,
    int? currMonthlyAttendanceCount,
  }) {
    return GymPartnerConstraints(
      maxAttendanceByDateInCurrentMonthCount:
          maxAttendanceByDateInCurrentMonthCount ??
              this.maxAttendanceByDateInCurrentMonthCount,
      maxMonthlyAttendanceCount:
          maxMonthlyAttendanceCount ?? this.maxMonthlyAttendanceCount,
      currAttendanceByDateInCurrentMonthCount:
          currAttendanceByDateInCurrentMonthCount ??
              this.currAttendanceByDateInCurrentMonthCount,
      currMonthlyAttendanceCount:
          currMonthlyAttendanceCount ?? this.currMonthlyAttendanceCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'maxAttendanceByDateInCurrentMonthCount':
          maxAttendanceByDateInCurrentMonthCount,
      'maxMonthlyAttendanceCount': maxMonthlyAttendanceCount,
      'currAttendanceByDateInCurrentMonthCount':
          currAttendanceByDateInCurrentMonthCount,
      'currMonthlyAttendanceCount': currMonthlyAttendanceCount,
    };
  }

  factory GymPartnerConstraints.fromMap(Map<String, dynamic> map) {
    return GymPartnerConstraints(
      maxAttendanceByDateInCurrentMonthCount:
          map['maxAttendanceByDateInCurrentMonthCount'] != null
              ? map['maxAttendanceByDateInCurrentMonthCount'] as int
              : null,
      maxMonthlyAttendanceCount: map['maxMonthlyAttendanceCount'] != null
          ? map['maxMonthlyAttendanceCount'] as int
          : null,
      currAttendanceByDateInCurrentMonthCount:
          map['currAttendanceByDateInCurrentMonthCount'] != null
              ? map['currAttendanceByDateInCurrentMonthCount'] as int
              : null,
      currMonthlyAttendanceCount: map['currMonthlyAttendanceCount'] != null
          ? map['currMonthlyAttendanceCount'] as int
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GymPartnerConstraints.fromJson(String source) =>
      GymPartnerConstraints.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GymPartnerConstraints(maxAttendanceByDateInCurrentMonthCount: $maxAttendanceByDateInCurrentMonthCount, maxMonthlyAttendanceCount: $maxMonthlyAttendanceCount, currAttendanceByDateInCurrentMonthCount: $currAttendanceByDateInCurrentMonthCount, currMonthlyAttendanceCount: $currMonthlyAttendanceCount)';
  }
}
