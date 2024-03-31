import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:igdb_games/data/models/screenshot_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  const screenShotModel = ScreenShotModel(
      id: 714,
      gameId: 325,
      url:
          "//images.igdb.com/igdb/image/upload/t_thumb/lcnxec5nvnspzrf10ybd.jpg");

  Future<List<dynamic>> readJson(String fileName) async {
    final String response = await File(fileName).readAsString();
    return await json.decode(response);
  }

  group('Model matches JSON', () {
    test('Model is able to be deserialized', () async {
      final json =
          await readJson('test/data/fixtures/screenshots_fixture.json');
      final screenShotmodels =
          json.map((model) => ScreenShotModel.fromJson(model)).toList();
      final firstResult = screenShotmodels.first;
      expect(screenShotmodels.length, 5);
      expect(firstResult.id, screenShotModel.id);
      expect(firstResult.gameId, screenShotModel.gameId);
      expect(firstResult.url, screenShotModel.url);
    });
  });
}
