// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ourUser.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OurUserDetailOriginal extends TypeAdapter<OurUser> {
  @override
  final int typeId = 123;

  @override
  OurUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OurUser(
      uid: fields[1] as String?,
      name: fields[0] as String?,
      email: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OurUser obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.uid)
      ..writeByte(2)
      ..write(obj.email);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OurUserDetailOriginal &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
