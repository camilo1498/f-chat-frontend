import 'package:chat_app/src/data/models/chat.dart';
import 'package:chat_app/src/data/models/api_response.dart';
import 'package:chat_app/src/data/models/message.dart';
import 'package:chat_app/src/data/models/user.dart';
import 'package:chat_app/src/data/repositories/env.dart';
import 'package:chat_app/src/presentation/providers/chat_provider.dart';
import 'package:chat_app/src/presentation/providers/message_provider.dart';
import 'package:chat_app/src/presentation/providers/user_provider.dart';
import 'package:chat_app/src/presentation/widgets/alert_sheets/snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

class MessageController {
  MessageController({
    required this.context,
    required this.userChat
}){
    socket.connect();
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
  /// create socket
  Socket socket = io('${Environment.apiChat}chat', <String, dynamic> {
    'transports': ['websocket'],
    'autoConnect': false
  });
  /// create chat
  Future<ApiResponse> createChat({required User userChat}) async{
    Chat chat = Chat(
      idUser1: myUser.id,
      idUser2: userChat.id,
    );

    ApiResponse _res = await Provider.of<ChatProvider>(context, listen: false).create(chat);
    if(_res.success == true){
      getMessage();
      Provider.of<MessageProvider>(context, listen: false).messageId = _res.data;
      Future.delayed(const Duration(milliseconds: 100), (){
        if(controller.positions.isNotEmpty){
          controller.jumpTo(controller.position.maxScrollExtent);
        }
      });
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
        controller.jumpTo(controller.position.maxScrollExtent);
      }
    });

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
    socket.on('seen/${Provider.of<MessageProvider>(context, listen: false).chatId}', (data) {
      getMessage();
    });
  }
  /// received by other user
  void listenMessageReceived() {
    socket.on('received/${Provider.of<MessageProvider>(context, listen: false).chatId}', (data) {
      getMessage();
    });
  }
  /// other user is writing
  void listenWriting() {
    final messageProvider = Provider.of<MessageProvider>(context, listen: false);
    socket.on('writing/${Provider.of<MessageProvider>(context, listen: false).chatId}/${userChat.id}', (data) {
      messageProvider.isWriting = true;
      Future.delayed(const Duration(milliseconds: 2000), () {
        messageProvider.isWriting = false;
      });
    });
  }
  /// other user is offline
  void listenOffline() async {
    final messageProvider = Provider.of<MessageProvider>(context, listen: false);
    if (idSocket.isNotEmpty) {
      socket.off('offline/$idSocket');
      socket.on('offline/$idSocket', (data) {
        if (idSocket == data['id_socket']) {
          messageProvider.isOnline = false;
          socket.off('offline/$idSocket');
        }
      });
    }
  }
  /// other user is online
  void listenOnline() {
    print('online');
    final messageProvider = Provider.of<MessageProvider>(context, listen: false);
    socket.off('online/${userChat.id}');
    socket.on('online/${userChat.id}', (data) {
      messageProvider.isOnline = true;
      idSocket = data['id_socket'];
      listenOffline();
    });
  }
  /// received message of other user
  void listenMessage() {
    socket.on('message/${Provider.of<MessageProvider>(context, listen: false).chatId}', (data) {
      print('listen message: $data');
      getMessage();
    });
  }

  /// emit
  /// writing listener
  void emitWriting() {
    socket.emit('writing', {
      'id_chat': Provider.of<MessageProvider>(context, listen: false).chatId,
      'id_user': myUser.id,
    });
  }
  /// seen message
  void emitMessageSeen() {
    socket.emit('seen', {
      'id_chat': Provider.of<MessageProvider>(context, listen: false).chatId
    });
  }
  /// send message to socket
  void emitMessage() {
    socket.emit('message', {
      'id_chat': Provider.of<MessageProvider>(context, listen: false).chatId,
      'id_user': userChat.id
    });
  }


  void checkIfIsOnline() async {
    final messageProvider = Provider.of<MessageProvider>(context, listen: false);
    Response response = await Provider.of<UserProvider>(context, listen: false).checkIfIsOnline(userId: userChat.id!);

    if (response.data['online'] == true) {
      messageProvider.isOnline = true;
      print('user online ${messageProvider.isOnline}');
      idSocket = response.data['id_socket'];
      listenOnline();
    }
    else {
      messageProvider.isOnline = false;
      print('user online ${messageProvider.isOnline}');
    }

  }

  void disposeSocket(){
    socket.disconnect();
  }

}