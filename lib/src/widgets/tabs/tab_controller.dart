import 'package:flutter/foundation.dart';

class AppTabController extends ChangeNotifier {
  AppTabController({required int length}) : _length = length;

  final int _length;
  int _index = 0;

  int get index => _index;
  int get length => _length;

  void animateTo(int value) {
    if (value != _index && value >= 0 && value < _length) {
      _index = value;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
