// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      isAwaitingEnrollment: fields[13] as bool,
      pendingApprovals: (fields[14] as List?)?.cast<dynamic>(),
      phoneNumber: fields[12] as String?,
      userType: fields[0] as String,
      userName: fields[1] as String,
      uid: fields[2] as String?,
      profilephoto: fields[3] as String?,
      email: fields[4] as String,
      gender: fields[5] as String,
      DOB: fields[6] as String,
      isUser: fields[7] as bool,
      registeredDate: fields[8] as DateTime?,
      enrolledGym: fields[9] as String?,
      enrolledGymDate: fields[10] as DateTime?,
      membershipExpiry: fields[11] as DateTime?,
      memberShipFeesPaid: fields[15] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.userType)
      ..writeByte(1)
      ..write(obj.userName)
      ..writeByte(2)
      ..write(obj.uid)
      ..writeByte(3)
      ..write(obj.profilephoto)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.gender)
      ..writeByte(6)
      ..write(obj.DOB)
      ..writeByte(7)
      ..write(obj.isUser)
      ..writeByte(8)
      ..write(obj.registeredDate)
      ..writeByte(9)
      ..write(obj.enrolledGym)
      ..writeByte(10)
      ..write(obj.enrolledGymDate)
      ..writeByte(11)
      ..write(obj.membershipExpiry)
      ..writeByte(12)
      ..write(obj.phoneNumber)
      ..writeByte(13)
      ..write(obj.isAwaitingEnrollment)
      ..writeByte(14)
      ..write(obj.pendingApprovals)
      ..writeByte(15)
      ..write(obj.memberShipFeesPaid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
