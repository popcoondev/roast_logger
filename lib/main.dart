// main.dart

import 'package:flutter/material.dart';

// モデルクラスのインポート
import 'models/bean_info.dart';
import 'models/roast_info.dart';
import 'models/log_entry.dart';
import 'models/roast_log.dart';

// 他の必要なインポート
import 'package:google_fonts/google_fonts.dart';
import 'widgets/roast_logger.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // アプリケーションのルートウィジェット
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Roast Logger',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        textTheme: GoogleFonts.notoSansTextTheme(
          Theme.of(context).textTheme.apply(
                bodyColor: Colors.black87,
                displayColor: Colors.black87,
              ),
        ),
      ),
      home: const RoastLogger(),
    );
  }
}

