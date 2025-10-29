import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

class ShuffleGameData {
  List<String> _words = [];

  ShuffleGameData._();

  static Future<ShuffleGameData> data() async {
    final data = ShuffleGameData._();
    await data.loadData();
    return data;
  }

  String? getWord() {
    if (_words.isEmpty) return null;
    return _words.removeAt(0).trim().toUpperCase();
    // return _words[0].toUpperCase();
  }

  Future<void> loadData() async {
    final txt = await rootBundle.loadString('assets/data/shuffleWords.txt');
    _words = txt.split('\n');
    _words.shuffle();
  }
}
