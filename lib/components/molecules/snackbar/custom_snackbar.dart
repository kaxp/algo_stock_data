import 'package:algo_test/components/atoms/typography/header3.dart';
import 'package:algo_test/components/atoms/typography/header4.dart';
import 'package:algo_test/config/themes/assets/app_colors.dart';
import 'package:algo_test/constants/spacing_constants.dart';
import 'package:flutter/material.dart';

class CustomSnackbar extends SnackBar {
  CustomSnackbar({
    super.key,
    required String message,
    Duration? duration,
    String? actionText,
    VoidCallback? onActionTap,
    super.margin = const EdgeInsets.all(kSpacingSmall),
  }) : super(
          content: _SnackbarContent(
            message: message,
            actionText: actionText,
            onActionTap: onActionTap,
          ),
          duration: duration ?? const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        );

  static void show(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackbar(
        message: message,
      ),
    );
  }
}

class _SnackbarContent extends StatelessWidget {
  const _SnackbarContent({
    required this.message,
    required this.actionText,
    required this.onActionTap,
  });

  final String message;
  final String? actionText;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Header3(
          title: message,
          color: AppColors.white,
        ),
        if (actionText != null)
          Padding(
            padding: const EdgeInsets.only(top: kSpacingXSmall),
            child: GestureDetector(
              onTap: onActionTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Header4(
                    title: actionText!,
                    color: AppColors.greyTextColor,
                  )
                ],
              ),
            ),
          )
      ],
    );
  }
}
