import 'package:flutter/material.dart';
import '../helper/database_helper.dart';
import '../models/green_bean.dart';
import '../models/roast_bean.dart';

class RoastListItem extends StatelessWidget {
  final RoastBean roastBean;
  final VoidCallback onTap;

  const RoastListItem({Key? key, required this.roastBean, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // roastBean.greenBeanId から GreenBean を取得
    DatabaseHelper dbHelper = DatabaseHelper();
    
        // FutureBuilderを使って非同期でgreenBeanを取得する
    return FutureBuilder<GreenBean?>(
      future: dbHelper.getBeanById(roastBean.greenBeanId),  // 非同期処理の結果を待つ
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 非同期処理がまだ完了していない間、ローディングインジケータを表示
          return ListTile(
            title: Text('Loading...'),
            subtitle: Text('Roasted on: ${roastBean.date}'),
            trailing: Text(roastBean.roastLevelName),
            onTap: onTap,
          );
        } else if (snapshot.hasError) {
          // エラーが発生した場合
          return ListTile(
            title: Text('Error loading bean'),
            subtitle: Text('Roasted on: ${roastBean.date}'),
            trailing: Text(roastBean.roastLevelName),
            onTap: onTap,
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          // データ取得が成功し、greenBeanが存在する場合
          GreenBean greenBean = snapshot.data!;
          return ListTile(
            title: Text(greenBean.name),
            subtitle: Text('Roasted on: ${roastBean.date}'),
            trailing: Text(roastBean.roastLevelName),
            onTap: onTap,
          );
        } else {
          // データが見つからない場合
          return ListTile(
            title: Text('Unknown bean'),
            subtitle: Text('Roasted on: ${roastBean.date}'),
            trailing: Text(roastBean.roastLevelName),
            onTap: onTap,
          );
        }
      },
    );
  }
}
