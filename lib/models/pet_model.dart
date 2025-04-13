import 'package:hive/hive.dart';
part 'pet_model.g.dart';

@HiveType(typeId: 10)
class PetData extends HiveObject {
  @HiveField(0)
  int level;

  @HiveField(1)
  int experience;

  PetData({required this.level, required this.experience});

  void gainXP(int xp) {
    experience += xp;
    if (experience >= 100) {
      experience -= 100;
      level += 1;
    }
  }
}