import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:igdb_games/data/game_model.dart';
import 'package:igdb_games/domain/game_entity.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  const gameModel = GameModel(
      id: 325,
      storyline: "storyline",
      cover: GameImage(
          id: 94918,
          url: "//images.igdb.com/igdb/image/upload/t_thumb/co218m.jpg"),
      gameModes: [GameMode(id: 1, name: "Single player")],
      name: "Hellgate: London",
      status: 5,
      screenshots: [
        GameImage(
            id: 710,
            url:
                "//images.igdb.com/igdb/image/upload/t_thumb/r4gzsrbgwlqvdm3u64sl.jpg"),
      ],
      summary: "summary",
      totalRating: 74.82126012744726);

  Future<List<dynamic>> readJson(String fileName) async {
    final String response = await File(fileName).readAsString();
    return await json.decode(response);
  }

  group('Model matches JSON', () {
    test('Model is able to be deserialized', () async {
      final json = await readJson('test/data/game_fixtures.json');
      final gameModels =
          json.map((postModel) => GameModel.fromJson(postModel)).toList();
      final firstResult = gameModels.first;
      expect(gameModels.length, 10);
      expect(firstResult.totalRating, gameModel.totalRating);
      expect(firstResult.id, gameModel.id);
      expect(firstResult.status, gameModel.status);
      expect(firstResult.cover, gameModel.cover);
      expect(firstResult.screenshots, gameModel.screenshots);
      expect(firstResult.gameModes, gameModel.gameModes);
      expect(firstResult.name, gameModel.name);
      expect(firstResult.storyline, gameModel.storyline);
    });

    test('Model can be mapped to an entity', () async {
      final game = gameModel.toEntity();
      expect(game, isA<Game>());
      expect(game.totalRating, gameModel.totalRating);
      expect(game.id, gameModel.id);
      expect(game.totalRating, gameModel.totalRating);
      expect(game.name, gameModel.name);
      expect(game.storyLine, gameModel.storyline);
      expect(game.summary, gameModel.summary);
      expect(game.screenshot, gameModel.screenshots.map((e) => e.url));
    });
  });
}
