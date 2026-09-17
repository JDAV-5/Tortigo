import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data/services/player_progress_service.dart';

import 'presentation/pages/onboarding/onboarding_page.dart';
import 'presentation/pages/auth/login_page.dart';
import 'presentation/pages/auth/create_user_page.dart';
import 'presentation/pages/home/home_page.dart';
import 'presentation/pages/missions/missions_page.dart';
import 'presentation/pages/missions/plant_seed_page.dart';

// =====================================================================
// MAIN
// =====================================================================

Future<void> main() async {
  // Necesario porque ejecutamos código async antes de runApp.
  WidgetsFlutterBinding.ensureInitialized();

  // ===================================================================
  // INICIALIZAR PROGRESO LOCAL
  // ===================================================================
  //
  // IMPORTANTE:
  //
  // Este servicio se mantiene temporalmente porque actualmente
  // Home, Misiones y Logros todavía utilizan PlayerProgressService.
  //
  // El registro y login de usuarios se están migrando al backend:
  //
  // Flutter
  //   ↓
  // ASP.NET Core
  //   ↓
  // SQL Server
  //
  // Cuando migremos también el progreso al backend, esta inicialización
  // podrá eliminarse.
  // ===================================================================

  await PlayerProgressService.instance.initialize();

  // ===================================================================
  // CONFIGURACIÓN DE LA INTERFAZ DEL SISTEMA
  // ===================================================================

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemStatusBarContrastEnforced: false,
    ),
  );

  // ===================================================================
  // INICIAR APLICACIÓN
  // ===================================================================

  runApp(
    const MyApp(),
  );
}

// =====================================================================
// APP
// =====================================================================

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TortiGo',

      debugShowCheckedModeBanner: false,

      // ===============================================================
      // TEMA
      // ===============================================================

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(
            0xFF45A049,
          ),
        ),
        scaffoldBackgroundColor: const Color(
          0xFFF4F8F1,
        ),
      ),

      // ===============================================================
      // RUTA INICIAL
      // ===============================================================

      initialRoute: '/',

      // ===============================================================
      // RUTAS
      // ===============================================================

      routes: {
        // -------------------------------------------------------------
        // ONBOARDING
        // -------------------------------------------------------------

        '/': (context) =>
            const OnboardingPage(),

        // -------------------------------------------------------------
        // AUTENTICACIÓN
        // -------------------------------------------------------------

        '/login': (context) =>
            const LoginPage(),

        '/register': (context) =>
            const CreateUserPage(),

        // -------------------------------------------------------------
        // HOME
        // -------------------------------------------------------------

        '/home': (context) =>
            const HomePage(),

        // -------------------------------------------------------------
        // MISIONES
        // -------------------------------------------------------------

        '/missions': (context) =>
            const MissionsPage(),

        '/missions/plant-seed': (context) =>
            const PlantSeedPage(),
      },
    );
  }
}