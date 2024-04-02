import 'package:equatable/equatable.dart';
import 'package:igdb_games/core/status_enum.dart';
import 'package:igdb_games/domain/entities/game_entity.dart';

class GameModel extends Equatable {
  final int id;
  final GameImage cover;
  final List<GameMode> gameModes;
  final String name;
  final String storyline;
  final String summary;
  final double totalRating;
  final int status;

  const GameModel(
      {required this.id,
      required this.cover,
      required this.gameModes,
      required this.name,
      required this.storyline,
      required this.summary,
      required this.totalRating,
      required this.status});

  factory GameModel.fromJson(Map<String, dynamic> json) => GameModel(
      id: json["id"],
      cover: GameImage.fromJson(json["cover"]),
      gameModes: List<GameMode>.from(
          json["game_modes"].map((x) => GameMode.fromJson(x))),
      name: json["name"],
      storyline: json["storyline"],
      summary: json["summary"],
      totalRating: json["total_rating"],
      status: json["status"]);

  @override
  List<Object?> get props =>
      [id, cover, gameModes, name, storyline, summary, status];
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
        storyLine: storyline,
        totalRating: totalRating,
        gameModes: gameModes.map((e) => e.name).toList(),
        status: Status.values.firstWhere((element) => element.value == status),
        key: DateTime.now().millisecondsSinceEpoch);
  }
}
