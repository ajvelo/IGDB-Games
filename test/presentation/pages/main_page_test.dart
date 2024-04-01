import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:igdb_games/core/status_enum.dart';
import 'package:igdb_games/domain/entities/game_entity.dart';
import 'package:igdb_games/presentation/cubit/game/game_cubit.dart';
import 'package:igdb_games/presentation/cubit/game/game_state.dart';
import 'package:igdb_games/presentation/pages/main_page.dart';
import 'package:igdb_games/presentation/widgets/filter_dialog.dart';
import 'package:igdb_games/presentation/widgets/game_card.dart';
import 'package:mocktail/mocktail.dart';

class MockGameCubit extends MockBloc<GameCubit, GameState>
    implements GameCubit {}

class MockGameCubitState extends Mock implements GameState {}

void main() {
  late MockGameCubit gameCubit;

  setUpAll(() {
    registerFallbackValue(MockGameCubitState());
    gameCubit = MockGameCubit();
  });

  const game = Game(
    storyLine: 'storyLine',
    gameModes: ['url'],
    id: 1,
    name: 'name',
    imageCover: 'imageCover',
    summary: 'summary',
    status: Status.alpha,
    totalRating: 0.0,
  );

  group('MainPage', () {
    testWidgets('Initial state', (WidgetTester tester) async {
      when(() => gameCubit.state).thenReturn(GameInitialState());

      await tester.pumpWidget(BlocProvider<GameCubit>(
        create: (context) =>
            gameCubit..fetchGames(isRefresh: true, statusValue: null, page: 0),
        child: const MaterialApp(
          home: MainPage(),
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('No filters match your results.'), findsNothing);
      expect(find.text('Clear filters'), findsNothing);
      expect(find.byType(SizedBox), findsExactly(2));

      verify(() =>
              gameCubit.fetchGames(isRefresh: true, statusValue: null, page: 0))
          .called(1);
    });
  });

  testWidgets('Loading state', (WidgetTester tester) async {
    when(() => gameCubit.state).thenReturn(GameLoadingState());

    await tester.pumpWidget(BlocProvider<GameCubit>(
      create: (context) =>
          gameCubit..fetchGames(isRefresh: true, statusValue: null, page: 0),
      child: const MaterialApp(
        home: MainPage(),
      ),
    ));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Loaded state with games', (WidgetTester tester) async {
    when(() => gameCubit.state)
        .thenReturn(GameLoadedState(games: const [game]));

    await tester.pumpWidget(BlocProvider<GameCubit>(
      create: (context) =>
          gameCubit..fetchGames(isRefresh: true, statusValue: null, page: 0),
      child: const MaterialApp(
        home: MainPage(),
      ),
    ));

    await tester.pumpAndSettle();

    expect(find.byType(GameCard), findsOneWidget);
  });

  testWidgets('Loaded state with no games', (WidgetTester tester) async {
    when(() => gameCubit.state).thenReturn(GameLoadedState(games: const []));

    await tester.pumpWidget(BlocProvider<GameCubit>(
      create: (context) =>
          gameCubit..fetchGames(isRefresh: true, statusValue: null, page: 0),
      child: const MaterialApp(
        home: MainPage(),
      ),
    ));

    await tester.pumpAndSettle();

    expect(find.text('No filters match your results.'), findsOneWidget);
    expect(find.text('Clear filters'), findsOneWidget);
  });

  testWidgets('Error state', (WidgetTester tester) async {
    when(() => gameCubit.state).thenReturn(GameErrorState(error: 'Some Error'));

    await tester.pumpWidget(BlocProvider<GameCubit>(
      create: (context) =>
          gameCubit..fetchGames(isRefresh: true, statusValue: null, page: 0),
      child: const MaterialApp(
        home: MainPage(),
      ),
    ));

    await tester.pumpAndSettle();

    expect(find.text('Some Error'), findsOneWidget);
  });

  testWidgets('Filter options', (WidgetTester tester) async {
    await tester.pumpWidget(BlocProvider<GameCubit>(
      create: (context) =>
          gameCubit..fetchGames(isRefresh: true, statusValue: null, page: 0),
      child: const MaterialApp(
        home: MainPage(),
      ),
    ));

    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.filter_alt));
    await tester.pump();

    expect(find.byType(FilterOptionsDialog), findsOneWidget);
  });
}
