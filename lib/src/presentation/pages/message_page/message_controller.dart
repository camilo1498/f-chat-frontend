import 'package:chat_app/src/data/models/chat.dart';
import 'package:chat_app/src/data/models/api_response.dart';
import 'package:chat_app/src/data/models/message.dart';
import 'package:chat_app/src/data/models/user.dart';
import 'package:chat_app/src/presentation/pages/home_page/home_page_controller.dart';
import 'package:chat_app/src/presentation/providers/chat_provider.dart';
import 'package:chat_app/src/presentation/providers/message_provider.dart';
import 'package:chat_app/src/presentation/providers/user_provider.dart';
import 'package:chat_app/src/presentation/widgets/alert_sheets/snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

class MessageController {
  MessageController({
    required this.context,
    required this.userChat
}){
    createChat(userChat: userChat);
    checkIfIsOnline();
  }
  /// app current context
  final BuildContext context;
  /// user model instance
  final User myUser = User.fromJson(GetStorage().read('user') ?? {});
  /// user chat
  final User userChat;
  /// text controller
  final TextEditingController messageTextController = TextEditingController();
  /// text node
  final FocusNode messageNode = FocusNode();
  /// list controller
  final ScrollController controller = ScrollController();
  /// stored socked id
  String idSocket = '';
  final HomePageController _homePageController = HomePageController();


  /// create chat
  Future<ApiResponse> createChat({required User userChat}) async{
    Chat chat = Chat(
      idUser1: myUser.id,
      idUser2: userChat.id,
    );

    ApiResponse _res = await Provider.of<ChatProvider>(context, listen: false).create(chat);
    if(_res.success == true){
      Provider.of<MessageProvider>(context, listen: false).messageId = _res.data;
      Provider.of<MessageProvider>(context, listen: false).chatId = _res.data;
      /// here put the listeners
      getMessage();
      listenMessage();
      listenWriting();
      listenMessageSeen();
      listenOffline();
      listenMessageReceived();

      return _res;
    } else{
      return _res;
    }
  }

  /// only message
  void sendMessage({required User userChat}) async{
    if(messageTextController.text.trim().isEmpty){
      return;
    } else{
      /// create chat if does not exists
      ApiResponse _res = await createChat(userChat: userChat);

      if(_res.success == true){
        Message message = Message(
          message: messageTextController.text.trim(),
          idSender: myUser.id,
          idReceiver: userChat.id,
          idChat: _res.data.toString(),
          isImage: false,
          isVideo: false,
        );
        ApiResponse _messageRes = await Provider.of<MessageProvider>(context, listen: false).create(message);
        if(_messageRes.success == true){
          messageTextController.clear();
          emitMessage();
          /// send notification
          //getMessage(chatId: _res.data);
        } else{
        }
      } else{
        showToast(message: 'Error sending message');
      }

    }
  }

  void getMessage() async{
    try{
      final messageProvider = Provider.of<MessageProvider>(context, listen: false);
      var _res = await messageProvider.getMessagesByChat();
      messageProvider.message.clear();
      messageProvider.message.addAll(_res);

      /// validate if the message was seen
      for (var message in messageProvider.message) {
        if(message.status != 'VISTO' && message.idReceiver == myUser.id){
          await messageProvider.updateToSeen(messageId: message.id!);
          emitMessageSeen();
        }
      }

      getChats();

      Future.delayed(const Duration(milliseconds: 100), (){
        if(controller.positions.isNotEmpty){
          controller.jumpTo(controller.position.minScrollExtent);
        }
      });
    } catch(e){
      debugPrint(e.toString());
    }

  }

  void getChats() async{
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    var _res = await chatProvider.getChats();
    chatProvider.chats.clear();
    chatProvider.chats.addAll(_res);
  }


  /// message status
  /// listeners
  /// seen by other user
  void listenMessageSeen() {
    _homePageController.socket.on('seen/${Provider.of<MessageProvider>(context, listen: false).chatId}', (data) {
     getMessage();
    });
  }
  /// received by other user
  void listenMessageReceived() {
    _homePageController.socket.on('received/${Provider.of<MessageProvider>(context, listen: false).chatId}', (data) {
      getMessage();
    });
  }
  /// other user is writing
  void listenWriting() {
    final messageProvider = Provider.of<MessageProvider>(context, listen: false);
    _homePageController.socket.on('writing/${Provider.of<MessageProvider>(context, listen: false).chatId}/${userChat.id}', (data) {
      messageProvider.isWriting = true;
      Future.delayed(const Duration(milliseconds: 2000), () {
        messageProvider.isWriting = false;
      });
    });
  }
  /// other user is offline
  void listenOffline() async {
    try{
      final messageProvider = Provider.of<MessageProvider>(context, listen: false);
      if (idSocket.isNotEmpty) {
        _homePageController.socket.off('offline/$idSocket');
        _homePageController.socket.on('offline/$idSocket', (data) {
          if (idSocket == data['id_socket']) {
            messageProvider.isOnline = false;
            _homePageController.socket.off('offline/$idSocket');
          }
        });
      }
    } catch(e){
      debugPrint(e.toString());
    }
  }
  /// other user is online
  void listenOnline() {
    final messageProvider = Provider.of<MessageProvider>(context, listen: false);
    _homePageController.socket.off('online/${userChat.id}');
    _homePageController.socket.on('online/${userChat.id}', (data) {
      messageProvider.isOnline = true;
      idSocket = data['id_socket'];
      listenOffline();
    });
  }
  /// received message of other user
  void listenMessage() {
    _homePageController.socket.on('message/${Provider.of<MessageProvider>(context, listen: false).chatId}', (data) {
      getMessage();
    });
  }

  /// emit
  /// writing listener
  void emitWriting() {
    _homePageController.socket.emit('writing', {
      'id_chat': Provider.of<MessageProvider>(context, listen: false).chatId,
      'id_user': myUser.id,
    });
  }
  /// seen message
  void emitMessageSeen() {
    _homePageController.socket.emit('seen', {
      'id_chat': Provider.of<MessageProvider>(context, listen: false).chatId
    });
  }
  /// send message to socket
  void emitMessage() {
    _homePageController.socket.emit('message', {
      'id_chat': Provider.of<MessageProvider>(context, listen: false).chatId,
      'id_user': userChat.id
    });
  }


  void checkIfIsOnline() async {

    final messageProvider = Provider.of<MessageProvider>(context, listen: false);
    Response response = await Provider.of<UserProvider>(context, listen: false).checkIfIsOnline(userId: userChat.id!);

    if (response.data['online'] == true) {
      idSocket = response.data['id_socket'];
      listenOnline();
    }
    else {
      messageProvider.isOnline = false;
    }

  }

  void dispose(){
    var _chat = Provider.of<MessageProvider>(context, listen: false);
    controller.dispose();
    _homePageController.socket.off('message/${_chat.chatId}');
    _homePageController.socket.off('seen/${_chat.chatId}');
    _homePageController.socket.off('writing/${_chat.chatId}');
  }

}