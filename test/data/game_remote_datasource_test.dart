import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:igdb_games/core/server_exception.dart';
import 'package:igdb_games/data/remote_datasource/game_remote_datasource.dart';

void main() {
  final mockDio = Dio(BaseOptions());
  final dioAdapter = DioAdapter(dio: mockDio);

  final gameDataSource = GameRemoteDataSourceImpl(dio: mockDio);
  Future<List<dynamic>> readJson(String fileName) async {
    final String response = await File(fileName).readAsString();
    return await json.decode(response);
  }

  group('Fetch games', () {
    test('Should throw a Server Exception when a 400 is recieved', () async {
      dioAdapter.onPost(
          'https://api.igdb.com/v4/games',
          data: Matchers.any,
          (server) => server.throws(
              400,
              DioException(
                  requestOptions: RequestOptions(),
                  response: Response(
                      requestOptions: RequestOptions(), statusCode: 400))));
      expect(
          () => gameDataSource.fetchGames(),
          throwsA(predicate(
              (p0) => p0 is ServerException && p0.message == '400 error')));
    });

    test(
        'Should throw a Server Exception when an unknown status code is recieved',
        () async {
      dioAdapter.onPost(
          'https://api.igdb.com/v4/games',
          data: Matchers.any,
          (server) => server.throws(
              513,
              DioException(
                  requestOptions: RequestOptions(),
                  response: Response(
                      requestOptions: RequestOptions(), statusCode: 513))));
      expect(
          () => gameDataSource.fetchGames(),
          throwsA(predicate(
              (p0) => p0 is ServerException && p0.message == 'unknown error')));
    });

    test('Should return list of game models with 200 is received', () async {
      final json = await readJson('test/data/fixtures/game_fixtures.json');
      dioAdapter.onPost(
          'https://api.igdb.com/v4/games',
          data: Matchers.any,
          (server) => server.reply(200, json));
      final result = await gameDataSource.fetchGames();
      expect(result.length, 10);
    });
  });

  group('Fetch Screenshots', () {
    test('Should throw a Server Exception when a 400 is recieved', () async {
      dioAdapter.onPost(
          'https://api.igdb.com/v4/screenshots',
          data: Matchers.any,
          (server) => server.throws(
              400,
              DioException(
                  requestOptions: RequestOptions(),
                  response: Response(
                      requestOptions: RequestOptions(), statusCode: 400))));
      expect(
          () => gameDataSource.fetchScreenShots(gameId: 1),
          throwsA(predicate(
              (p0) => p0 is ServerException && p0.message == '400 error')));
    });

    test(
        'Should throw a Server Exception when an unknown status code is recieved',
        () async {
      dioAdapter.onPost(
          'https://api.igdb.com/v4/screenshots',
          data: Matchers.any,
          (server) => server.throws(
              513,
              DioException(
                  requestOptions: RequestOptions(),
                  response: Response(
                      requestOptions: RequestOptions(), statusCode: 513))));
      expect(
          () => gameDataSource.fetchScreenShots(gameId: 1),
          throwsA(predicate(
              (p0) => p0 is ServerException && p0.message == 'unknown error')));
    });

    test('Should return list of game models with 200 is received', () async {
      final json =
          await readJson('test/data/fixtures/screenshots_fixture.json');
      dioAdapter.onPost(
          'https://api.igdb.com/v4/screenshots',
          data: Matchers.any,
          (server) => server.reply(200, json));
      final result = await gameDataSource.fetchScreenShots(gameId: 325);
      expect(result.length, 5);
    });
  });
}
