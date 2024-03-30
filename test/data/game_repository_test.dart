import 'package:flutter_test/flutter_test.dart';
import 'package:igdb_games/core/server_exception.dart';
import 'package:igdb_games/data/game_model.dart';
import 'package:igdb_games/data/game_remote_datasource.dart';
import 'package:igdb_games/data/game_repository.dart';
import 'package:igdb_games/data/local_datasource/game_local_datasource.dart';
import 'package:igdb_games/domain/game_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock implements GameRemoteDatasource {}

class MockLocalDataSource extends Mock implements GameLocalDatasource {}

void main() {
  final mockRemoteDataSource = MockRemoteDataSource();
  final mockLocalDataSource = MockLocalDataSource();
  const game = Game(
    screenshot: null,
    storyLine: null,
    id: 1,
    name: 'name',
    imageCover: 'imageCover',
    summary: 'summary',
    totalRating: 0.0,
  );
  const gameModel = GameModel(
      id: 1,
      cover: GameImage(id: 1, url: 'imageCover'),
      gameModes: null,
      name: 'name',
      screenshots: null,
      storyline: null,
      summary: 'summary',
      totalRating: 0.0,
      url: 'url');
  final repository = GameRepositoryImpl(
      localDatasource: mockLocalDataSource,
      remoteDatasource: mockRemoteDataSource);

  group('Fetch Games', () {
    test('Fetch posts returns list of posts when successful', () async {
      when(() => mockRemoteDataSource.fetchGames())
          .thenAnswer((_) async => [gameModel]);
      when(() => mockLocalDataSource.saveGames([game]))
          .thenAnswer((invocation) => Future.value());

      final result = await repository.fetchGames(isRefresh: true);

      verify(() => mockRemoteDataSource.fetchGames()).called(1);
      verify(() => mockLocalDataSource.saveGames([game])).called(1);
      expect(result.length, 1);
      expect(result.first, game);
    });
    test('Calls Fetch posts on CacheException when games are empty', () async {
      when(() => mockRemoteDataSource.fetchGames())
          .thenAnswer((_) async => [gameModel]);
      when(() => mockLocalDataSource.fetchGames())
          .thenThrow(CacheException(message: 'empty'));
      when(() => mockLocalDataSource.saveGames([game]))
          .thenAnswer((invocation) => Future.value());

      final result = await repository.fetchGames(isRefresh: false);

      verify(() => mockLocalDataSource.fetchGames()).called(1);
      verify(() => mockRemoteDataSource.fetchGames()).called(1);
      expect(result.length, 1);
      expect(result.first, game);
    });
  });
}
