import 'package:flutter/material.dart';
import 'package:zanshin/styles/app_text_styles.dart';

class TitleBar extends StatelessWidget {
  final String title;
  final Function? onBackClick;

  const TitleBar({Key? key, required this.title, this.onBackClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, top: 16.0, right: 12.0, bottom: 8.0),
      child: Stack(
        children: [
          Visibility(
            visible: onBackClick != null,
            child: IconButton(
              onPressed: () => onBackClick?.call(),
              icon: const Icon(Icons.arrow_back_ios),
            ),
          ),
          SizedBox(
            height: 48.0,
            width: double.maxFinite,
            child: Center(child: Text(title, style: AppTextStyles.normalSizeSuperBold)),
          ),
        ],
      ),
    );
  }
}
