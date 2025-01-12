import 'package:algo_test/components/atoms/typography/header3.dart';
import 'package:algo_test/components/atoms/typography/header4.dart';
import 'package:algo_test/config/themes/assets/app_colors.dart';
import 'package:algo_test/constants/radius_constants.dart';
import 'package:algo_test/constants/spacing_constants.dart';
import 'package:algo_test/modules/home/blocs/home_bloc.dart';
import 'package:algo_test/modules/home/models/option_chain_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _homeBloc = Modular.get<HomeBloc>();

  @override
  void initState() {
    super.initState();
    _homeBloc.getOptionChainsWithLtp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AlgoTest'),
        centerTitle: true,
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        bloc: _homeBloc,
        listener: (context, state) {
          if (state is HomeError) {
            // TODO(kapil): Display error message
          }
        },
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HomeLoaded) {
            return _buildOptionTable(
              optionsData: state.optionsData!,
              expiryDates: state.expiryDates,
              currentExpiryDate: state.currentExpiryDate,
            );
          } else if (state is HomeEmpty) {
            return const Center(child: Text('No data available.'));
          } else
            return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildOptionTable({
    required OptionChainResponse optionsData,
    required List<String> expiryDates,
    required String currentExpiryDate,
  }) {
    return Column(
      children: [
        SizedBox(
          height: 36,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: kSpacingXSmall),
            itemCount: expiryDates.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final expiryKey = expiryDates[index];
              final isSelected = currentExpiryDate == expiryKey;

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
                  // TODO(kapil): Implement tab change functionality
                },
                child: Header4(title: expiryKey),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(
              width: kSpacingXSmall,
            ),
          ),
        ),

        const SizedBox(
          height: kSpacingSmall,
        ),
        // Data Header
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: kSpacingXSmall,
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
            itemCount:
                optionsData.options[currentExpiryDate]?.strike.length ?? 0,
            itemBuilder: (context, index) {
              final row = optionsData.options[currentExpiryDate];

              return Container(
                padding: const EdgeInsets.symmetric(
                  vertical: kSpacingSmall,
                  horizontal: kSpacingMedium,
                ),
                child: Row(
                  key: ValueKey(row?.strike[index]),
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Header3(
                        title:
                            row!.callClose?[index]?.toStringAsFixed(2) ?? '--',
                        color: AppColors.white,
                        fontWeight: FontWeight.w400,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Expanded(
                      child: Header3(
                        title: row.strike[index].toStringAsFixed(2),
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Header3(
                        title: row.putClose?[index]?.toStringAsFixed(2) ?? '--',
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
    );
  }
}
