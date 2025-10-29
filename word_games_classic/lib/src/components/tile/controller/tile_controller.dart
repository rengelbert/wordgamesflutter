import 'package:get/get.dart';

import '../data/tile_data.dart';

class TileController extends GetxController {
  TileData selectedTile = TileData()..value = "W";
  // AudioPlayer _player = AudioPlayer();

  Future<void> init() async {
    // try {
    //   // AAC example: https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.aac
    //   await _player.setUrl("asset:///assets/sounds/beep.mp3");
    // } on PlayerException catch (e) {
    //   print("Error loading audio source: $e");
    // }

    print("hahahahaha");
  }

  void select() {
    selectedTile.selected = !selectedTile.selected;
    update();
    print("hahahahahahha");
  }

// ServicesBinding.instance.keyboard.addHandler(_onKey);
  // bool _onKey(KeyEvent event) {
  //   final key = event.logicalKey.keyLabel;
  //   if (event is KeyDownEvent) {
  //     print("Key down: $key");
  //     print(key);
  //   }
  //   // } else if (event is KeyUpEvent) {
  //   //   print("Key up: $key");
  //   // } else if (event is KeyRepeatEvent) {
  //   //   print("Key repeat: $key");
  //   // }

  //   return false;
  // }
}
/*
Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.orange,
        body: GetBuilder<TileController>(builder: (TileController controller) {
          return Center(
            child: GestureDetector(
                onTap: () {
                  SystemChannels.textInput.invokeMethod("TextInput.show");
                },
                onLongPress: () {
                  SystemChannels.textInput.invokeMethod("TextInput.hide");
                },
                child: FlutterTile(tileData: TileData(), tileSize: 100)),
          );
        })
        // FlutterWordSplash(),
        );
  }
}
*/