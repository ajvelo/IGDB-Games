import 'package:equatable/equatable.dart';
import 'package:igdb_games/domain/entities/game_entity.dart';

abstract class GameState extends Equatable {}

class GameInitialState extends GameState {
  @override
  List<Object?> get props => [];
}

class GameLoadingState extends GameState {
  @override
  List<Object?> get props => [];
}

class GameLoadedState extends GameState {
  final List<Game> games;
  final bool inSearch;
  GameLoadedState({required this.games, required this.inSearch});
  @override
  List<Object?> get props => [games, inSearch];
}

class GameErrorState extends GameState {
  final String error;
  GameErrorState({required this.error});
  @override
  List<Object?> get props => [error];
}
