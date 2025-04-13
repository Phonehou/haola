import 'package:flutter/material.dart';    // 基础组件库
import 'package:intl/intl.dart';           // 日期格式化库
import '../models/bowel_record.dart';      // 数据模型
import '../widgets/bristol_chart.dart';    // 自定义组件
import 'package:hive_flutter/hive_flutter.dart'; 

class RecordPage extends StatefulWidget {
  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  final _formKey = GlobalKey<FormState>();
  var _record = BowelRecord(
    dateTime: DateTime.now(),
    duration: Duration(minutes: 5),
    type: BristolType.type4,
    isStraining: false,
  );

  // 定义颜色主题
  final _primaryColor = Color(0xFF4CAF50); // 类似丁香医生的绿色
  final _secondaryColor = Color(0xFF607D8B); 
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateTimePicker(),
            _buildDurationInput(),
            _buildBristolSelector(),
            _buildAdditionalInfo(),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimePicker() {
    return ListTile(
      title: Text("时间"),
      subtitle: Text(DateFormat('yyyy-MM-dd HH:mm').format(_record.dateTime)),
      trailing: Icon(Icons.edit),
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _record.dateTime,
          firstDate: DateTime.now().subtract(Duration(days: 30)),
          lastDate: DateTime.now(),
        );
        if (date != null) {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(_record.dateTime),
          );
          setState(() {
            _record.dateTime = date.add(Duration(
              hours: time?.hour ?? 0,
              minutes: time?.minute ?? 0,
            ));
          });
        }
      },
    );
  }

  Widget _buildDurationInput() {
    return TextFormField(
      decoration: InputDecoration(labelText: "排便时长（分钟）"),
      keyboardType: TextInputType.number,
      initialValue: _record.duration.inMinutes.toString(),
      validator: (value) {
        if (value == null || int.tryParse(value) == null) {
          return "请输入有效数字";
        }
        return null;
      },
      onSaved: (value) => _record.duration = Duration(minutes: int.parse(value!)),
    );
  }

  Widget _buildBristolSelector() {
    return ExpansionTile(
      title: Text("大便形态"),
      children: [
        BristolChart(
          selectedType: _record.type,
          onSelect: (type) => setState(() => _record.type = type),
        ),
      ],
    );
  }

  Widget _buildAdditionalInfo() {
    return Column(
      children: [
        SwitchListTile(
          title: Text("排便费力"),
          value: _record.isStraining,
          onChanged: (v) => setState(() => _record.isStraining = v),
        ),
        CheckboxListTile(
          title: Text("出血"),
          value: _record.hasBlood,
          onChanged: (v) => setState(() => _record.hasBlood = v ?? false),
        ),
        CheckboxListTile(
          title: Text("粘液"),
          value: _record.hasMucus,
          onChanged: (v) => setState(() => _record.hasMucus = v ?? false),
        ),
        DropdownButtonFormField<PostFeeling>(
          decoration: InputDecoration(labelText: "便后感受"),
          items: PostFeeling.values.map((feeling) {
            return DropdownMenuItem(
              value: feeling,
              child: Text(_feelingToString(feeling)),
            );
          }).toList(),
          onChanged: (v) => _record.feeling = v,
        ),
      ],
    );
  }

  String _feelingToString(PostFeeling feeling) {
    switch (feeling) {
      case PostFeeling.relaxed:
        return "轻松舒畅";
      case PostFeeling.bloated:
        return "腹胀未缓解";
      case PostFeeling.incomplete:
        return "未排净感";
      case PostFeeling.pain:
        return "疼痛不适";
    }
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      child: Text("保存记录"),
      onPressed: () async { 
        if (!_formKey.currentState!.validate()) return;
        if (_record.duration.inMinutes > 60) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("排便时长异常，请检查输入"))
          );
          return;
        }
        _record.dateTime.isAfter(DateTime.now()) ? DateTime.now() : _record.dateTime;
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          print("💾 bowelRecords开始保存排便记录: $_record");
          try {
            // 获取Hive Box实例
            final box = Hive.box<BowelRecord>('bowelRecords');           
            // 添加新记录
            await box.add(_record);
            print("✅ bowelRecords保存成功，当前记录数: ${box.length}");

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("记录已保存"),
                duration: Duration(seconds: 2),
              ),
            );
            
            // 可选：保存后重置表单
            _formKey.currentState?.reset();
            setState(() {
              // 重置_record实例（根据实际需求选择）
              _record = BowelRecord(
                dateTime: DateTime.now(),
                duration: Duration(minutes: 5),
                type: BristolType.type4,
                isStraining: false,
              );
            });
            
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("保存失败: ${e.toString()}"),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
    );
  }
}