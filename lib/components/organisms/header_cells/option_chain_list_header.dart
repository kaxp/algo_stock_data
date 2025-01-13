import 'package:algo_test/components/atoms/typography/header4.dart';
import 'package:algo_test/config/themes/assets/app_colors.dart';
import 'package:algo_test/constants/app_strings.dart';
import 'package:algo_test/constants/spacing_constants.dart';
import 'package:flutter/material.dart';

class OptionChainListHeader extends StatelessWidget {
  const OptionChainListHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: kSpacingXSmall,
        horizontal: kSpacingMedium,
      ),
      color: AppColors.secondaryColor,
      child: Row(
        children: [
          Expanded(
            child: Header4(
              title: AppStrings.callLTP,
              color: AppColors.greyTextColor,
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
            child: Header4(
              title: AppStrings.strike,
              color: AppColors.yellowColor,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Header4(
              title: AppStrings.putLTP,
              color: AppColors.greyTextColor,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
