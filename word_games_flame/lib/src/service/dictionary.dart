import 'package:dart_core/dictionary.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class DictionaryService extends GetxService {
  late Dictionary _dictionary;

  Future<void> init() async {
    final txt = await rootBundle.loadString('assets/data/dictionary.txt');
    _dictionary = Dictionary(txt);
  }

  Future<void> initWithFile(String path) async {
    final txt = await rootBundle.loadString(path);
    _dictionary = Dictionary(txt);
  }

  Dictionary get dictionary => _dictionary;
}
