import '../models/bowel_record.dart';      // 数据模型 
import 'package:hive_flutter/hive_flutter.dart';

extension IterableNumberExtension on Iterable<num> {
  double average() {
    if (isEmpty) return 0;
    //return reduce((a, b) => a + b) / length; 
    return map((e) => e.toDouble()).reduce((a, b) => a + b) / length;
  }
}

class HealthScoreCalculator {
  static const Map<BristolType, int> typeScores = {
    BristolType.type4: 100,
    BristolType.type3: 90,
    BristolType.type5: 70,
    BristolType.type2: 60,
    BristolType.type6: 50,
    BristolType.type7: 40,
    BristolType.type1: 30,
  };

  static final Map<int, int> durationScores = {
    5: 100,   // 5分钟
    10: 80,   // 10分钟
    15: 60,   // 15分钟
    20: 40,   // 20分钟
  };

  static Map<DateTime, int> _groupByDay(List<BowelRecord> records) {
    final dailyCounts = <DateTime, int>{};
    for (final record in records) {
      final date = DateTime(
        record.dateTime.year,
        record.dateTime.month,
        record.dateTime.day,
      );
      dailyCounts[date] = (dailyCounts[date] ?? 0) + 1;
    }
    return dailyCounts;
  }

  static int calculateScore(List<BowelRecord> records) {
    if (records.isEmpty) return 0;
    final frequencyScore = _calculateFrequencyScore(records);
    final typeScore = _averageTypeScore(records);
    final durationScore = _averageDurationScore(records);
    
    return (frequencyScore * 0.4 + typeScore * 0.4 + durationScore * 0.2).toInt();
  }

  static double _calculateFrequencyScore(List<BowelRecord> records) {
    // 理想频率：每天1-2次
    final dailyCounts = _groupByDay(records);
    final validDays = dailyCounts.values.where((c) => c >=1 && c <=2).length;
    return (validDays / dailyCounts.length) * 100;
  }

  static double _averageTypeScore(List<BowelRecord> records) {
    return records.map((r) => typeScores[r.type] ?? 0).average();
  }

  static double _averageDurationScore(List<BowelRecord> records) {
    if(records.isEmpty) return 0.0;
    return records.map((r) {
      final minutes = r.duration.inMinutes;
      return durationScores.entries
        .firstWhere((e) => minutes <= e.key,
          orElse: () => MapEntry(20, 30)).value;
    }).average();
  }
}

List<String> generateHealthAdvice(int score, Map<String, double> correlations) {
  final advice = <String>[];
  
  if (score < 60) {
    advice.add("建议尽快咨询消化科医生");
  }
  
  if (correlations.containsKey("乳制品")) {
    advice.add("检测到乳制品可能引发不适，建议尝试无乳糖饮食");
  }
  
  final avgDuration = Hive.box<BowelRecord>('bowelRecords')
    .values.map((r) => r.duration.inMinutes).average();
  if (avgDuration > 15) {
    advice.add("如厕时间过长，建议增加膳食纤维摄入");
  }

  return advice;
}