import 'package:chat_app/src/core/extensions/hex_color.dart';
import 'package:chat_app/src/presentation/pages/message_page/message_controller.dart';
import 'package:flutter/material.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MessageController _messageController = MessageController();
    return Scaffold(
      backgroundColor: HexColor.fromHex('#EFEEEE'),
    );
  }
}
