import 'package:equatable/equatable.dart';

class ScreenShotModel extends Equatable {
  final int id;
  final int gameId;
  final String url;

  const ScreenShotModel(
      {required this.id, required this.gameId, required this.url});

  factory ScreenShotModel.fromJson(Map<String, dynamic> json) =>
      ScreenShotModel(id: json["id"], gameId: json["game"], url: json["url"]);

  @override
  List<Object?> get props => [id, gameId, url];
}
