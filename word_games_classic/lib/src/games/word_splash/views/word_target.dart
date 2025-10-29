import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../data/splash_model.dart';

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
