import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';
import 'package:igdb_games/core/status_enum.dart';

@entity
class Game extends Equatable {
  @primaryKey
  final int id;
  final String name;
  final String summary;
  final String imageCover;
  final List<String> screenshot;
  final String storyLine;
  final double totalRating;
  final Status status;

  const Game(
      {required this.id,
      required this.name,
      required this.imageCover,
      required this.storyLine,
      required this.summary,
      required this.totalRating,
      required this.screenshot,
      required this.status});

  @override
  List<Object?> get props => [
        id,
        name,
        summary,
        screenshot,
        totalRating,
        imageCover,
        storyLine,
        status
      ];
}
