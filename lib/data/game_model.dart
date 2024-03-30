import 'package:equatable/equatable.dart';
import 'package:igdb_games/domain/game_entity.dart';

class GameModel extends Equatable {
  final int id;
  final GameImage cover;
  final List<GameMode>? gameModes;
  final String name;
  final List<GameImage>? screenshots;
  final String? storyline;
  final String summary;
  final double totalRating;
  final String url;

  const GameModel({
    required this.id,
    required this.cover,
    required this.gameModes,
    required this.name,
    required this.screenshots,
    required this.storyline,
    required this.summary,
    required this.totalRating,
    required this.url,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) => GameModel(
        id: json["id"],
        cover: GameImage.fromJson(json["cover"]),
        gameModes: json["game_modes"] != null
            ? List<GameMode>.from(
                json["game_modes"].map((x) => GameMode.fromJson(x)))
            : null,
        name: json["name"],
        screenshots: json["screenshots"] != null
            ? List<GameImage>.from(
                json["screenshots"].map((x) => GameImage.fromJson(x)))
            : null,
        storyline: json["storyline"],
        summary: json["summary"],
        totalRating: json["total_rating"],
        url: json["url"],
      );

  @override
  List<Object?> get props =>
      [id, cover, gameModes, name, screenshots, storyline, summary, url];
}

class GameImage extends Equatable {
  final int id;
  final String url;

  const GameImage({
    required this.id,
    required this.url,
  });

  factory GameImage.fromJson(Map<String, dynamic> json) => GameImage(
        id: json["id"],
        url: json["url"],
      );

  @override
  List<Object?> get props => [id, url];
}

class GameMode extends Equatable {
  final int id;
  final String name;

  const GameMode({
    required this.id,
    required this.name,
  });

  factory GameMode.fromJson(Map<String, dynamic> json) => GameMode(
        id: json["id"],
        name: json["name"],
      );

  @override
  List<Object?> get props => [id, name];
}

extension GameModelExtension on GameModel {
  Game toEntity() {
    return Game(
        id: id,
        name: name,
        summary: summary,
        imageCover: cover.url,
        screenshot: screenshots?.map((image) => image.url).toList(),
        storyLine: storyline,
        totalRating: totalRating);
  }
}
