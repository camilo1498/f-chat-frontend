import 'package:chat_app/src/core/extensions/life_cycle.dart';
import 'package:chat_app/src/data/models/user.dart';
import 'package:chat_app/src/data/repositories/env.dart';
import 'package:chat_app/src/presentation/pages/home_page/home_page.dart';
import 'package:chat_app/src/presentation/pages/sign_in/sign_in_page.dart';
import 'package:chat_app/src/presentation/providers/auth_provider.dart';
import 'package:chat_app/src/presentation/providers/chat_provider.dart';
import 'package:chat_app/src/presentation/providers/home_page_provider.dart';
import 'package:chat_app/src/presentation/providers/message_provider.dart';
import 'package:chat_app/src/presentation/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Paint.enableDithering = true;

  /// force portrait mode
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  /// hide bottom navigation bar in android
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top]);

  /// force transparent top bar
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  /// storage init
  await GetStorage.init();
  Socket socket = io('${Environment.apiChat}chat', <String, dynamic> {
    'transports': ['websocket'],
    'autoConnect': false
  });
  socket.connect();
  /// initialize get storage
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => HomePageProvider()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => ChatProvider()),
      ChangeNotifierProvider(create: (_) => MessageProvider())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1080, 1920),
      builder: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.red),
        title: 'Chat App',
        home: const LifeCycleManager(child: MainPage()),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthProvider>(context);
    switch (_auth.status) {
      case AuthStatus.uninitialized:
        return const Center(
          child: SizedBox(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(),
          ),
        );
      case AuthStatus.unauthenticated:
      case AuthStatus.authenticating:
        return const SignInPage();

      case AuthStatus.authenticated:
        return const HomePage();
    }
  }
}
