import 'package:algo_test/components/atoms/typography/header2.dart';
import 'package:algo_test/config/themes/assets/app_images.dart';
import 'package:algo_test/constants/app_strings.dart';
import 'package:flutter/material.dart';

class ErrorStateView extends StatelessWidget {
  const ErrorStateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          AppImages.icDataNotFound(),
          Header2(
            textAlign: TextAlign.center,
            title: AppStrings.noDataFound,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
