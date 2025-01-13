import 'package:algo_test/components/atoms/typography/header4.dart';
import 'package:algo_test/config/themes/assets/app_colors.dart';
import 'package:algo_test/constants/radius_constants.dart';
import 'package:algo_test/constants/spacing_constants.dart';
import 'package:flutter/material.dart';

class FilterListView extends StatelessWidget {
  const FilterListView({
    super.key,
    required this.expiryDates,
    required this.currentExpiryDate,
    required this.onTap,
  });

  final List<String> expiryDates;
  final String currentExpiryDate;
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: kSpacingXSmall),
      itemCount: expiryDates.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final expiry = expiryDates[index];
        final isSelected = expiry == currentExpiryDate;

        return OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor:
                isSelected ? AppColors.blueColor : Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(kRadiusMedium),
              ),
            ),
          ),
          onPressed: () {
            onTap(expiry);
          },
          child: Header4(title: expiry),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
        width: kSpacingXSmall,
      ),
    );
  }
}
