import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:igdb_games/core/filter.dart';
import 'package:igdb_games/core/server_exception.dart';
import 'package:igdb_games/core/status_enum.dart';
import 'package:igdb_games/domain/game_entity.dart';
import 'package:igdb_games/domain/game_repostiory_abstract.dart';
import 'package:igdb_games/presentation/cubit/game_cubit.dart';
import 'package:igdb_games/presentation/cubit/game_state.dart';
import 'package:mocktail/mocktail.dart';

class MockPostRepository extends Mock implements GameRepository {}

void main() {
  final mockPostRepository = MockPostRepository();
  late GameCubit gameCubit;
  const game = Game(
    screenshot: ['screenshot'],
    storyLine: 'storyLine',
    id: 1,
    name: 'name',
    imageCover: 'imageCover',
    summary: 'summary',
    status: Status.alpha,
    totalRating: 0.0,
  );

  setUp(() {
    gameCubit = GameCubit(gameRepository: mockPostRepository);
  });
  group('Fetch Games', () {
    test('Initial state should be GameStateInitial', () {
      expect(gameCubit.state, GameInitialState());
    });
    blocTest('fetch games emits corrects states when succesfull',
        build: () {
          when(() => mockPostRepository.fetchGames(isRefresh: false))
              .thenAnswer((invocation) async => [game]);
          return gameCubit;
        },
        act: (cubit) => gameCubit.fetchGames(isRefresh: false),
        expect: () => [
              GameLoadingState(),
              GameLoadedState(games: const [game])
            ]);

    blocTest('fetch games emits corrects states when unsuccesfull',
        build: () {
          when(() => mockPostRepository.fetchGames(isRefresh: false))
              .thenThrow(ServerException(message: 'Unknown'));
          return gameCubit;
        },
        act: (cubit) => gameCubit.fetchGames(isRefresh: false),
        expect: () => [GameLoadingState(), GameErrorState(error: 'Unknown')]);
  });

  group('Filter By', () {
    test('Initial state should be GameStateInitial', () {
      expect(gameCubit.state, GameInitialState());
    });
    blocTest('filter by  emits corrects states when succesfull',
        build: () {
          when(() => mockPostRepository.filterBy(
              filter: FilterEnum.name,
              isAscending: true)).thenAnswer((invocation) async => [game]);
          return gameCubit;
        },
        act: (cubit) =>
            gameCubit.filterBy(filter: FilterEnum.name, isAscending: true),
        expect: () => [
              GameLoadingState(),
              GameLoadedState(games: const [game])
            ]);

    blocTest('filter by emits corrects states when unsuccesfull',
        build: () {
          when(() => mockPostRepository.filterBy(
              filter: FilterEnum.name,
              isAscending: true)).thenThrow(CacheException(message: 'Unknown'));
          return gameCubit;
        },
        act: (cubit) =>
            gameCubit.filterBy(filter: FilterEnum.name, isAscending: true),
        expect: () => [GameLoadingState(), GameErrorState(error: 'Unknown')]);
  });
}
