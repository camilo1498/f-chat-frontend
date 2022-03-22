import 'package:chat_app/src/data/models/chat.dart';
import 'package:chat_app/src/data/models/api_response.dart';
import 'package:chat_app/src/data/models/message.dart';
import 'package:chat_app/src/data/models/user.dart';
import 'package:chat_app/src/presentation/providers/chat_provider.dart';
import 'package:chat_app/src/presentation/providers/message_provider.dart';
import 'package:chat_app/src/presentation/widgets/alert_sheets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

class MessageController {
  MessageController({
    required this.context
});
  final BuildContext context;
  /// user model instance
  final User myUser = User.fromJson(GetStorage().read('user') ?? {});

  /// text controller
  final TextEditingController messageTextController = TextEditingController();
  /// text node
  final FocusNode messageNode = FocusNode();

  Future<ApiResponse> createChat({required User userChat}) async{
    Chat chat = Chat(
      idUser1: myUser.id,
      idUser2: userChat.id,
    );

    ApiResponse _res = await Provider.of<ChatProvider>(context, listen: false).create(chat);
    if(_res.success == true){
      debugPrint('success: ${_res.message}');
      return _res;
    } else{
      debugPrint('success: ${_res.message}');
      return _res;
    }
  }

  void sendMessage({required User userChat}) async{
    if(messageTextController.text.trim().isEmpty){
      return;
    } else{
      messageTextController.clear();
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
          debugPrint('success: ${_messageRes.message}');
        } else{
          debugPrint('error: ${_messageRes.message}');
        }
      } else{
        showToast(message: 'Error sending message');
      }

    }
  }

}