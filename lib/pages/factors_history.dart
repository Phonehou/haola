import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/factor_record.dart';
import 'package:intl/intl.dart';
import '../utils/model_utils.dart';

class FactorsHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("历史记录")),
      body: ValueListenableBuilder<Box<FactorRecord>>(
        valueListenable: Hive.box<FactorRecord>('factorRecords').listenable(),
        builder: (context, box, _) {
          final records = box.values.toList().cast<FactorRecord>();
          records.sort((a,b) => b.date.compareTo(a.date));
          
          return ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              return ListTile(
                title: Text(DateFormat('yyyy-MM-dd').format(record.date)),
                subtitle: Text("饮水量: ${record.waterIntake}L  压力: ${record.stressLevel}"),
                onTap: () => _showDetail(context, record),
              );
            },
          );
        },
      ),
    );
  }
  // 在 FactorsHistoryPage 类中添加以下方法
  void _showDetail(BuildContext context, FactorRecord record) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final timeFormat = DateFormat('HH:mm');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("详细记录 - ${dateFormat.format(record.date)}"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailItem(
                "饮食类型", 
                (record.foodTypes.map(ModelMapper.foodTypeToChinese).join(", "))
              ),
              _buildDetailItem("饮水量", "${record.waterIntake} 升"),
              _buildDetailItem("运动强度", ModelMapper.exerciseLevelToChinese(record.exercise)),
              _buildDetailItem("压力等级", "${record.stressLevel} 级"),
              Divider(),
              Text("药物/补剂记录:", style: TextStyle(fontWeight: FontWeight.bold)),
              if (record.medications.isEmpty)
                Text("无记录", style: TextStyle(color: Colors.grey)),
              ...record.medications.map((med) => ListTile(
                title: Text(med.name),
                subtitle: Text("${med.dosage}g - ${timeFormat.format(med.time)}"),
              )),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text("关闭"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  // 辅助方法：构建详情条目
  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.black, fontSize: 16),
          children: [
            TextSpan(
              text: "$label: ",
              style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }    
}