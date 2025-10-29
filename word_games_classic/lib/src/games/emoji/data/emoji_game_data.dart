import 'package:dart_core/dictionary.dart';
import 'package:dart_core/emoji_data.dart';

import 'tile_data.dart';

class EmojiGameData {
  List<String> emoji = [
    "😀",
    "😶",
    "🤢",
    "🥶",
    "😎",
    "😭",
    "😡",
    "😈",
    "👽",
    "🤘",
    "🙏",
    "👂",
    "🧠",
    "👄"
  ];

  late EmojiWordData puzzleData;
  Map<String, String> emojiMap = {};
  List<EmojiTileData> allTiles = [];
  List<List<EmojiTileData>> wordTiles = [];
  Map<String, List<EmojiTileData>> wordToTilesMap = {};
  List<EmojiTileData> changeHistory = [];

  void addChange(EmojiTileData tileData) {
    changeHistory.add(tileData);
  }

  void undoChange() {
    if (changeHistory.isEmpty) return;
    final tile = changeHistory.removeLast();
    for (var otherTile in allTiles) {
      if (otherTile.emoji.isNotEmpty && otherTile.emoji == tile.emoji) {
        otherTile.input = "";
      }
    }
  }

  bool _isWordComplete(List<EmojiTileData> tiles) {
    for (var tile in tiles) {
      if (tile.input.isEmpty && tile.emoji.isNotEmpty) return false;
    }
    return true;
  }

  String _spelledWord(List<EmojiTileData> tiles) {
    return tiles
        .map((tile) => tile.input.isNotEmpty && tile.emoji.isNotEmpty
            ? tile.input
            : tile.value)
        .join()
        .toLowerCase();
  }

  bool isGameOver(Dictionary dictionary) {
    for (var word in wordToTilesMap.keys) {
      final tiles = wordToTilesMap[word]!;
      for (var tile in tiles) {
        tile.incorrect = false;
      }
      if (!_isWordComplete(tiles)) return false;
      final spelledWord = _spelledWord(tiles);
      if (spelledWord != word && !dictionary.isWord(spelledWord)) {
        for (var tile in tiles) {
          tile.incorrect = true;
        }
        return false;
      }
    }
    return true;
  }

  void newGame(EmojiWordData puzzleData) {
    this.puzzleData = puzzleData;
    for (var char in puzzleData.letterPool) {
      emojiMap[char] = emoji.removeAt(0);
    }

    for (var word in puzzleData.puzzleWords) {
      print(word);
      wordTiles.add(<EmojiTileData>[]);
      wordTiles.last.addAll(word.split('').map((char) {
        final tile = EmojiTileData()
          ..word = word
          ..value = char
          ..emoji = emojiMap[char] ?? "";

        allTiles.add(tile);
        return tile;
      }));
      wordToTilesMap[word] = wordTiles.last;
    }
  }
}
