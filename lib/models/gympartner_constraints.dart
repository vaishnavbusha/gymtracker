// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class GymPartnerConstraints {
  int? maxAttendanceByDateInCurrentMonthCount;
  int? maxMonthlyAttendanceCount;
  int? currAttendanceByDateInCurrentMonthCount;
  int? currMonthlyAttendanceCount;
  bool? isPlanStartDateEnabled;
  bool? isDataAccessible;
  bool? isQRcodeAccessible;
  bool? isViewUsersAccessible;
  bool? isAddUserManuallyAccessible;
  bool? isMarkAttendanceManuallyAccessible;
  bool? isSearchUserAccessible;
  bool? isExpiredUsersAccessible;
  bool? isTodaysAttendanceAccessible;
  bool? isDateWiseAttendanceAccessible;
  bool? isMonthWiseAttendanceAccessible;
  bool? isRenewUsersAccessible;

  GymPartnerConstraints({
    this.maxAttendanceByDateInCurrentMonthCount,
    this.maxMonthlyAttendanceCount,
    this.currAttendanceByDateInCurrentMonthCount,
    this.currMonthlyAttendanceCount,
    this.isPlanStartDateEnabled,
    this.isDataAccessible,
    this.isQRcodeAccessible,
    this.isViewUsersAccessible,
    this.isAddUserManuallyAccessible,
    this.isMarkAttendanceManuallyAccessible,
    this.isSearchUserAccessible,
    this.isExpiredUsersAccessible,
    this.isTodaysAttendanceAccessible,
    this.isDateWiseAttendanceAccessible,
    this.isMonthWiseAttendanceAccessible,
    this.isRenewUsersAccessible,
  });

  GymPartnerConstraints copyWith({
    int? maxAttendanceByDateInCurrentMonthCount,
    int? maxMonthlyAttendanceCount,
    int? currAttendanceByDateInCurrentMonthCount,
    int? currMonthlyAttendanceCount,
    bool? isPlanStartDateEnabled,
    bool? isDataAccessible,
    bool? isQRcodeAccessible,
    bool? isViewUsersAccessible,
    bool? isAddUserManuallyAccessible,
    bool? isMarkAttendanceManuallyAccessible,
    bool? isSearchUserAccessible,
    bool? isExpiredUsersAccessible,
    bool? isTodaysAttendanceAccessible,
    bool? isDateWiseAttendanceAccessible,
    bool? isMonthWiseAttendanceAccessible,
    bool? isRenewUsersAccessible,
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
      isPlanStartDateEnabled:
          isPlanStartDateEnabled ?? this.isPlanStartDateEnabled,
      isDataAccessible: isDataAccessible ?? this.isDataAccessible,
      isQRcodeAccessible: isQRcodeAccessible ?? this.isQRcodeAccessible,
      isViewUsersAccessible:
          isViewUsersAccessible ?? this.isViewUsersAccessible,
      isAddUserManuallyAccessible:
          isAddUserManuallyAccessible ?? this.isAddUserManuallyAccessible,
      isMarkAttendanceManuallyAccessible: isMarkAttendanceManuallyAccessible ??
          this.isMarkAttendanceManuallyAccessible,
      isSearchUserAccessible:
          isSearchUserAccessible ?? this.isSearchUserAccessible,
      isExpiredUsersAccessible:
          isExpiredUsersAccessible ?? this.isExpiredUsersAccessible,
      isTodaysAttendanceAccessible:
          isTodaysAttendanceAccessible ?? this.isTodaysAttendanceAccessible,
      isDateWiseAttendanceAccessible:
          isDateWiseAttendanceAccessible ?? this.isDateWiseAttendanceAccessible,
      isMonthWiseAttendanceAccessible: isMonthWiseAttendanceAccessible ??
          this.isMonthWiseAttendanceAccessible,
      isRenewUsersAccessible:
          isRenewUsersAccessible ?? this.isRenewUsersAccessible,
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
      'isPlanStartDateEnabled': isPlanStartDateEnabled,
      'isDataAccessible': isDataAccessible,
      'isQRcodeAccessible': isQRcodeAccessible,
      'isViewUsersAccessible': isViewUsersAccessible,
      'isAddUserManuallyAccessible': isAddUserManuallyAccessible,
      'isMarkAttendanceManuallyAccessible': isMarkAttendanceManuallyAccessible,
      'isSearchUserAccessible': isSearchUserAccessible,
      'isExpiredUsersAccessible': isExpiredUsersAccessible,
      'isTodaysAttendanceAccessible': isTodaysAttendanceAccessible,
      'isDateWiseAttendanceAccessible': isDateWiseAttendanceAccessible,
      'isMonthWiseAttendanceAccessible': isMonthWiseAttendanceAccessible,
      'isRenewUsersAccessible': isRenewUsersAccessible,
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
      isPlanStartDateEnabled: map['isPlanStartDateEnabled'] != null
          ? map['isPlanStartDateEnabled'] as bool
          : null,
      isDataAccessible: map['isDataAccessible'] != null
          ? map['isDataAccessible'] as bool
          : null,
      isQRcodeAccessible: map['isQRcodeAccessible'] != null
          ? map['isQRcodeAccessible'] as bool
          : null,
      isViewUsersAccessible: map['isViewUsersAccessible'] != null
          ? map['isViewUsersAccessible'] as bool
          : null,
      isAddUserManuallyAccessible: map['isAddUserManuallyAccessible'] != null
          ? map['isAddUserManuallyAccessible'] as bool
          : null,
      isMarkAttendanceManuallyAccessible:
          map['isMarkAttendanceManuallyAccessible'] != null
              ? map['isMarkAttendanceManuallyAccessible'] as bool
              : null,
      isSearchUserAccessible: map['isSearchUserAccessible'] != null
          ? map['isSearchUserAccessible'] as bool
          : null,
      isExpiredUsersAccessible: map['isExpiredUsersAccessible'] != null
          ? map['isExpiredUsersAccessible'] as bool
          : null,
      isTodaysAttendanceAccessible: map['isTodaysAttendanceAccessible'] != null
          ? map['isTodaysAttendanceAccessible'] as bool
          : null,
      isDateWiseAttendanceAccessible:
          map['isDateWiseAttendanceAccessible'] != null
              ? map['isDateWiseAttendanceAccessible'] as bool
              : null,
      isMonthWiseAttendanceAccessible:
          map['isMonthWiseAttendanceAccessible'] != null
              ? map['isMonthWiseAttendanceAccessible'] as bool
              : null,
      isRenewUsersAccessible: map['isRenewUsersAccessible'] != null
          ? map['isRenewUsersAccessible'] as bool
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GymPartnerConstraints.fromJson(String source) =>
      GymPartnerConstraints.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GymPartnerConstraints(maxAttendanceByDateInCurrentMonthCount: $maxAttendanceByDateInCurrentMonthCount, maxMonthlyAttendanceCount: $maxMonthlyAttendanceCount, currAttendanceByDateInCurrentMonthCount: $currAttendanceByDateInCurrentMonthCount, currMonthlyAttendanceCount: $currMonthlyAttendanceCount, isPlanStartDateEnabled: $isPlanStartDateEnabled, isDataAccessible: $isDataAccessible, isQRcodeAccessible: $isQRcodeAccessible, isViewUsersAccessible: $isViewUsersAccessible, isAddUserManuallyAccessible: $isAddUserManuallyAccessible, isMarkAttendanceManuallyAccessible: $isMarkAttendanceManuallyAccessible, isSearchUserAccessible: $isSearchUserAccessible, isExpiredUsersAccessible: $isExpiredUsersAccessible, isTodaysAttendanceAccessible: $isTodaysAttendanceAccessible, isDateWiseAttendanceAccessible: $isDateWiseAttendanceAccessible, isMonthWiseAttendanceAccessible: $isMonthWiseAttendanceAccessible, isRenewUsersAccessible: $isRenewUsersAccessible)';
  }

  @override
  bool operator ==(covariant GymPartnerConstraints other) {
    if (identical(this, other)) return true;

    return other.maxAttendanceByDateInCurrentMonthCount ==
            maxAttendanceByDateInCurrentMonthCount &&
        other.maxMonthlyAttendanceCount == maxMonthlyAttendanceCount &&
        other.currAttendanceByDateInCurrentMonthCount ==
            currAttendanceByDateInCurrentMonthCount &&
        other.currMonthlyAttendanceCount == currMonthlyAttendanceCount &&
        other.isPlanStartDateEnabled == isPlanStartDateEnabled &&
        other.isDataAccessible == isDataAccessible &&
        other.isQRcodeAccessible == isQRcodeAccessible &&
        other.isViewUsersAccessible == isViewUsersAccessible &&
        other.isAddUserManuallyAccessible == isAddUserManuallyAccessible &&
        other.isMarkAttendanceManuallyAccessible ==
            isMarkAttendanceManuallyAccessible &&
        other.isSearchUserAccessible == isSearchUserAccessible &&
        other.isExpiredUsersAccessible == isExpiredUsersAccessible &&
        other.isTodaysAttendanceAccessible == isTodaysAttendanceAccessible &&
        other.isDateWiseAttendanceAccessible ==
            isDateWiseAttendanceAccessible &&
        other.isMonthWiseAttendanceAccessible ==
            isMonthWiseAttendanceAccessible &&
        other.isRenewUsersAccessible == isRenewUsersAccessible;
  }

  @override
  int get hashCode {
    return maxAttendanceByDateInCurrentMonthCount.hashCode ^
        maxMonthlyAttendanceCount.hashCode ^
        currAttendanceByDateInCurrentMonthCount.hashCode ^
        currMonthlyAttendanceCount.hashCode ^
        isPlanStartDateEnabled.hashCode ^
        isDataAccessible.hashCode ^
        isQRcodeAccessible.hashCode ^
        isViewUsersAccessible.hashCode ^
        isAddUserManuallyAccessible.hashCode ^
        isMarkAttendanceManuallyAccessible.hashCode ^
        isSearchUserAccessible.hashCode ^
        isExpiredUsersAccessible.hashCode ^
        isTodaysAttendanceAccessible.hashCode ^
        isDateWiseAttendanceAccessible.hashCode ^
        isMonthWiseAttendanceAccessible.hashCode ^
        isRenewUsersAccessible.hashCode;
  }
}
