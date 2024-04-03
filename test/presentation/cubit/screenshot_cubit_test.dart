import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:igdb_games/core/server_exception.dart';
import 'package:igdb_games/presentation/cubit/screenshot/screenshot_cubit.dart';
import 'package:igdb_games/presentation/cubit/screenshot/screenshot_state.dart';
import 'package:mocktail/mocktail.dart';

import 'game_cubit_test.dart';

void main() {
  final mockGameRepository = MockGameRepository();
  late ScreenshotCubit screenShotCubit;
  const url = 'https://test';

  setUp(() {
    screenShotCubit = ScreenshotCubit(gameRepository: mockGameRepository);
  });
  group('Fetch Screenshots', () {
    test('Initial state should be GameStateInitial', () {
      expect(screenShotCubit.state, ScreenShotInitialState());
    });
    blocTest('fetch games emits corrects states when succesfull',
        build: () {
          when(() => mockGameRepository.fetchScreenShots(gameId: 123))
              .thenAnswer((invocation) async => [url]);
          return screenShotCubit;
        },
        act: (cubit) => screenShotCubit.fetchScreenShots(gameId: 123),
        expect: () => [
              ScreenShotLoadingState(),
              ScreenShotLoadedState(urls: const [url])
            ]);

    blocTest('fetch games emits corrects states when unsuccesfull',
        build: () {
          when(() => mockGameRepository.fetchScreenShots(gameId: 123))
              .thenThrow(ServerException(message: 'Unknown'));
          return screenShotCubit;
        },
        act: (cubit) => screenShotCubit.fetchScreenShots(gameId: 123),
        expect: () =>
            [ScreenShotLoadingState(), ScreenShotErrorState(error: 'Unknown')]);
  });
}
