import 'package:flutter/cupertino.dart';

class Settings with ChangeNotifier {
  var darkMode = false;

  void switchMode() {
    darkMode = !darkMode;
    notifyListeners();
  }
}
