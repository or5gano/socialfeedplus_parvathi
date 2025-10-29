import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final String? username = prefs.getString('username');
    final String initialRoute = username != null ? Home.id : LoginScreen.id;

  runApp(ProviderScope(
      child: MyApp(initialRoute: initialRoute)));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
        // theme: ThemeData(
        //   colorScheme: ThemeData().colorScheme.copyWith(
        //     primary: primaryColour,
        //   ),
        // ),
        debugShowCheckedModeBanner: false,
        initialRoute: initialRoute,
        routes: {
          LoginScreen.id: (context) => const LoginScreen(),
          Home.id: (context) => const Home(),
        });
  }
}
