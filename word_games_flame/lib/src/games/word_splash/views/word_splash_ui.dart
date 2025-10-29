import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_config.dart';
import '../controller/splash_controller.dart';
import '../data/splash_model.dart';

class WordSplashUI extends StatelessWidget {
  const WordSplashUI({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppConfig.screenWidth,
      height: AppConfig.screenHeight * 0.2,
      child: GetBuilder<WordsSplashController>(
        builder: (WordsSplashController controller) {
          return Column(
            children: [
              Text(
                controller.spelling,
                style: const TextStyle(fontSize: 40),
              ),
              const SizedBox(
                height: 20,
              ),
              Wrap(
                runSpacing: 8.0,
                spacing: 8.0,
                children: controller.targets.map((t) {
                  return WordTarget(word: t, tileSize: 25.0);
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class WordTarget extends StatelessWidget {
  final TargetWord word;
  final double tileSize;
  const WordTarget({super.key, required this.word, required this.tileSize});

  Widget _getCharacterItem(String char, int charIndex) {
    return Container(
      width: tileSize,
      height: tileSize,
      margin: const EdgeInsets.symmetric(horizontal: 1.0),
      decoration: BoxDecoration(
        color: word.found ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(tileSize * 0.2),
      ),
      child: Center(
        child: Text(
          maxLines: 1,
          word.found ? char.toUpperCase() : word.hint[charIndex],
          style: TextStyle(
            fontSize: tileSize * 0.5,
            color: word.found ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: word.value
          .split('')
          .mapIndexed(
            (i, char) => _getCharacterItem(char, i),
          )
          .toList(),
    );
  }
}
