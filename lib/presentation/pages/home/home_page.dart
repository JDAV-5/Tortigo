import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final playerName =
        ModalRoute.of(context)?.settings.arguments as String? ?? 'Héroe';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemStatusBarContrastEnforced: false,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF00506B),

        // =====================================================
        // BODY
        // =====================================================
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Fondo
            const CustomPaint(
              painter: HomeBackgroundPainter(),
            ),

            // Contenido
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 12),

                    // =================================================
                    // CABECERA
                    // =================================================
                    Row(
                      children: [
                        // Avatar
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF8FB8FF),
                              width: 2,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            '🐢',
                            style: TextStyle(
                              fontSize: 27,
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Saludo
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '¡Hola, $playerName!',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                '¿Qué aprenderemos hoy?',
                                style: TextStyle(
                                  color: Colors.white.withValues(
                                    alpha: 0.75,
                                  ),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Estrellas
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(
                              alpha: 0.14,
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.star_rounded,
                                color: Color(0xFFFFD23F),
                                size: 21,
                              ),
                              SizedBox(width: 5),
                              Text(
                                '0',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 35),

                    // =================================================
                    // TÍTULO
                    // =================================================
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Explora TortiGo',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Aprende, juega y ayuda al planeta',
                        style: TextStyle(
                          color: Colors.white.withValues(
                            alpha: 0.72,
                          ),
                          fontSize: 14,
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // =================================================
                    // FILA 1
                    // =================================================
                    Row(
                      children: [
                        // MISIONES
                        Expanded(
                          child: _HomeOptionCard(
                            title: 'Misiones\necológicas',
                            subtitle: 'Completa retos',
                            icon: Icons.eco_rounded,
                            iconColor: const Color(0xFF4C82D8),
                            backgroundColor: const Color(0xFFEAF1FF),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/missions',
                              );
                            },
                          ),
                        ),

                        const SizedBox(width: 12),

                        // JUEGOS
                        Expanded(
                          child: _HomeOptionCard(
                            title: 'Juegos\neducativos',
                            subtitle: 'Aprende jugando',
                            icon: Icons.sports_esports_rounded,
                            iconColor: const Color(0xFF006080),
                            backgroundColor: const Color(0xFFE3F7FA),
                            onTap: () {
                              debugPrint('Juegos');
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // =================================================
                    // FILA 2
                    // =================================================
                    Row(
                      children: [
                        // APRENDE
                        Expanded(
                          child: _HomeOptionCard(
                            title: 'Aprende',
                            subtitle: 'Explora el planeta',
                            icon: Icons.menu_book_rounded,
                            iconColor: const Color(0xFF7158C8),
                            backgroundColor: const Color(0xFFF1ECFF),
                            onTap: () {
                              debugPrint('Aprende');
                            },
                          ),
                        ),

                        const SizedBox(width: 12),

                        // LOGROS
                        Expanded(
                          child: _HomeOptionCard(
                            title: 'Logros',
                            subtitle: 'Tus recompensas',
                            icon: Icons.emoji_events_rounded,
                            iconColor: const Color(0xFFE8A700),
                            backgroundColor: const Color(0xFFFFF5D8),
                            onTap: () {
                              debugPrint('Logros');
                            },
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // =================================================
                    // FRASE
                    // =================================================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(
                          alpha: 0.13,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(
                            alpha: 0.12,
                          ),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.eco_outlined,
                            color: Color(0xFFAFCBFF),
                          ),

                          SizedBox(width: 10),

                          Flexible(
                            child: Text(
                              'Pequeñas acciones hacen grandes cambios',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),

        // =====================================================
        // BARRA DE NAVEGACIÓN
        // =====================================================
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.12,
                ),
                blurRadius: 18,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 68,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  _BottomNavItem(
                    icon: Icons.home_rounded,
                    label: 'Inicio',
                    selected: true,
                  ),
                  _BottomNavItem(
                    icon: Icons.sports_esports_rounded,
                    label: 'Juegos',
                  ),
                  _BottomNavItem(
                    icon: Icons.menu_book_rounded,
                    label: 'Aprende',
                  ),
                  _BottomNavItem(
                    icon: Icons.emoji_events_rounded,
                    label: 'Logros',
                  ),
                  _BottomNavItem(
                    icon: Icons.chat_bubble_rounded,
                    label: 'Torti',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================
// TARJETA DEL HOME
// =============================================================

class _HomeOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _HomeOptionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          height: 140,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Colors.white.withValues(
                alpha: 0.5,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.08,
                ),
                blurRadius: 14,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icono
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 27,
                ),
              ),

              const Spacer(),

              // Título
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF003D5B),
                  fontSize: 16,
                  height: 1.05,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 5),

              // Descripción
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF7B878D),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================
// ITEM BARRA INFERIOR
// =============================================================

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? const Color(0xFF4C82D8)
        : const Color(0xFF8A969D);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),

        const SizedBox(height: 3),

        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight:
                selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// =============================================================
// FONDO
// =============================================================

class HomeBackgroundPainter extends CustomPainter {
  const HomeBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // Fondo principal
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF0080A8),
          Color(0xFF006080),
          Color(0xFF003D5B),
        ],
      ).createShader(
        Rect.fromLTWH(
          0,
          0,
          size.width,
          size.height,
        ),
      );

    canvas.drawRect(
      Rect.fromLTWH(
        0,
        0,
        size.width,
        size.height,
      ),
      paint,
    );

    // Decoración
    final decorativePaint = Paint()
      ..color = const Color(
        0xFF8FB8FF,
      ).withValues(
        alpha: 0.16,
      );

    // Círculo derecho superior
    canvas.drawCircle(
      Offset(
        size.width * 0.90,
        size.height * 0.18,
      ),
      size.width * 0.28,
      decorativePaint,
    );

    // Círculo izquierdo inferior
    canvas.drawCircle(
      Offset(
        size.width * 0.05,
        size.height * 0.82,
      ),
      size.width * 0.23,
      decorativePaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}