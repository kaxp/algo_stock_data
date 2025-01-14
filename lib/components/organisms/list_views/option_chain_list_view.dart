import 'package:algo_test/components/molecules/list_items/option_chain_list_item.dart';
import 'package:algo_test/config/themes/assets/app_colors.dart';
import 'package:algo_test/modules/home/models/option_chain_response.dart';
import 'package:flutter/material.dart';

class OptionChainListView extends StatelessWidget {
  const OptionChainListView({
    super.key,
    required this.options,
    required this.currentExpiryDate,
  });

  final List<Option> options;
  final String currentExpiryDate;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: options.length,
        itemBuilder: (context, index) {
          final strikeRow = options[index];

          return OptionChainListItem(
            option: strikeRow,
            keyValue: strikeRow.strike,
            index: index,
          );
        },
        separatorBuilder: (context, index) => const Divider(
          color: AppColors.dividerColour,
          height: 1,
        ),
      ),
    );
  }
}
