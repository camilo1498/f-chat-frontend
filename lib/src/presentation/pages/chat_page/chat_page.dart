import 'package:chat_app/src/core/extensions/hex_color.dart';
import 'package:chat_app/src/data/models/chat.dart';
import 'package:chat_app/src/data/repositories/env.dart';
import 'package:chat_app/src/presentation/pages/chat_page/chat_controller.dart';
import 'package:chat_app/src/presentation/providers/chat_provider.dart';
import 'package:chat_app/src/presentation/providers/message_provider.dart';
import 'package:chat_app/src/presentation/providers/user_provider.dart';
import 'package:chat_app/src/presentation/widgets/animations/animated_onTap_button.dart';
import 'package:chat_app/src/presentation/widgets/loading_indicartor.dart';
import 'package:chat_app/src/presentation/widgets/relative_time_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatController _chatController = ChatController(context: context);
    _chatController.getChats();
    return Consumer3<UserProvider, ChatProvider, MessageProvider>(
      builder: (_, userProvider, chatProvider, messageProvider, __){
        return Scaffold(
          appBar: AppBar(
            backgroundColor: HexColor.fromHex('#1C2938'),
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Chat list',
                style: TextStyle(
                  color: HexColor.fromHex('#EFEEEE'),
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
          backgroundColor: HexColor.fromHex('#EFEEEE'),
          body: Stack(
            children: [
              SafeArea(
                child: ListView(
                  children: getChats(chatProvider: chatProvider, userProvider: userProvider),
                ),
              ),
              if (userProvider.loading)
                const LoadingIndicator()
            ],
          ),
        );
      },
    );
  }

  Widget unreadMessageBubble({required int number}){
    return Container(
      margin: const EdgeInsets.only(top: 5, left: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(360),
        child: Container(
          height: 25,
          width: 25,
          color: HexColor.fromHex('#1C2938'),
          alignment: Alignment.center,
          child: Text(
            number.toString(),
            style: TextStyle(
              color: HexColor.fromHex('#EFEEEE'),
              fontSize: 10
            ),
          ),
        ),
      ),
    );
  }

  Widget chatCard({required Chat chat, required UserProvider userProvider}){
    return AnimatedOnTapButton(
      onTap: (){},
      child: ListTile(
        title: Text(
          chat.idUser1 != userProvider.user.id ? chat.nameUser1.toString() : chat.nameUser2.toString(),
          style: TextStyle(
            color: HexColor.fromHex('#1C2938'),
            fontWeight: FontWeight.bold,
            fontSize: 20
          ),
        ),
        subtitle: Text(
          chat.lastMessage.toString(),
          style: TextStyle(
              color: HexColor.fromHex('#1C2938'),
              fontWeight: FontWeight.w400,
              fontSize: 16
          ),
        ),
        trailing: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 7),
              child: Text(
                RelativeTimeUtil.getRelativeTime(chat.lastMessageTimestamp ?? 0),
                style: TextStyle(
                    color: HexColor.fromHex('#1C2938').withOpacity(0.5),
                    fontWeight: FontWeight.w400,
                    fontSize: 12
                ),
              ),
            ),
            const SizedBox(height: 5,),
            chat.unreadMessage! > 0
                ? unreadMessageBubble(number: chat.unreadMessage!)
                : const SizedBox(height: 0)
          ],
        ),
        leading: AspectRatio(
          aspectRatio: 1,
          child: ClipOval(
            child: FadeInImage.assetNetwork(
                fit: BoxFit.cover,
                placeholder: 'assets/images/user_placeholder.png',
                imageErrorBuilder: (_,__,___){
                  return const Image(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/user_placeholder.png'),
                  );
                },
                image: chat.idUser1 != userProvider.user.id
                    ? chat.imageUser2 ?? Environment.imageUrl
                    : chat.imageUser1 ?? Environment.imageUrl
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getChats({required ChatProvider chatProvider, required UserProvider userProvider}) {
    return chatProvider.chats.map((chat) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: chatCard(chat: chat, userProvider: userProvider),
      );
    }).toList();
  }
}
