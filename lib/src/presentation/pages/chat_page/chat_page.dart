import 'package:chat_app/src/core/extensions/hex_color.dart';
import 'package:chat_app/src/presentation/pages/chat_page/chat_controller.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatController _chatController = ChatController();
    return Scaffold(
      backgroundColor: HexColor.fromHex('#EFEEEE'),
    );
  }
}
