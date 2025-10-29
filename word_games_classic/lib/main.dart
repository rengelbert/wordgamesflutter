import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'src/games/emoji/views/emoji_screen.dart';
import 'src/components/tile/controller/tile_controller.dart';
import 'src/components/tile/data/tile_data.dart';
import 'src/components/tile/tile.dart';
import 'src/config/app_config.dart';
import 'src/games/boggle/controller/boggle_controller.dart';
import 'src/games/boggle/views/screen.dart';
import 'src/games/emoji/controller/emoji_controller.dart';
import 'src/games/shuffle/controller/controller.dart';
import 'src/games/shuffle/views/flutter_screen.dart';
import 'src/games/word_splash/controller/controller.dart';
import 'src/games/word_splash/views/flutter_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // # 1 Tile
  final controller = TileController();
  await controller.init();
  Get.put(controller);
  runApp(const SimpleTileApp());

  // # 2 Word Shuffle
  // final controller = ShuffleController();
  // await controller.initGame();
  // Get.put(controller);
  // runApp(const ShuffleGame());

  // # 3 Word Splash
  // final controller = WordsSplashController();
  // await controller.initGame();
  // Get.put(controller);
  // runApp(const WordSplashGame());

  // # 4 Boggle
  // final controller = BoggleController();
  // await controller.initGame();
  // Get.put(controller);
  // runApp(const BoggleGame());

  // # 5 Emoji
  // final controller = EmojiController();
  // await controller.initGame();
  // Get.put(controller);
  // runApp(const EmojiGame());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AppConfig.screenHeight = MediaQuery.of(context).size.height;
    AppConfig.screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      title: 'Flutter Word Games',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        backgroundColor: Colors.orange,
        body: Center(
          child: FlutterTile6(
            tileData: TileData()..value = "A",
            tileSize: 100,
          ),
        ),
      ),
    );
  }
}

// simple tile
class SimpleTileApp extends StatelessWidget {
  const SimpleTileApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Word Games',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.orange,
        body: GetBuilder<TileController>(
          builder: (TileController controller) {
            return const Center(
              child: FlutterTile1(),
            );
          },
        ),
      ),
    );
  }
}

// shuffle game
class ShuffleGame extends StatelessWidget {
  const ShuffleGame({super.key});

  @override
  Widget build(BuildContext context) {
    AppConfig.screenHeight = MediaQuery.of(context).size.height;
    AppConfig.screenWidth = MediaQuery.of(context).size.width;

    final controller = Get.find<ShuffleController>();
    controller.newRound();

    return const MaterialApp(
      title: 'Word Shuffle',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.orange,
        body: FlutterShuffle(),
      ),
    );
  }
}

// word cookie
class WordSplashGame extends StatelessWidget {
  const WordSplashGame({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AppConfig.screenHeight = MediaQuery.of(context).size.height;
    AppConfig.screenWidth = MediaQuery.of(context).size.width;

    final controller = Get.find<WordsSplashController>();
    controller.newRound();

    return const MaterialApp(
      title: 'Splash Words',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.orange,
        body: FlutterWordSplash(),
      ),
    );
  }
}

// boggle
class BoggleGame extends StatelessWidget {
  const BoggleGame({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AppConfig.screenHeight = MediaQuery.of(context).size.height;
    AppConfig.screenWidth = MediaQuery.of(context).size.width;

    final controller = Get.find<BoggleController>();
    controller.newGame();

    return const MaterialApp(
      title: 'Word Boggle',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.orange,
        body: FlutterBoggle(),
      ),
    );
  }
}

// emoji
class EmojiGame extends StatelessWidget {
  const EmojiGame({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AppConfig.screenHeight = MediaQuery.of(context).size.height;
    AppConfig.screenWidth = MediaQuery.of(context).size.width;

    final controller = Get.find<EmojiController>();
    controller.newGame();

    return const MaterialApp(
      title: 'Emoji Code',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.orange,
        body: FlutterEmoji(),
        //
      ),
    );
  }
}
