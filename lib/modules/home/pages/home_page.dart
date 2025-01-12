import 'package:algo_test/config/themes/assets/app_colors.dart';
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
              vertical: 8,
              horizontal: 16,
            ),
            color: AppColors.secondaryColor,
            child: const Row(
              children: [
                Expanded(
                  child: Text(
                    'Call LTP',
                    style: TextStyle(
                      color: AppColors.greyTextColor,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Strike',
                    style: TextStyle(
                      color: AppColors.yellowColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Put LTP',
                    style: TextStyle(
                      color: AppColors.greyTextColor,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
          // Data Rows
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: tableData.length,
              itemBuilder: (context, index) {
                final row = tableData[index];
                return Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.dividerColour,
                        width: 0.75,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          row['callLTP']!,
                          style: const TextStyle(
                            color: AppColors.white,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          row['strike']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          row['putLTP']!,
                          style: const TextStyle(
                            color: AppColors.white,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
