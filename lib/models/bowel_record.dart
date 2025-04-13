import 'package:hive/hive.dart';

part 'bowel_record.g.dart'; // 生成文件

@HiveType(typeId: 0)
enum BristolType {
  @HiveField(0)
  type1, // 坚果状
  @HiveField(1)
  type2, // 块状
  @HiveField(2)
  type3, // 裂痕状
  @HiveField(3)
  type4, // 光滑蛇形
  @HiveField(4)
  type5, // 软块状
  @HiveField(5)
  type6, // 糊状
  @HiveField(6)
  type7, // 水样
}

@HiveType(typeId: 1)
enum PostFeeling {
  @HiveField(0)
  relaxed,
  @HiveField(1)
  bloated,
  @HiveField(2)
  incomplete,
  @HiveField(3)
  pain,
}

@HiveType(typeId: 2)
class BowelRecord {
  @HiveField(0)
  DateTime dateTime;

  @HiveField(1)
  Duration duration;

  @HiveField(2)
  BristolType type;

  @HiveField(3)
  bool isStraining;

  @HiveField(4)
  bool hasBlood;

  @HiveField(5)
  bool hasMucus;

  @HiveField(6)
  PostFeeling? feeling;

  @HiveField(7)
  String? notes;

  BowelRecord({
    required this.dateTime,
    required this.duration,
    required this.type,
    required this.isStraining,
    this.hasBlood = false,
    this.hasMucus = false,
    this.feeling,
    this.notes,
  });
}