import 'package:flutter/material.dart';

class HomePageProvider extends ChangeNotifier {
  int _tapIndex = 0;
  int get tapIndex => _tapIndex;
  set tapIndex(int index) {
    _tapIndex = index;
    notifyListeners();
  }

  PageController _pageController = PageController(initialPage: 0);
  PageController get pageController=> _pageController;
  set pageController(PageController page){
    _pageController = page;
    notifyListeners();
  }

}
