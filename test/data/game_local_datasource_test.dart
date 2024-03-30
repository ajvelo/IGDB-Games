import 'package:flutter_test/flutter_test.dart';
import 'package:igdb_games/core/filter.dart';
import 'package:igdb_games/core/server_exception.dart';
import 'package:igdb_games/core/status_enum.dart';
import 'package:igdb_games/data/local_datasource/game_dao.dart';
import 'package:igdb_games/data/local_datasource/game_local_datasource.dart';
import 'package:igdb_games/domain/entities/game_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockGameDao extends Mock implements GameDao {}

void main() {
  final gameDao = MockGameDao();
  final localDataSource = GameLocalDatasourceImpl(dao: gameDao);

  const firstGame = Game(
    status: Status.alpha,
    storyLine: "",
    id: 1,
    name: 'A',
    imageCover: 'imageCover',
    summary: 'summary',
    totalRating: 50.0,
  );
  const secondGame = Game(
    status: Status.alpha,
    storyLine: "",
    id: 1,
    name: 'B',
    imageCover: 'imageCover',
    summary: 'summary',
    totalRating: 20.0,
  );
  const thirdGame = Game(
    status: Status.alpha,
    storyLine: "",
    id: 1,
    name: 'C',
    imageCover: 'imageCover',
    summary: 'summary',
    totalRating: 10.0,
  );

  group('Fetch games', () {
    test('Should throw a Cache Exception when a no games are found', () async {
      when(() => gameDao.findAllGames())
          .thenAnswer((invocation) async => Future.value([]));

      expect(
          () => localDataSource.fetchGames(),
          throwsA(predicate(
              (p0) => p0 is CacheException && p0.message == 'empty')));
    });

    test('Should succesfully return games when they are found', () async {
      when(() => gameDao.findAllGames()).thenAnswer(
          (invocation) async => Future.value([firstGame, secondGame]));

      final result = await localDataSource.fetchGames();

      expect(result.length, 2);
    });
  });

  group('Filter By', () {
    test('Should succesfully filter games by name', () async {
      when(() => gameDao.findAllGames()).thenAnswer((invocation) async =>
          Future.value([secondGame, thirdGame, firstGame]));

      final result = await localDataSource.filterBy(
          filter: FilterEnum.name, isAscending: true);

      expect(result.length, 3);
      expect(result, [firstGame, secondGame, thirdGame]);
    });

    test('Should succesfully filter games by rank', () async {
      when(() => gameDao.findAllGames()).thenAnswer((invocation) async =>
          Future.value([thirdGame, firstGame, secondGame]));

      final result = await localDataSource.filterBy(
          filter: FilterEnum.ranking, isAscending: true);

      expect(result.length, 3);
      expect(result, [firstGame, secondGame, thirdGame]);
    });
  });
}
