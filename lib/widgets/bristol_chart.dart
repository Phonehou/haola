import 'package:flutter/material.dart';    // 基础组件库
import '../models/bowel_record.dart';      // BristolType枚举

class BristolChart extends StatelessWidget {
  final BristolType? selectedType;
  final Function(BristolType) onSelect;

  const BristolChart({required this.onSelect, this.selectedType});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      children: BristolType.values.map((type) {
        return GestureDetector(
          onTap: () => onSelect(type),
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                color: selectedType == type 
                  ? Colors.blue 
                  : Colors.transparent,
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Image.asset('assets/bristol_${type.index + 1}.png'),
                Text(_getTypeDescription(type)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  String _getTypeDescription(BristolType type) {
    switch (type) {
      case BristolType.type1: return "坚果状";
      case BristolType.type2: return "块状";
      case BristolType.type3: return "裂痕状";
      case BristolType.type4: return "光滑蛇形";
      case BristolType.type5: return "软块状";
      case BristolType.type6: return "糊状";
      case BristolType.type7: return "水样";
    }
  }
}