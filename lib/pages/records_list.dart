import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/bowel_record.dart';
import '../utils/model_utils.dart';

class RecordsListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("历史记录")),
      body: ValueListenableBuilder<Box<BowelRecord>>(
        valueListenable: Hive.box<BowelRecord>('bowelRecords').listenable(),
        builder: (context, box, _) {
          final records = box.values.toList().cast<BowelRecord>();
          records.sort((a,b) => b.dateTime.compareTo(a.dateTime));
          
          return ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              return ListTile(
                title: Text(DateFormat('yyyy-MM-dd HH:mm').format(record.dateTime)),
                subtitle: Text("类型: ${ModelMapper.bristolToChinese(record.type)}  时长: ${record.duration.inMinutes}分钟"),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => box.deleteAt(index),
                ),
                onTap: () => _showDetail(context, record),
              );
            },
          );
        },
      ),
    );
  }

  void _showDetail(BuildContext context, BowelRecord record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("详细记录"),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("时间: ${DateFormat('yyyy-MM-dd HH:mm').format(record.dateTime)}"),
            Text("类型: ${ModelMapper.bristolToChinese(record.type)}"),
            Text("是否出血: ${record.hasBlood ? '是' : '否'}"),
            // 显示所有字段...
          ],
        ),
      ),
    );
  }
}