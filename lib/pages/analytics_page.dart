import 'package:flutter/material.dart';    // 基础组件库   
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:intl/intl.dart';
import 'health_score.dart';
import 'correlation_analysis.dart';
import '../models/bowel_record.dart';      
import '../models/factor_record.dart';  
import '../utils/model_utils.dart'; 

class WeeklyFrequency {
  final DateTime weekStart;
  final int count;

  WeeklyFrequency(this.weekStart, this.count);
}

class CombinedData {
  final double waterIntake;
  final Duration duration;
  final int stressLevel;       // 压力等级 1-5
  final ExerciseLevel exercise;// 运动强度
  final List<FoodType> foodTypes; // 饮食类型

  CombinedData({
    required this.waterIntake,
    required this.duration,
    required this.stressLevel,
    required this.exercise,
    required this.foodTypes,
  });
}

class BristolDistribution {
  final BristolType type;
  final int count;
  final HealthStatus healthStatus;

  BristolDistribution({
    required this.type,
    required this.count,
    required this.healthStatus,
  });
}

enum HealthStatus {
  normal(Colors.green, "正常"),
  warning(Colors.orange, "注意"),
  abnormal(Colors.red, "异常");

  final Color color;
  final String label;

  const HealthStatus(this.color, this.label);
}

HealthStatus _getHealthStatus(BristolType type) {
  // 基于国际胃肠病学会建议的分类标准
  switch (type) {
    case BristolType.type3:
    case BristolType.type4:
      return HealthStatus.normal;
    case BristolType.type2:
    case BristolType.type5:
      return HealthStatus.warning;
    case BristolType.type1:
    case BristolType.type6:
    case BristolType.type7:
      return HealthStatus.abnormal;
  }
}

// class AnalyticsPage extends StatefulWidget {
//   @override
//   _AnalyticsPageState createState() => _AnalyticsPageState();
// }

//class _AnalyticsPageState extends State<AnalyticsPage> {
class AnalyticsPage extends StatelessWidget {
    // 添加 Hive 监听器
  //late final Box<BowelRecord> _bowelBox;
  //late final Box<FactorRecord> _factorBox;

  // @override
  // void initState() {
  //   super.initState();
  //   _bowelBox = Hive.box<BowelRecord>('bowelRecords');
  //   _factorBox = Hive.box<FactorRecord>('factorRecords');
    
  //   // 注册监听器
  //   _bowelBox.listenable().addListener(_refresh);
  //   _factorBox.listenable().addListener(_refresh);
  // }

  //   @override
  // void dispose() {
  //   _bowelBox.listenable().removeListener(_refresh);
  //   _factorBox.listenable().removeListener(_refresh);
  //   super.dispose();
  // }

