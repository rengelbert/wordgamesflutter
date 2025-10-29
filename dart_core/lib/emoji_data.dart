import 'dart:collection';

class EmojiWordData {
  final List<String> _gameWords;
  final List<String> letterPool = [];
  final List<String> puzzleWords = [];
  int longestWord = 0;
  EmojiWordData(this._gameWords);

  void generatePuzzle(
      [int numWords = 5,
      double similarity = 0.6,
      double uniqueRatio = 0.7,
      int baseLength = 5,
      int maxLength = 6,
      int minLength = 3]) {
    _gameWords.shuffle();
    letterPool.clear();
    puzzleWords.clear();

    // pick base word
    for (var word in _gameWords) {
      if (word.length == baseLength &&
          _ratioUniqueLetters(word) > uniqueRatio) {
        final s = HashSet<String>.from(word.split(''));
        letterPool.addAll(s.toList());
        puzzleWords.add(word);
        longestWord = word.length;
        break;
      }
    }

    // pick other puzzle words
    for (var word in _gameWords) {
      if (puzzleWords.length == numWords) break;
      if (word.length < minLength || word.length > maxLength) continue;
      if (!puzzleWords.contains(word)) {
        final sim = _ratioPoolLetters(word);
        if (sim > similarity) {
          puzzleWords.add(word);
          if (word.length > longestWord) {
            longestWord = word.length;
          }
        }
      }
    }
  }

  double _ratioUniqueLetters(String word) {
    final s = HashSet<String>()..addAll(word.split(''));
    return s.length / word.length;
  }

  double _ratioPoolLetters(String word) {
    final overlap =
        word.split('').where((char) => letterPool.contains(char)).toList();
    return overlap.length / word.length;
  }
}
