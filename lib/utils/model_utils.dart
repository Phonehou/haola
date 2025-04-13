import '../models/bowel_record.dart';      
import '../models/factor_record.dart';   
// 模型映射工具类
class ModelMapper {
  // 布里斯托大便类型转中文
  static String bristolToChinese(BristolType type) {
    switch (type) {
      case BristolType.type1: return "坚果状";
      case BristolType.type2: return "块状";
      case BristolType.type3: return "裂痕状";
      case BristolType.type4: return "光滑蛇形";
      case BristolType.type5: return "软块状";
      case BristolType.type6: return "糊状";
      case BristolType.type7: return "水样";
      default: throw ArgumentError("无效的大便类型");
    }
  }

  // 食物类型转中文（带图标前缀）
  static String foodTypeToChinese(FoodType type) {
    switch (type) {
      case FoodType.highFiber: return "🌾 高纤维";
      case FoodType.dairy: return "🥛 乳制品";
      case FoodType.spicy: return "🌶 辛辣食物";
      case FoodType.greasy: return "🍟 油腻食物";
      case FoodType.caffeine: return "☕ 含咖啡因";
      default: throw ArgumentError("无效的食物类型");
    }
  }

  // 运动强度转中文（带代谢当量说明）
  static String exerciseLevelToChinese(ExerciseLevel level) {
    switch (level) {
      case ExerciseLevel.sedentary: return "久坐（<1.5 METs）";
      case ExerciseLevel.light: return "轻度运动（1.5-3 METs）";
      case ExerciseLevel.moderate: return "中度运动（3-6 METs）";
      case ExerciseLevel.vigorous: return "剧烈运动（>6 METs）";
      default: throw ArgumentError("无效的运动强度等级");
    }
  }
}