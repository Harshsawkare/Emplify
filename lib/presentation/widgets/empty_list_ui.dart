import 'package:flutter/material.dart';

import '../../utils/app_theme.dart';
import '../../utils/constants.dart';

class EmptyListUi extends StatelessWidget {
  const EmptyListUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          Constants.emptyListImagePath,
          width: 261.79,
        ),
        const Text(
          Constants.noRecordsMessage,
          style: TextStyle(
            color: AppTheme.textColor,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
