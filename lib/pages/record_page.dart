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
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 24),
              _buildDateTimeCard(),
              SizedBox(height: 16),
              _buildDurationInput(),
              SizedBox(height: 24),
              _buildSectionTitle("大便形态"),
              _buildBristolSelector(),
              SizedBox(height: 24),
              _buildSectionTitle("附加信息"),
              _buildAdditionalInfo(),
              SizedBox(height: 32),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Text(
        "记录排便情况",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: _primaryColor,
        ),
      ),
    );
  }

   Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: _secondaryColor,
        ),
      ),
    );
  }

Widget _buildDateTimeCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
             Icon(Icons.calendar_today, color: _primaryColor, size: 20),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "日期",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  DateFormat('yyyy-MM-dd').format(_record.dateTime),
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
             Spacer(),
            Icon(Icons.access_time, color: _primaryColor, size: 20),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "时间",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  DateFormat('HH:mm').format(_record.dateTime),
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String? _validateDuration(String? value) {
    if (value == null || value.isEmpty) return "请输入时长";
    final minutes = int.tryParse(value);
    if (minutes == null) return "请输入数字";
    if (minutes < 1) return "时长太短";
    if (minutes > 180) return "超过3小时请检查";
    return null;
  }

  Widget _buildDurationInput() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(Icons.timer_outlined, color: _primaryColor, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "排便时长（分钟）",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.left, 
              initialValue: _record.duration.inMinutes.toString(),
              validator: (value) => _validateDuration(value),
              onSaved: (value) => _record.duration = Duration(minutes: int.parse(value!)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBristolSelector() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent, // 隐藏默认分割线
        ),
        child: ExpansionTile(
          initiallyExpanded: false, // 修改这里为false
          tilePadding: EdgeInsets.symmetric(horizontal: 16),
          title: Row(
            children: [
              Icon(Icons.color_lens_outlined, color: _primaryColor, size: 20),
              SizedBox(width: 12),
              Text("选择大便类型", style: TextStyle(fontSize: 16)),
            ],
          ),
          trailing: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: _secondaryColor,
          ),
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: BristolChart(
                selectedType: _record.type,
                onSelect: (type) => setState(() => _record.type = type),
              ),
            ),
          ],
          // onExpansionChanged: (expanded) {
          //   // 可选：添加展开动画音效
          //   if (expanded) HapticFeedback.selectionClick();
          // },
        ),
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSwitchTile("排便费力", _record.isStraining, (v) => setState(() => _record.isStraining = v)),
            Divider(height: 24),
            _buildCheckboxTile("出血", _record.hasBlood, (v) => setState(() => _record.hasBlood = v ?? false)),
            _buildCheckboxTile("粘液", _record.hasMucus, (v) => setState(() => _record.hasMucus = v ?? false)),
            Divider(height: 24),
            _buildFeelingSelector(),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.accessibility, color: _secondaryColor),
      title: Text(title, style: TextStyle(fontSize: 16)),
      trailing: Switch(
        value: value,
        activeColor: _primaryColor,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildCheckboxTile(String title, bool value, Function(bool?) onChanged) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: TextStyle(fontSize: 16)),
      value: value,
      activeColor: _primaryColor,
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: onChanged,
    );
  }

    Widget _buildFeelingSelector() {
    return DropdownButtonFormField<PostFeeling>(
      decoration: InputDecoration(
        labelText: "便后感受",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.sentiment_satisfied_alt, color: _primaryColor),
      ),
      value: _record.feeling,
      items: PostFeeling.values.map((feeling) {
        return DropdownMenuItem(
          value: feeling,
          child: Text(
            _feelingToString(feeling),
            style: TextStyle(fontSize: 16),
          ),
        );
      }).toList(),
      onChanged: (v) => setState(() => _record.feeling = v),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
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
        child: Text(
          "保存记录",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white),
        ),
      ),
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

}