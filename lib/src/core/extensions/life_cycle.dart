import 'package:chat_app/src/data/models/user.dart';
import 'package:chat_app/src/presentation/pages/chat_page/chat_controller.dart';
import 'package:chat_app/src/presentation/pages/home_page/home_page_controller.dart';
import 'package:chat_app/src/presentation/pages/message_page/message_controller.dart';
import 'package:flutter/material.dart';

class LifeCycleManager extends StatefulWidget {
  const LifeCycleManager({
    Key? key,
    required this.child
  }) : super(key: key);

  final Widget child;

  @override
  _LifeCycleManagerState createState() => _LifeCycleManagerState();
}

class _LifeCycleManagerState extends State<LifeCycleManager> with WidgetsBindingObserver {
  late HomePageController _homePageController;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    _homePageController = HomePageController();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    debugPrint('AppLifecycleState: $state');
    if(state == AppLifecycleState.inactive || state == AppLifecycleState.paused){
      if(mounted){
        _homePageController.onDispose();
      }
    } else{
      if(mounted){
        _homePageController.connectAndList();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }
}