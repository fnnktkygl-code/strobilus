import 'package:flutter_test/flutter_test.dart';
import 'package:strobilus/data/models/species_model.dart';
import 'dart:io';
import 'dart:convert';

void main() {
  test('fromJson', () {
    final file = File('assets/data/species_seed.json');
    final jsonString = file.readAsStringSync();
    final jsonList = jsonDecode(jsonString) as List<dynamic>;
    for (var e in jsonList) {
      SpeciesModel.fromJson(e);
    }
  });
}
