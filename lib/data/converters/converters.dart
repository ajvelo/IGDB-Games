import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:igdb_games/core/status_enum.dart';

class StatusIntConverter extends TypeConverter<Status, String> {
  @override
  Status decode(String databaseValue) {
    final jsonFile = json.decode(databaseValue);
    return Status.values
        .firstWhere((element) => element.value == jsonFile["status"]);
  }

  @override
  String encode(Status value) {
    final data = <String, dynamic>{};
    data.addAll({'status': value.value});
    return json.encode(data);
  }
}

class StringListConverter extends TypeConverter<List<String>, String> {
  @override
  List<String> decode(String databaseValue) {
    final jsonFile = json.decode(databaseValue);
    return List<String>.from(jsonFile['gamemodes']).toList();
  }

  @override
  String encode(List<String> value) {
    final data = <String, dynamic>{};
    data.addAll({'gamemodes': value});
    return json.encode(data);
  }
}
