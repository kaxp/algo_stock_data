import 'package:algo_test/components/atoms/typography/header2.dart';
import 'package:algo_test/config/themes/assets/app_colors.dart';
import 'package:algo_test/config/themes/assets/app_images.dart';
import 'package:algo_test/constants/app_strings.dart';
import 'package:algo_test/constants/spacing_constants.dart';
import 'package:flutter/material.dart';

class EmptyStateView extends StatelessWidget {
  const EmptyStateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kSpacingMedium,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppImages.icDataNotFound(),
            const SizedBox(
              height: kSpacingSmall,
            ),
            Header2(
              textAlign: TextAlign.center,
              title: AppStrings.noResultFound,
              color: AppColors.white,
            ),
          ],
        ),
      ),
    );
  }
}
