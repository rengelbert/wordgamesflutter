# Word Games With Flutter

Source code for the ebook: [Word Games with Flutter](https://www.amazon.com/dp/B0FYQPRGP6)

## The Projects
The repo comprises of three separate projects:
- Dart Core: contains logic to support word analysis, grid evaluator and word pattern matching.
- Word Games Classic: contains the source code for 4 word games, done entirely with Flutter Widgets.
- Word Games Flame: the same as the previous project, but the 4 games are developed using Flame.


## Flutter Installation
It is much easier to do the installation through VSCode. 
Simply follow the [instructions](https://docs.flutter.dev/install/with-vs-code) from the Flutter website.


## Project Installation
- Clone repo
- Open containing folder inside VSCode
- Open `pubspec.yaml` for each project and run `flutter pub get` in the terminal.


## Running the Games
The file `main.dart` in each of the following projects: `word_games_classic` and `word_games_flame` has commented out lines listing the startup code for each one of the 4 games plus the tile.

```dart
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
```
Simply uncomment the one you want to run, leaving all other lines commented out and run the project.