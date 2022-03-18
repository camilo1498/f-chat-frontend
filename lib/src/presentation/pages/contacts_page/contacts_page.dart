import 'package:chat_app/src/core/extensions/hex_color.dart';
import 'package:chat_app/src/presentation/pages/contacts_page/contacts_controller.dart';
import 'package:flutter/material.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ContactsController _contactsController = ContactsController();
    return Scaffold(
      backgroundColor: HexColor.fromHex('#EFEEEE'),
    );
  }
}
