import 'package:algo_test/components/molecules/snackbar/custom_snackbar.dart';
import 'package:algo_test/components/organisms/list_views/filter_list_view.dart';
import 'package:algo_test/config/flavor_config.dart';
import 'package:algo_test/modules/home/home_module.dart';
import 'package:algo_test/modules/home/models/option_chain_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:modular_test/modular_test.dart';

import 'package:algo_test/modules/home/blocs/home_bloc.dart';
import 'package:algo_test/modules/home/pages/home_page.dart';
import 'package:algo_test/components/molecules/app_bar/custom_appbar.dart';
import 'package:algo_test/components/molecules/loading_overlay/loading_overlay.dart';
import 'package:algo_test/components/molecules/states/empty_state_view.dart';
import 'package:algo_test/components/molecules/states/error_state_view.dart';
import 'package:algo_test/components/organisms/list_views/option_chain_list_view.dart';
import 'package:algo_test/constants/app_strings.dart';

import '../../../mocks/bloc/mock_blocs.mocks.dart';

void main() {
  late MockHomeBloc _mockHomeBloc;

  setUpAll(() async {
    FlavorConfig(
      flavor: Flavor.mock,
      values: const FlavorValues(
        baseUrl: '',
      ),
    );
    _mockHomeBloc = MockHomeBloc();
  });

  setUp(() async {
    initModule(HomeModule(), replaceBinds: [
      Bind<HomeBloc>((_) => _mockHomeBloc),
    ]);
  });

  testWidgets('''Given HomePage is first opened
    When state is HomeInitial
    Then HomePage is rendered with loading overlay''', (tester) async {
    when(_mockHomeBloc.state).thenAnswer((_) => HomeInitial());

    await tester.pumpWidget(
      const MaterialApp(
        home: HomePage(),
      ),
    );

    await tester.pump();

    expect(find.byType(CustomAppBar), findsOneWidget);
    expect(find.byType(LoadingOverlay), findsOneWidget);
  });

  testWidgets('''Given HomePage is first opened
    When state is HomeEmpty
    Then HomePage is rendered with empty state view''', (tester) async {
    when(_mockHomeBloc.state).thenAnswer((_) => HomeEmpty());

    await tester.pumpWidget(
      const MaterialApp(
        home: HomePage(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(CustomAppBar), findsOneWidget);
    expect(find.byType(EmptyStateView), findsOneWidget);
    expect(find.text(AppStrings.noResultFound), findsOneWidget);
  });

  testWidgets('''Given HomePage is first opened
    When state is HomeError
    Then HomePage shows error state view''', (tester) async {
    when(_mockHomeBloc.state).thenAnswer((_) => const HomeError(
          errorMessage: 'An error occurred',
          optionsData: {},
          expiryDates: [],
          currentExpiryDate: '',
        ));

    await tester.pumpWidget(
      const MaterialApp(
        home: HomePage(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(CustomAppBar), findsOneWidget);
    expect(find.byType(ErrorStateView), findsOneWidget);
  });

  testWidgets('''Given HomePage is first opened
    When state is HomeLoaded
    Then HomePage shows the option chain list view''', (tester) async {
    when(_mockHomeBloc.state).thenAnswer((_) => const HomeLoaded(
          optionsData: {'expiryDate': OptionData(options: [])},
          expiryDates: ['expiryDate'],
          currentExpiryDate: 'expiryDate',
        ));

    await tester.pumpWidget(
      const MaterialApp(
        home: HomePage(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(CustomAppBar), findsOneWidget);
    expect(find.byType(OptionChainListView), findsOneWidget);
  });

  testWidgets('''Given HomePage is first opened
    When state is HomeLoaded with multiple expiry dates
    Then HomePage renders the FilterListView with correct data''',
      (tester) async {
    when(_mockHomeBloc.state).thenAnswer((_) => const HomeLoaded(
          optionsData: {
            'expiryDate1': OptionData(options: []),
            'expiryDate2': OptionData(options: [])
          },
          expiryDates: ['expiryDate1', 'expiryDate2'],
          currentExpiryDate: 'expiryDate1',
        ));

    await tester.pumpWidget(
      const MaterialApp(
        home: HomePage(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(FilterListView), findsOneWidget);
    expect(find.text('expiryDate1'), findsOneWidget);
    expect(find.text('expiryDate2'), findsOneWidget);
  });

  testWidgets('''Given HomePage is first opened
    When state is HomeLoaded and user pulls to refresh
    Then refresh action triggers HomeBloc's getOptionChainsWithLtp''',
      (tester) async {
    when(_mockHomeBloc.state).thenAnswer((_) => const HomeLoaded(
          optionsData: {'expiryDate': OptionData(options: [])},
          expiryDates: ['expiryDate'],
          currentExpiryDate: 'expiryDate',
        ));

    await tester.pumpWidget(
      const MaterialApp(
        home: HomePage(),
      ),
    );

    await tester.pumpAndSettle();

    // Trigger pull-to-refresh
    final listView = find.byType(OptionChainListView);
    expect(listView, findsOneWidget);
    await tester.drag(listView, const Offset(0, 300));
    await tester.pumpAndSettle();

    // Verify the refresh action was triggered
    verify(_mockHomeBloc.getOptionChainsWithLtp()).called(1);
  });

  testWidgets('''Given HomePage is first opened
    When HomeEmpty state occurs
    Then no snackbar is displayed''', (tester) async {
    when(_mockHomeBloc.state).thenAnswer((_) => HomeEmpty());

    await tester.pumpWidget(
      const MaterialApp(
        home: HomePage(),
      ),
    );

    await tester.pumpAndSettle();

    await tester.pumpAndSettle();

    // Verify no snackbar is displayed
    expect(find.byType(CustomSnackbar), findsNothing);
    expect(find.byType(EmptyStateView), findsOneWidget);
  });
}
