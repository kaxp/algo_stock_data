import 'package:algo_test/components/atoms/typography/header3.dart';
import 'package:algo_test/config/themes/assets/app_colors.dart';
import 'package:algo_test/constants/spacing_constants.dart';
import 'package:algo_test/modules/home/models/option_chain_response.dart';
import 'package:flutter/material.dart';

class OptionChainListItem extends StatelessWidget {
  const OptionChainListItem({
    Key? key,
    required this.optionData,
    required this.keyValue,
    required this.index,
  }) : super(key: key);

  final OptionData? optionData;
  final double? keyValue;
  final int index;

  @override
  Widget build(BuildContext context) {
    final callValue = optionData?.callClose?[index]?.toStringAsFixed(2) ?? '--';
    final strikeValue = optionData?.strike[index].toStringAsFixed(2) ?? '--';
    final putValue = optionData?.putClose?[index]?.toStringAsFixed(2) ?? '--';

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: kSpacingSmall,
        horizontal: kSpacingMedium,
      ),
      child: Row(
        key: ValueKey(keyValue),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Header3(
              title: callValue,
              color: AppColors.white,
              fontWeight: FontWeight.w400,
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
            child: Header3(
              title: strikeValue,
              color: AppColors.white,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Header3(
              title: putValue,
              color: AppColors.white,
              fontWeight: FontWeight.w400,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
