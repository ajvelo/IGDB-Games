import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:igdb_games/core/filter.dart';
import 'package:igdb_games/core/server_exception.dart';
import 'package:igdb_games/core/status_enum.dart';
import 'package:igdb_games/domain/entities/game_entity.dart';
import 'package:igdb_games/domain/game_repostiory_abstract.dart';
import 'package:igdb_games/presentation/cubit/game/game_cubit.dart';
import 'package:igdb_games/presentation/cubit/game/game_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGameRepository extends Mock implements GameRepository {}

void main() {
  final mockGameRepository = MockGameRepository();
  late GameCubit gameCubit;
  const game = Game(
    key: 1,
    storyLine: 'storyLine',
    gameModes: ['url'],
    id: 1,
    name: 'name',
    imageCover: 'imageCover',
    summary: 'summary',
    status: Status.alpha,
    totalRating: 0.0,
  );

  setUp(() {
    gameCubit = GameCubit(gameRepository: mockGameRepository);
  });
  group('Fetch Games', () {
    test('Initial state should be GameStateInitial', () {
      expect(gameCubit.state, GameInitialState());
    });
    blocTest('fetch games emits corrects states when succesfull',
        build: () {
          when(() => mockGameRepository.fetchGames(
              page: 0,
              isRefresh: false,
              statusValue: null)).thenAnswer((invocation) async => [game]);
          return gameCubit;
        },
        act: (cubit) =>
            gameCubit.fetchGames(isRefresh: false, statusValue: null, page: 0),
        expect: () => [
              GameLoadingState(),
              GameLoadedState(games: const [game], inSearch: false)
            ]);

    blocTest('fetch games emits corrects states when unsuccesfull',
        build: () {
          when(() => mockGameRepository.fetchGames(
              isRefresh: false,
              statusValue: null,
              page: 0)).thenThrow(ServerException(message: 'Unknown'));
          return gameCubit;
        },
        act: (cubit) =>
            gameCubit.fetchGames(isRefresh: false, statusValue: null, page: 0),
        expect: () => [GameLoadingState(), GameErrorState(error: 'Unknown')]);
  });

  group('Filter By', () {
    test('Initial state should be GameStateInitial', () {
      expect(gameCubit.state, GameInitialState());
    });
    blocTest('filter by emits corrects states when succesfull',
        build: () {
          when(() => mockGameRepository.filterBy(
              filter: FilterEnum.name,
              statusValue: null,
              isAscending: true)).thenAnswer((invocation) async => [game]);
          return gameCubit;
        },
        act: (cubit) => gameCubit.filterBy(
            filter: FilterEnum.name, isAscending: true, statusValue: null),
        expect: () => [
              GameLoadingState(),
              GameLoadedState(games: const [game], inSearch: false)
            ]);

    blocTest('filter by emits corrects states when unsuccesfull',
        build: () {
          when(() => mockGameRepository.filterBy(
              filter: FilterEnum.name,
              statusValue: null,
              isAscending: true)).thenThrow(CacheException(message: 'Unknown'));
          return gameCubit;
        },
        act: (cubit) => gameCubit.filterBy(
            filter: FilterEnum.name, isAscending: true, statusValue: null),
        expect: () => [GameLoadingState(), GameErrorState(error: 'Unknown')]);
  });

  group('Search By Name', () {
    blocTest('search by name emits corrects states when succesfull',
        build: () {
          when(() => mockGameRepository.searchForGames(
                text: 'text',
                statusValue: null,
              )).thenAnswer((invocation) async => [game]);
          return gameCubit;
        },
        act: (cubit) =>
            gameCubit.searchForGames(text: 'text', statusValue: null),
        expect: () => [
              GameLoadedState(games: const [game], inSearch: true)
            ]);

    blocTest('seacrch by name emits corrects states when succesfull',
        build: () {
          when(() => mockGameRepository.searchForGames(
                text: 'text',
                statusValue: null,
              )).thenAnswer((invocation) async => []);
          return gameCubit;
        },
        act: (cubit) =>
            gameCubit.searchForGames(text: 'text', statusValue: null),
        expect: () => [GameLoadedState(games: const [], inSearch: true)]);
  });
}
