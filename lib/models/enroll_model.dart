// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

class EnrollModel {
  String? gymPartnerGYMName;
  String? gymPartnerName;
  // String? gymPartnerUID;
  String? UID;
  List? users;
  EnrollModel({
    this.gymPartnerGYMName,
    this.gymPartnerName,
    // this.gymPartnerUID,
    this.UID,
    this.users,
  });

  EnrollModel copyWith({
    String? gymPartnerGYMName,
    String? gymPartnerName,
    //String? gymPartnerUID,
    String? UID,
    List? users,
  }) {
    return EnrollModel(
      gymPartnerGYMName: gymPartnerGYMName ?? this.gymPartnerGYMName,
      gymPartnerName: gymPartnerName ?? this.gymPartnerName,
      // gymPartnerUID: gymPartnerUID ?? this.gymPartnerUID,
      UID: UID ?? this.UID,
      users: users ?? this.users,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'gymPartnerGYMName': gymPartnerGYMName,
      'gymPartnerName': gymPartnerName,
      // 'gymPartnerUID': gymPartnerUID,
      'UID': UID,
      'users': users,
    };
  }

  factory EnrollModel.fromMap(Map<String, dynamic> map) {
    return EnrollModel(
      gymPartnerGYMName: map['gymPartnerGYMName'] != null
          ? map['gymPartnerGYMName'] as String
          : null,
      gymPartnerName: map['gymPartnerName'] != null
          ? map['gymPartnerName'] as String
          : null,
      UID: map['UID'] != null ? map['UID'] as String : null,
      users: map['users'] != null ? map['users'] as List : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory EnrollModel.fromJson(String source) =>
      EnrollModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EnrollModel(gymPartnerGYMName: $gymPartnerGYMName, gymPartnerName: $gymPartnerName)';
  }

  @override
  bool operator ==(covariant EnrollModel other) {
    if (identical(this, other)) return true;

    return other.gymPartnerGYMName == gymPartnerGYMName &&
        other.gymPartnerName == gymPartnerName &&
        // other.gymPartnerUID == gymPartnerUID &&
        other.UID == UID &&
        other.users == users;
  }

  @override
  int get hashCode {
    return gymPartnerGYMName.hashCode ^
        gymPartnerName.hashCode ^
        // gymPartnerUID.hashCode ^
        UID.hashCode ^
        users.hashCode;
  }
}
