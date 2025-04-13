import 'package:flutter/material.dart';
import 'package:bower_tracker/game/pet_care.dart';
import 'package:bower_tracker/models/pet_model.dart';
import 'package:hive_flutter/hive_flutter.dart'; 

class GutExplorerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gut Explorer',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: true,
      home: GameHomePage(),
    );
  }
}
class GameHomePage extends StatefulWidget {
  @override
  _GameHomePageState createState() => _GameHomePageState();
}

class _GameHomePageState extends State<GameHomePage> {
  late Box<PetData> _petBox;

  @override
  void initState() {
    super.initState();
    _petBox = Hive.box<PetData>('petBox');
    if (!_petBox.containsKey('pet')) {
      final newPet = PetData(level: 1, experience: 0);
      _petBox.put('pet', newPet);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("🔥 GameHomePage build");
    return Scaffold(
      appBar: AppBar(title: Text('肠道探险家')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ValueListenableBuilder(
          valueListenable: _petBox.listenable(keys: ['pet']),
          builder: (context, Box box, _) {
            final pet = box.get('pet') as PetData;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildMissionCard(),
                SizedBox(height: 16),
                _buildCharacterCard(pet),
                SizedBox(height: 16),
                _buildButtonBar(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMissionCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('今日任务', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('🧻 完成一次健康排便记录'),
            Text('💧 记录饮水 1500ml'),
            Text('🥦 吃一次富含纤维的食物'),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterCard(PetData pet) {
    return Card(
      color: Colors.lightGreen.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.green,
              child: Icon(Icons.emoji_nature, size: 30, color: Colors.white),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('菌菌战士', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('等级：Lv.${pet.level}'),
                Text('经验值：${pet.experience} / 100'),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildButtonBar(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          icon: Icon(Icons.edit_note),
          label: Text('记录排便'),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PetCarePage()),
          ),
        ),
        SizedBox(height: 8),
        ElevatedButton.icon(
          icon: Icon(Icons.leaderboard),
          label: Text('查看成就'),
          onPressed: () {
            // TODO: Implement achievements page
          },
        ),
        SizedBox(height: 8),
        ElevatedButton.icon(
          icon: Icon(Icons.info_outline),
          label: Text('肠道知识小问答'),
          onPressed: () {
            // TODO: Implement quiz/game page
          },
        ),
      ],
    );
  }
}