import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlantSeedPage extends StatefulWidget {
  const PlantSeedPage({super.key});

  @override
  State<PlantSeedPage> createState() => _PlantSeedPageState();
}

class _PlantSeedPageState extends State<PlantSeedPage> {
  int _currentStep = 0;

  final List<PlantStep> _steps = const [
    PlantStep(
      title: 'Tierra',
      description: 'Prepara la tierra',
      icon: Icons.landscape_rounded,
      color: Color(0xFF8FB8FF),
    ),
    PlantStep(
      title: 'Semilla',
      description: 'Coloca la semilla',
      icon: Icons.grass_rounded,
      color: Color(0xFFAFCBFF),
    ),
    PlantStep(
      title: 'Agua',
      description: 'Dale un poco de agua',
      icon: Icons.water_drop_rounded,
      color: Color(0xFF719DF4),
    ),
    PlantStep(
      title: 'Sol',
      description: 'Necesita luz del sol',
      icon: Icons.wb_sunny_rounded,
      color: Color(0xFFFFD23F),
    ),
  ];

  // ============================================================
  // SELECCIONAR PASO
  // ============================================================

  void _selectStep(int index) {
    // Si ya fue completado, no hacemos nada.
    if (index < _currentStep) {
      return;
    }

    // Paso correcto.
    if (index == _currentStep) {
      HapticFeedback.lightImpact();

      setState(() {
        _currentStep++;
      });

      // Si completó todos los pasos.
      if (_currentStep == _steps.length) {
        Future.delayed(
          const Duration(milliseconds: 600),
          () {
            if (!mounted) return;

            _showCompletedDialog();
          },
        );
      }

      return;
    }

    // Paso incorrecto.
    HapticFeedback.mediumImpact();

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(
            '¡Casi! Piensa qué necesitamos primero 🌱',
          ),
          duration: Duration(
            milliseconds: 1200,
          ),
        ),
      );
  }

  // ============================================================
  // MISIÓN COMPLETADA
  // ============================================================

  void _showCompletedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(26),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: 0.18,
                  ),
                  blurRadius: 25,
                  offset: const Offset(
                    0,
                    10,
                  ),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ICONO
                Container(
                  width: 85,
                  height: 85,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFAFCBFF),
                        Color(0xFF719DF4),
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.eco_rounded,
                    color: Colors.white,
                    size: 50,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  '¡Misión completada!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF003D5B),
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  '¡Excelente! Aprendiste cómo plantar una semilla.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF718089),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 22),

                // RECOMPENSA
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF5D8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: Color(0xFFFFD23F),
                        size: 32,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '+20',
                        style: TextStyle(
                          color: Color(0xFF003D5B),
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // BOTÓN CONTINUAR
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      // Cierra diálogo.
                      Navigator.pop(dialogContext);

                      // Regresa a Misiones.
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                        0xFF719DF4,
                      ),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          17,
                        ),
                      ),
                    ),
                    child: const Text(
                      'Continuar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final progress = _currentStep / _steps.length;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemStatusBarContrastEnforced: false,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF00506B),
        body: Stack(
          fit: StackFit.expand,
          children: [
            // ==================================================
            // FONDO
            // ==================================================

            const CustomPaint(
              painter: PlantSeedBackgroundPainter(),
            ),

            // ==================================================
            // CONTENIDO
            // ==================================================

            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  20,
                  12,
                  20,
                  32,
                ),
                child: Column(
                  children: [
                    // ==========================================
                    // CABECERA
                    // ==========================================

                    Row(
                      children: [
                        Material(
                          color: Colors.white.withValues(
                            alpha: 0.15,
                          ),
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const SizedBox(
                              width: 48,
                              height: 48,
                              child: Icon(
                                Icons.arrow_back_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                        ),

                        const Expanded(
                          child: Text(
                            'Planta una semilla',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),

                        const SizedBox(
                          width: 48,
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // ==========================================
                    // PROGRESO
                    // ==========================================

                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              20,
                            ),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 9,
                              backgroundColor:
                                  Colors.white.withValues(
                                alpha: 0.20,
                              ),
                              valueColor:
                                  const AlwaysStoppedAnimation<
                                      Color>(
                                Color(0xFF8FB8FF),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        SizedBox(
                          width: 35,
                          child: Text(
                            '$_currentStep/${_steps.length}',
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // ==========================================
                    // PREGUNTA
                    // ==========================================

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(
                          alpha: 0.13,
                        ),
                        borderRadius: BorderRadius.circular(
                          24,
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(
                            alpha: 0.14,
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            '🌱',
                            style: TextStyle(
                              fontSize: 38,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            _currentStep == 0
                                ? '¿Sabes cómo plantar una semilla?'
                                : _currentStep < _steps.length
                                    ? '¡Muy bien! ¿Qué sigue ahora?'
                                    : '¡Tu planta está lista para crecer!',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              height: 1.25,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ==========================================
                    // VISUALIZACIÓN
                    // ==========================================

                    _PlantVisualization(
                      progress: progress,
                    ),

                    const SizedBox(height: 28),

                    // ==========================================
                    // INSTRUCCIÓN
                    // ==========================================

                    const Text(
                      'Toca los elementos en el orden correcto',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ==========================================
                    // TARJETAS
                    // CORREGIDAS PARA EVITAR OVERFLOW
                    // ==========================================

                    GridView.builder(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      itemCount: _steps.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,

                        // Altura fija para evitar:
                        // BOTTOM OVERFLOWED
                        mainAxisExtent: 158,
                      ),
                      itemBuilder: (
                        context,
                        index,
                      ) {
                        final completed =
                            index < _currentStep;

                        final current =
                            index == _currentStep;

                        return _StepCard(
                          step: _steps[index],
                          completed: completed,
                          current: current,
                          onTap: () {
                            _selectStep(index);
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // ==========================================
                    // PISTA
                    // ==========================================

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(
                          alpha: 0.08,
                        ),
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.lightbulb_outline_rounded,
                            color: Colors.white.withValues(
                              alpha: 0.75,
                            ),
                            size: 20,
                          ),

                          const SizedBox(width: 7),

                          Flexible(
                            child: Text(
                              'Piensa qué necesita primero una semilla',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withValues(
                                  alpha: 0.75,
                                ),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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

class PlantStep {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const PlantStep({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

// =============================================================
// TARJETA DEL PASO
// =============================================================

class _StepCard extends StatelessWidget {
  final PlantStep step;
  final bool completed;
  final bool current;
  final VoidCallback onTap;

  const _StepCard({
    required this.step,
    required this.completed,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(
        milliseconds: 180,
      ),
      scale: current ? 1.025 : 1,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          22,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            22,
          ),
          child: AnimatedContainer(
            duration: const Duration(
              milliseconds: 180,
            ),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                22,
              ),
              border: Border.all(
                color: completed
                    ? const Color(0xFF719DF4)
                    : current
                        ? const Color(0xFF8FB8FF)
                        : Colors.transparent,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: 0.08,
                  ),
                  blurRadius: 12,
                  offset: const Offset(
                    0,
                    6,
                  ),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                // ============================================
                // ICONO
                // ============================================

                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: step.color.withValues(
                          alpha: 0.20,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        step.icon,
                        size: 29,
                        color: step.title == 'Sol'
                            ? const Color(
                                0xFFE8A700,
                              )
                            : const Color(
                                0xFF4C82D8,
                              ),
                      ),
                    ),

                    // CHECK
                    if (completed)
                      Positioned(
                        right: -5,
                        bottom: -3,
                        child: Container(
                          width: 23,
                          height: 23,
                          decoration:
                              const BoxDecoration(
                            color: Color(
                              0xFF4C82D8,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 10),

                // ============================================
                // TÍTULO
                // ============================================

                Text(
                  step.title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: const TextStyle(
                    color: Color(0xFF003D5B),
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 4),

                // ============================================
                // DESCRIPCIÓN
                // ============================================

                Text(
                  step.description,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF7B878D),
                    fontSize: 10,
                    height: 1.2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================
// VISUALIZACIÓN DE LA PLANTA
// =============================================================

class _PlantVisualization extends StatelessWidget {
  final double progress;

  const _PlantVisualization({
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 175,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // RESPLANDOR
          Container(
            width: 210,
            height: 115,
            decoration: BoxDecoration(
              color: const Color(
                0xFF8FB8FF,
              ).withValues(
                alpha: 0.12,
              ),
              shape: BoxShape.circle,
            ),
          ),

          // MACETA
          Positioned(
            bottom: 5,
            child: Container(
              width: 105,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(
                  0xFF719DF4,
                ),
                borderRadius:
                    const BorderRadius.only(
                  bottomLeft:
                      Radius.circular(30),
                  bottomRight:
                      Radius.circular(30),
                  topLeft:
                      Radius.circular(10),
                  topRight:
                      Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: 0.18,
                    ),
                    blurRadius: 12,
                    offset: const Offset(
                      0,
                      7,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // TIERRA
          if (progress >= 0.25)
            Positioned(
              bottom: 61,
              child: Container(
                width: 92,
                height: 22,
                decoration: BoxDecoration(
                  color: const Color(
                    0xFF003D5B,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    50,
                  ),
                ),
              ),
            ),

          // SEMILLA
          if (progress >= 0.50 &&
              progress < 0.75)
            const Positioned(
              bottom: 67,
              child: Icon(
                Icons.circle,
                color: Color(0xFFFFD23F),
                size: 13,
              ),
            ),

          // BROTE
          if (progress >= 0.75)
            Positioned(
              bottom: 70,
              child: AnimatedContainer(
                duration: const Duration(
                  milliseconds: 400,
                ),
                height:
                    progress >= 1 ? 80 : 48,
                child: Icon(
                  Icons.eco_rounded,
                  color: const Color(
                    0xFFAFCBFF,
                  ),
                  size:
                      progress >= 1 ? 76 : 48,
                ),
              ),
            ),

          // SOL
          if (progress >= 1)
            const Positioned(
              top: 3,
              right: 50,
              child: Icon(
                Icons.wb_sunny_rounded,
                color: Color(
                  0xFFFFD23F,
                ),
                size: 43,
              ),
            ),
        ],
      ),
    );
  }
}

// =============================================================
// FONDO
// =============================================================

class PlantSeedBackgroundPainter
    extends CustomPainter {
  const PlantSeedBackgroundPainter();

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    // =========================================================
    // FONDO PRINCIPAL
    // =========================================================

    final background = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF0080A8),
          Color(0xFF006080),
          Color(0xFF004A69),
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
      background,
    );

    // =========================================================
    // DECORACIÓN SUPERIOR
    // =========================================================

    final topDecoration = Paint()
      ..color = const Color(
        0xFF8FB8FF,
      ).withValues(
        alpha: 0.18,
      );

    canvas.drawCircle(
      Offset(
        size.width * 0.05,
        size.height * 0.10,
      ),
      size.width * 0.42,
      topDecoration,
    );

    // =========================================================
    // DECORACIÓN INFERIOR
    // =========================================================

    final bottomDecoration = Paint()
      ..color = const Color(
        0xFF719DF4,
      ).withValues(
        alpha: 0.10,
      );

    canvas.drawCircle(
      Offset(
        size.width,
        size.height * 0.78,
      ),
      size.width * 0.45,
      bottomDecoration,
    );
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}