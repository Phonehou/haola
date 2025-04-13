import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../models/factor_record.dart';
import 'factors_history.dart';
import '../utils/model_utils.dart';

class FactorsPage extends StatefulWidget {
  @override
  _FactorsPageState createState() => _FactorsPageState();
}

class _FactorsPageState extends State<FactorsPage> {
  final _formKey = GlobalKey<FormState>();
  final _record = FactorRecord(date: DateTime.now());
  final _medicationNameController = TextEditingController();
  final _medicationDosageController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("关联因素记录"),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => FactorsHistoryPage()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDateSelector(),
              _buildFoodTypeSection(),
              _buildWaterIntake(),
              _buildExerciseSelector(),
              _buildStressLevel(),
              _buildMedicationSection(),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return ListTile(
      title: Text("记录日期"),
      subtitle: Text(DateFormat('yyyy-MM-dd').format(_record.date)),
      trailing: IconButton(
        icon: Icon(Icons.calendar_today),
        onPressed: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: _record.date,
            firstDate: DateTime.now().subtract(Duration(days: 30)),
            lastDate: DateTime.now(),
          );
          if (date != null) setState(() => _record.date = date);
        },
      ),
    );
  }

  Widget _buildFoodTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("饮食类型", style: TextStyle(fontSize: 16)),
        Wrap(
          spacing: 8,
          children: FoodType.values.map((type) {
            final isSelected = _record.foodTypes.contains(type);
            return FilterChip(
              label: Text(ModelMapper.foodTypeToChinese(type)),
              selected: isSelected,
              onSelected: (selected) => setState(() {
                selected 
                  ? _record.foodTypes.add(type)
                  : _record.foodTypes.remove(type);
              }),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildWaterIntake() {
    return Slider(
      value: _record.waterIntake,
      min: 0,
      max: 5,
      divisions: 10,
      label: "${_record.waterIntake.toStringAsFixed(1)} 升",
      onChanged: (value) => setState(() => _record.waterIntake = value),
    );
  }

  Widget _buildExerciseSelector() {
    return DropdownButtonFormField<ExerciseLevel>(
      value: _record.exercise,
      decoration: InputDecoration(labelText: "运动强度"),
      items: ExerciseLevel.values.map((level) {
        return DropdownMenuItem(
          value: level,
          child: Text(ModelMapper.exerciseLevelToChinese(level)),
        );
      }).toList(),
      onChanged: (value) => setState(() => _record.exercise = value!),
    );
  }

  Widget _buildStressLevel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("压力等级 (${_record.stressLevel})"),
        Slider(
          value: _record.stressLevel.toDouble(),
          min: 1,
          max: 5,
          divisions: 4,
          onChanged: (value) => setState(() => _record.stressLevel = value.toInt()),
        ),
      ],
    );
  }

  Widget _buildMedicationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("药物/补剂记录"),
        ..._record.medications.map((med) => ListTile(
          title: Text("${med.name} ${med.dosage}g"),
          subtitle: Text(DateFormat('HH:mm').format(med.time)),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => setState(() => _record.medications.remove(med)),
          ),
        )),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _medicationNameController,
                decoration: InputDecoration(labelText: "药物名称"),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: _medicationDosageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "剂量 (g)"),
              ),
            ),
            IconButton(
              icon: Icon(Icons.access_time),
              onPressed: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime,
                );
                if (time != null) setState(() => _selectedTime = time);
              },
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                if (_medicationNameController.text.isNotEmpty &&
                    _medicationDosageController.text.isNotEmpty) {
                  setState(() {
                    _record.medications.add(Medication(
                      name: _medicationNameController.text,
                      dosage: double.parse(_medicationDosageController.text),
                      time: DateTime(
                        _record.date.year,
                        _record.date.month,
                        _record.date.day,
                        _selectedTime.hour,
                        _selectedTime.minute,
                      ),
                    ));
                    _medicationNameController.clear();
                    _medicationDosageController.clear();
                  });
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  // 提交按钮组件
  Widget _buildSubmitButton() {
    return ElevatedButton(
      child: Text("保存记录"),
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          print("💾 factorRecords开始保存排便记录: $_record");
          final box = Hive.box<FactorRecord>('factorRecords');
          await box.add(_record);
          print("✅ factorRecords保存成功，当前记录数: ${box.length}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("记录已保存")),
          );
          setState(() {
            _record.medications = [];
            _medicationNameController.clear();
            _medicationDosageController.clear();
          });
        }
      },
    );
  }
}