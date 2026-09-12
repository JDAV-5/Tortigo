import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() =>
      _OnboardingPageState();
}

class _OnboardingPageState
    extends State<OnboardingPage>
    with TickerProviderStateMixin {
  // ============================================================
  // CONTROLADORES
  // ============================================================

  late final AnimationController _introController;
  late final AnimationController _floatingController;

  // ============================================================
  // TORTI
  // ============================================================

  late final Animation<double> _tortiOpacity;
  late final Animation<double> _tortiScale;
  late final Animation<Offset> _tortiSlide;

  // ============================================================
  // LOGO
  // ============================================================

  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoScale;

  // ============================================================
  // FLOTACIÓN
  // ============================================================

  late final Animation<double> _floatingY;
  late final Animation<double> _floatingRotation;

  bool _navigated = false;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    // ----------------------------------------------------------
    // ANIMACIÓN PRINCIPAL
    // ----------------------------------------------------------

    _introController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1900,
      ),
    );

    // ----------------------------------------------------------
    // TORTI - OPACIDAD
    // ----------------------------------------------------------

    _tortiOpacity = CurvedAnimation(
      parent: _introController,
      curve: const Interval(
        0.0,
        0.45,
        curve: Curves.easeOut,
      ),
    );

    // ----------------------------------------------------------
    // TORTI - ESCALA
    // ----------------------------------------------------------

    _tortiScale = Tween<double>(
      begin: 0.72,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(
          0.0,
          0.65,
          curve: Curves.easeOutBack,
        ),
      ),
    );

    // ----------------------------------------------------------
    // TORTI - SUBE DESDE ABAJO
    // ----------------------------------------------------------

    _tortiSlide = Tween<Offset>(
      begin: const Offset(
        0,
        0.28,
      ),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(
          0.0,
          0.65,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    // ----------------------------------------------------------
    // LOGO - OPACIDAD
    // ----------------------------------------------------------

    _logoOpacity = CurvedAnimation(
      parent: _introController,
      curve: const Interval(
        0.38,
        0.90,
        curve: Curves.easeOut,
      ),
    );

    // ----------------------------------------------------------
    // LOGO - EFECTO POP
    // ----------------------------------------------------------

    _logoScale = Tween<double>(
      begin: 0.55,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(
          0.38,
          1.0,
          curve: Curves.elasticOut,
        ),
      ),
    );

    // ----------------------------------------------------------
    // MOVIMIENTO SUAVE DE TORTI
    // ----------------------------------------------------------

    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1800,
      ),
    );

    _floatingY = Tween<double>(
      begin: -5,
      end: 5,
    ).animate(
      CurvedAnimation(
        parent: _floatingController,
        curve: Curves.easeInOut,
      ),
    );

    _floatingRotation = Tween<double>(
      begin: -0.012,
      end: 0.012,
    ).animate(
      CurvedAnimation(
        parent: _floatingController,
        curve: Curves.easeInOut,
      ),
    );

    _startIntro();
  }

  // ============================================================
  // INICIAR INTRO
  // ============================================================

  Future<void> _startIntro() async {
    await Future.delayed(
      const Duration(
        milliseconds: 150,
      ),
    );

    if (!mounted) return;

    _introController.forward();

    await Future.delayed(
      const Duration(
        milliseconds: 1100,
      ),
    );

    if (!mounted) return;

    _floatingController.repeat(
      reverse: true,
    );

    // ----------------------------------------------------------
    // TIEMPO TOTAL EN SPLASH
    // ----------------------------------------------------------

    await Future.delayed(
      const Duration(
        milliseconds: 2350,
      ),
    );

    if (!mounted) return;

    _goToLogin();
  }

  // ============================================================
  // IR AL LOGIN
  // ============================================================

  Future<void> _goToLogin() async {
    if (_navigated) return;

    _navigated = true;

    HapticFeedback.selectionClick();

    if (!mounted) return;

    Navigator.pushReplacementNamed(
      context,
      '/login',
    );
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _introController.dispose();
    _floatingController.dispose();

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            Brightness.light,
        statusBarBrightness:
            Brightness.dark,
        systemStatusBarContrastEnforced:
            false,
      ),
      child: Scaffold(
        backgroundColor: const Color(
          0xFF00506B,
        ),
        body: LayoutBuilder(
          builder: (
            context,
            constraints,
          ) {
            final width =
                constraints.maxWidth;

            final height =
                constraints.maxHeight;

            return GestureDetector(
              behavior:
                  HitTestBehavior.opaque,

              // Permite saltar la intro tocando.
              onTap: () {
                if (_introController.value >
                    0.65) {
                  _goToLogin();
                }
              },

              child: Stack(
                fit: StackFit.expand,
                children: [
                  // =================================================
                  // NUEVO FONDO
                  // =================================================

                  Image.asset(
                    'assets/images/fondo1.png',
                    fit: BoxFit.cover,
                    alignment:
                        Alignment.center,
                  ),

                  // =================================================
                  // CAPA SUAVE
                  //
                  // Ayuda a que Torti y el logo resalten sobre
                  // cualquier zona clara del fondo.
                  // =================================================

                  Container(
                    color: Colors.black
                        .withValues(
                      alpha: 0.04,
                    ),
                  ),

                  // =================================================
                  // BRILLO CENTRAL DETRÁS DE TORTI
                  // =================================================

                  AnimatedBuilder(
                    animation:
                        _floatingController,
                    builder: (
                      context,
                      child,
                    ) {
                      final pulse =
                          _floatingController
                              .value;

                      return Positioned(
                        top: height * 0.14,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Opacity(
                            opacity:
                                0.10 +
                                (pulse * 0.07),
                            child:
                                Transform.scale(
                              scale:
                                  0.92 +
                                  (pulse *
                                      0.08),
                              child:
                                  Container(
                                width:
                                    width *
                                    0.78,
                                height:
                                    width *
                                    0.78,
                                decoration:
                                    const BoxDecoration(
                                  shape:
                                      BoxShape
                                          .circle,
                                  gradient:
                                      RadialGradient(
                                    colors: [
                                      Colors
                                          .white,
                                      Colors
                                          .transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // =================================================
                  // DESTELLO IZQUIERDO
                  // =================================================

                  Positioned(
                    top:
                        height *
                        0.21,
                    left:
                        width *
                        0.13,
                    child:
                        _AnimatedSparkle(
                      controller:
                          _floatingController,
                      size: 22,
                    ),
                  ),

                  // =================================================
                  // DESTELLO DERECHO
                  // =================================================

                  Positioned(
                    top:
                        height *
                        0.31,
                    right:
                        width *
                        0.12,
                    child:
                        _AnimatedSparkle(
                      controller:
                          _floatingController,
                      size: 17,
                      reverse: true,
                    ),
                  ),

                  // =================================================
                  // HOJA DECORATIVA
                  // =================================================

                  Positioned(
                    top:
                        height *
                        0.48,
                    right:
                        width *
                        0.09,
                    child:
                        FadeTransition(
                      opacity:
                          _logoOpacity,
                      child:
                          const Icon(
                        Icons.eco_rounded,
                        color:
                            Color(
                          0xFF8FD14F,
                        ),
                        size: 25,
                      ),
                    ),
                  ),

                  // =================================================
// TORTI
// =================================================

Positioned(
  // Antes: 0.16
  // Más grande el valor = más abajo
  top: height * 0.36,
  left: 0,
  right: 0,
  child: FadeTransition(
    opacity: _tortiOpacity,
    child: SlideTransition(
      position: _tortiSlide,
      child: ScaleTransition(
        scale: _tortiScale,
        child: AnimatedBuilder(
          animation: _floatingController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(
                0,
                _floatingY.value,
              ),
              child: Transform.rotate(
                angle: _floatingRotation.value,
                alignment: Alignment.bottomCenter,
                child: child,
              ),
            );
          },
          child: Center(
            child: Image.asset(
              'assets/images/tortigo_splash.png',
              // Antes: 0.62
              // Más grande = más tamaño
              width: width * 0.74,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    ),
  ),
),

                  // =================================================
                  // LOGO TORTIGO
                  // =================================================

                  Positioned(
                    top:
                        height *
                        0.60,
                    left:
                        width *
                        0.10,
                    right:
                        width *
                        0.10,
                    child:
                        FadeTransition(
                      opacity:
                          _logoOpacity,
                      child:
                          ScaleTransition(
                        scale:
                            _logoScale,
                        child:
                            Image.asset(
                          'assets/images/tortigo_logo1.png',
                          fit:
                              BoxFit
                                  .contain,
                        ),
                      ),
                    ),
                  ),

                  // =================================================
                  // TEXTO
                  // =================================================

                  Positioned(
                    top:
                        height *
                        0.75,
                    left: 20,
                    right: 20,
                    child:
                        FadeTransition(
                      opacity:
                          _logoOpacity,
                      child:
                          const Text(
                        '¡Aprende, juega y cuida el planeta!',
                        textAlign:
                            TextAlign
                                .center,
                        style:
                            TextStyle(
                          color:
                              Colors
                                  .white,
                          fontSize:
                              15,
                          fontWeight:
                              FontWeight
                                  .w700,
                          letterSpacing:
                              0.2,
                          shadows: [
                            Shadow(
                              color:
                                  Colors
                                      .black38,
                              blurRadius:
                                  6,
                              offset:
                                  Offset(
                                0,
                                2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // =================================================
                  // INDICADOR DE CARGA
                  // =================================================

                  Positioned(
                    bottom:
                        MediaQuery
                                .paddingOf(
                                  context,
                                )
                                .bottom +
                            25,
                    left: 0,
                    right: 0,
                    child:
                        FadeTransition(
                      opacity:
                          _logoOpacity,
                      child:
                          const Center(
                        child:
                            _LoadingDots(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// =====================================================================
// DESTELLO ANIMADO
// =====================================================================

class _AnimatedSparkle
    extends StatelessWidget {
  final AnimationController controller;

  final double size;

  final bool reverse;

  const _AnimatedSparkle({
    required this.controller,
    required this.size,
    this.reverse = false,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return AnimatedBuilder(
      animation: controller,
      builder: (
        context,
        child,
      ) {
        final value = reverse
            ? 1 -
                controller.value
            : controller.value;

        return Opacity(
          opacity:
              0.30 +
              (value * 0.70),
          child:
              Transform.scale(
            scale:
                0.65 +
                (value * 0.45),
            child:
                Transform.rotate(
              angle:
                  value * 0.35,
              child:
                  child,
            ),
          ),
        );
      },
      child: Icon(
        Icons.auto_awesome_rounded,
        color:
            const Color(
          0xFFFFD23F,
        ),
        size: size,
      ),
    );
  }
}

// =====================================================================
// PUNTOS DE CARGA
// =====================================================================

class _LoadingDots
    extends StatefulWidget {
  const _LoadingDots();

  @override
  State<_LoadingDots>
      createState() =>
          _LoadingDotsState();
}

class _LoadingDotsState
    extends State<_LoadingDots>
    with
        SingleTickerProviderStateMixin {
  late final AnimationController
      _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(
      vsync: this,
      duration:
          const Duration(
        milliseconds: 1000,
      ),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return AnimatedBuilder(
      animation:
          _controller,
      builder: (
        context,
        child,
      ) {
        return Row(
          mainAxisSize:
              MainAxisSize.min,
          children:
              List.generate(
            3,
            (index) {
              final phase =
                  (_controller.value *
                          3 -
                      index)
                      .abs();

              final opacity =
                  (1 -
                          phase.clamp(
                            0.0,
                            1.0,
                          ))
                      .clamp(
                        0.35,
                        1.0,
                      );

              return Container(
                margin:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 4,
                ),
                width: 8,
                height: 8,
                decoration:
                    BoxDecoration(
                  color: Colors.white
                      .withValues(
                    alpha:
                        opacity,
                  ),
                  shape:
                      BoxShape.circle,
                ),
              );
            },
          ),
        );
      },
    );
  }
}