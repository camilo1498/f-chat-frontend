import 'package:chat_app/src/data/models/user.dart';
import 'package:chat_app/src/data/repositories/env.dart';
import 'package:chat_app/src/presentation/providers/home_page_provider.dart';
import 'package:chat_app/src/presentation/providers/message_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

class HomePageController {
  User user = User.fromJson(GetStorage().read('user') ?? {});

  Socket socket = io('${Environment.apiChat}chat', <String, dynamic> {
    'transports': ['websocket'],
    'autoConnect': false
  });


  void changeTapIndex(
      {required HomePageProvider homeProvider, required int index}) {
    homeProvider.tapIndex = index;
  }

  void connectAndList() {
    if (user.id != null) {
      socket.connect();
      socket.onConnect((data) {
        debugPrint('user connected');
        emitOnline();
      });
    }
  }
  void emitOnline() {
    socket.emit('online', {
      'id_user': user.id
    });
  }

  void onDispose(){
    if(socket.connected){
      debugPrint('user disconnected');
      socket.disconnect();
    }
  }


  /// other user is writing
  void listenWriting({required BuildContext context, required User userChat}) {
    final messageProvider = Provider.of<MessageProvider>(context, listen: false);
    socket.on('writing/${Provider.of<MessageProvider>(context, listen: false).chatId}/${userChat.id}', (data) {
      messageProvider.isWriting = true;
      Future.delayed(const Duration(milliseconds: 2000), () {
        messageProvider.isWriting = false;
      });
    });
  }


}
