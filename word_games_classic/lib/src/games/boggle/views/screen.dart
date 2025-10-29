import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/boggle_controller.dart';
import 'boggle_grid.dart';

class FlutterBoggle extends StatelessWidget {
  const FlutterBoggle({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BoggleController>(
      builder: (BoggleController controller) {
        return Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const SizedBox(width: 20),
                Text(
                  controller.score,
                  style: const TextStyle(fontSize: 35),
                ),
                const Spacer(),
                Text(
                  controller.spelling,
                  style: const TextStyle(fontSize: 35),
                ),
                const SizedBox(width: 20),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: BoggleGrid(),
            ),
          ],
        );
      },
    );
  }
}
