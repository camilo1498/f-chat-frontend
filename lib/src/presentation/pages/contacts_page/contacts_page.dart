import 'package:chat_app/src/core/extensions/hex_color.dart';
import 'package:chat_app/src/data/models/user.dart';
import 'package:chat_app/src/presentation/pages/contacts_page/contacts_controller.dart';
import 'package:chat_app/src/presentation/pages/message_page/message_page.dart';
import 'package:chat_app/src/presentation/providers/user_provider.dart';
import 'package:chat_app/src/presentation/widgets/animations/animated_onTap_button.dart';
import 'package:chat_app/src/presentation/widgets/animations/page_transition_animation.dart';
import 'package:chat_app/src/presentation/widgets/loading_indicartor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ContactsController _contactsController = ContactsController();
    /// mediaQuery
    final _size = MediaQueryData.fromWindow(WidgetsBinding.instance!.window);
    return Consumer<UserProvider>(
      builder: (_, userProvider, __){
        return Scaffold(
          backgroundColor: HexColor.fromHex('#EFEEEE'),
          appBar: AppBar(
            backgroundColor: HexColor.fromHex('#1C2938'),
            elevation: 2,
            title: Text(
              'User list',
              style: TextStyle(
                color: HexColor.fromHex('#EFEEEE'),
              ),
            ),
          ),
          body: Stack(
            children: [
              SafeArea(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SizedBox(
                    width: _size.size.width,
                    height: _size.size.height,
                    child: FutureBuilder(
                      future: _contactsController.getUsers(),
                      builder: (context, AsyncSnapshot<List<User>> snapshot){
                        if(snapshot.hasData){
                          if(snapshot.data!.isNotEmpty == true){
                            return Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: ListView.builder(
                                itemCount: snapshot.data?.length ?? 0,
                                itemBuilder: (_, index){
                                  return _card(
                                      context: context,
                                      userChat: snapshot.data![index],
                                      name: '${snapshot.data?[index].name!} ${snapshot.data![index].lastname!}',
                                      photoUrl: snapshot.data?[index].image!.toString() ?? '',
                                      email: snapshot.data?[index].email! ?? ''
                                  );
                                },
                              ),
                            );
                          } else{
                            return const Center(
                                child: LoadingIndicator()
                            );
                          }
                        }
                        return const Center(
                            child: LoadingIndicator()
                        );
                      },
                    ),
                  ),
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

  /// list tile card
  Widget _card({
    required BuildContext context,
    required String name,
    required User userChat,
    required String photoUrl,
    required String email}) {
    return AnimatedOnTapButton(
      onTap: (){
        /// open sign up page
        Navigator.of(context).push(
            PageTransitionAnimation(
                child:
                MessagePage(userChat: userChat),
                direction:
                AxisDirection
                    .left));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        child: ListTile(
            leading: SizedBox(
              width: 56,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(3),
                    child: ClipRRect(
                      borderRadius:
                      BorderRadius.circular(360),
                      child: FadeInImage(
                        height: 56,
                        width: 56,
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            photoUrl),
                        placeholder: const AssetImage(
                            'assets/images/user_placeholder.png'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5,bottom: 2),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        width: 13,
                        height: 13,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white)
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            title: Text(
              name,
              style: TextStyle(
                  color: HexColor.fromHex('#1C2938'),
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              email,
              style: TextStyle(color: HexColor.fromHex('#1C2938')),
            )),
      ),
    );
  }
}