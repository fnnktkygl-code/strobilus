// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocationModelAdapter extends TypeAdapter<LocationModel> {
  @override
  final int typeId = 2;

  @override
  LocationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocationModel(
      latitude: fields[0] as double,
      longitude: fields[1] as double,
      locationName: fields[2] as String,
      city: fields[3] as String,
      country: fields[4] as String,
      countryCode: fields[5] as String,
      continent: fields[6] as String,
      elevation: fields[7] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, LocationModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.latitude)
      ..writeByte(1)
      ..write(obj.longitude)
      ..writeByte(2)
      ..write(obj.locationName)
      ..writeByte(3)
      ..write(obj.city)
      ..writeByte(4)
      ..write(obj.country)
      ..writeByte(5)
      ..write(obj.countryCode)
      ..writeByte(6)
      ..write(obj.continent)
      ..writeByte(7)
      ..write(obj.elevation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
