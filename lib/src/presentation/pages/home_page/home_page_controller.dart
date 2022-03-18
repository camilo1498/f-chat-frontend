import 'package:chat_app/src/presentation/providers/home_page_provider.dart';
import 'package:flutter/material.dart';

class HomePageController {

  void changeTapIndex({required HomePageProvider homeProvider, required int index}){
    homeProvider.tapIndex = index;
  }

}