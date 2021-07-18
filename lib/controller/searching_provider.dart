import 'package:flutter/cupertino.dart';

class SearchingProvider with ChangeNotifier {
  bool searching = false;

  changeSearch(bool value) {
    print("change search");
    searching = value;
    notifyListeners();
  }
}
