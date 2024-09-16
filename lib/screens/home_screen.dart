// screens/home_screen.dart

import 'package:flutter/material.dart';
import 'roast_list_screen.dart';
// 他の管理ページができたらインポートします

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  final List<Widget> _screens = const [
    Center(child: Text('Green Management')), // Green管理ページのプレースホルダー
    RoastListScreen(), // Roast管理ページ
    Center(child: Text('Drink Management')), // Drink管理ページのプレースホルダー
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // タブの数
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Roast Logger'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Green'),
              Tab(text: 'Roast'),
              Tab(text: 'Drink'),
            ],
          ),
        ),
        body: TabBarView(
          children: _screens,
        ),
      ),
    );
  }
}
