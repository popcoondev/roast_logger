// widgets/components_container.dart

import 'package:flutter/material.dart';
import 'package:roast_logger/widgets/roast_info_widget.dart';

class ComponentsContainer extends StatelessWidget {
  final Widget child;
  final String labelTitle;
  final String buttonTitle;
  final void Function()? buttonAction;
  bool isVisible = false;

  ComponentsContainer({
    Key? key,
    required this.child,
    this.labelTitle = '',
    this.buttonTitle = '',
    this.buttonAction,
    this.isVisible = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isVisible ? SizedBox() : // 編集モードの場合は非表示
    Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ヘッダー部分
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  labelTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (buttonTitle.isNotEmpty && buttonAction != null)
                  TextButton(
                    onPressed: buttonAction,
                    child: Text(buttonTitle),
                  ),
              ],
            ),
            const SizedBox(height: 8.0),
            // メインコンテンツ
            child,
          ],
        ),
      ),
    );
  }
}
