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

  // 颜色主题
  final _primaryColor = Color(0xFF4CAF50);
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
              _buildDateCard(),
              SizedBox(height: 24),
              _buildSectionTitle("饮食记录"),
              _buildFoodTypeSection(),
              SizedBox(height: 24),
              _buildSectionTitle("饮水量"),
              _buildWaterIntake(),
              SizedBox(height: 24),
              _buildSectionTitle("运动强度"),
              _buildExerciseSelector(),
              SizedBox(height: 24),
              _buildSectionTitle("压力等级"),
              _buildStressLevel(),
              SizedBox(height: 24),
              _buildSectionTitle("药物/补剂"),
              _buildMedicationSection(),
              SizedBox(height: 32),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
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

  Widget _buildDateCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Icon(Icons.calendar_today, color: _primaryColor),
        title: Text(
          "记录日期",
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        subtitle: Text(
          DateFormat('yyyy-MM-dd').format(_record.date),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit, color: _primaryColor),
          onPressed: _pickDate,
        ),
      ),
    );
  }

  void _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _record.date,
      firstDate: DateTime.now().subtract(Duration(days: 30)),
      lastDate: DateTime.now(),
    );
    if (date != null) setState(() => _record.date = date);
  }

  Widget _buildFoodTypeSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: FoodType.values.map((type) {
            final isSelected = _record.foodTypes.contains(type);
            return FilterChip(
              label: Text(ModelMapper.foodTypeToChinese(type)),
              selected: isSelected,
              selectedColor: _primaryColor.withOpacity(0.2),
              checkmarkColor: _primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? _primaryColor : Colors.black87,
                fontWeight: FontWeight.w500
              ),
              onSelected: (selected) => setState(() {
                selected 
                  ? _record.foodTypes.add(type)
                  : _record.foodTypes.remove(type);
              }),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildWaterIntake() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.water_drop, color: _primaryColor),
                SizedBox(width: 8),
                Text(
                  "${_record.waterIntake.toStringAsFixed(1)} 升",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            Slider(
              value: _record.waterIntake,
              min: 0,
              max: 5,
              divisions: 10,
              activeColor: _primaryColor,
              inactiveColor: _primaryColor.withOpacity(0.2),
              label: "${_record.waterIntake.toStringAsFixed(1)} 升",
              onChanged: (value) => setState(() => _record.waterIntake = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseSelector() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: DropdownButtonFormField<ExerciseLevel>(
          value: _record.exercise,
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(Icons.directions_run, color: _primaryColor),
          ),
          items: ExerciseLevel.values.map((level) {
            return DropdownMenuItem(
              value: level,
              child: Text(
                ModelMapper.exerciseLevelToChinese(level),
                style: TextStyle(fontSize: 16),
              ),
            );
          }).toList(),
          onChanged: (value) => setState(() => _record.exercise = value!),
        ),
      ),
    );
  }

  Widget _buildStressLevel() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.psychology_outlined, color: _primaryColor),
                SizedBox(width: 12),
                Text(
                  "压力等级",
                  style: TextStyle(fontSize: 16),
                ),
                Spacer(),
                Text(
                  "${_record.stressLevel} 级",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _primaryColor
                  ),
                ),
              ],
            ),
            Slider(
              value: _record.stressLevel.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              activeColor: _primaryColor,
              inactiveColor: _primaryColor.withOpacity(0.2),
              onChanged: (value) => setState(() => _record.stressLevel = value.toInt()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.medication_outlined, color: _primaryColor),
                SizedBox(width: 12),
                Text(
                  "药物/补剂",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: _secondaryColor
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            ..._record.medications.map((med) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.circle, size: 8, color: _primaryColor),
              title: Text("${med.name} - ${med.dosage}g"),
              subtitle: Text(DateFormat('HH:mm').format(med.time)),
              trailing: IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.red[300]),
                onPressed: () => setState(() => _record.medications.remove(med)),
              ),
            )),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _medicationNameController,
                    decoration: InputDecoration(
                      labelText: "药物名称",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.medication, size: 20),
                    ),
     ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _medicationDosageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "剂量 (g)",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.scale, size: 20),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.access_time, color: _primaryColor),
                  onPressed: _pickTime,
                ),
                Text(DateFormat('HH:mm').format(DateTime(
                  0, 0, 0, _selectedTime.hour, _selectedTime.minute))),
                Spacer(),
                ElevatedButton.icon(
                  icon: Icon(Icons.add, size: 18),
                  label: Text("添加记录"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _addMedication,
                ),
              ],
            ),
          ],
              ),
      ),
    );
  }

  void _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (time != null) setState(() => _selectedTime = time);
  }

  void _addMedication() {
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
  }

  // 提交按钮组件
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
        onPressed: _submitForm,
        child: Text(
          "保存记录",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        final box = Hive.box<FactorRecord>('factorRecords');
        await box.add(_record);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("记录已保存"),
            backgroundColor: _primaryColor,
          ),
        );
        setState(() {
          _record.medications = [];
          _medicationNameController.clear();
          _medicationDosageController.clear();
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
  }
}