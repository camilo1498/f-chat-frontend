import 'package:chat_app/src/data/models/user.dart';
import 'package:chat_app/src/data/repositories/env.dart';
import 'package:chat_app/src/presentation/pages/home_page/home_page_controller.dart';
import 'package:chat_app/src/presentation/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatController {
  /// get context
  final BuildContext context;

  ChatController({
    required this.context
  }){
    socket.connect();
    getChats();
    listenMessage();
  }

  /// get local user
  User user = User.fromJson(GetStorage().read('user') ?? {});
  /// home controller
  HomePageController homePageController = HomePageController();
  /// create socket
  Socket socket = io('${Environment.apiChat}chat', <String, dynamic> {
    'transports': ['websocket'],
    'autoConnect': false
  });

  void getChats() async{
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    var res = await chatProvider.getChats();
    chatProvider.chats.clear();
    chatProvider.chats.addAll(res);
  }

  void listenMessage() {
   socket.on('message/${user.id}', (data) {
      getChats();
    });
  }

  void disposeSocket(){
    socket.disconnect();
  }
}
