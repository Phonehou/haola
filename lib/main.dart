import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/bowel_record.dart'; 
import 'models/factor_record.dart'; 
import 'package:flutter_localizations/flutter_localizations.dart';
import 'pages/home_page.dart';
import 'adapter/duration_adapter.dart'; 

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(DurationAdapter());
  Hive.registerAdapter(BowelRecordAdapter());
  Hive.registerAdapter(BristolTypeAdapter());
  Hive.registerAdapter(PostFeelingAdapter());
  Hive.registerAdapter(FactorRecordAdapter());
  Hive.registerAdapter(FoodTypeAdapter());
  Hive.registerAdapter(ExerciseLevelAdapter());
  Hive.registerAdapter(MedicationAdapter());
   await Future.wait([
    Hive.openBox<BowelRecord>('bowelRecords'),
    Hive.openBox<FactorRecord>('factorRecords'),
  ]);
  try {
    print("⏳ 正在打开boxes...");
    await Future.wait([
      Hive.openBox<BowelRecord>('bowelRecords'),
      Hive.openBox<FactorRecord>('factorRecords'),
    ]);
    print("✅ Boxes打开成功");
  } catch (e) {
    print("❌ Boxes打开失败: $e");
  }
  runApp(MyApp());
  // 添加全局错误捕获
  FlutterError.onError = (details) {
    print("Flutter Error: ${details.exception}");
  };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '好拉',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // 本地化配置
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate, // 可选，用于iOS风格支持
      ],
      supportedLocales: const [
        Locale('zh'), // 中文
        Locale('en'), // 英文
      ],
      locale: const Locale('zh'), // 设置默认语言为中文

      home: HomePage(),
    );
  }
}
