import 'package:dio/dio.dart';
import 'package:igdb_games/core/constants.dart';
import 'package:igdb_games/core/server_exception.dart';
import 'package:igdb_games/data/models/game_model.dart';
import 'package:igdb_games/data/models/screenshot_model.dart';

abstract class GameRemoteDatasource {
  Future<List<GameModel>> fetchGames(
      {required int? statusValue, required int page});
  Future<List<ScreenShotModel>> fetchScreenShots({required int gameId});
}

class GameRemoteDataSourceImpl implements GameRemoteDatasource {
  final Dio dio;

  GameRemoteDataSourceImpl({required this.dio});
  @override
  Future<List<GameModel>> fetchGames(
      {required int? statusValue, required int page}) async {
    try {
      final response = await dio.post('https://api.igdb.com/v4/games',
          data:
              "fields cover.url,game_modes.name,status,name,screenshots,storyline,summary,total_rating,url; where cover.url!=null & storyline!=null & total_rating!=null & screenshots!=null & summary!=null & name!= null & ${statusValue != null ? 'status=$statusValue' : 'status!=null'} & game_modes.name !=null; limit 5; offset ${page * 5};",
          options: Options(headers: {
            'Client-ID': Constants.clientId,
            'Authorization': 'Bearer ${Constants.token}'
          }));
      if (response.statusCode != 200) {
        throw _returnError(response.statusCode!);
      } else {
        final List<dynamic> result = response.data;

        final gameModels =
            result.map((json) => GameModel.fromJson(json)).toList();
        return gameModels;
      }
    } catch (e) {
      if (e is DioException) {
        throw _returnError(e.response!.statusCode!);
      }
      if (e is ServerException) rethrow;
      throw e.toString();
    }
  }

  @override
  Future<List<ScreenShotModel>> fetchScreenShots({required int gameId}) async {
    try {
      final response = await dio.post('https://api.igdb.com/v4/screenshots',
          data:
              "fields url, game; where url!=null & game!=null; where game = ($gameId);",
          options: Options(headers: {
            'Client-ID': Constants.clientId,
            'Authorization': 'Bearer ${Constants.token}'
          }));
      if (response.statusCode != 200) {
        throw _returnError(response.statusCode!);
      } else {
        final List<dynamic> result = response.data;

        final screenShotModels =
            result.map((json) => ScreenShotModel.fromJson(json)).toList();
        return screenShotModels;
      }
    } catch (e) {
      if (e is DioException) {
        throw _returnError(e.response!.statusCode!);
      }
      if (e is ServerException) rethrow;
      throw e.toString();
    }
  }

  ServerException _returnError(int statusCode) {
    switch (statusCode) {
      case 400:
        return ServerException(message: '400 error');
      default:
        return ServerException(message: 'unknown error');
    }
  }
}
