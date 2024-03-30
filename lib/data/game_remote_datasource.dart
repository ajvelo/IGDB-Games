import 'package:dio/dio.dart';
import 'package:igdb_games/core/constants.dart';
import 'package:igdb_games/core/server_exception.dart';
import 'package:igdb_games/data/game_model.dart';

abstract class GameRemoteDatasource {
  Future<List<GameModel>> fetchGames();
}

class GameRemoteDataSourceImpl implements GameRemoteDatasource {
  final Dio dio;

  GameRemoteDataSourceImpl({required this.dio});
  @override
  Future<List<GameModel>> fetchGames() async {
    try {
      final response = await dio.post('https://api.igdb.com/v4/games',
          data:
              "fields cover.url,game_modes.name,name,screenshots.url,storyline,summary,total_rating,url; where cover.url!=null; where storyline!=null; where total_rating!=null; where summary!=null; where url!=null; where name!= null; sort total_rating desc;",
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
        gameModels.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
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

  ServerException _returnError(int statusCode) {
    switch (statusCode) {
      case 400:
        return ServerException(message: '400 error');
      default:
        return ServerException(message: 'unknown error');
    }
  }
}