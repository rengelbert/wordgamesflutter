import 'package:dart_core/emoji_data.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../config/app_config.dart';
import '../../../service/dictionary.dart';
import '../model/emoji_game_data.dart';
import '../views/emoji_game_screen.dart';
import '../views/emoji_tile.dart';

class EmojiController extends GetxController {
  static const alpha = [
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z',
  ];

  late EmojiGameData _gameModel;
  late final DictionaryService _dictionary;
  late final EmojiWordData _emojiWordData;

  FlameEmojiTile? _selectedTile;
  late FlameEmoji game;

  static const kTileHitArea = 0.6;

  final List<FlameEmojiTile> allTiles = [];

  double tileSize = 0;
  bool _active = true;

  bool get hasUndo => _gameModel.changeHistory.isNotEmpty;

  Future<void> initGame() async {
    _dictionary = DictionaryService();
    await _dictionary.initWithFile('assets/data/dictionary.txt');
    final gameWordsData = await rootBundle.loadString('assets/data/10k.txt');
    final gameWords = <String>[];
    gameWords.addAll(gameWordsData.split('\n'));
    _emojiWordData = EmojiWordData(gameWords);

    ServicesBinding.instance.keyboard.addHandler(_onKey);
  }

  void newGame([int seed = 100]) {
    for (var tile in allTiles) {
      tile.removeFromParent();
    }
    allTiles.clear();
    _selectedTile = null;
    _gameModel = EmojiGameData();
    _emojiWordData.generatePuzzle(5, 0.6, 0.7, 5, 6);
    _gameModel.newGame(_emojiWordData);

    _buildGrid(_emojiWordData.puzzleWords.length, _emojiWordData.longestWord);
  }

  void updateTiles() {
    final over = _gameModel.isGameOver(_dictionary.dictionary);
    if (over) {
      print("GAME OVER");
      _active = false;
      Future.delayed(const Duration(milliseconds: 2000)).then((value) {
        _active = true;
        _selectedTile = null;
        game.newGame();
      });
    }
    _clearSelection();
  }

  void undoChange() {
    _gameModel.undoChange();
    for (var tile in allTiles) {
      if (tile.tileData.emoji.isNotEmpty) {
        tile.updateValue(tile.tileData.input);
      }
    }
  }

  void _buildGrid(int rows, int columns) {
    //make space a fraction of total width
    final h_spc = AppConfig.screenWidth * 0.012;
    final v_spc = AppConfig.screenHeight * 0.035;

    //make horizontal margin (left and right) 10% of screen width
    var hMargin = AppConfig.screenWidth * 0.1;

    //actual width we have for grid (total width - margins)
    var canvasWidth = AppConfig.screenWidth - (2 * hMargin);

    //total horizontal amount taken up by space between tiles
    var totalHorizontalGridSpace = (columns - 1) * h_spc;

    //total vertical amount taken up by space between tiles
    var totalVerticalGridSpace = (rows - 1) * v_spc;

    //the tile size (based on width)
    tileSize = (canvasWidth - totalHorizontalGridSpace) / columns;

    // total width and height of the grid
    final gridHeight = (rows * tileSize) + totalVerticalGridSpace;
    final gridWidth = (columns) * (tileSize) + totalHorizontalGridSpace;

    //the offset position of the grid, here centered, but
    //any other offset can be stated here
    final gridPosition = Vector2(
      (AppConfig.screenWidth - gridWidth) * 0.5,
      (AppConfig.screenHeight - gridHeight) * 0.5,
    );

    var r = 0;

    for (var tiles in _gameModel.wordToTilesMap.values) {
      for (var i = 0; i < tiles.length; i++) {
        var tile = FlameEmojiTile(tileData: tiles[i], tileSize: tileSize);
        tile.position.x = gridPosition.x + (i * (tileSize + h_spc));
        tile.position.y = gridPosition.y + r * (tileSize + v_spc);
        allTiles.add(tile);
        game.add(tile);
      }
      r += 1;
    }
  }

  void _clearSelection() {
    for (var tile in _gameModel.allTiles) tile.selected = false;
  }

  void onTouchDown(Vector2 touch) {
    var tile = _tileClosestToPoint(touch);
    if (tile != null && isTouchingTile(tile, touch)) {
      if (_selectedTile != null) {
        _selectedTile!.tileData.selected = false;
      }
      if (tile.tileData.emoji.isEmpty) return;
      if (tile.tileData.input.isNotEmpty) return;
      _selectedTile = tile;
      _selectedTile!.tileData.selected = true;
      SystemChannels.textInput.invokeMethod("TextInput.show");
    }
  }

  void onLongTouch() {
    SystemChannels.textInput.invokeMethod("TextInput.hide");
    _selectedTile = null;
  }

  bool isTouchingTile(FlameEmojiTile tile, Vector2 point) {
    var distance =
        point.distanceTo(tile.position + Vector2.all(tileSize * 0.5));
    return distance <= tileSize * kTileHitArea;
  }

  FlameEmojiTile? _tileClosestToPoint(Vector2 point) {
    FlameEmojiTile? closest;
    double minDistance = tileSize;
    for (var tile in allTiles) {
      var distance =
          point.distanceTo(tile.position + Vector2.all(tileSize * 0.5));
      if (distance < minDistance) {
        minDistance = distance;
        closest = tile;
      }
    }
    return closest;
  }

  bool _onKey(KeyEvent event) {
    if (_selectedTile == null) {
      return false;
    }
    final key = event.logicalKey.keyLabel;
    if (event is KeyDownEvent) {
      if (alpha.contains(key.toLowerCase())) {
        _selectedTile!.updateValue(key.toUpperCase());
        _gameModel.addChange(_selectedTile!.tileData);
        for (var tile in allTiles) {
          if (tile != _selectedTile! &&
              tile.tileData.emoji.isNotEmpty &&
              tile.tileData.emoji == _selectedTile!.tileData.emoji) {
            tile.updateValue(key.toUpperCase());
          }
        }
        _selectedTile = null;
        updateTiles();

        SystemChannels.textInput.invokeMethod("TextInput.hide");
      }
    }
    return false;
  }
}
