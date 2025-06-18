import 'package:flutter/foundation.dart';

class LabTabController extends ChangeNotifier {
  LabTabController({
    required int length,
    int initialIndex = 0,
  })  : _length = length,
        _index = initialIndex;

  final int _length;
  int _index;

  int get index => _index;
  int get length => _length;

  void animateTo(int value) {
    if (value != _index && value >= 0 && value < _length) {
      _index = value;
      notifyListeners();
    }
  }
}
