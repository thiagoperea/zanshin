import 'package:flutter/material.dart';
import 'package:zanshin/styles/app_text_styles.dart';

class SimpleMessage extends StatelessWidget {
  final String message;
  final IconData? icon;
  final double iconSize;

  const SimpleMessage(this.message, {this.icon, this.iconSize = 64, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Visibility(
            child: Icon(icon, size: iconSize),
            visible: icon != null,
          ),
          Text(
            message,
            style: AppTextStyles.extremeSize.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.38),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
