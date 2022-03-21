import 'package:chat_app/src/core/extensions/hex_color.dart';
import 'package:chat_app/src/presentation/pages/chat_page/chat_controller.dart';
import 'package:chat_app/src/presentation/providers/user_provider.dart';
import 'package:chat_app/src/presentation/widgets/loading_indicartor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatController _chatController = ChatController();
    return Consumer<UserProvider>(
      builder: (_, userProvider, __){
        return Scaffold(
          backgroundColor: HexColor.fromHex('#EFEEEE'),
          body: Stack(
            children: [

              if (userProvider.loading)
                const LoadingIndicator()
            ],
          ),
        );
      },
    );
  }
}
