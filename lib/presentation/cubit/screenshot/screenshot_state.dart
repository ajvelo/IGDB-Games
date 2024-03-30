import 'package:equatable/equatable.dart';

abstract class ScreenShotState extends Equatable {}

class ScreenShotInitialState extends ScreenShotState {
  @override
  List<Object?> get props => [];
}

class ScreenShotLoadingState extends ScreenShotState {
  @override
  List<Object?> get props => [];
}

class ScreenShotLoadedState extends ScreenShotState {
  final List<String> urls;
  ScreenShotLoadedState({required this.urls});
  @override
  List<Object?> get props => [urls];
}

class ScreenShotErrorState extends ScreenShotState {
  final String error;
  ScreenShotErrorState({required this.error});
  @override
  List<Object?> get props => [error];
}
