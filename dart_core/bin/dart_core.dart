import 'dart:io';
import 'dart:isolate';

import 'package:dart_core/dictionary.dart';
import 'package:dart_core/grid_solver.dart';

void main(List<String> arguments) async {
  // final receivePort = ReceivePort();
  // receivePort.listen(_handleResponsesFromIsolate);
  // await Isolate.spawn(getWordYieldData, receivePort.sendPort);

  // matchesPattern("a--bc-d");

  await gridSolver();
}

Future<void> gridSolver() async {
  final txt = await File('./assets/data/10k.txt').readAsString();
  final d = Dictionary(txt);

  final rows = 4;
  final columns = 3;
  final grid = "airnotareeye";
  GridSolver.solveGrid(
      dictionary: d.words,
      grid: grid,
      rows: rows,
      cols: columns,
      callback: (map) {
        for (var word in map.keys) {
          print(word);
        }
      });
}

List<String> matchesPattern(String pattern, List<String> wordList) {
  String p = pattern.split('').map((char) {
    if (char == "-") return ".";
    return "[$char]";
  }).join();
  final result = <String>[];
  final re = RegExp(p);
  for (var word in wordList) {
    if (word.length != pattern.length) continue;
    if (!re.hasMatch(word)) continue;
    result.add(word);
  }
  return result;
}

void _handleResponsesFromIsolate(dynamic message) async {
  if (message is SendPort) {
  } else if (message is List<String>) {
    await File('../assets/data/wordYield.txt')
        .writeAsString(message.join('\n'));
  }
}

//produces sorted char list and words formed by ALL same chars
Future<void> getCharMap() async {
  final txt = await File('../assets/data/dictionary.txt').readAsString();
  final words = txt.split('\n');
  final result = <String, List<String>>{};
  for (var word in words) {
    final wordChars = word.split('')..sort();
    final sortedWord = wordChars.join();
    if (!result.containsKey(sortedWord)) {
      result[sortedWord] = [];
    }
    result[sortedWord]!.add(word);
  }
  final resultString = <String>[];
  for (var key in result.keys) {
    resultString.add("$key|${result[key].toString()}");
  }

  await File('../assets/data/charMap.txt')
      .writeAsString(resultString.join('\n'));
}

// get all words build with a pool of char
Future<void> getWordYieldData(SendPort port) async {
  final targetData = await File('../assets/data/10kwords.txt').readAsString();
  final targets = targetData.split('\n');

  final wordsData =
      await File('../assets/data/highFrequencyWords.txt').readAsString();
  final words = wordsData.split('\n');
  final result = <String>[];

  for (var targetWord in targets) {
    if (targetWord.length < 3 || targetWord.length > 6) continue;
    final wordsFound = <String>[];
    for (var word in words) {
      if (word.length > targetWord.length) continue;
      int i = 0;
      int j = 0;
      final sortedTarget = targetWord.split('')..sort();
      final sortedWord = word.split('')..sort();

      while (j < sortedTarget.length) {
        if (sortedWord[i] == sortedTarget[j]) {
          i++;
          if (i == sortedWord.length) {
            wordsFound.add(word);
            break;
          }
        } else if (sortedWord[i].compareTo(sortedTarget[i]) == -1) {
          break;
        }
        j++;
      }
    }
    if (wordsFound.length > 5) {
      wordsFound.sort((a, b) {
        return b.length - a.length;
      });
      result.add("$targetWord|${wordsFound.join(',')}");
    }
  }
  port.send(result);
}

/*
select a secret word with 5 chars
calculate percentage of chars in each 10k words that exists in secret word
(this will yield possible words we can use for emoji game)
*/

Future<void> getSecretWords() async {
  final txt = await File('../assets/data/10kwords.txt').readAsString();
  final words = txt.split('\n');
  // pick target word with 5 chars
  words.shuffle();
  final word = words.where((w) => w.length == 5).first;
  print(word);
  //turn word chars into secret chars
  final wordChars = word.split('')..sort();

  final result = <(String, double)>[];
  for (var w in words) {
    var matchedChars = 0;
    if (w.length > 7) continue;
    if (w != word) {
      final sortedWord = w.split('')..sort();
      for (var char in sortedWord) {
        if (wordChars.contains(char)) {
          matchedChars += 1;
        }
      }
    }
    if (matchedChars > 0 && matchedChars < w.length) {
      result
          .add((w, double.parse((matchedChars / w.length).toStringAsFixed(2))));
    }
  }
  result.sort((a, b) {
    if (a.$2 < b.$2) return 1;
    if (a.$2 > b.$2) return -1;
    return 0;
  });

  final eighty = result.where((r) => r.$2 >= 0.8).toList();
  final seventy = result.where((r) => r.$2 >= 0.7 && r.$2 < 0.8).toList();
  final sixty = result.where((r) => r.$2 >= 0.6 && r.$2 < 0.7).toList();
  final fifty = result.where((r) => r.$2 >= 0.5 && r.$2 < 0.6).toList();
  final forty = result.where((r) => r.$2 >= 0.4 && r.$2 < 0.5).toList();
  print(eighty);
  print(seventy);
  print(sixty);
  print(fifty);
  print(forty);
}

bool _isCharMatch(String word, String charPool) {
  int i = 0;
  int j = 0;
  while (j < charPool.length) {
    if (word[i] == charPool[j]) {
      i++;
      if (i == word.length) {
        return true;
      }
    } else if (word[i].compareTo(charPool[i]) == -1) {
      print(1);
      return false;
    }
    j++;
  }
  return false;
}

List<String> wordsFromChars() {
  final result = <String>[];

  final chars = "ace";

  final wordKey = "abcde";

  if (_isCharMatch(chars, wordKey)) {
    print("YES");
  } else {
    print("NO2");
  }

  return result;
}
