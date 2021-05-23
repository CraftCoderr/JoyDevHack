import 'package:example/navigation_page.dart';
import 'package:example/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'rooms.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('auth_box');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static final ThemeData _themeData = ThemeData(
    fontFamily: 'Montserrat_Medium',
    appBarTheme: const AppBarTheme(
      brightness: Brightness.light,
      centerTitle: true,
    ),
    primarySwatch: Colors.blue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    accentColor: Colors.purple[800]!
  );

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.grey,
      ),
    );
    // SystemChrome.setEnabledSystemUIOverlays(overlays)
    return MaterialApp(
      theme: _themeData,
      // home: const RoomsPage(),
      home: FirebaseChatCore.instance.firebaseUser != null
          ? const NavigationPage()
          : const RegisterPage(),
      routes: {
        '/navigation_page': (context) => NavigationPage(),
        '/register': (context) => RegisterPage(),
      },
    );
  }
}
