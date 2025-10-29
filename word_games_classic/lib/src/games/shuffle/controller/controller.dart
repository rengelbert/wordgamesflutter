import 'package:collection/collection.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import '../../../config/app_config.dart';
import '../../../config/app_theme.dart';
import '../../../utils/vector2.dart';
import '../data/model.dart';
import '../data/tile_data.dart';

class ShuffleController extends GetxController {
  late final ShuffleGameData _gameData;

  String _targetWord = "";

  List<ShuffleTileData> _tiles = [];
  ShuffleTileData? _selectedTile;
  double tileSize = 100;

  Future<void> initGame() async {
    _gameData = await ShuffleGameData.data();
  }

  List<ShuffleTileData> get tiles => _tiles;

  void selectTile(ShuffleTileData tile) {
    if (tile.tileType == TileType.correct) {
      return;
    }
    if (_selectedTile == null) {
      _selectedTile = tile;
      tile.tileType = TileType.selected;
    } else {
      if (tile == _selectedTile) return;

      if (tile.tileType == TileType.incorrect) {
        _swapTile(tile);
        _checkTiles();
        _selectedTile = null;
      }
    }
    update();
  }

  void _swapTile(ShuffleTileData targetTile) {
    final selectedValue = _selectedTile!.value;
    _selectedTile!.value = targetTile.value;
    targetTile.value = selectedValue;
  }

  void newRound() {
    _targetWord = _gameData.getWord() ?? "testy";
    var shuffledWord = _targetWord.split('')..shuffle();

    while (shuffledWord.join() == _targetWord) {
      shuffledWord = _targetWord.split('')..shuffle();
    }

    _tiles = shuffledWord
        .map((char) => ShuffleTileData()..value = char.toUpperCase())
        .toList();

    _buildRow();
    _checkTiles();
    update();
  }

  void _buildRow() {
    //make space a fraction of total width
    var spc = AppConfig.screenWidth * 0.015;

    //make horizontal margin (left and right) 10% of screen width
    var hMargin = AppConfig.screenWidth * 0.1;

    //actual width we have for row (total width - margins)
    var rowWidth = AppConfig.screenWidth - (2 * hMargin);

    //total horizontal amount taken up by space between tiles
    var totalHorizontalRowSpace = (_tiles.length - 1) * spc;

    //the tile size (based on width)
    tileSize = (rowWidth - totalHorizontalRowSpace) / _tiles.length;

    //the offset position of the grid, here centered, but
    //any other offset can be stated here

    final rowPosition = Vector2(
      (AppConfig.screenWidth - rowWidth) * 0.5,
      (AppConfig.screenHeight - tileSize) * 0.5,
    );

    // position individual tiles
    for (var i = 0; i < _tiles.length; i++) {
      final tileData = _tiles[i];
      tileData.position.x = rowPosition.x + (i * (tileSize + spc));
      tileData.position.y = rowPosition.y;
    }
  }

  void _checkTiles() {
    _tiles = _tiles.mapIndexed((i, tile) {
      if (_targetWord[i].toLowerCase() == tile.value.toLowerCase()) {
        tile.tileType = TileType.correct;
      } else {
        tile.tileType = TileType.incorrect;
      }
      return tile;
    }).toList();

    final incorrect = _tiles
        .where((element) => element.tileType == TileType.incorrect)
        .firstOrNull;

    if (incorrect == null) {
      //player solved puzzle!

      // start new game after 3 seconds
      Future.delayed(const Duration(seconds: 3)).then((value) {
        newRound();
      });
    }
  }
}
