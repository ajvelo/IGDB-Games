import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

class StringListConverter extends TypeConverter<List<String>?, String> {
  @override
  List<String>? decode(String? databaseValue) {
    if (databaseValue == null) {
      return null;
    } else {
      final jsonFile = json.decode(databaseValue);
      return jsonFile['screenshots'] != null
          ? List<String>.from(jsonFile['screenshots']).toList()
          : null;
    }
  }

  @override
  String encode(List<String>? value) {
    final data = <String, dynamic>{};
    data.addAll({'screenshots': value});
    return json.encode(data);
  }
}

@entity
class Game extends Equatable {
  @primaryKey
  final int id;
  final String name;
  final String summary;
  final String imageCover;
  final List<String>? screenshot;
  final String? storyLine;
  final double totalRating;

  const Game(
      {required this.id,
      required this.name,
      required this.imageCover,
      required this.storyLine,
      required this.summary,
      required this.totalRating,
      required this.screenshot});

  @override
  List<Object?> get props =>
      [id, name, summary, screenshot, totalRating, imageCover, storyLine];
}
