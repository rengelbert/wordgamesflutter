import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/services.dart';

class WordSplashModel {
  // list of words as they appear on screen
  List<TargetWord> targetWords = [];

  //all target words for current game
  List<String> _allTargetWords = [];

  // the letters we use to create the tiles
  List<String> letterPool = [];

  // shuffled words from our data file
  List<String> _words = [];

  // words found in round
  final List<String> _wordsFound = [];

  late Random _randomGenerator;

  int _wordIndex = 0;
  static int maxTargetWords = 5;

  WordSplashModel._();

  static Future<WordSplashModel> data() async {
    final data = WordSplashModel._();
    await data.loadData();
    return data;
  }

  Future<void> loadData([Random? r]) async {
    final txt = await rootBundle.loadString('assets/data/splashWords.txt');
    _words = txt.split('\n');
    _words.shuffle(r);
  }

  void newRound([int numChars = 5, int seed = 100]) {
    _randomGenerator = Random(seed);
    _wordsFound.clear();
    _getNewLetterPool(numChars);
    _getNewTargets();
  }

  bool isTargetWord(String word) {
    final match = targetWords
        .where((t) => (t.found == false && t.word == word))
        .firstOrNull;
    if (match != null) {
      match.found = true;
      return true;
    }

    return false;
  }

  bool addNewWord(String word) {
    if (!_wordsFound.contains(word)) {
      _wordsFound.add(word);
      return true;
    }
    return false;
  }

  void _getNewLetterPool(int numChars) {
    // find the next available word with the right length
    while (_wordIndex < _words.length) {
      if (_words[_wordIndex].split("|")[0].length == numChars) {
        //use the characters in the word for our tiles
        letterPool = _words[_wordIndex].split("|")[0].split('')..sort();
        //store all possible words generated from pool
        _allTargetWords = _words[_wordIndex].split("|")[1].split(",");
        _wordIndex++;
        break;
      }
      _wordIndex++;
    }
  }

  void _getNewTargets() {
    targetWords.clear();

    if (_allTargetWords.length > maxTargetWords) {
      targetWords = _allTargetWords
          .slice(0, maxTargetWords)
          .map((w) => TargetWord()..word = w)
          .toList();
    } else {
      targetWords = _allTargetWords.map((w) => TargetWord()..word = w).toList();
    }

    // generate hints
    for (var t in targetWords) {
      t.hint = _getHint(t.word);
      print(t.word);
    }
  }

  String _getHint(String word) {
    final index = _randomGenerator.nextInt(word.length);
    String hint = word.split('').mapIndexed((i, c) {
      if (i == index) {
        return word[index].toUpperCase();
      } else {
        return " ";
      }
    }).join();
    return hint;
  }
}

class TargetWord {
  String word = "";
  String hint = "";
  bool found = false;
  String get value => found ? word : hint;
}
