import 'package:collection/collection.dart';
import 'package:flame/extensions.dart';
import '../../../config/app_config.dart';
import '../../../config/app_theme.dart';
import '../data/shuffle_model.dart';
import '../views/flame_shuffle_game.dart';
import '../views/flame_suffle_tile.dart';

class ShuffleController {
  late final ShuffleGameData _gameData;
  late FlameShuffle game;

  List<FlameShuffleTile> tiles = [];

  String? _targetWord = "";
  FlameShuffleTile? _selectedTile;

  Future<void> initGame() async {
    _gameData = await ShuffleGameData.data();
  }

  void selectTile(FlameShuffleTile tile) {
    if (_selectedTile == null) {
      _selectedTile = tile;
      tile.updateTileType(TileType.selected);
    } else {
      if (tile == _selectedTile) {
        tile.updateTileType(TileType.normal);
        _selectedTile = null;
        return;
      }
      _swapTile(tile);
      _checkTiles();
      _selectedTile = null;
    }
  }

  void _swapTile(FlameShuffleTile targetTile) {
    final selectedValue = _selectedTile!.value;
    _selectedTile!.value = targetTile.value;
    _selectedTile!.label.text = _selectedTile!.value;
    targetTile.value = selectedValue;
    targetTile.label.text = targetTile.value;
  }

  void loadWord() {
    _targetWord = _gameData.getWord();
    if (_targetWord != null) {
      _buildRow();
      _checkTiles();
    }
  }

  void _checkTiles() {
    tiles = tiles.mapIndexed((i, tile) {
      if (_targetWord![i].toLowerCase() == tile.value.toLowerCase()) {
        tile.updateTileType(TileType.correct);
      } else {
        tile.updateTileType(TileType.incorrect);
      }
      return tile;
    }).toList();

    final incorrect = tiles
        .where((element) => element.tileType == TileType.incorrect)
        .firstOrNull;

    if (incorrect == null) {
      //player solved puzzle!
      // start new game after 3 seconds
      Future.delayed(const Duration(seconds: 3)).then((value) {
        print("jajajaj");
        loadWord();
        game.newGame();
      });
    }
  }

  void _buildRow() {
    //make space a fraction of total width
    var spc = AppConfig.screenWidth * 0.015;

    //make horizontal margin (left and right) 10% of screen width
    var hMargin = AppConfig.screenWidth * 0.1;

    //actual width we have for grid (total width - margins)
    var canvasWidth = AppConfig.screenWidth - (2 * hMargin);

    //total horizontal amount taken up by space between tiles
    var totalHorizontalGridSpace = (_targetWord!.length - 1) * spc;

    //the tile size (based on width)
    final tileSize =
        (canvasWidth - totalHorizontalGridSpace) / _targetWord!.length;

    // total width and height of the grid
    final totalRowWidth =
        (_targetWord!.length) * (tileSize) + totalHorizontalGridSpace;

    //the offset position of the grid, here centered, but
    //any other offset can be stated here

    final rowPosition = Vector2(
      (AppConfig.screenWidth - totalRowWidth) * 0.5,
      (AppConfig.screenHeight - tileSize) * 0.35,
    );

    var shuffledWord = _targetWord!.split('')..shuffle();

    while (shuffledWord.join() == _targetWord) {
      shuffledWord = _targetWord!.split('')..shuffle();
    }

    tiles = shuffledWord
        .mapIndexed((i, char) => FlameShuffleTile(
              value: char.toUpperCase(),
              tileSize: tileSize,
            )..position =
                Vector2(rowPosition.x + (i * (tileSize + spc)), rowPosition.y))
        .toList();
  }
}
