// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// ignore_for_file: non_constant_identifier_names

class GymEnrollmentModel {
  String? gymPartnerGYMName;
  String? gymPartnerName;
  String? UID;
  GymEnrollmentModel({
    this.gymPartnerGYMName,
    this.gymPartnerName,
    this.UID,
  });

  GymEnrollmentModel copyWith({
    String? gymPartnerGYMName,
    String? gymPartnerName,
    String? UID,
  }) {
    return GymEnrollmentModel(
      gymPartnerGYMName: gymPartnerGYMName ?? this.gymPartnerGYMName,
      gymPartnerName: gymPartnerName ?? this.gymPartnerName,
      UID: UID ?? this.UID,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'gymPartnerGYMName': gymPartnerGYMName,
      'gymPartnerName': gymPartnerName,
      'UID': UID,
    };
  }

  factory GymEnrollmentModel.fromMap(Map<String, dynamic> map) {
    return GymEnrollmentModel(
      gymPartnerGYMName: map['gymPartnerGYMName'] != null
          ? map['gymPartnerGYMName'] as String
          : null,
      gymPartnerName: map['gymPartnerName'] != null
          ? map['gymPartnerName'] as String
          : null,
      UID: map['UID'] != null ? map['UID'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GymEnrollmentModel.fromJson(String source) =>
      GymEnrollmentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'GymEnrollmentModel(gymPartnerGYMName: $gymPartnerGYMName, gymPartnerName: $gymPartnerName, UID: $UID)';

  @override
  bool operator ==(covariant GymEnrollmentModel other) {
    if (identical(this, other)) return true;

    return other.gymPartnerGYMName == gymPartnerGYMName &&
        other.gymPartnerName == gymPartnerName &&
        other.UID == UID;
  }

  @override
  int get hashCode =>
      gymPartnerGYMName.hashCode ^ gymPartnerName.hashCode ^ UID.hashCode;
}
