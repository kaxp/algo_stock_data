import 'package:algo_test/components/molecules/app_bar/custom_appbar.dart';
import 'package:algo_test/components/molecules/loading_overlay/loading_overlay.dart';
import 'package:algo_test/components/molecules/snackbar/custom_snackbar.dart';
import 'package:algo_test/components/molecules/states/empty_state_view.dart';
import 'package:algo_test/components/molecules/states/error_state_view.dart';
import 'package:algo_test/components/organisms/header_cells/option_chain_list_header.dart';
import 'package:algo_test/components/organisms/list_views/filter_list_view.dart';
import 'package:algo_test/components/organisms/list_views/option_chain_list_view.dart';
import 'package:algo_test/constants/app_strings.dart';
import 'package:algo_test/constants/spacing_constants.dart';
import 'package:algo_test/modules/home/blocs/home_bloc.dart';
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
    _homeBloc.getValidContracts();
  }

  @override
  void dispose() {
    _homeBloc.closeOptionsWebSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: Text(AppStrings.algoTest),
        isCenter: true,
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        bloc: _homeBloc,
        listener: (context, state) {
          if (state is HomeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackbar(
                message: state.errorMessage,
                duration: const Duration(seconds: 5),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is HomeError) {
            return const ErrorStateView();
          } else if (state is HomeEmpty) {
            return const EmptyStateView();
          }

          return LoadingOverlay(
            isLoading: state is HomeInitial || state is HomeLoading,
            child: state.optionsData.isNotEmpty
                ? Column(
                    children: [
                      SizedBox(
                        height: 36,
                        child: FilterListView(
                          expiryDates: state.expiryDates,
                          currentExpiryDate: state.currentExpiryDate,
                          onTap: _homeBloc.onFilterChange,
                        ),
                      ),
                      const SizedBox(
                        height: kSpacingSmall,
                      ),
                      const OptionChainListHeader(),
                      OptionChainListView(
                        optionsData: state.optionsData,
                        currentExpiryDate: state.currentExpiryDate,
                      ),
                    ],
                  )
                : const EmptyStateView(),
          );
        },
      ),
    );
  }
}
