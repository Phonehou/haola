// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'factor_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FactorRecordAdapter extends TypeAdapter<FactorRecord> {
  @override
  final int typeId = 5;

  @override
  FactorRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FactorRecord(
      date: fields[0] as DateTime,
      foodTypes: (fields[1] as List).cast<FoodType>(),
      waterIntake: fields[2] as double,
      exercise: fields[3] as ExerciseLevel,
      stressLevel: fields[4] as int,
      medications: (fields[5] as List).cast<Medication>(),
    );
  }

  @override
  void write(BinaryWriter writer, FactorRecord obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.foodTypes)
      ..writeByte(2)
      ..write(obj.waterIntake)
      ..writeByte(3)
      ..write(obj.exercise)
      ..writeByte(4)
      ..write(obj.stressLevel)
      ..writeByte(5)
      ..write(obj.medications);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FactorRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MedicationAdapter extends TypeAdapter<Medication> {
  @override
  final int typeId = 6;

  @override
  Medication read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Medication(
      name: fields[0] as String,
      dosage: fields[1] as double,
      time: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Medication obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.dosage)
      ..writeByte(2)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FoodTypeAdapter extends TypeAdapter<FoodType> {
  @override
  final int typeId = 3;

  @override
  FoodType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FoodType.highFiber;
      case 1:
        return FoodType.dairy;
      case 2:
        return FoodType.spicy;
      case 3:
        return FoodType.greasy;
      case 4:
        return FoodType.caffeine;
      default:
        return FoodType.highFiber;
    }
  }

  @override
  void write(BinaryWriter writer, FoodType obj) {
    switch (obj) {
      case FoodType.highFiber:
        writer.writeByte(0);
        break;
      case FoodType.dairy:
        writer.writeByte(1);
        break;
      case FoodType.spicy:
        writer.writeByte(2);
        break;
      case FoodType.greasy:
        writer.writeByte(3);
        break;
      case FoodType.caffeine:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExerciseLevelAdapter extends TypeAdapter<ExerciseLevel> {
  @override
  final int typeId = 4;

  @override
  ExerciseLevel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ExerciseLevel.sedentary;
      case 1:
        return ExerciseLevel.light;
      case 2:
        return ExerciseLevel.moderate;
      case 3:
        return ExerciseLevel.vigorous;
      default:
        return ExerciseLevel.sedentary;
    }
  }

  @override
  void write(BinaryWriter writer, ExerciseLevel obj) {
    switch (obj) {
      case ExerciseLevel.sedentary:
        writer.writeByte(0);
        break;
      case ExerciseLevel.light:
        writer.writeByte(1);
        break;
      case ExerciseLevel.moderate:
        writer.writeByte(2);
        break;
      case ExerciseLevel.vigorous:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
