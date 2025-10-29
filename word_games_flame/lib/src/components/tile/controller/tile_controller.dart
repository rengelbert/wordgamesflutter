// ignore: unnecessary_import
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../data/tile_data.dart';

class TileController extends GetxController {
  TileData? selectedTile;

  TileController() {
    ServicesBinding.instance.keyboard.addHandler(_onKey);
  }

  bool _onKey(KeyEvent event) {
    final key = event.logicalKey.keyLabel;
    if (event is KeyDownEvent) {
      print("Key down: $key");
      print(key);
    }
    // } else if (event is KeyUpEvent) {
    //   print("Key up: $key");
    // } else if (event is KeyRepeatEvent) {
    //   print("Key repeat: $key");
    // }

    return false;
  }
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