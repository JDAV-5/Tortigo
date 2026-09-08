import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum PlantGameStage {
  dig,
  seed,
  water,
  sun,
  completed,
}

class PlantSeedPage extends StatefulWidget {
  const PlantSeedPage({super.key});

  @override
  State<PlantSeedPage> createState() => _PlantSeedPageState();
}

class _PlantSeedPageState extends State<PlantSeedPage>
    with SingleTickerProviderStateMixin {
  PlantGameStage _stage = PlantGameStage.dig;

  double _cloudOffset = 0.0;

  int _growthPhase = 0;

  bool _sunActivated = false;

  // ==========================================================
  // MOVIMIENTO DE TORTI
  // ==========================================================

  double _tortiX = 5.0;

  // Posición vertical base de Torti medida desde abajo.
  // El usuario puede moverla hacia arriba y hacia abajo.
  double _tortiY = 4.0;

  bool _tortiFacingRight = true;
  bool _tortiWalking = false;

  // Animación de pasos independiente de la velocidad del dedo.
  // Aunque el usuario arrastre muy rápido, Torti mantendrá
  // una cadencia estable de caminata.
  late final AnimationController _tortiStepController;
  late final Animation<double> _tortiStepAnimation;

  static const double _tortiWidth = 110.0;

  // Rango vertical permitido. Así Torti se puede mover
  // un poco hacia arriba sin invadir demasiado la escena.
  static const double _tortiMinY = 4.0;
  static const double _tortiMaxY = 75.0;

  @override
  void initState() {
    super.initState();

    // Un medio paso tarda 325 ms.
    // Como repeat(reverse: true) va y vuelve, el ciclo completo
    // dura aproximadamente 650 ms: se siente como una caminata
    // infantil tranquila y no depende de qué tan rápido arrastre.
    _tortiStepController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 325),
    );

    _tortiStepAnimation = CurvedAnimation(
      parent: _tortiStepController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _tortiStepController.dispose();
    super.dispose();
  }

  // ==========================================================
  // PROGRESO
  // ==========================================================

  int get _step {
    switch (_stage) {
      case PlantGameStage.dig:
        return 0;

      case PlantGameStage.seed:
        return 1;

      case PlantGameStage.water:
        return 2;

      case PlantGameStage.sun:
        return 3;

      case PlantGameStage.completed:
        return 4;
    }
  }

  double get _progress => _step / 4;

  // ==========================================================
  // INSTRUCCIONES
  // ==========================================================

  String get _instruction {
    switch (_stage) {
      case PlantGameStage.dig:
        return 'Arrastra la pala hasta la tierra';

      case PlantGameStage.seed:
        return '¡Muy bien! Ahora planta la semilla';

      case PlantGameStage.water:
        return 'La semilla necesita agua';

      case PlantGameStage.sun:
        return 'Mueve la nube para dejar pasar el sol';

      case PlantGameStage.completed:
        return '¡Excelente! Tu planta está creciendo';
    }
  }

  String get _expectedTool {
    switch (_stage) {
      case PlantGameStage.dig:
        return 'shovel';

      case PlantGameStage.seed:
        return 'seed';

      case PlantGameStage.water:
        return 'water';

      case PlantGameStage.sun:
      case PlantGameStage.completed:
        return '';
    }
  }

  // ==========================================================
  // HERRAMIENTA ACEPTADA
  // ==========================================================

  void _acceptTool(String tool) {
    if (tool != _expectedTool) {
      _wrongTool();
      return;
    }

    HapticFeedback.mediumImpact();

    switch (_stage) {
      case PlantGameStage.dig:
        setState(() {
          _stage = PlantGameStage.seed;
        });

        _showMessage(
          '¡Excelente! Ya hiciste el agujero 🕳️',
        );

        break;

      case PlantGameStage.seed:
        setState(() {
          _stage = PlantGameStage.water;
        });

        _showMessage(
          '¡Muy bien! La semilla está plantada 🌰',
        );

        break;

      case PlantGameStage.water:
        setState(() {
          _stage = PlantGameStage.sun;
          _growthPhase = 1;
        });

        _showMessage(
          '¡Mira! Está apareciendo un brote 🌱',
        );

        break;

      case PlantGameStage.sun:
      case PlantGameStage.completed:
        break;
    }
  }

  // ==========================================================
  // HERRAMIENTA INCORRECTA
  // ==========================================================

  void _wrongTool() {
    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(
            milliseconds: 1000,
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF003D5B),
          content: Text(
            _instruction,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
  }

  // ==========================================================
  // MENSAJES
  // ==========================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(
            milliseconds: 1100,
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF236B3A),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
  }

  // ==========================================================
  // MOVER TORTI
  // ==========================================================

  void _moveTorti(
    Offset delta,
    double availableWidth,
    double availableHeight,
  ) {
    if (delta == Offset.zero) {
      return;
    }

    // -----------------------------
    // LÍMITES HORIZONTALES
    // -----------------------------

    final maxX =
        (availableWidth - _tortiWidth)
            .clamp(0.0, double.infinity)
            .toDouble();

    final newX =
        (_tortiX + delta.dx)
            .clamp(0.0, maxX)
            .toDouble();

    // -----------------------------
    // LÍMITES VERTICALES
    // -----------------------------
    //
    // delta.dy positivo = el dedo baja.
    // Como usamos bottom, restamos delta.dy.

    final availableMaxY =
        (availableHeight - 120.0)
            .clamp(_tortiMinY, _tortiMaxY)
            .toDouble();

    final newY =
        (_tortiY - delta.dy)
            .clamp(_tortiMinY, availableMaxY)
            .toDouble();

    setState(() {
      _tortiX = newX;
      _tortiY = newY;

      // La dirección solo cambia cuando existe
      // movimiento horizontal suficiente.
      if (delta.dx > 0.15) {
        _tortiFacingRight = true;
      } else if (delta.dx < -0.15) {
        _tortiFacingRight = false;
      }
    });
  }

  void _startTortiWalking() {
    if (!_tortiWalking) {
      setState(() {
        _tortiWalking = true;
      });
    }

    if (!_tortiStepController.isAnimating) {
      _tortiStepController.repeat(
        reverse: true,
      );
    }
  }

  void _stopTorti() {
    if (!_tortiWalking) {
      return;
    }

    setState(() {
      _tortiWalking = false;
    });

    // Regresa suavemente al suelo cuando el usuario suelta a Torti.
    _tortiStepController.stop();
    _tortiStepController.animateTo(
      0.0,
      duration: const Duration(
        milliseconds: 160,
      ),
      curve: Curves.easeOut,
    );
  }

  // ==========================================================
  // MOVER NUBE
  // ==========================================================

  void _moveCloud(DragUpdateDetails details) {
    if (_stage != PlantGameStage.sun ||
        _sunActivated) {
      return;
    }

    final nextOffset =
        _cloudOffset + details.delta.dx;

    setState(() {
      _cloudOffset = nextOffset.clamp(
        0.0,
        180.0,
      );
    });

    if (_cloudOffset >= 115) {
      _activateSun();
    }
  }

  // ==========================================================
  // ACTIVAR SOL Y CRECIMIENTO
  // ==========================================================

  Future<void> _activateSun() async {
    if (_sunActivated) {
      return;
    }

    _sunActivated = true;

    HapticFeedback.heavyImpact();

    setState(() {
      _growthPhase = 2;
    });

    await Future.delayed(
      const Duration(milliseconds: 1400),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _growthPhase = 3;
    });

    await Future.delayed(
      const Duration(milliseconds: 1700),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _stage = PlantGameStage.completed;
    });

    // Dejamos la planta final visible un poco más de tiempo
    // antes de mostrar la tarjeta de misión completada.
    // Puedes aumentar o reducir este valor si quieres ajustar la pausa.
    await Future.delayed(
      const Duration(milliseconds: 2200),
    );

    if (!mounted) {
      return;
    }

    _showCompletedDialog();
  }

  // ==========================================================
  // REINICIAR
  // ==========================================================

  void _restartGame() {
    setState(() {
      _stage = PlantGameStage.dig;
      _cloudOffset = 0.0;
      _growthPhase = 0;
      _sunActivated = false;

      _tortiX = 5.0;
      _tortiY = 4.0;
      _tortiFacingRight = true;
      _tortiWalking = false;
    });

    _tortiStepController.stop();
    _tortiStepController.value = 0.0;
  }

  // ==========================================================
  // DIÁLOGO FINAL
  // ==========================================================

  void _showCompletedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(
              22,
              18,
              22,
              22,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: 0.20,
                  ),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/missions/torti_happy.png',
                  height: 150,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 5),

                const Text(
                  '¡Misión completada!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF236B3A),
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  '¡Plantaste una semilla y la ayudaste a crecer!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF64747C),
                    fontSize: 13,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 15),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF4C6),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: Color(0xFFFFC928),
                        size: 31,
                      ),
                      SizedBox(width: 5),
                      Text(
                        '+20',
                        style: TextStyle(
                          color: Color(0xFF7A5700),
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(
                            dialogContext,
                          );

                          _restartGame();
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize:
                              const Size(0, 50),
                          foregroundColor:
                              const Color(0xFF236B3A),
                          side: const BorderSide(
                            color: Color(0xFF59B83A),
                            width: 2,
                          ),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              16,
                            ),
                          ),
                        ),
                        child: const Text(
                          'Repetir',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(
                            dialogContext,
                          );

                          Navigator.pop(
                            context,
                            true,
                          );
                        },
                        style:
                            ElevatedButton.styleFrom(
                          minimumSize:
                              const Size(0, 50),
                          backgroundColor:
                              const Color(0xFF59B83A),
                          foregroundColor:
                              Colors.white,
                          elevation: 0,
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              16,
                            ),
                          ),
                        ),
                        child: const Text(
                          'Continuar',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            Brightness.light,
        systemStatusBarContrastEnforced: false,
      ),
      child: Scaffold(
        backgroundColor:
            const Color(0xFF51A934),
        body: Stack(
          fit: StackFit.expand,
          children: [
            // ==================================================
            // FONDO
            // ==================================================

            Image.asset(
              'assets/images/missions/fondoplant.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),

            Container(
              color: Colors.black.withValues(
                alpha: 0.04,
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  // ==================================================
                  // ENCABEZADO
                  // ==================================================

                  Padding(
                    padding:
                        const EdgeInsets.fromLTRB(
                      14,
                      8,
                      14,
                      0,
                    ),
                    child: Row(
                      children: [
                        Material(
                          color: const Color(
                            0xFF59B83A,
                          ),
                          elevation: 4,
                          shape:
                              const CircleBorder(),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            customBorder:
                                const CircleBorder(),
                            child:
                                const SizedBox(
                              width: 44,
                              height: 44,
                              child: Icon(
                                Icons
                                    .arrow_back_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        const Expanded(
                          child: Text(
                            'Planta una semilla',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight:
                                  FontWeight.w900,
                              shadows: [
                                Shadow(
                                  color:
                                      Colors.black38,
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                          ),
                        ),

                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white
                                .withValues(
                              alpha: 0.95,
                            ),
                            borderRadius:
                                BorderRadius.circular(
                              18,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color:
                                    Color(0xFFFFC928),
                                size: 21,
                              ),

                              const SizedBox(width: 4),

                              Text(
                                '$_step/4',
                                style:
                                    const TextStyle(
                                  color:
                                      Color(0xFF236B3A),
                                  fontSize: 14,
                                  fontWeight:
                                      FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ==================================================
                  // BARRA DE PROGRESO
                  // ==================================================

                  Padding(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 25,
                    ),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(20),
                      child:
                          LinearProgressIndicator(
                        value: _progress,
                        minHeight: 9,
                        backgroundColor:
                            Colors.white.withValues(
                          alpha: 0.60,
                        ),
                        valueColor:
                            const AlwaysStoppedAnimation<
                                Color>(
                          Color(0xFF59B83A),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ==================================================
                  // INSTRUCCIÓN
                  // ==================================================

                  Padding(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 22,
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(
                        milliseconds: 250,
                      ),
                      child: Container(
                        key: ValueKey(_stage),
                        width: double.infinity,
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white
                              .withValues(
                            alpha: 0.96,
                          ),
                          borderRadius:
                              BorderRadius.circular(
                            20,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withValues(
                                alpha: 0.10,
                              ),
                              blurRadius: 8,
                              offset:
                                  const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons
                                  .lightbulb_rounded,
                              color:
                                  Color(0xFFFFC928),
                              size: 23,
                            ),

                            const SizedBox(width: 8),

                            Flexible(
                              child: Text(
                                _instruction,
                                textAlign:
                                    TextAlign.center,
                                style:
                                    const TextStyle(
                                  color:
                                      Color(0xFF236B3A),
                                  fontSize: 13,
                                  fontWeight:
                                      FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 4),

                  // ==================================================
                  // ESCENARIO
                  // ==================================================

                  Expanded(
                    child: LayoutBuilder(
                      builder: (
                        context,
                        constraints,
                      ) {
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // =========================================
                            // SOL
                            // =========================================

                            if (_stage ==
                                    PlantGameStage
                                        .sun ||
                                _stage ==
                                    PlantGameStage
                                        .completed)
                              Positioned(
                                top: 2,
                                right: 70,
                                child:
                                    AnimatedOpacity(
                                  duration:
                                      const Duration(
                                    milliseconds:
                                        400,
                                  ),
                                  opacity:
                                      _cloudOffset >
                                              70
                                          ? 1
                                          : 0.50,
                                  child:
                                      Image.asset(
                                    'assets/images/missions/sun.png',
                                    width: 82,
                                    fit:
                                        BoxFit.contain,
                                  ),
                                ),
                              ),

                            // =========================================
                            // NUBE
                            // =========================================

                            if (_stage ==
                                PlantGameStage.sun)
                              Positioned(
                                top: 2,
                                right:
                                    60 -
                                    _cloudOffset,
                                child:
                                    GestureDetector(
                                  behavior:
                                      HitTestBehavior
                                          .opaque,
                                  onHorizontalDragUpdate:
                                      _moveCloud,
                                  child:
                                      Image.asset(
                                    'assets/images/missions/cloud.png',
                                    width: 125,
                                    fit:
                                        BoxFit.contain,
                                  ),
                                ),
                              ),

                            // =========================================
                            // ZONA DE PLANTACIÓN
                            // =========================================

                            Positioned(
                              left:
                                  constraints.maxWidth *
                                      0.22,
                              right: 0,
                              top: 38,
                              bottom: 0,
                              child:
                                  _buildPlantingArea(),
                            ),

                            // =========================================
                            // TORTI INTERACTIVA
                            // Se dibuja después de la zona de plantación
                            // para que siempre pueda recibir el gesto.
                            // =========================================

                            Positioned(
                              left: _tortiX,
                              // Posición vertical elegida por el usuario.
                              // El paso animado se aplica con Transform.translate,
                              // así su velocidad no depende del arrastre.
                              bottom: _tortiY,
                              child: Semantics(
                                label:
                                    'Torti. Arrastra en cualquier dirección para moverla.',
                                child:
                                    GestureDetector(
                                  behavior:
                                      HitTestBehavior
                                          .translucent,
                                  onPanStart: (_) {
                                    HapticFeedback
                                        .selectionClick();

                                    _startTortiWalking();
                                  },
                                  onPanUpdate:
                                      (details) {
                                    _moveTorti(
                                      details.delta,
                                      constraints
                                          .maxWidth,
                                      constraints
                                          .maxHeight,
                                    );
                                  },
                                  onPanEnd: (_) {
                                    _stopTorti();
                                  },
                                  onPanCancel:
                                      _stopTorti,
                                  child:
                                      AnimatedBuilder(
                                    animation:
                                        _tortiStepAnimation,
                                    builder:
                                        (context, child) {
                                      // IMPORTANTE:
                                      // Torti ya NO sube y baja automáticamente.
                                      // Sus pies se mantienen apoyados en el suelo.
                                      //
                                      // Para simular pasos usamos un balanceo
                                      // muy pequeño y una ligera compresión
                                      // del cuerpo, siempre anclada abajo.

                                      final phase =
                                          (_tortiStepAnimation
                                                      .value *
                                                  2.0) -
                                              1.0;

                                      final tilt =
                                          _tortiWalking
                                              ? phase *
                                                  0.018
                                              : 0.0;

                                      // Se comprime apenas cuando se inclina.
                                      // Como el alignment es bottomCenter,
                                      // los pies no "flotan".
                                      final compression =
                                          _tortiWalking
                                              ? phase.abs()
                                              : 0.0;

                                      final scaleY =
                                          1.0 -
                                              (compression *
                                                  0.012);

                                      final scaleX =
                                          1.0 +
                                              (compression *
                                                  0.006);

                                      return Transform.rotate(
                                        angle: tilt,
                                        alignment:
                                            Alignment
                                                .bottomCenter,
                                        child:
                                            Transform.scale(
                                          alignment:
                                              Alignment
                                                  .bottomCenter,
                                          scaleX:
                                              scaleX,
                                          scaleY:
                                              scaleY,
                                          child: child,
                                        ),
                                      );
                                    },
                                    child:
                                        Transform.flip(
                                      flipX:
                                          !_tortiFacingRight,
                                      child:
                                          AnimatedSwitcher(
                                        duration:
                                            const Duration(
                                          milliseconds:
                                              350,
                                        ),
                                        child:
                                            Image.asset(
                                          _stage ==
                                                  PlantGameStage
                                                      .completed
                                              ? 'assets/images/missions/torti_happy.png'
                                              : 'assets/images/missions/torti_idle.png',
                                          key:
                                              ValueKey(
                                            _stage ==
                                                PlantGameStage
                                                    .completed,
                                          ),
                                          width:
                                              _tortiWidth,
                                          fit:
                                              BoxFit.contain,
                                    ),
                                  ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  // ==================================================
                  // HERRAMIENTAS
                  // ==================================================

                  if (_stage !=
                      PlantGameStage.completed)
                    _buildToolbox(),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // ÁREA DE PLANTACIÓN
  // ==========================================================

  Widget _buildPlantingArea() {
    if (_stage == PlantGameStage.sun ||
        _stage == PlantGameStage.completed) {
      return Center(
        child: SizedBox(
          // Caja fija para todas las etapas de crecimiento.
          // Así el punto donde la planta toca la tierra no cambia
          // aunque el brote sea más grande.
          width: 260,
          height: 235,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedSwitcher(
              duration: const Duration(
                milliseconds: 900,
              ),

              // Mantiene el brote anterior y el nuevo apoyados
              // exactamente sobre la misma línea inferior.
              layoutBuilder: (
                currentChild,
                previousChildren,
              ) {
                return Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    ...previousChildren,
                    if (currentChild != null)
                      currentChild,
                  ],
                );
              },

              transitionBuilder: (
                child,
                animation,
              ) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: animation,
                    // MUY IMPORTANTE:
                    // la animación crece desde abajo hacia arriba,
                    // no desde el centro.
                    alignment: Alignment.bottomCenter,
                    child: child,
                  ),
                );
              },

              child: _growthWidget(),
            ),
          ),
        ),
      );
    }

    return DragTarget<String>(
      onWillAcceptWithDetails: (details) {
        return details.data ==
            _expectedTool;
      },

      onAcceptWithDetails: (details) {
        _acceptTool(details.data);
      },

      builder: (
        context,
        candidateData,
        rejectedData,
      ) {
        final highlighted =
            candidateData.isNotEmpty;

        return Center(
          child: AnimatedScale(
            duration: const Duration(
              milliseconds: 180,
            ),
            scale:
                highlighted ? 1.06 : 1.0,
            child: Container(
              padding:
                  const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: highlighted
                    ? Border.all(
                        color:
                            const Color(
                          0xFFFFD23F,
                        ),
                        width: 4,
                      )
                    : null,
              ),
              child: _groundWidget(),
            ),
          ),
        );
      },
    );
  }

  // ==========================================================
  // ESTADO DEL SUELO
  // ==========================================================

  Widget _groundWidget() {
    switch (_stage) {
      // ========================================================
      // TIERRA
      // ========================================================

      case PlantGameStage.dig:
        return Transform.translate(
          offset: const Offset(
            -30, // Horizontal: + derecha / - izquierda
            -5, // Vertical: + abajo / - arriba
          ),
          child: Image.asset(
            'assets/images/missions/soil.png',
            key: const ValueKey('soil'),
            width: 350, // Tamaño de soil.png
            fit: BoxFit.contain,
          ),
        );

      // ========================================================
      // AGUJERO
      // IMPORTANTE: el archivo actual se llama Hole.png
      // ========================================================

      case PlantGameStage.seed:
  return Transform.translate(
    offset: const Offset(
      -30, // Horizontal: + derecha / - izquierda
      -5, // Vertical: + abajo / - arriba
    ),
    child: Image.asset(
      'assets/images/missions/Hole.png',
      key: const ValueKey('hole'),
      width: 285, // Tamaño de Hole.png
      fit: BoxFit.contain,
    ),
  );

     // ========================================================
// SEMILLA DENTRO DEL AGUJERO
// ========================================================

case PlantGameStage.water:
  return SizedBox(
    width: 285,
    height: 210,
    child: Stack(
      alignment: Alignment.center,
      children: [

        // ================================================
        // AGUJERO
        // ================================================

        Transform.translate(
          offset: const Offset(
            -30, // + derecha / - izquierda
            -5, // + abajo / - arriba
          ),
          child: Image.asset(
            'assets/images/missions/Hole.png',
            width: 285,
            fit: BoxFit.contain,
          ),
        ),

        // ================================================
        // SEMILLA
        // ================================================

        Positioned(
          bottom: 72,
          left: 0,
          right: 0,
          child: Transform.translate(
            offset: const Offset(
              -30, // + derecha / - izquierda
              -12, // + abajo / - arriba
            ),
            child: Image.asset(
              'assets/images/missions/seed.png',
              width: 42,
              height: 42,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    ),
  );

case PlantGameStage.sun:
case PlantGameStage.completed:
  return const SizedBox();
    }
  }

  // ==========================================================
  // CRECIMIENTO DE LA PLANTA
  // ==========================================================

  Widget _growthWidget() {
    String asset;
    double width;

    // ========================================================
    // POSICIÓN COMPARTIDA DE TODOS LOS BROTES
    // ========================================================
    //
    // Los tres estados usan exactamente la misma ubicación.
    // Negativo = izquierda / positivo = derecha.
    const double plantOffsetX = -40.0;

    // Negativo = arriba / positivo = abajo.
    const double plantOffsetY = 0.0;

    // ========================================================
    // PRIMER BROTE
    // ========================================================

    if (_growthPhase <= 1) {
      asset =
          'assets/images/missions/sprout_1.png';

      width = 150;
    }

    // ========================================================
    // SEGUNDO BROTE
    // ========================================================

    else if (_growthPhase == 2) {
      asset =
          'assets/images/missions/sprout_2.png';

      width = 175;
    }

    // ========================================================
    // PLANTA FINAL
    // ========================================================

    else {
      asset =
          'assets/images/missions/plant.png';

      width = 200;
    }

    return Transform.translate(
      offset: const Offset(
        plantOffsetX,
        plantOffsetY,
      ),
      child: Image.asset(
        asset,
        key: ValueKey(
          '$asset-$_growthPhase',
        ),
        width: width,
        fit: BoxFit.contain,
      ),
    );
  }

  // ==========================================================
  // BANDEJA DE HERRAMIENTAS
  // ==========================================================

  Widget _buildToolbox() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 18,
      ),
      padding: const EdgeInsets.fromLTRB(
        12,
        9,
        12,
        11,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.97,
        ),
        borderRadius:
            BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.14,
            ),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Herramientas',
            style: TextStyle(
              color: Color(0xFF236B3A),
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 7),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly,
            children: [
              // ==================================================
              // PALA
              // ==================================================

              _ToolSlot(
                title: 'Pala',
                tool: 'shovel',
                active:
                    _stage ==
                    PlantGameStage.dig,
                completed: _step > 0,
                onWrong: _wrongTool,
                child: Image.asset(
                  'assets/images/missions/shovel.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ),

              // ==================================================
              // SEMILLA
              // ==================================================

              _ToolSlot(
                title: 'Semilla',
                tool: 'seed',
                active:
                    _stage ==
                    PlantGameStage.seed,
                completed: _step > 1,
                onWrong: _wrongTool,
                child: Image.asset(
                  'assets/images/missions/seed.png',
                  width: 47,
                  height: 47,
                  fit: BoxFit.contain,
                ),
              ),

              // ==================================================
              // REGADERA
              // ==================================================

              _ToolSlot(
                title: 'Agua',
                tool: 'water',
                active:
                    _stage ==
                    PlantGameStage.water,
                completed: _step > 2,
                onWrong: _wrongTool,
                child: Image.asset(
                  'assets/images/missions/watering_can.png',
                  width: 52,
                  height: 52,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ====================================================================
// TOOL SLOT
// ====================================================================

class _ToolSlot extends StatelessWidget {
  final String title;
  final String tool;

  final bool active;
  final bool completed;

  final Widget child;

  final VoidCallback onWrong;

  const _ToolSlot({
    required this.title,
    required this.tool,
    required this.active,
    required this.completed,
    required this.child,
    required this.onWrong,
  });

  @override
  Widget build(BuildContext context) {
    final content =
        AnimatedContainer(
      duration: const Duration(
        milliseconds: 200,
      ),
      width: 82,
      height: 88,
      padding:
          const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: active
            ? const Color(0xFFF2FAE9)
            : const Color(0xFFF4F6F7),
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: active
              ? const Color(0xFF59B83A)
              : const Color(0xFFE1E7EA),
          width: active ? 2.5 : 1.4,
        ),
        boxShadow: active
            ? [
                BoxShadow(
                  color:
                      const Color(
                    0xFF59B83A,
                  ).withValues(
                    alpha: 0.16,
                  ),
                  blurRadius: 8,
                  offset:
                      const Offset(
                    0,
                    3,
                  ),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 54,
            child: Center(
              child: completed
                  ? const Icon(
                      Icons
                          .check_circle_rounded,
                      color:
                          Color(0xFF59B83A),
                      size: 39,
                    )
                  : Opacity(
                      // Las herramientas inactivas
                      // siguen siendo visibles.
                      opacity:
                          active ? 1.0 : 0.68,
                      child: child,
                    ),
            ),
          ),

          const SizedBox(height: 1),

          Text(
            title,
            style: TextStyle(
              color: active
                  ? const Color(
                      0xFF236B3A,
                    )
                  : const Color(
                      0xFF718089,
                    ),
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );

    // ==========================================================
    // SOLO LA HERRAMIENTA ACTUAL SE PUEDE ARRASTRAR
    // ==========================================================

    if (!active || completed) {
      return content;
    }

    return Draggable<String>(
      data: tool,

      feedback: Material(
        color: Colors.transparent,
        child: Transform.scale(
          scale: 1.12,
          child: content,
        ),
      ),

      childWhenDragging:
          Opacity(
        opacity: 0.30,
        child: content,
      ),

      onDragStarted: () {
        HapticFeedback
            .selectionClick();
      },

      onDragEnd: (details) {
        if (!details.wasAccepted) {
          onWrong();
        }
      },

      child: content,
    );
  }
}