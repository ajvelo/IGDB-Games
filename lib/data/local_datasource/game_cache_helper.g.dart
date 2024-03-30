// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_cache_helper.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  GameDao? _gameDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Game` (`id` INTEGER NOT NULL, `name` TEXT NOT NULL, `summary` TEXT NOT NULL, `imageCover` TEXT NOT NULL, `screenshot` TEXT, `storyLine` TEXT, `totalRating` REAL NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  GameDao get gameDao {
    return _gameDaoInstance ??= _$GameDao(database, changeListener);
  }
}

class _$GameDao extends GameDao {
  _$GameDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _gameInsertionAdapter = InsertionAdapter(
            database,
            'Game',
            (Game item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'summary': item.summary,
                  'imageCover': item.imageCover,
                  'screenshot': _stringListConverter.encode(item.screenshot),
                  'storyLine': item.storyLine,
                  'totalRating': item.totalRating
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Game> _gameInsertionAdapter;

  @override
  Future<List<Game>> findAllGames() async {
    return _queryAdapter.queryList('SELECT * FROM Game',
        mapper: (Map<String, Object?> row) => Game(
            id: row['id'] as int,
            name: row['name'] as String,
            imageCover: row['imageCover'] as String,
            storyLine: row['storyLine'] as String?,
            summary: row['summary'] as String,
            totalRating: row['totalRating'] as double,
            screenshot:
                _stringListConverter.decode(row['screenshot'] as String)));
  }

  @override
  Future<List<String>> findAllGamesByName() async {
    return _queryAdapter.queryList('SELECT name FROM Game',
        mapper: (Map<String, Object?> row) => row.values.first as String);
  }

  @override
  Future<Game?> findGameById(int id) async {
    return _queryAdapter.query('SELECT * FROM Game WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Game(
            id: row['id'] as int,
            name: row['name'] as String,
            imageCover: row['imageCover'] as String,
            storyLine: row['storyLine'] as String?,
            summary: row['summary'] as String,
            totalRating: row['totalRating'] as double,
            screenshot:
                _stringListConverter.decode(row['screenshot'] as String)),
        arguments: [id]);
  }

  @override
  Future<void> insertGames(List<Game> games) async {
    await _gameInsertionAdapter.insertList(games, OnConflictStrategy.replace);
  }
}

// ignore_for_file: unused_element
final _stringListConverter = StringListConverter();
