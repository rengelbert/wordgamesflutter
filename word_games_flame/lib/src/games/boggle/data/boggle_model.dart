import 'dart:math';

class BoggleData {
  final Set<String> _wordsFound = {};
  num score = 0;

  void newGame() {
    _wordsFound.clear();
    score = 0;
  }

  bool isNewWord(String word) {
    if (_wordsFound.contains(word)) {
      return false;
    }
    score += pow(2, word.length);
    _wordsFound.add(word);
    return true;
  }
}