  // void _refresh() {
  //   if (mounted) setState(() {});
  // }
 @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<BowelRecord>('bowelRecords').listenable(),
      builder: (context, Box<BowelRecord> bowelBox, _) {
        return ValueListenableBuilder(
          valueListenable: Hive.box<FactorRecord>('factorRecords').listenable(),
          builder: (context, Box<FactorRecord> factorBox, _) {
            return _buildContent(bowelBox, factorBox);
          },
        );
      },
    );
  }

  @override
  //Widget build(BuildContext context) {
  Widget _buildContent(Box<BowelRecord> bowelBox, Box<FactorRecord> factorBox) {
    final bowelBox = Hive.box<BowelRecord>('bowelRecords');
    final factorBox = Hive.box<FactorRecord>('factorRecords');
    print("🔄 当前排便记录数量: ${bowelBox.length}");
    print("🔄 当前关联因素数量: ${factorBox.length}");
    // 添加空数据检查
    if (bowelBox.isEmpty || factorBox.isEmpty) {
      return Center(child: Text("暂无足够数据进行分析"));
    }

    final bowelRecords = bowelBox.values;
    final factorRecords = factorBox.values;
    print("🔄 执行:HealthScoreCalculator.calculateScore");
    final score = HealthScoreCalculator.calculateScore(bowelRecords.toList());
    final analysis = CorrelationAnalysis(
      bowelRecords.toList(),
      factorRecords.toList(),
    );
    final correlations = analysis.analyzeCorrelations();
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSummaryCard(bowelRecords),
          SizedBox(height: 20),
          _buildTypeChart(bowelRecords),
          SizedBox(height: 20),
          _buildHealthDashboard(score),
          SizedBox(height: 20),
          _buildCorrelationChart(bowelRecords, factorRecords),  
          SizedBox(height: 20),
          _buildAnalysisSuggestions(correlations),
          SizedBox(height: 20),
          _buildFrequencyChart(bowelRecords),
          SizedBox(height: 20),
          _buildBristolDistribution(bowelRecords),
        ],
      ),
    );
  }

  Widget _buildHealthDashboard(int score) {
    print("🔄 执行:_buildHealthDashboard");
    if (score <= 0) {
      return Center(child: Text("暂无有效评分"));
    }
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('当前肠道健康评分', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            Container(
              height: 200,
              child: SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                    minimum: 0,
                    maximum: 100,
                    ranges: [
                      GaugeRange(startValue: 0, endValue: 40, color: Colors.red),
                      GaugeRange(startValue: 40, endValue: 70, color: Colors.orange),
                      GaugeRange(startValue: 70, endValue: 100, color: Colors.green),
                    ],
                    pointers: [NeedlePointer(value: score.toDouble())],
annotations: [
                      GaugeAnnotation(
                        widget: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('$score', style: TextStyle(fontSize: 24)),
                            Text(_getHealthLevel(score)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(Iterable<BowelRecord> records) {
    print("🔄 执行:_buildSummaryCard");
    final weeklyCount = records.where((r) => 
      r.dateTime.isAfter(DateTime.now().subtract(Duration(days: 7)))
    ).length;
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("本周排便次数", style: TextStyle(fontSize: 18)),
            Text("$weeklyCount 次", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChart(Iterable<BowelRecord> records) {
    print("🔄 执行:_buildTypeChart");
    final dataMap = <BristolType, int>{};
    for (var type in BristolType.values) {
      dataMap[type] = records.where((r) => r.type == type).length;
    }

    final total = dataMap.values.fold(0, (a, b) => a + b);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("大便类型分布", style: TextStyle(fontSize: 18)),
            SizedBox(height: 300,
              child: PieChart(
                PieChartData(
                  sections: dataMap.entries.map((entry) {
                    final percent = total == 0 ? 0 : (entry.value / total * 100).toStringAsFixed(1);
                    return PieChartSectionData(
                      color: _getTypeColor(entry.key),
                      value: entry.value.toDouble(),
                      title: "${percent}%",
                      radius: 60,
                      titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    );
                  }).toList(),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCorrelationChart( Iterable<BowelRecord> bowelBox,
  Iterable<FactorRecord> factorBox) {
    print("🔄 执行:_buildCorrelationChart");
    //final bowelBox = Hive.box<BowelRecord>('bowelRecords');
    //final factorBox = Hive.box<FactorRecord>('factorRecords');
    final combinedData = _combineData(bowelBox, factorBox);

    final double minX = combinedData.map((e) => e.waterIntake).reduce((a, b) => a < b ? a : b) - 0.5;
    final double maxX = combinedData.map((e) => e.waterIntake).reduce((a, b) => a > b ? a : b) + 0.5;
    final double minY = combinedData.map((e) => e.duration.inMinutes.toDouble()).reduce((a, b) => a < b ? a : b) - 5;
    final double maxY = combinedData.map((e) => e.duration.inMinutes.toDouble()).reduce((a, b) => a > b ? a : b) + 5;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("水摄入量与排便时长关系图", style: TextStyle(fontSize: 18)),
            SizedBox(
              height: 300,
              child: ScatterChart(
                ScatterChartData(
                  scatterSpots: combinedData.map((data) => ScatterSpot(
                    data.waterIntake,
                    data.duration.inMinutes.toDouble(),
                  )).toList(),
                  scatterTouchData: ScatterTouchData(enabled: true),
                  minX: minX,
                  maxX: maxX,
                  minY: minY,
                  maxY: maxY,
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, interval: 1),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, interval: 10),
                    ),
                  ),
                  
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisSuggestions(Map<String, double> correlations) {
      print("🔄 执行:_buildAnalysisSuggestions");
    final suggestions = correlations.entries.map((e) {
      final factor = e.key;
      final rate = e.value;
      String suggestion;

      if (rate > 0.5) {
        suggestion = "⚠️ $factor与排便异常高度相关（相关性${(rate*100).toInt()}%），建议减少相关因素";
      } else if (rate > 0.3) {
        suggestion = "🔍 $factor可能影响肠道健康（相关性${(rate*100).toInt()}%），建议关注";
      } else {
        return Container();
      }
      
      return ListTile(
        leading: Icon(Icons.warning, color: Colors.orange),
        title: Text(suggestion),
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: suggestions.isEmpty 
        ? [Text("未检测到显著关联因素", style: TextStyle(color: Colors.grey))]
        : suggestions,
    );
  }

  Widget _buildFrequencyChart(Iterable<BowelRecord> records) {
      print("🔄 执行:_buildFrequencyChart");
    //final records = Hive.box<BowelRecord>('bowelRecords').values;
    final weeklyData = _groupByWeekFrequency(records);

    if (weeklyData.isEmpty) {
        return Center(child: Text("暂无频率数据"));
    }
    // 将日期转换为毫秒时间戳（double）
    final spots = weeklyData.map((data) {
      return FlSpot(
        data.weekStart.millisecondsSinceEpoch.toDouble(),
        data.count.toDouble(),
      );
    }).toList();

    // 坐标轴范围
    final minX = spots.map((e) => e.x).reduce((a, b) => a < b ? a : b);
    final maxX = spots.map((e) => e.x).reduce((a, b) => a > b ? a : b);
    final minY = 0.0;
    final maxY = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 1;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("每周排便次数趋势图", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  minX: minX,
                  maxX: maxX,
                  minY: minY,
                  maxY: maxY,
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: ((maxX - minX) / 4).ceilToDouble().clamp(1.0, double.infinity),
                        getTitlesWidget: (value, meta) {
                          final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                          final formatted = "${date.month}/${date.day}";
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(formatted, style: const TextStyle(fontSize: 10)),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) => SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(value.toInt().toString(), style: const TextStyle(fontSize: 10)),
                        ),
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBristolDistribution(Iterable<BowelRecord> records) {
    //final records = Hive.box<BowelRecord>('bowelRecords').values;
print("🔄 执行:_buildBristolDistribution");
    final typeCounts = BristolType.values.map((type) {
      return BristolDistribution(
        type: type,
        count: records.where((r) => r.type == type).length,
        healthStatus: _getHealthStatus(type),
      );
    }).toList();

    final maxCount = typeCounts.map((e) => e.count).fold(0, (a, b) => a > b ? a : b).toDouble();

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("布里斯托类型分布", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  barGroups: typeCounts.asMap().entries.map((entry) {
                    final index = entry.key;
                    final data = entry.value;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: data.count.toDouble(),
                          width: 20,
                          color: data.healthStatus.color,
                          borderRadius: BorderRadius.circular(4),
                        )
                      ],
                    );
                  }).toList(),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: const TextStyle(fontSize: 10)),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= typeCounts.length) return const SizedBox.shrink();
                          return Text(
                            ModelMapper.bristolToChinese(typeCounts[index].type),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                  maxY: maxCount + 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _getHealthLevel(int score) {
  if (score >= 90) return "健康";
  if (score >= 70) return "良好";
  if (score >= 50) return "注意";
  return "异常";
}

Color _getTypeColor(BristolType type) {
  const colors = [
    Colors.brown,    // type1
    Colors.orange,   // type2
    Colors.amber,    // type3
    Colors.green,    // type4
    Colors.lightGreen, // type5
    Colors.yellow,   // type6
    Colors.blue,     // type7
  ];
  return colors[type.index];
}

List<CombinedData> _combineData(
  Iterable<BowelRecord> bowelRecords,
  Iterable<FactorRecord> factorRecords,
) {
  // 创建日期到关联因素的映射
  final factorMap = <DateTime, FactorRecord>{};
  for (final factor in factorRecords) {
    final date = DateTime(factor.date.year, factor.date.month, factor.date.day);
    factorMap[date] = factor;
  }

  // 合并数据
  final combinedList = <CombinedData>[];
  for (final bowel in bowelRecords) {
    final bowelDate = DateTime(bowel.dateTime.year, bowel.dateTime.month, bowel.dateTime.day);
    final factor = factorMap[bowelDate];
    
    if (factor != null) {
      combinedList.add(CombinedData(
        waterIntake: factor.waterIntake,
        duration: bowel.duration,
        stressLevel: factor.stressLevel,
        exercise: factor.exercise,
        foodTypes: factor.foodTypes,
      ));
    }
  }
  
  return combinedList;
}

List<WeeklyFrequency> _groupByWeekFrequency(Iterable<BowelRecord> records) {
  final Map<String, int> weeklyCount = {};
  
  for (final record in records) {
    final weekKey = DateFormat('yyyy-ww').format(record.dateTime);
    weeklyCount[weekKey] = (weeklyCount[weekKey] ?? 0) + 1;
  }

  return weeklyCount.entries.map((e) {
    return WeeklyFrequency(
      DateFormat('yyyy-ww').parse(e.key),
      e.value,
    );
  }).toList()
    ..sort((a,b) => a.weekStart.compareTo(b.weekStart));
}
