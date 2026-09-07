import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'presentation/pages/onboarding/onboarding_page.dart';
//import 'presentation/pages/onboarding/welcome_page.dart';
import 'presentation/pages/auth/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemStatusBarContrastEnforced: false,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TortiGo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF005A78),
        ),
      ),

      initialRoute: '/',

      routes: {
        '/': (context) => const OnboardingPage(),
        //'/welcome': (context) => const WelcomePage(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}