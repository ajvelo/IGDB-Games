import 'package:flutter_test/flutter_test.dart';
import 'package:igdb_games/core/filter.dart';
import 'package:igdb_games/core/server_exception.dart';
import 'package:igdb_games/core/status_enum.dart';
import 'package:igdb_games/data/models/game_model.dart';
import 'package:igdb_games/data/models/screenshot_model.dart';
import 'package:igdb_games/data/remote_datasource/game_remote_datasource.dart';
import 'package:igdb_games/data/game_repository.dart';
import 'package:igdb_games/data/local_datasource/game_local_datasource.dart';
import 'package:igdb_games/domain/entities/game_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock implements GameRemoteDatasource {}

class MockLocalDataSource extends Mock implements GameLocalDatasource {}

void main() {
  final mockRemoteDataSource = MockRemoteDataSource();
  final mockLocalDataSource = MockLocalDataSource();
  const game = Game(
    storyLine: 'storyLine',
    id: 1,
    name: 'name',
    imageCover: 'imageCover',
    summary: 'summary',
    status: Status.alpha,
    totalRating: 0.0,
  );
  const secondGame = Game(
    storyLine: 'storyLine',
    id: 1,
    name: 'Z',
    imageCover: 'imageCover',
    summary: 'summary',
    status: Status.alpha,
    totalRating: 10.0,
  );
  const gameMode = GameMode(id: 1, name: 'name');
  const gameModel = GameModel(
      id: 1,
      cover: GameImage(id: 1, url: 'imageCover'),
      gameModes: [gameMode],
      name: 'name',
      storyline: 'storyLine',
      summary: 'summary',
      totalRating: 0.0,
      status: 2);
  const screenShotModel = ScreenShotModel(
      id: 714,
      gameId: 325,
      url:
          "//images.igdb.com/igdb/image/upload/t_thumb/lcnxec5nvnspzrf10ybd.jpg");
  final repository = GameRepositoryImpl(
      localDatasource: mockLocalDataSource,
      remoteDatasource: mockRemoteDataSource);

  group('Fetch Games', () {
    test('Fetch games returns list of games when successful', () async {
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
    test('Calls Fetch games on CacheException when games are empty', () async {
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

    test('Throws ServerException when remote data source fails', () async {
      when(() => mockRemoteDataSource.fetchGames())
          .thenThrow(ServerException(message: 'error'));

      try {
        await repository.fetchGames(isRefresh: true);
      } catch (e) {
        expect(e, isA<ServerException>());
        expect((e as ServerException).message, 'error');
      }
    });
  });

  group('Filter By', () {
    test('Should call local data source to filter games', () async {
      when(() => mockLocalDataSource.filterBy(
          filter: FilterEnum.name,
          isAscending: true)).thenAnswer((invocation) async => [game]);

      await repository.filterBy(filter: FilterEnum.name, isAscending: true);

      verify(() => mockLocalDataSource.filterBy(
          filter: FilterEnum.name, isAscending: true)).called(1);
    });
    test('Should successfully return ordered games by name', () async {
      when(() => mockLocalDataSource.filterBy(
              filter: FilterEnum.name, isAscending: true))
          .thenAnswer((invocation) async => [game, secondGame]);

      final result =
          await repository.filterBy(filter: FilterEnum.name, isAscending: true);

      expect(result, [game, secondGame]);
    });
  });

  group('Fetch Screnshots', () {
    test('Fetch screenshots returns list of games when successful', () async {
      when(() => mockRemoteDataSource.fetchScreenShots(gameId: 325))
          .thenAnswer((_) async => [screenShotModel]);

      final result = await repository.fetchScreenShots(gameId: 325);

      verify(() => mockRemoteDataSource.fetchScreenShots(gameId: 325))
          .called(1);
      expect(result.length, 1);
      expect(result.first, screenShotModel.url);
    });
    test('Calls throw ServerException when remote data source fails', () async {
      when(() => mockRemoteDataSource.fetchScreenShots(gameId: 325))
          .thenThrow(ServerException(message: 'error'));

      try {
        await repository.fetchScreenShots(gameId: 325);
      } catch (e) {
        expect(e, isA<ServerException>());
        expect((e as ServerException).message, 'error');
      }
    });
  });
}
