import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/emoji_controller.dart';
import 'emoji_grid.dart';

class FlutterEmoji extends StatelessWidget {
  const FlutterEmoji({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmojiController>(
      builder: (EmojiController controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            IconButton(
                onPressed: () {
                  controller.undoChange();
                },
                icon: const Icon(Icons.refresh, color: Colors.white, size: 40)),
            const SizedBox(
              height: 30,
            ),
            const Expanded(
              child: EmojiGrid(),
            ),
          ],
        );
      },
    );
  }
}
