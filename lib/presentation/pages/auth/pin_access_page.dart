import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../data/services/player_progress_service.dart';

class PinAccessPage extends StatefulWidget {
  final String playerName;

  // PIN temporal para validar el perfil.
  // Más adelante podremos guardarlo junto al perfil.
  final String expectedPin;

  const PinAccessPage({
    super.key,
    required this.playerName,
    required this.expectedPin,
  });

  @override
  State<PinAccessPage> createState() =>
      _PinAccessPageState();
}

class _PinAccessPageState
    extends State<PinAccessPage> {
  static const int _pinLength = 4;

  final PlayerProgressService _progressService =
      PlayerProgressService.instance;

  String _pin = '';

  bool _hasError = false;
  bool _isChecking = false;

  // ============================================================
  // AGREGAR NÚMERO
  // ============================================================

  void _addDigit(String digit) {
    if (_isChecking) {
      return;
    }

    if (_pin.length >= _pinLength) {
      return;
    }

    HapticFeedback.selectionClick();

    setState(() {
      _hasError = false;
      _pin += digit;
    });
  }

  // ============================================================
  // BORRAR ÚLTIMO NÚMERO
  // ============================================================

  void _removeDigit() {
    if (_isChecking) {
      return;
    }

    if (_pin.isEmpty) {
      return;
    }

    HapticFeedback.lightImpact();

    setState(() {
      _hasError = false;

      _pin = _pin.substring(
        0,
        _pin.length - 1,
      );
    });
  }

  // ============================================================
  // VALIDAR PIN
  // ============================================================

  Future<void> _submitPin() async {
    if (_isChecking) {
      return;
    }

    if (_pin.length != _pinLength) {
      HapticFeedback.lightImpact();

      setState(() {
        _hasError = true;
      });

      return;
    }

    setState(() {
      _isChecking = true;
      _hasError = false;
    });

    // Pequeña espera para que la interacción
    // se sienta más natural.
    await Future.delayed(
      const Duration(
        milliseconds: 250,
      ),
    );

    if (!mounted) {
      return;
    }

    // ==========================================================
    // PIN CORRECTO
    // ==========================================================

    if (_pin == widget.expectedPin) {
      HapticFeedback.mediumImpact();

      // ========================================================
      // ACTIVAR PERFIL
      // ========================================================
      //
      // Aquí ocurre algo MUY importante:
      //
      // Ana  -> perfil activo Ana 🐢
      // Juan -> perfil activo Juan 🦫
      // Sofía -> perfil activo Sofía 🐼
      //
      // Home, Misiones y Logros podrán consultar después
      // exactamente este mismo perfil.
      // ========================================================

      final profileActivated =
          await _progressService
              .setActiveProfileByName(
        widget.playerName,
      );

      if (!mounted) {
        return;
      }

      // ========================================================
      // ERROR SI NO EXISTE EL PERFIL
      // ========================================================

      if (!profileActivated) {
        setState(() {
          _isChecking = false;
        });

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                'No se pudo abrir el perfil de ${widget.playerName}.',
              ),
              duration: const Duration(
                seconds: 2,
              ),
            ),
          );

        return;
      }

      // ========================================================
      // ENTRAR AL HOME
      // ========================================================
      //
      // Seguimos enviando playerName por compatibilidad
      // temporal con el Home actual.
      //
      // En el siguiente paso el Home dejará de depender
      // de este argumento y leerá directamente el perfil activo.
      // ========================================================

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (route) => false,
        arguments: widget.playerName,
      );

      return;
    }

    // ==========================================================
    // PIN INCORRECTO
    // ==========================================================

    HapticFeedback.heavyImpact();

    setState(() {
      _hasError = true;
      _isChecking = false;
    });

    await Future.delayed(
      const Duration(
        milliseconds: 650,
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _pin = '';
    });
  }

  // ============================================================
  // VOLVER
  // ============================================================

  void _goBack() {
    HapticFeedback.selectionClick();

    Navigator.pop(context);
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
        backgroundColor:
            const Color(
          0xFF236B3A,
        ),

        body: Stack(
          fit: StackFit.expand,

          children: [
            // =================================================
            // FONDO
            // =================================================

            Image.asset(
              'assets/images/fondo2.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),

            // =================================================
            // CAPA MUY SUAVE
            // =================================================

            Container(
              color: Colors.black.withValues(
                alpha: 0.03,
              ),
            ),

            // =================================================
            // CONTENIDO
            // =================================================

            SafeArea(
              child: LayoutBuilder(
                builder: (
                  context,
                  constraints,
                ) {
                  final bool compact =
                      constraints.maxHeight <
                          700;

                  return SingleChildScrollView(
                    physics:
                        const BouncingScrollPhysics(),

                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(
                        minHeight:
                            constraints
                                .maxHeight,
                      ),

                      child: Padding(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 22,
                        ),

                        child: Column(
                          children: [
                            // =====================================
                            // BOTÓN VOLVER
                            // =====================================

                            Align(
                              alignment:
                                  Alignment
                                      .centerLeft,

                              child:
                                  GestureDetector(
                                onTap:
                                    _goBack,

                                child:
                                    Container(
                                  width: 44,
                                  height: 44,

                                  decoration:
                                      BoxDecoration(
                                    color:
                                        const Color(
                                      0xFF45A049,
                                    ),

                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      14,
                                    ),

                                    border:
                                        Border.all(
                                      color:
                                          Colors
                                              .white,
                                      width:
                                          2,
                                    ),

                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors
                                            .black
                                            .withValues(
                                          alpha:
                                              0.18,
                                        ),
                                        blurRadius:
                                            8,
                                        offset:
                                            const Offset(
                                          0,
                                          3,
                                        ),
                                      ),
                                    ],
                                  ),

                                  child:
                                      const Icon(
                                    Icons
                                        .arrow_back_rounded,
                                    color:
                                        Colors
                                            .white,
                                    size: 27,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                              height:
                                  compact
                                      ? 18
                                      : 30,
                            ),

                            // =====================================
                            // SALUDO
                            // =====================================

                            Text(
                              'Hola ${widget.playerName}',
                              textAlign:
                                  TextAlign
                                      .center,

                              style:
                                  const TextStyle(
                                color:
                                    Color(
                                  0xFF176B32,
                                ),
                                fontSize:
                                    30,
                                fontWeight:
                                    FontWeight
                                        .w800,

                                shadows: [
                                  Shadow(
                                    color:
                                        Colors
                                            .white70,
                                    blurRadius:
                                        4,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            const Text(
                              'Ingresa tu PIN para continuar',
                              textAlign:
                                  TextAlign
                                      .center,

                              style:
                                  TextStyle(
                                color:
                                    Color(
                                  0xFF2D7A3F,
                                ),
                                fontSize:
                                    14,
                                fontWeight:
                                    FontWeight
                                        .w600,
                              ),
                            ),

                            SizedBox(
                              height:
                                  compact
                                      ? 18
                                      : 24,
                            ),

                            // =====================================
                            // INDICADORES DEL PIN
                            // =====================================

                            AnimatedContainer(
                              duration:
                                  const Duration(
                                milliseconds:
                                    220,
                              ),

                              width:
                                  double.infinity,

                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal:
                                    22,
                                vertical:
                                    15,
                              ),

                              decoration:
                                  BoxDecoration(
                                color: Colors
                                    .white
                                    .withValues(
                                  alpha:
                                      0.94,
                                ),

                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  18,
                                ),

                                border:
                                    Border.all(
                                  color:
                                      _hasError
                                          ? const Color(
                                              0xFFE24C4B,
                                            )
                                          : const Color(
                                              0xFF59B83A,
                                            ),
                                  width:
                                      _hasError
                                          ? 2.5
                                          : 2,
                                ),

                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color(
                                      0xFF236B3A,
                                    ).withValues(
                                      alpha:
                                          0.14,
                                    ),
                                    blurRadius:
                                        12,
                                    offset:
                                        const Offset(
                                      0,
                                      5,
                                    ),
                                  ),
                                ],
                              ),

                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceEvenly,

                                children:
                                    List.generate(
                                  _pinLength,
                                  (
                                    index,
                                  ) {
                                    final filled =
                                        index <
                                            _pin.length;

                                    return AnimatedContainer(
                                      duration:
                                          const Duration(
                                        milliseconds:
                                            150,
                                      ),

                                      width: 42,
                                      height:
                                          42,

                                      decoration:
                                          BoxDecoration(
                                        shape:
                                            BoxShape
                                                .circle,

                                        color: filled
                                            ? const Color(
                                                0xFF59B83A,
                                              )
                                            : Colors
                                                .white,

                                        border:
                                            Border.all(
                                          color: _hasError
                                              ? const Color(
                                                  0xFFE24C4B,
                                                )
                                              : const Color(
                                                  0xFF45A049,
                                                ),
                                          width:
                                              2,
                                        ),
                                      ),

                                      child: filled
                                          ? const Center(
                                              child:
                                                  Icon(
                                                Icons
                                                    .circle,
                                                color:
                                                    Colors.white,
                                                size:
                                                    15,
                                              ),
                                            )
                                          : null,
                                    );
                                  },
                                ),
                              ),
                            ),

                            // =====================================
                            // ERROR
                            // =====================================

                            AnimatedSwitcher(
                              duration:
                                  const Duration(
                                milliseconds:
                                    220,
                              ),

                              child: _hasError
                                  ? const Padding(
                                      key:
                                          ValueKey(
                                        'error',
                                      ),
                                      padding:
                                          EdgeInsets
                                              .only(
                                        top:
                                            9,
                                      ),
                                      child:
                                          Text(
                                        'PIN incorrecto. Inténtalo otra vez.',
                                        textAlign:
                                            TextAlign
                                                .center,
                                        style:
                                            TextStyle(
                                          color:
                                              Color(
                                            0xFFC62828,
                                          ),
                                          fontSize:
                                              13,
                                          fontWeight:
                                              FontWeight
                                                  .w700,
                                        ),
                                      ),
                                    )
                                  : const SizedBox(
                                      key:
                                          ValueKey(
                                        'empty',
                                      ),
                                      height:
                                          25,
                                    ),
                            ),

                            SizedBox(
                              height:
                                  compact
                                      ? 4
                                      : 10,
                            ),

                            // =====================================
                            // TECLADO 1 - 9
                            // =====================================

                            SizedBox(
                              width: 265,

                              child:
                                  GridView.builder(
                                shrinkWrap:
                                    true,

                                physics:
                                    const NeverScrollableScrollPhysics(),

                                itemCount:
                                    9,

                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      3,
                                  crossAxisSpacing:
                                      14,
                                  mainAxisSpacing:
                                      12,
                                  childAspectRatio:
                                      1.20,
                                ),

                                itemBuilder:
                                    (
                                  context,
                                  index,
                                ) {
                                  final number =
                                      '${index + 1}';

                                  return _PinNumberButton(
                                    label:
                                        number,

                                    onTap:
                                        () {
                                      _addDigit(
                                        number,
                                      );
                                    },
                                  );
                                },
                              ),
                            ),

                            const SizedBox(
                              height: 12,
                            ),

                            // =====================================
                            // FILA 0 / BORRAR
                            // =====================================

                            SizedBox(
                              width: 265,

                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,

                                children: [
                                  const SizedBox(
                                    width: 72,
                                  ),

                                  const SizedBox(
                                    width: 14,
                                  ),

                                  _PinNumberButton(
                                    label:
                                        '0',

                                    onTap:
                                        () {
                                      _addDigit(
                                        '0',
                                      );
                                    },
                                  ),

                                  const SizedBox(
                                    width: 14,
                                  ),

                                  _PinDeleteButton(
                                    onTap:
                                        _removeDigit,
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              height:
                                  compact
                                      ? 20
                                      : 30,
                            ),

                            // =====================================
                            // BOTÓN ENTRAR
                            // =====================================

                            SizedBox(
                              width: 220,
                              height: 54,

                              child:
                                  ElevatedButton(
                                onPressed:
                                    _pin.length ==
                                                _pinLength &&
                                            !_isChecking
                                        ? _submitPin
                                        : null,

                                style:
                                    ElevatedButton
                                        .styleFrom(
                                  backgroundColor:
                                      const Color(
                                    0xFF45A049,
                                  ),

                                  foregroundColor:
                                      Colors
                                          .white,

                                  disabledBackgroundColor:
                                      const Color(
                                    0xFF59B83A,
                                  ).withValues(
                                    alpha:
                                        0.45,
                                  ),

                                  disabledForegroundColor:
                                      Colors
                                          .white70,

                                  elevation:
                                      5,

                                  shadowColor:
                                      const Color(
                                    0xFF236B3A,
                                  ).withValues(
                                    alpha:
                                        0.35,
                                  ),

                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      16,
                                    ),
                                  ),
                                ),

                                child:
                                    _isChecking
                                        ? const SizedBox(
                                            width:
                                                23,
                                            height:
                                                23,
                                            child:
                                                CircularProgressIndicator(
                                              strokeWidth:
                                                  2.5,
                                              color:
                                                  Colors.white,
                                            ),
                                          )
                                        : const Text(
                                            'Entrar',
                                            style:
                                                TextStyle(
                                              fontSize:
                                                  19,
                                              fontWeight:
                                                  FontWeight.w800,
                                            ),
                                          ),
                              ),
                            ),

                            const SizedBox(
                              height: 30,
                            ),
                          ],
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

// =====================================================================
// BOTÓN NUMÉRICO
// =====================================================================

class _PinNumberButton
    extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PinNumberButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 60,

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          onTap: onTap,

          borderRadius:
              BorderRadius.circular(
            16,
          ),

          child: Ink(
            decoration:
                BoxDecoration(
              color:
                  Colors.white,

              borderRadius:
                  BorderRadius.circular(
                16,
              ),

              border:
                  Border.all(
                color:
                    const Color(
                  0xFF45A049,
                ),
                width: 2,
              ),

              boxShadow: [
                BoxShadow(
                  color:
                      const Color(
                    0xFF236B3A,
                  ).withValues(
                    alpha:
                        0.16,
                  ),
                  blurRadius:
                      7,
                  offset:
                      const Offset(
                    0,
                    3,
                  ),
                ),
              ],
            ),

            child: Center(
              child: Text(
                label,

                style:
                    const TextStyle(
                  color:
                      Color(
                    0xFF178329,
                  ),
                  fontSize:
                      27,
                  fontWeight:
                      FontWeight
                          .w800,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// BOTÓN BORRAR
// =====================================================================

class _PinDeleteButton
    extends StatelessWidget {
  final VoidCallback onTap;

  const _PinDeleteButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 60,

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          onTap: onTap,

          borderRadius:
              BorderRadius.circular(
            16,
          ),

          child: Ink(
            decoration:
                BoxDecoration(
              color:
                  const Color(
                0xFF45A049,
              ),

              borderRadius:
                  BorderRadius.circular(
                16,
              ),

              boxShadow: [
                BoxShadow(
                  color:
                      const Color(
                    0xFF236B3A,
                  ).withValues(
                    alpha:
                        0.20,
                  ),
                  blurRadius:
                      7,
                  offset:
                      const Offset(
                    0,
                    3,
                  ),
                ),
              ],
            ),

            child:
                const Center(
              child: Icon(
                Icons
                    .backspace_rounded,
                color:
                    Colors.white,
                size: 28,
              ),
            ),
          ),
        ),
      ),
    );
  }
}