// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pine_cone_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PineConeModelAdapter extends TypeAdapter<PineConeModel> {
  @override
  final int typeId = 0;

  @override
  PineConeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PineConeModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      speciesId: fields[2] as String?,
      commonName: fields[3] as String,
      scientificName: fields[4] as String?,
      photoUrls: (fields[5] as List).cast<String>(),
      latitude: fields[6] as double,
      longitude: fields[7] as double,
      locationName: fields[8] as String,
      city: fields[9] as String,
      country: fields[10] as String,
      countryCode: fields[11] as String,
      continent: fields[12] as String,
      collectedAt: fields[13] as DateTime,
      size: fields[14] as ConeSize,
      condition: fields[15] as ConeCondition,
      rarity: fields[16] as ConeRarity,
      habitat: fields[17] as String?,
      personalNotes: fields[18] as String?,
      tags: (fields[19] as List).cast<String>(),
      isPublic: fields[20] as bool,
      isAiIdentified: fields[21] as bool,
      aiConfidence: fields[22] as double?,
      createdAt: fields[23] as DateTime,
      updatedAt: fields[24] as DateTime,
      elevationMeters: fields[25] as double?,
      voiceNoteUrls: (fields[26] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, PineConeModel obj) {
    writer
      ..writeByte(27)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.speciesId)
      ..writeByte(3)
      ..write(obj.commonName)
      ..writeByte(4)
      ..write(obj.scientificName)
      ..writeByte(5)
      ..write(obj.photoUrls)
      ..writeByte(6)
      ..write(obj.latitude)
      ..writeByte(7)
      ..write(obj.longitude)
      ..writeByte(8)
      ..write(obj.locationName)
      ..writeByte(9)
      ..write(obj.city)
      ..writeByte(10)
      ..write(obj.country)
      ..writeByte(11)
      ..write(obj.countryCode)
      ..writeByte(12)
      ..write(obj.continent)
      ..writeByte(13)
      ..write(obj.collectedAt)
      ..writeByte(14)
      ..write(obj.size)
      ..writeByte(15)
      ..write(obj.condition)
      ..writeByte(16)
      ..write(obj.rarity)
      ..writeByte(17)
      ..write(obj.habitat)
      ..writeByte(18)
      ..write(obj.personalNotes)
      ..writeByte(19)
      ..write(obj.tags)
      ..writeByte(20)
      ..write(obj.isPublic)
      ..writeByte(21)
      ..write(obj.isAiIdentified)
      ..writeByte(22)
      ..write(obj.aiConfidence)
      ..writeByte(23)
      ..write(obj.createdAt)
      ..writeByte(24)
      ..write(obj.updatedAt)
      ..writeByte(25)
      ..write(obj.elevationMeters)
      ..writeByte(26)
      ..write(obj.voiceNoteUrls);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PineConeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ConeSizeAdapter extends TypeAdapter<ConeSize> {
  @override
  final int typeId = 10;

  @override
  ConeSize read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ConeSize.xs;
      case 1:
        return ConeSize.s;
      case 2:
        return ConeSize.m;
      case 3:
        return ConeSize.l;
      case 4:
        return ConeSize.xl;
      default:
        return ConeSize.xs;
    }
  }

  @override
  void write(BinaryWriter writer, ConeSize obj) {
    switch (obj) {
      case ConeSize.xs:
        writer.writeByte(0);
        break;
      case ConeSize.s:
        writer.writeByte(1);
        break;
      case ConeSize.m:
        writer.writeByte(2);
        break;
      case ConeSize.l:
        writer.writeByte(3);
        break;
      case ConeSize.xl:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConeSizeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ConeConditionAdapter extends TypeAdapter<ConeCondition> {
  @override
  final int typeId = 11;

  @override
  ConeCondition read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ConeCondition.pristine;
      case 1:
        return ConeCondition.good;
      case 2:
        return ConeCondition.worn;
      case 3:
        return ConeCondition.fragmented;
      default:
        return ConeCondition.pristine;
    }
  }

  @override
  void write(BinaryWriter writer, ConeCondition obj) {
    switch (obj) {
      case ConeCondition.pristine:
        writer.writeByte(0);
        break;
      case ConeCondition.good:
        writer.writeByte(1);
        break;
      case ConeCondition.worn:
        writer.writeByte(2);
        break;
      case ConeCondition.fragmented:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConeConditionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ConeRarityAdapter extends TypeAdapter<ConeRarity> {
  @override
  final int typeId = 12;

  @override
  ConeRarity read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ConeRarity.common;
      case 1:
        return ConeRarity.uncommon;
      case 2:
        return ConeRarity.rare;
      case 3:
        return ConeRarity.veryRare;
      case 4:
        return ConeRarity.legendary;
      default:
        return ConeRarity.common;
    }
  }

  @override
  void write(BinaryWriter writer, ConeRarity obj) {
    switch (obj) {
      case ConeRarity.common:
        writer.writeByte(0);
        break;
      case ConeRarity.uncommon:
        writer.writeByte(1);
        break;
      case ConeRarity.rare:
        writer.writeByte(2);
        break;
      case ConeRarity.veryRare:
        writer.writeByte(3);
        break;
      case ConeRarity.legendary:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConeRarityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ConeHabitatAdapter extends TypeAdapter<ConeHabitat> {
  @override
  final int typeId = 13;

  @override
  ConeHabitat read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ConeHabitat.forest;
      case 1:
        return ConeHabitat.park;
      case 2:
        return ConeHabitat.garden;
      case 3:
        return ConeHabitat.mountain;
      case 4:
        return ConeHabitat.coastal;
      case 5:
        return ConeHabitat.other;
      default:
        return ConeHabitat.forest;
    }
  }

  @override
  void write(BinaryWriter writer, ConeHabitat obj) {
    switch (obj) {
      case ConeHabitat.forest:
        writer.writeByte(0);
        break;
      case ConeHabitat.park:
        writer.writeByte(1);
        break;
      case ConeHabitat.garden:
        writer.writeByte(2);
        break;
      case ConeHabitat.mountain:
        writer.writeByte(3);
        break;
      case ConeHabitat.coastal:
        writer.writeByte(4);
        break;
      case ConeHabitat.other:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConeHabitatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
