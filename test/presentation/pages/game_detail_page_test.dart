import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:igdb_games/core/status_enum.dart';
import 'package:igdb_games/domain/entities/game_entity.dart';
import 'package:igdb_games/presentation/cubit/screenshot/screenshot_cubit.dart';
import 'package:igdb_games/presentation/cubit/screenshot/screenshot_state.dart';
import 'package:igdb_games/presentation/pages/game_detail_page.dart';
import 'package:igdb_games/presentation/widgets/carousel_slider.dart';
import 'package:igdb_games/presentation/widgets/game_mode_dialog.dart';
import 'package:mocktail/mocktail.dart';

class MockScreenShotCubit extends MockBloc<ScreenshotCubit, ScreenShotState>
    implements ScreenshotCubit {}

class MockScreenShotCubitState extends Mock implements ScreenShotState {}

void main() {
  late MockScreenShotCubit screenShotCubit;

  setUpAll(() {
    registerFallbackValue(MockScreenShotCubitState());
    screenShotCubit = MockScreenShotCubit();
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

  group('GameDetailPage', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      when(() => screenShotCubit.state)
          .thenReturn(ScreenShotLoadedState(urls: const ['url']));

      await tester.pumpWidget(BlocProvider<ScreenshotCubit>(
        create: (context) => screenShotCubit..fetchScreenShots(gameId: game.id),
        child: const MaterialApp(
          home: GameDetailPage(game: game),
        ),
      ));

      expect(find.text('Summary:'), findsOneWidget);
      expect(find.text('Storyline:'), findsOneWidget);
      expect(find.text('Screenshots:'), findsOneWidget);
    });

    testWidgets('tapping gamepad icon opens GameModeDialog',
        (WidgetTester tester) async {
      when(() => screenShotCubit.state)
          .thenReturn(ScreenShotLoadedState(urls: const ['url']));

      await tester.pumpWidget(BlocProvider<ScreenshotCubit>(
        create: (context) => screenShotCubit..fetchScreenShots(gameId: game.id),
        child: const MaterialApp(
          home: GameDetailPage(game: game),
        ),
      ));

      await tester.tap(find.byIcon(Icons.gamepad));
      await tester.pump();

      expect(find.byType(GameModeDialog), findsOneWidget);
    });

    testWidgets('shows screenshot carousel when loaded',
        (WidgetTester tester) async {
      when(() => screenShotCubit.state)
          .thenReturn(ScreenShotLoadedState(urls: const ['url']));

      await tester.pumpWidget(BlocProvider<ScreenshotCubit>(
        create: (context) => screenShotCubit..fetchScreenShots(gameId: game.id),
        child: const MaterialApp(
          home: GameDetailPage(game: game),
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(CustomCarouselSlider), findsOneWidget);
    });
  });
}
