import 'package:hive/hive.dart';

part 'factor_record.g.dart';

@HiveType(typeId: 3)
enum FoodType {
  @HiveField(0) highFiber,  // 高纤维
  @HiveField(1) dairy,       // 乳制品
  @HiveField(2) spicy,       // 辛辣
  @HiveField(3) greasy,      // 油腻
  @HiveField(4) caffeine     // 咖啡因
}

@HiveType(typeId: 4)
enum ExerciseLevel {
  @HiveField(0) sedentary,   // 久坐
  @HiveField(1) light,       // 轻度
  @HiveField(2) moderate,    // 中度
  @HiveField(3) vigorous     // 剧烈
}

@HiveType(typeId: 5)
class FactorRecord {
  @HiveField(0)
  DateTime date;
  
  @HiveField(1)
  List<FoodType> foodTypes;
  
  @HiveField(2)
  double waterIntake; // 单位：升
  
  @HiveField(3)
  ExerciseLevel exercise;
  
  @HiveField(4)
  int stressLevel; // 压力等级 1-5
  
  @HiveField(5)
  List<Medication> medications;

  FactorRecord({
    required this.date,
    this.foodTypes = const [],
    this.waterIntake = 0,
    this.exercise = ExerciseLevel.sedentary,
    this.stressLevel = 1,
    this.medications = const [],
  });
}

@HiveType(typeId: 6)
class Medication {
  @HiveField(0)
  String name;
  
  @HiveField(1)
  double dosage; // 剂量
  
  @HiveField(2)
  DateTime time;

  Medication({
    required this.name,
    required this.dosage,
    required this.time,
  });
}