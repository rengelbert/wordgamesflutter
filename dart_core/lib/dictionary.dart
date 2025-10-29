import 'dart:math';

class Dictionary {
  final List<String> _words = [];
  Map<String, List<String>> _wordsToChars = {};
  final Random _rng = Random();

  List<String> get words => _words;

  Dictionary(String data) {
    _words.addAll(data.split('\n'));

    //create map of sorted word chars to array of all words made with the same chars
    for (var word in _words) {
      final keyList = word.split('');
      keyList.sort();
      final key = keyList.join();
      if (!_wordsToChars.containsKey(key)) {
        _wordsToChars[key] = [];
      }
      _wordsToChars[key]!.add(word);
    }
  }

  String getWord() => _words[_rng.nextInt(_words.length)];

  String? getWordWithLength(int length) {
    return _words.where((w) => w.length == length).firstOrNull;
  }

  bool isWord(String word) => _words.contains(word);

  List<String> randomChars(int count) {
    var result = <String>[];

    const v = 'aeiou';
    const c = 'bcdfghjklmnpqrstvwxyz';
    final totalVowels = (count * 0.5).ceil();
    final totalConsonants = count - totalVowels;

    var i = 0;
    while (i < totalVowels) {
      result.add(v[_rng.nextInt(v.length)]);
      i++;
    }
    i = 0;
    while (i < totalConsonants) {
      result.add(c[_rng.nextInt(c.length)]);
      i++;
    }

    result.shuffle();

    return result;
  }

  List<String> wordsFromChars(List<String> charsList) {
    final result = <String>[];
    charsList.sort();

    final chars = charsList.join();

    for (var wordKey in _wordsToChars.keys) {
      if (wordKey.length > chars.length) continue;

      final p = "^[$wordKey]+\$";
      final re = RegExp(p);
      if (!re.hasMatch(chars)) {
        continue;
      }
      if (_isCharMatch(chars, wordKey)) {
        result.addAll(_wordsToChars[wordKey]!);
      }
    }

    return result;
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
        return false;
      }
      j++;
    }
    return false;
  }
}
