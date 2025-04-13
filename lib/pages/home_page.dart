import 'package:flutter/material.dart';    // 核心组件库（必须）
import 'record_page.dart';                
import 'factors_page.dart';               
import 'analytics_page.dart';             
import 'records_list.dart';
import 'factors_history.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    RecordPage(),
    FactorsPage(),
    AnalyticsPage(),
  ];

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: _buildAppBar(),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  AppBar _buildAppBar() {
  final titles = ['排便记录', '关联因素', '健康分析'];
    return AppBar(
      title: Text(titles[_selectedIndex]),
      actions: _selectedIndex == 0 
          ? _buildHistoryButton(RecordsListPage())
          : _selectedIndex == 1
              ? _buildHistoryButton(FactorsHistoryPage())
              : null,
    );
  }

  List<Widget> _buildHistoryButton(Widget page) {
    return [
      IconButton(
        icon: Icon(Icons.history),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        ),
      ),
    ];
  }

  BottomNavigationBar _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.edit),
          label: '记录',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.link),
          label: '关联',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics),
          label: '分析',
        ),
      ],
      onTap: (index) => setState(() => _selectedIndex = index),
    );
  }
}