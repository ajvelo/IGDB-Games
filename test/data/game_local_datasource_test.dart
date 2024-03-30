import 'package:flutter_test/flutter_test.dart';
import 'package:igdb_games/core/server_exception.dart';
import 'package:igdb_games/core/status_enum.dart';
import 'package:igdb_games/data/local_datasource/game_dao.dart';
import 'package:igdb_games/data/local_datasource/game_local_datasource.dart';
import 'package:igdb_games/domain/game_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockGameDao extends Mock implements GameDao {}

void main() {
  final gameDao = MockGameDao();
  final localDataSource = GameLocalDatasourceImpl(dao: gameDao);

  const game = Game(
    screenshot: [""],
    status: Status.alpha,
    storyLine: "",
    id: 1,
    name: 'name',
    imageCover: 'imageCover',
    summary: 'summary',
    totalRating: 0.0,
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
      when(() => gameDao.findAllGames())
          .thenAnswer((invocation) async => Future.value([game]));

      final result = await localDataSource.fetchGames();

      expect(result.length, 1);
      expect(result.first, game);
    });
  });
}
