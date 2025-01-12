import 'package:algo_test/components/atoms/typography/header3.dart';
import 'package:algo_test/components/atoms/typography/header4.dart';
import 'package:algo_test/config/themes/assets/app_colors.dart';
import 'package:algo_test/constants/spacing_constants.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Dummy data for the table
  final List<Map<String, dynamic>> tableData = List.generate(
    50,
    (index) => {
      'callLTP': (1000 + index).toStringAsFixed(2),
      'strike': (21800 + (index * 50)).toString(),
      'putLTP': (5 + index * 0.5).toStringAsFixed(2),
    },
  );

  @override
  Widget build(BuildContext context) {
    //TODO(kapil): Refactor this static UI in follow up PRs

    return Scaffold(
      appBar: AppBar(
        title: const Text('AlgoTest'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Data Header
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: kSpacingSmall,
              horizontal: kSpacingMedium,
            ),
            color: AppColors.secondaryColor,
            child: const Row(
              children: [
                Expanded(
                  child: Header4(
                    title: 'Call LTP',
                    color: AppColors.greyTextColor,
                    textAlign: TextAlign.start,
                  ),
                ),
                Expanded(
                  child: Header4(
                    title: 'Strike',
                    color: AppColors.yellowColor,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Header4(
                    title: 'Put LTP',
                    color: AppColors.greyTextColor,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
          // Data Rows
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: tableData.length,
              itemBuilder: (context, index) {
                final row = tableData[index];
                return Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: kSpacingSmall,
                    horizontal: kSpacingMedium,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Header3(
                          title: row['callLTP']!,
                          color: AppColors.white,
                          fontWeight: FontWeight.w400,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Expanded(
                        child: Header3(
                          title: row['strike']!,
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Header3(
                          title: row['putLTP']!,
                          color: AppColors.white,
                          fontWeight: FontWeight.w400,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(
                color: AppColors.dividerColour,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
