import 'package:floor/floor.dart';
import 'package:igdb_games/data/local_datasource/game_dao.dart';
import 'package:igdb_games/domain/game_entity.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'game_cache_helper.g.dart';

@Database(version: 1, entities: [Game])
@TypeConverters([StringListConverter])
abstract class AppDatabase extends FloorDatabase {
  GameDao get gameDao;
}
