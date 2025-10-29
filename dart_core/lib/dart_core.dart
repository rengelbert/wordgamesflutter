import 'dart:io';

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

Future<List<String>> getWordsFromChars(List<String> chars) async {
  final txt = await File('../assets/data/dictionary.txt').readAsString();
  final words = txt.split('\n');
  final result = <String>[];
  chars.sort();
  for (var word in words) {
    if (word.length > chars.length) continue;
    final wordChars = word.split('')..sort();
    int i = 0;
    int j = 0;
    while (j < chars.length) {
      if (wordChars[i] == chars[j]) {
        i++;
        if (i == wordChars.length) {
          result.add(word);
          break;
        }
      } else if (wordChars[i].compareTo(chars[i]) == -1) {
        break;
      }
      j++;
    }
  }
  return result;
}

// by length
Map<int, List<String>> sortByLength(List<String> wordList) {
  var result = <int, List<String>>{};
  for (var word in wordList) {
    final len = word.length;
    if (!result.containsKey(word.length)) {
      result[len] = [];
    }
    result[len]!.add(word);
  }
  return result;
}

Map<String, List<String>> sortByFirstChar(List<String> wordList) {
  final result = <String, List<String>>{};
  for (var word in wordList) {
    final key = word[0];
    if (!result.containsKey(key)) {
      result[key] = [];
    }
    result[key]!.add(word);
  }
  return result;
}

Map<String, List<String>> sortBySortedLetters(List<String> wordList) {
  final result = <String, List<String>>{};
  for (var word in wordList) {
    final sortedLetters = word.split('')..sort();
    final key = sortedLetters.join();
    if (!result.containsKey(key)) {
      result[key] = [];
    }
    result[key]!.add(word);
  }
  return result;
}

Future<void> getWordYieldData() async {
  final txt = await File('../assets/data/10k.txt').readAsString();
  final words = txt.split('\n');
  final result = <String>[];

  for (var targetWord in words) {
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
    result.add("$targetWord|${wordsFound.length}");
  }

  await File('../assets/data/wordYield.txt').writeAsString(result.join('\n'));
}
