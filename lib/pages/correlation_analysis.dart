import '../models/bowel_record.dart';      // 数据模型
import '../models/factor_record.dart';      
import 'dart:math';
import '../utils/model_utils.dart';

class CorrelationAnalysis {
  final List<BowelRecord> bowelRecords;
  final List<FactorRecord> factorRecords;

  CorrelationAnalysis(this.bowelRecords, this.factorRecords) {}

  Map<String, double> analyzeCorrelations() {
    final results = <String, double>{};
    
    // 饮食类型关联分析
    for (final foodType in FoodType.values) {
      final withFoodRecords = _getRecordsWithFood(foodType);
      final withoutFoodRecords = _getRecordsWithoutFood(foodType);
      
      if (withFoodRecords.isEmpty || withoutFoodRecords.isEmpty) continue;
      
      final p1 = _calculateAbnormalRate(withFoodRecords);
      final p2 = _calculateAbnormalRate(withoutFoodRecords);
      final n1 = withFoodRecords.length;
      final n2 = withoutFoodRecords.length;
      
      final pValue = _calculatePValue(p1, p2, n1, n2);
      
      if (pValue < 0.05) {
        final riskRatio = _calculateRiskRatio(p1, p2);
        results[ModelMapper.foodTypeToChinese(foodType)] = riskRatio;
      }
    }

    // 压力等级关联分析
    for (int level = 1; level <= 5; level++) {
      final relatedRecords = bowelRecords.where((r) {
        final factor = _getFactorRecord(r.dateTime);
        return factor?.stressLevel == level;
      }).toList();
      final abnormalRate = _calculateAbnormalRate(relatedRecords);
      if (abnormalRate > 0.3) { // 经验阈值
        results['压力等级$level'] = abnormalRate;
      }
    }

    return results;
  }
  // 新增风险比计算
  double _calculateRiskRatio(double exposedRate, double unexposedRate) {
    if (unexposedRate == 0) return double.infinity;
    return exposedRate / unexposedRate;
  }

  double _calculateAbnormalRate(List<BowelRecord> records) {
    final abnormalCount = records.where((r) => 
      r.type.index <= 1 || r.type.index >= 5).length;
    return abnormalCount / records.length;
  }

  List<BowelRecord> _getRecordsWithFood(FoodType type) {
    return bowelRecords.where((r) {
      final factor = _getFactorRecord(r.dateTime);
      return factor?.foodTypes.contains(type) ?? false;
    }).toList();
  }

  /// 获取没有某种食物类型的排便记录
  List<BowelRecord> _getRecordsWithoutFood(FoodType type) {
    return bowelRecords.where((r) {
      final factor = _getFactorRecord(r.dateTime);
      return factor != null && !factor.foodTypes.contains(type);
    }).toList();
  }

  /// 计算两个比例的p值（使用Z检验简化版）
  double _calculatePValue(double p1, double p2, int n1, int n2) {
    // 合并比例
    final pooledP = (p1 * n1 + p2 * n2) / (n1 + n2);
    // 标准误差
    final se = sqrt(pooledP * (1 - pooledP) * (1/n1 + 1/n2));
    // Z值计算
    final z = (p1 - p2) / se;
    // 使用正态分布计算双尾p值（简化计算）
    return 2 * (1 - _normalCDF(z.abs()));
  }

  /// 标准正态分布累积分布函数近似计算
  double _normalCDF(double z) {
    return 0.5 * (1 + erf(z / sqrt(2)));
  }

  /// 错误函数近似计算
  double erf(double x) {
    // 使用Abramowitz and Stegun近似公式
    final a1 =  0.254829592;
    final a2 = -0.284496736;
    final a3 =  1.421413741;
    final a4 = -1.453152027;
    final a5 =  1.061405429;
    final p  =  0.3275911;

    final t = 1.0 / (1.0 + p * x.abs());
    final y = 1.0 - (((((a5 * t + a4) * t) + a3) * t + a2) * t + a1) * t * exp(-x * x);
    
    return x < 0 ? -y : y;
  }

  /// 获取对应日期的关联因素记录
  FactorRecord? _getFactorRecord(DateTime bowelTime) {
    // 标准化为日期（忽略时间）
    final date = DateTime(bowelTime.year, bowelTime.month, bowelTime.day);
    
    // 创建日期映射加速查询
    final factorMap = <DateTime, FactorRecord>{};
    for (final factor in factorRecords) {
      final keyDate = DateTime(factor.date.year, factor.date.month, factor.date.day);
      factorMap[keyDate] = factor;
    }
    
    return factorMap[date] ?? FactorRecord(date: DateTime.now());
  }
}

