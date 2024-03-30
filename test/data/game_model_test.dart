import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:igdb_games/data/game_model.dart';
import 'package:igdb_games/domain/game_entity.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  const gameModel = GameModel(
      id: 287454,
      storyline: null,
      cover: GameImage(
          id: 363074,
          url: "//images.igdb.com/igdb/image/upload/t_thumb/co7s5e.jpg"),
      gameModes: [GameMode(id: 2, name: "Multiplayer")],
      name: "RGG Land",
      screenshots: [
        GameImage(
            id: 1243607,
            url: "//images.igdb.com/igdb/image/upload/t_thumb/scqnkn.jpg"),
        GameImage(
            id: 1243608,
            url: "//images.igdb.com/igdb/image/upload/t_thumb/scqnko.jpg"),
        GameImage(
            id: 1243609,
            url: "//images.igdb.com/igdb/image/upload/t_thumb/scqnkp.jpg"),
        GameImage(
            id: 1243610,
            url: "//images.igdb.com/igdb/image/upload/t_thumb/scqnkq.jpg"),
      ],
      summary:
          "RGG Land is an online multiplayer board game where the goal is to reach the final square faster than other players. Rats, gremlins, teleporters (and some elevators) — it's all there in RGG Land.",
      totalRating: 100.0,
      url: "https://www.igdb.com/games/rgg-land--2");

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
      expect(firstResult.cover, gameModel.cover);
      expect(firstResult.screenshots, gameModel.screenshots);
      expect(firstResult.gameModes, gameModel.gameModes);
      expect(firstResult.url, gameModel.url);
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
      expect(game.screenshot, gameModel.screenshots?.map((e) => e.url));
    });
  });
}
