import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'src/components/tile/controller/tile_controller.dart';
import 'src/components/tile/data/tile_data.dart';
import 'src/components/tile/flame_tile.dart';
import 'src/config/app_config.dart';
import 'src/games/boggle/controller/boggle_controller.dart';
import 'src/games/boggle/views/boggle_game.dart';
import 'src/games/emoji/controller/emoji_controller.dart';
import 'src/games/emoji/views/emoji_game_screen.dart';
import 'src/games/emoji/views/emoji_ui.dart';
import 'src/games/shuffle/controller/shuffle_controller.dart';
import 'src/games/shuffle/views/flame_shuffle_game.dart';
import 'src/games/word_splash/controller/splash_controller.dart';
import 'src/games/word_splash/views/word_splash_game.dart';
import 'src/games/word_splash/views/word_splash_ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //1. tile
  final controller = TileController();
  Get.put<TileController>(controller);
  runApp(TileApp());

  //2. shuffle
  // final controller = ShuffleController();
  // await controller.initGame();
  // Get.put<ShuffleController>(controller);
  // runApp(ShuffleGame());

  //3. word splash
  // final controller = WordsSplashController();
  // await controller.initGame();
  // Get.put(controller);
  // runApp(WordSplashGame());

  //4. boggle
  // final controller = BoggleController();
  // await controller.initGame();
  // Get.put(controller);
  // runApp(BoggleMain());

  //5. emoji
  // final controller = EmojiController();
  // await controller.initGame();
  // Get.put(controller);
  // runApp(EmojiMain());
}

//tile
class TileApp extends StatelessWidget {
  TileApp({super.key});
  final game = TestGame();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GameWidget(game: game),
      ),
    );
  }
}

class MainApp2 extends StatelessWidget {
  MainApp2({super.key});
  final game = FlameShuffle();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GameWidget(
          game: game,
        ),
      ),
    );
  }
}

class WordSplashGame extends StatelessWidget {
  WordSplashGame({super.key});

  final game = FlameWordSplash();

  @override
  Widget build(BuildContext context) {
    AppConfig.screenHeight = MediaQuery.of(context).size.height;
    AppConfig.screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GameWidget(
          game: game,
          overlayBuilderMap: {
            "GameUI": (BuildContext context, FlameWordSplash game) {
              return const WordSplashUI();
            },
          },
        ),
      ),
    );
  }
}

class BoggleMain extends StatelessWidget {
  BoggleMain({super.key});

  final game = FlameBoggle();

  @override
  Widget build(BuildContext context) {
    AppConfig.screenHeight = MediaQuery.of(context).size.height;
    AppConfig.screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GameWidget(
          game: game,
        ),
      ),
    );
  }
}

class EmojiMain extends StatelessWidget {
  EmojiMain({super.key});

  final game = FlameEmoji();

  @override
  Widget build(BuildContext context) {
    AppConfig.screenHeight = MediaQuery.of(context).size.height;
    AppConfig.screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GameWidget(
          game: game,
          overlayBuilderMap: {
            "GameUI": (BuildContext context, FlameEmoji game) {
              return const EmojiUI();
            },
          },
        ),
      ),
    );
  }
}

class ShuffleGame extends StatelessWidget {
  ShuffleGame({super.key});
  final game = FlameShuffle();

  @override
  Widget build(BuildContext context) {
    AppConfig.screenHeight = MediaQuery.of(context).size.height;
    AppConfig.screenWidth = MediaQuery.of(context).size.width;

    final controller = Get.find<ShuffleController>();
    controller.loadWord();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GameWidget(game: game),
      ),
    );
  }
}

class TestGame extends FlameGame {
  @override
  Color backgroundColor() => Colors.orange;

  @override
  Future<void> onLoad() async {
    final tile = FlameTile3(data: TileData());
    tile.position.x = size.x * 0.5;
    tile.position.y = size.y * 0.5;
    add(tile);
  }

  void selectTile(TileData data) {
    data.selected = !data.selected;
  }
}
