import 'package:flutter_test/flutter_test.dart';
import 'package:igdb_games/core/server_exception.dart';
import 'package:igdb_games/core/status_enum.dart';
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
    screenshot: ['screenshot'],
    storyLine: 'storyLine',
    id: 1,
    name: 'name',
    imageCover: 'imageCover',
    summary: 'summary',
    status: Status.alpha,
    totalRating: 0.0,
  );
  const gameMode = GameMode(id: 1, name: 'name');
  const gameImage = GameImage(id: 1, url: 'screenshot');
  const gameModel = GameModel(
      id: 1,
      cover: GameImage(id: 1, url: 'imageCover'),
      gameModes: [gameMode],
      name: 'name',
      screenshots: [gameImage],
      storyline: 'storyLine',
      summary: 'summary',
      totalRating: 0.0,
      status: 2,
      url: 'url');
  final repository = GameRepositoryImpl(
      localDatasource: mockLocalDataSource,
      remoteDatasource: mockRemoteDataSource);

  group('Fetch Games', () {
    test('Fetch posts returns list of posts when successful', () async {
      when(() => mockRemoteDataSource.fetchGames())
          .thenAnswer((_) async => [gameModel]);
      when(() => mockLocalDataSource.saveGames([game]))
          .thenAnswer((invocation) async => Future.value());

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
