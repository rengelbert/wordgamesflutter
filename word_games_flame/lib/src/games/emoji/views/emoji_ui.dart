import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/emoji_controller.dart';

class EmojiUI extends StatelessWidget {
  const EmojiUI({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EmojiController>();
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: IconButton(
            onPressed: () {
              controller.undoChange();
            },
            icon: const Icon(Icons.refresh, color: Colors.white, size: 40)),
      ),
    );
  }
}
