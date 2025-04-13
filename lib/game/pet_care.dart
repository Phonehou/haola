import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:bower_tracker/models/pet_model.dart';
import 'package:hive_flutter/hive_flutter.dart'; 

class PetCarePage extends StatefulWidget {
  @override
  _PetCarePageState createState() => _PetCarePageState();
}

class _PetCarePageState extends State<PetCarePage> {
  late PetData pet;
  String? _animationType;
  //int xp = 80;
  //String? _currentAnimation; // 'feed' or 'play'
@override
  void initState() {
    super.initState();
    final box = Hive.box<PetData>('petBox');
    if (box.isEmpty) {
      pet = PetData(level: 1, experience: 0);
      box.put('pet', pet);
    } else {
      pet = box.get('pet')!;
    }
  }

  void _triggerAction(String type) async {
    setState(() {
      _animationType = type;
    });
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _animationType = null;
    });
    setState(() {
      pet.gainXP(10);
      pet.save();
    });
  }

  Widget _buildLottie() {
    if (_animationType == null) return Container();
    String asset = _animationType == 'feed'
        ? 'assets/animations/feed.json'
        : 'assets/animations/play.json';
    return Lottie.asset(asset, height: 150);
  }

  // void _playAnimation(String type) {
  //   setState(() {
  //     _currentAnimation = type;
  //     if (type == 'feed' || type == 'play') {
  //       xp += 10;
  //     }
  //   });

  //   Future.delayed(Duration(seconds: 2), () {
  //     setState(() {
  //       _currentAnimation = null;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('陪伴菌菌')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildLottie(),
            SizedBox(height: 16),
            Text('等级 Lv.${pet.level}', style: TextStyle(fontSize: 22)),
            Text('经验 ${pet.experience} / 100'),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.restaurant),
                  label: Text('喂食'),
                  onPressed: () => _triggerAction('feed'),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.sports_esports),
                  label: Text('陪玩'),
                  onPressed: () => _triggerAction('play'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: Text('陪伴菌菌成长')),
  //     body: SingleChildScrollView(
  //       padding: EdgeInsets.all(16),
  //       child: Column(
  //         children: [
  //           _buildPetDisplay(),
  //           SizedBox(height: 16),
  //           if (_currentAnimation != null) _buildLottieAnimation(),
  //           SizedBox(height: 16),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceAround,
  //             children: [
  //               ElevatedButton.icon(
  //                 onPressed: () => _playAnimation('feed'),
  //                 icon: Icon(Icons.restaurant),
  //                 label: Text('喂食'),
  //               ),
  //               ElevatedButton.icon(
  //                 onPressed: () => _playAnimation('play'),
  //                 icon: Icon(Icons.sports_esports),
  //                 label: Text('陪玩'),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildPetDisplay() {
  //   return Column(
  //     children: [
  //       CircleAvatar(
  //         radius: 50,
  //         backgroundColor: Colors.green.shade100,
  //         child: Icon(Icons.pets, size: 50),
  //       ),
  //       Text('菌菌战士 · Lv.2'),
  //       Text('经验值：$xp / 100'),
  //     ],
  //   );
  // }

  // Widget _buildLottieAnimation() {
  //   String assetPath = _currentAnimation == 'feed'
  //       ? 'assets/animations/feed.json'
  //       : 'assets/animations/play.json';

  //   return Container(
  //     height: 150,
  //     child: Lottie.asset(assetPath),
  //   );
  // }
}