import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int? _selectedProfile;

  final List<PlayerProfile> _profiles = const [
    PlayerProfile(
      name: 'Ana',
      emoji: '🐢',
      accentColor: Color(0xFF8FB8FF),
    ),
    PlayerProfile(
      name: 'Juan',
      emoji: '🦫',
      accentColor: Color(0xFF719DF4),
    ),
    PlayerProfile(
      name: 'Sofía',
      emoji: '🐼',
      accentColor: Color(0xFFAFCBFF),
    ),
  ];

  void _selectProfile(int index) {
    setState(() {
      _selectedProfile = index;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Perfil seleccionado: ${_profiles[index].name}',
        ),
        duration: const Duration(milliseconds: 800),
      ),
    );

    // Después:
    //
    // Navigator.pushReplacementNamed(
    //   context,
    //   '/home',
    // );
  }

  void _createPlayer() {
    // Después:
    //
    // Navigator.pushNamed(
    //   context,
    //   '/register',
    // );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Crear nuevo jugador'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemStatusBarContrastEnforced: false,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF00506B),
        body: Stack(
          fit: StackFit.expand,
          children: [
            // ============================================
            // FONDO
            // ============================================

            const CustomPaint(
              painter: LoginBackgroundPainter(),
            ),

            // ============================================
            // CONTENIDO
            // ============================================

            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 430,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 22,
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 12),

                                // ============================
                                // LOGO
                                // ============================

                                Image.asset(
                                  'assets/images/tortigo_logo.png',
                                  width: 215,
                                  fit: BoxFit.contain,
                                ),

                                const SizedBox(height: 24),

                                // ============================
                                // TÍTULO
                                // ============================

                                const Text(
                                  '¿Quién está jugando?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    height: 1.1,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  'Selecciona tu perfil para continuar',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white.withValues(
                                      alpha: 0.78,
                                    ),
                                    fontSize: 14,
                                    height: 1.4,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                const SizedBox(height: 28),

                                // ============================
                                // PERFILES
                                // ============================

                                Row(
                                  children: List.generate(
                                    _profiles.length,
                                    (index) {
                                      return Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left:
                                                index == 0 ? 0 : 5,
                                            right: index ==
                                                    _profiles.length -
                                                        1
                                                ? 0
                                                : 5,
                                          ),
                                          child: _ProfileCard(
                                            profile:
                                                _profiles[index],
                                            selected:
                                                _selectedProfile ==
                                                    index,
                                            onTap: () {
                                              _selectProfile(index);
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                const SizedBox(height: 26),

                                // ============================
                                // NUEVO JUGADOR
                                // ============================

                                GestureDetector(
                                  onTap: _createPlayer,
                                  child: Container(
                                    width: double.infinity,
                                    constraints:
                                        const BoxConstraints(
                                      minHeight: 96,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(22),
                                      border: Border.all(
                                        color: const Color(
                                          0xFF8FB8FF,
                                        ),
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(
                                            alpha: 0.12,
                                          ),
                                          blurRadius: 16,
                                          offset:
                                              const Offset(0, 7),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        // BOTÓN +

                                        Container(
                                          width: 58,
                                          height: 58,
                                          decoration:
                                              const BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient:
                                                LinearGradient(
                                              begin:
                                                  Alignment.topLeft,
                                              end: Alignment
                                                  .bottomRight,
                                              colors: [
                                                Color(
                                                  0xFF719DF4,
                                                ),
                                                Color(
                                                  0xFF4C82D8,
                                                ),
                                              ],
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.add_rounded,
                                            size: 38,
                                            color: Colors.white,
                                          ),
                                        ),

                                        const SizedBox(width: 16),

                                        // TEXTO

                                        const Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                            children: [
                                              Text(
                                                'Nuevo jugador',
                                                style: TextStyle(
                                                  color: Color(
                                                    0xFF003D5B,
                                                  ),
                                                  fontSize: 18,
                                                  fontWeight:
                                                      FontWeight
                                                          .w800,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                'Crea un nuevo perfil y comienza tu aventura',
                                                style: TextStyle(
                                                  color: Color(
                                                    0xFF7B878D,
                                                  ),
                                                  fontSize: 12,
                                                  height: 1.3,
                                                  fontWeight:
                                                      FontWeight
                                                          .w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        const SizedBox(width: 12),

                                        // HOJA

                                        Container(
                                          width: 50,
                                          height: 50,
                                          decoration:
                                              BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: const Color(
                                              0xFF719DF4,
                                            ).withValues(
                                              alpha: 0.14,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.eco_rounded,
                                            color: Color(
                                              0xFF4C82D8,
                                            ),
                                            size: 30,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // ============================
                                // FRASE
                                // ============================

                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF003D5B,
                                    ).withValues(
                                      alpha: 0.68,
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.14,
                                      ),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.eco_outlined,
                                        color: Color(
                                          0xFFAFCBFF,
                                        ),
                                        size: 23,
                                      ),

                                      SizedBox(width: 10),

                                      Flexible(
                                        child: Text(
                                          'Pequeñas acciones hacen grandes cambios',
                                          textAlign:
                                              TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            height: 1.2,
                                            fontWeight:
                                                FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 32),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================
// MODELO
// =============================================================

class PlayerProfile {
  final String name;
  final String emoji;
  final Color accentColor;

  const PlayerProfile({
    required this.name,
    required this.emoji,
    required this.accentColor,
  });
}

// =============================================================
// TARJETA DE PERFIL
// =============================================================

class _ProfileCard extends StatelessWidget {
  final PlayerProfile profile;
  final bool selected;
  final VoidCallback onTap;

  const _ProfileCard({
    required this.profile,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(
        milliseconds: 180,
      ),
      scale: selected ? 1.035 : 1,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 180,
          ),
          height: 152,
          padding: const EdgeInsets.fromLTRB(
            8,
            10,
            8,
            8,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),

            // Todos mantienen borde.
            border: Border.all(
              color: selected
                  ? const Color(0xFF719DF4)
                  : profile.accentColor,
              width: selected ? 3.5 : 2.5,
            ),

            boxShadow: [
              BoxShadow(
                color: selected
                    ? const Color(
                        0xFF719DF4,
                      ).withValues(
                        alpha: 0.35,
                      )
                    : Colors.black.withValues(
                        alpha: 0.10,
                      ),
                blurRadius: selected ? 18 : 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              // ============================
              // AVATAR
              // ============================

              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFAFCBFF)
                          .withValues(
                        alpha: 0.85,
                      ),
                      const Color(0xFF8FB8FF),
                    ],
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  profile.emoji,
                  style: const TextStyle(
                    fontSize: 40,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                profile.name,
                style: const TextStyle(
                  color: Color(0xFF003D5B),
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const Spacer(),

              Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.star_rounded,
                  color: const Color(
                    0xFFFFD23F,
                  ),
                  size: 21,
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
// FONDO
// =============================================================

class LoginBackgroundPainter extends CustomPainter {
  const LoginBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // =========================================================
    // GRADIENTE PRINCIPAL
    // =========================================================

    final backgroundPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF0080A8),
          Color(0xFF006080),
          Color(0xFF004A69),
          Color(0xFF003D5B),
        ],
        stops: [
          0.0,
          0.30,
          0.68,
          1.0,
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
      backgroundPaint,
    );

    // =========================================================
    // MANCHA SUPERIOR IZQUIERDA
    // =========================================================

    final topPaint = Paint()
      ..color = const Color(
        0xFF8FB8FF,
      ).withValues(
        alpha: 0.25,
      );

    final topPath = Path()
      ..moveTo(0, 0)
      ..lineTo(
        size.width * 0.48,
        0,
      )
      ..cubicTo(
        size.width * 0.44,
        size.height * 0.08,
        size.width * 0.32,
        size.height * 0.10,
        size.width * 0.26,
        size.height * 0.16,
      )
      ..cubicTo(
        size.width * 0.15,
        size.height * 0.25,
        size.width * 0.08,
        size.height * 0.27,
        0,
        size.height * 0.28,
      )
      ..close();

    canvas.drawPath(
      topPath,
      topPaint,
    );

    // =========================================================
    // MANCHA DERECHA
    // =========================================================

    final rightPaint = Paint()
      ..color = const Color(
        0xFF719DF4,
      ).withValues(
        alpha: 0.09,
      );

    canvas.drawCircle(
      Offset(
        size.width * 0.93,
        size.height * 0.22,
      ),
      size.width * 0.22,
      rightPaint,
    );

    // =========================================================
    // ONDA INFERIOR 1
    // =========================================================

    final hillPaint = Paint()
      ..color = const Color(
        0xFF719DF4,
      ).withValues(
        alpha: 0.16,
      );

    final hillPath = Path()
      ..moveTo(
        0,
        size.height * 0.87,
      )
      ..cubicTo(
        size.width * 0.20,
        size.height * 0.80,
        size.width * 0.34,
        size.height * 0.91,
        size.width * 0.54,
        size.height * 0.85,
      )
      ..cubicTo(
        size.width * 0.74,
        size.height * 0.78,
        size.width * 0.88,
        size.height * 0.87,
        size.width,
        size.height * 0.81,
      )
      ..lineTo(
        size.width,
        size.height,
      )
      ..lineTo(
        0,
        size.height,
      )
      ..close();

    canvas.drawPath(
      hillPath,
      hillPaint,
    );

    // =========================================================
    // ONDA INFERIOR 2
    // =========================================================

    final secondHillPaint = Paint()
      ..color = const Color(
        0xFFAFCBFF,
      ).withValues(
        alpha: 0.10,
      );

    final secondHillPath = Path()
      ..moveTo(
        0,
        size.height * 0.94,
      )
      ..cubicTo(
        size.width * 0.25,
        size.height * 0.87,
        size.width * 0.48,
        size.height * 0.97,
        size.width * 0.68,
        size.height * 0.90,
      )
      ..cubicTo(
        size.width * 0.83,
        size.height * 0.85,
        size.width * 0.92,
        size.height * 0.91,
        size.width,
        size.height * 0.88,
      )
      ..lineTo(
        size.width,
        size.height,
      )
      ..lineTo(
        0,
        size.height,
      )
      ..close();

    canvas.drawPath(
      secondHillPath,
      secondHillPaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}