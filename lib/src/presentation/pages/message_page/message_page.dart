import 'package:chat_app/src/core/extensions/hex_color.dart';
import 'package:chat_app/src/data/models/message.dart';
import 'package:chat_app/src/data/models/user.dart';
import 'package:chat_app/src/presentation/pages/message_page/message_controller.dart';
import 'package:chat_app/src/presentation/providers/message_provider.dart';
import 'package:chat_app/src/presentation/providers/user_provider.dart';
import 'package:chat_app/src/presentation/widgets/animations/animated_onTap_button.dart';
import 'package:chat_app/src/presentation/widgets/bubble.dart';
import 'package:chat_app/src/presentation/widgets/relative_time_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessagePage extends StatelessWidget {
  final User userChat;
  const MessagePage({
    Key? key,
    required this.userChat
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MessageController _messageController = MessageController(context: context, userChat: userChat);
    final _size = MediaQueryData.fromWindow(WidgetsBinding.instance!.window);
    return Consumer2<MessageProvider, UserProvider>(
      builder: (_, messageProvider, userProvider,__){
        return Scaffold(
          backgroundColor: HexColor.fromHex('#EFEEEE'),
          body: SizedBox(
            width: _size.size.width,
            height: _size.size.height,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: _appBar(context: context, messageProvider: messageProvider),
                ),
                Expanded(
                  flex: 1,
                  child: ListView(
                    reverse: true,
                    controller: _messageController.controller,
                    children: getMessages(messageProvider: messageProvider, userProvider: userProvider),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _messageBox(
                      context: context,
                      messageController: _messageController
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// chat details
  Widget _appBar({required BuildContext context, required MessageProvider messageProvider}){
    return Container(
      color: HexColor.fromHex('#EFEEEE'),
      child: SafeArea(
        child: ListTile(
          title: Text(
            '${userChat.name} ${userChat.lastname}',
            style: TextStyle(
                color: HexColor.fromHex('#1C2938'),
                fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            messageProvider.isWriting == true ?
            'Writing...' : messageProvider.isOnline == true ? 'Online' : 'Offline',
            style: TextStyle(
                color: messageProvider.isWriting == true
                    ? Colors.green
                    : HexColor.fromHex('#1C2938')
            ),
          ),
          leading: AnimatedOnTapButton(
            onTap: () => Navigator.pop(context),
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Icon(
                Icons.arrow_back_ios,
              color: HexColor.fromHex('#1C2938'),
          ),
            ),
          ),
          trailing: SizedBox(
            width: 56,
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: HexColor.fromHex('#1C2938'),
                          blurRadius: 5,
                          offset: const Offset(0, 1))
                    ]),
                child: ClipRRect(
                  borderRadius:
                  BorderRadius.circular(360),
                  child: FadeInImage(
                    height: 56,
                    width: 56,
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        userChat.image!),
                    imageErrorBuilder: (_,__,___){
                      return const Image(
                        fit: BoxFit.cover,
                        image: AssetImage(
                            'assets/images/user_placeholder.png'),
                      );
                    },
                    placeholder: const AssetImage(
                        'assets/images/user_placeholder.png'),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// custom message box
  Widget _messageBox({required BuildContext context, required MessageController messageController}){
    return SafeArea(
      top: false,
      child: Container(
        constraints: const BoxConstraints(
          maxHeight: 180
        ),
        color: HexColor.fromHex('#EFEEEE'),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 7,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: HexColor.fromHex('#EFEEEE'),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                          color: HexColor.fromHex('#1C2938'),
                          blurRadius: 2,
                          offset: const Offset(0, 1)
                      )
                    ]

                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        flex: 1,
                        child: AnimatedOnTapButton(
                          onTap: (){},
                          child: Icon(
                            Icons.image,
                            color: HexColor.fromHex('#1C2938'),
                            size: 30,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: TextField(
                            controller: messageController.messageTextController,
                            focusNode: messageController.messageNode,
                            maxLines: 200,
                            minLines: 1,
                            onChanged: (_){
                              messageController.emitWriting();
                            },
                            style: TextStyle(
                              color: HexColor.fromHex('#1C2938'),
                              fontWeight: FontWeight.w400
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Type a message',
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10,),
              Expanded(
                flex: 1,
                child: AnimatedOnTapButton(
                  onTap: (){
                    messageController.sendMessage(userChat: userChat);
                  },
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      color: HexColor.fromHex('#1C2938'),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: HexColor.fromHex('#1C2938'),
                            blurRadius: 2,
                            offset: const Offset(0, 1)
                        )
                      ]
                    ),
                    child: Icon(
                      Icons.send,
                      color: HexColor.fromHex('#EFEEEE'),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// message list
  List<Widget>getMessages({required MessageProvider messageProvider, required UserProvider userProvider}){
    return messageProvider.message.map((message) {
      return Container(
        margin:  const EdgeInsets.symmetric(horizontal: 20),
        child: bubbleMessage(message, userProvider),
      );
    }).toList();
  }
  /// message container
  Widget bubbleMessage(Message message, UserProvider userProvider){
    return Align(
      alignment: message.idSender == userProvider.user.id ? Alignment.centerRight : Alignment.centerLeft,
      child: Bubble(
        message: message.message!,
        delivered: true,
        isMe: message.idSender == userProvider.user.id,
        status: message.status!,
        time: RelativeTimeUtil.getRelativeTime(message.timestamp!),
      ),
    );
  }
}