import 'package:chat_app/src/data/models/user.dart';
import 'package:chat_app/src/presentation/providers/user_provider.dart';

class ContactsController {

  UserProvider userProvider = UserProvider();

  Future<List<User>> getUsers() async{
    return await userProvider.getUsers();
  }

}
