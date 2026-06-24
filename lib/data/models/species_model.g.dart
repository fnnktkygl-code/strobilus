// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'species_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SpeciesModelAdapter extends TypeAdapter<SpeciesModel> {
  @override
  final int typeId = 1;

  @override
  SpeciesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SpeciesModel(
      id: fields[0] as String,
      scientificName: fields[1] as String,
      commonNames: (fields[2] as Map).cast<String, String>(),
      family: fields[3] as String,
      genus: fields[4] as String,
      nativeCountryCodes: (fields[5] as List).cast<String>(),
      continents: (fields[6] as List).cast<String>(),
      description: fields[7] as String,
      sizeRange: fields[8] as String,
      colorDescription: fields[9] as String,
      shapeDescription: fields[10] as String,
      habitat: fields[11] as String,
      baseRarity: fields[12] as String,
      imageUrls: (fields[13] as List).cast<String>(),
      interestingFacts: (fields[14] as List).cast<String>(),
      wikipediaSlug: fields[15] as String?,
      updatedAt: fields[16] as DateTime,
      descriptionFr: fields[17] as String?,
      sizeRangeFr: fields[18] as String?,
      colorDescriptionFr: fields[19] as String?,
      shapeDescriptionFr: fields[20] as String?,
      habitatFr: fields[21] as String?,
      interestingFactsFr: (fields[22] as List?)?.cast<String>(),
      subgenus: fields[23] as String?,
      section: fields[24] as String?,
      subsection: fields[25] as String?,
      coneLengthMinCm: fields[26] as double?,
      coneLengthMaxCm: fields[27] as double?,
      coneWeightMaxKg: fields[28] as double?,
      coneShape: fields[29] as String?,
      umboPosition: fields[30] as String?,
      hasMucro: fields[31] as bool?,
      apophysisShape: fields[32] as String?,
      isSerotinous: fields[33] as bool?,
      needlesPerFascicle: fields[34] as int?,
      seedType: fields[35] as String?,
      nativeBoundingBoxes: (fields[36] as List?)
          ?.map((dynamic e) => (e as Map).cast<String, double>())
          ?.toList(),
      introducedCountryCodes: (fields[41] as List?)?.cast<String>(),
      isIntroducedOrnamental: fields[37] as bool?,
      conservationStatus: fields[38] as String?,
      pokedexNumber: fields[39] as int?,
      discoveryDifficulty: fields[40] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, SpeciesModel obj) {
    writer
      ..writeByte(42)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.scientificName)
      ..writeByte(2)
      ..write(obj.commonNames)
      ..writeByte(3)
      ..write(obj.family)
      ..writeByte(4)
      ..write(obj.genus)
      ..writeByte(5)
      ..write(obj.nativeCountryCodes)
      ..writeByte(41)
      ..write(obj.introducedCountryCodes)
      ..writeByte(6)
      ..write(obj.continents)
      ..writeByte(7)
      ..write(obj.description)
      ..writeByte(8)
      ..write(obj.sizeRange)
      ..writeByte(9)
      ..write(obj.colorDescription)
      ..writeByte(10)
      ..write(obj.shapeDescription)
      ..writeByte(11)
      ..write(obj.habitat)
      ..writeByte(12)
      ..write(obj.baseRarity)
      ..writeByte(13)
      ..write(obj.imageUrls)
      ..writeByte(14)
      ..write(obj.interestingFacts)
      ..writeByte(15)
      ..write(obj.wikipediaSlug)
      ..writeByte(16)
      ..write(obj.updatedAt)
      ..writeByte(17)
      ..write(obj.descriptionFr)
      ..writeByte(18)
      ..write(obj.sizeRangeFr)
      ..writeByte(19)
      ..write(obj.colorDescriptionFr)
      ..writeByte(20)
      ..write(obj.shapeDescriptionFr)
      ..writeByte(21)
      ..write(obj.habitatFr)
      ..writeByte(22)
      ..write(obj.interestingFactsFr)
      ..writeByte(23)
      ..write(obj.subgenus)
      ..writeByte(24)
      ..write(obj.section)
      ..writeByte(25)
      ..write(obj.subsection)
      ..writeByte(26)
      ..write(obj.coneLengthMinCm)
      ..writeByte(27)
      ..write(obj.coneLengthMaxCm)
      ..writeByte(28)
      ..write(obj.coneWeightMaxKg)
      ..writeByte(29)
      ..write(obj.coneShape)
      ..writeByte(30)
      ..write(obj.umboPosition)
      ..writeByte(31)
      ..write(obj.hasMucro)
      ..writeByte(32)
      ..write(obj.apophysisShape)
      ..writeByte(33)
      ..write(obj.isSerotinous)
      ..writeByte(34)
      ..write(obj.needlesPerFascicle)
      ..writeByte(35)
      ..write(obj.seedType)
      ..writeByte(36)
      ..write(obj.nativeBoundingBoxes)
      ..writeByte(37)
      ..write(obj.isIntroducedOrnamental)
      ..writeByte(38)
      ..write(obj.conservationStatus)
      ..writeByte(39)
      ..write(obj.pokedexNumber)
      ..writeByte(40)
      ..write(obj.discoveryDifficulty);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpeciesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
