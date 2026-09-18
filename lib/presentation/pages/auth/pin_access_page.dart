import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../data/services/current_user_service.dart';
import '../../../data/services/user_service.dart';

class PinAccessPage
    extends StatefulWidget {
  final String playerName;
  final String avatar;

  const PinAccessPage({
    super.key,
    required this.playerName,
    required this.avatar,
  });

  @override
  State<PinAccessPage> createState() =>
      _PinAccessPageState();
}

class _PinAccessPageState
    extends State<PinAccessPage> {
  // ============================================================
  // SERVICIOS
  // ============================================================

  final UserService _userService =
      UserService.instance;

  final CurrentUserService
      _currentUserService =
      CurrentUserService.instance;

  // ============================================================
  // PIN
  // ============================================================

  static const int _pinLength =
      4;

  String _pin =
      '';

  bool _hasError =
      false;

  bool _isChecking =
      false;

  String _errorMessage =
      'PIN incorrecto. Inténtalo otra vez.';

  // ============================================================
  // AGREGAR NÚMERO
  // ============================================================

  void _addDigit(
    String digit,
  ) {
    if (_isChecking) {
      return;
    }

    if (_pin.length >=
        _pinLength) {
      return;
    }

    HapticFeedback.selectionClick();

    setState(() {
      _hasError =
          false;

      _pin +=
          digit;
    });
  }

  // ============================================================
  // BORRAR NÚMERO
  // ============================================================

  void _removeDigit() {
    if (_isChecking ||
        _pin.isEmpty) {
      return;
    }

    HapticFeedback.lightImpact();

    setState(() {
      _hasError =
          false;

      _pin =
          _pin.substring(
        0,
        _pin.length - 1,
      );
    });
  }

  // ============================================================
  // ENVIAR LOGIN AL BACKEND
  // ============================================================

  Future<void> _submitPin() async {
    if (_isChecking) {
      return;
    }

    if (_pin.length !=
        _pinLength) {
      setState(() {
        _hasError =
            true;

        _errorMessage =
            'Ingresa los 4 números de tu PIN.';
      });

      return;
    }

    setState(() {
      _isChecking =
          true;

      _hasError =
          false;
    });

    try {
      // ========================================================
      // LOGIN:
      //
      // DisplayName + PIN
      // ========================================================

      final Map<String, dynamic>
          response =
          await _userService.login(
        displayName:
            widget.playerName,
        pin:
            _pin,
      );

      // ========================================================
      // OBTENER USUARIO
      // ========================================================

      final dynamic rawData =
          response['data'];

      if (rawData is! Map) {
        throw Exception(
          'El servidor no devolvió los datos del usuario.',
        );
      }

      final Map<String, dynamic>
          user =
          Map<String, dynamic>.from(
        rawData,
      );

      user['stars'] ??=
          0;

      // ========================================================
      // GUARDAR USUARIO ACTIVO
      // ========================================================

      _currentUserService
          .setCurrentUser(
        user,
      );

      if (!mounted) {
        return;
      }

      HapticFeedback.mediumImpact();

      // ========================================================
      // IR AL HOME
      // ========================================================

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (
          Route<dynamic> route,
        ) =>
            false,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      HapticFeedback.heavyImpact();

      String message =
          error.toString();

      if (message.startsWith(
        'Exception: ',
      )) {
        message =
            message.substring(
          'Exception: '.length,
        );
      }

      setState(() {
        _hasError =
            true;

        _isChecking =
            false;

        _errorMessage =
            message;

        _pin =
            '';
      });
    }
  }

  // ============================================================
  // VOLVER
  // ============================================================

  void _goBack() {
    HapticFeedback.selectionClick();

    Navigator.pop(
      context,
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return AnnotatedRegion<
        SystemUiOverlayStyle>(
      value:
          const SystemUiOverlayStyle(
        statusBarColor:
            Colors.transparent,
        statusBarIconBrightness:
            Brightness.light,
        statusBarBrightness:
            Brightness.dark,
        systemStatusBarContrastEnforced:
            false,
      ),
      child:
          Scaffold(
        backgroundColor:
            const Color(
          0xFF236B3A,
        ),
        body:
            Stack(
          fit:
              StackFit.expand,
          children: [
            // =================================================
            // FONDO
            // =================================================

            Image.asset(
              'assets/images/fondo2.png',
              fit:
                  BoxFit.cover,
              alignment:
                  Alignment.center,
            ),

            Container(
              color:
                  Colors.black.withValues(
                alpha:
                    0.03,
              ),
            ),

            // =================================================
            // CONTENIDO
            // =================================================

            SafeArea(
              child:
                  LayoutBuilder(
                builder:
                    (
                  BuildContext context,
                  BoxConstraints constraints,
                ) {
                  final bool compact =
                      constraints.maxHeight <
                          700;

                  return SingleChildScrollView(
                    physics:
                        const BouncingScrollPhysics(),
                    child:
                        ConstrainedBox(
                      constraints:
                          BoxConstraints(
                        minHeight:
                            constraints.maxHeight,
                      ),
                      child:
                          Padding(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal:
                              22,
                        ),
                        child:
                            Column(
                          children: [
                            // =================================
                            // VOLVER
                            // =================================

                            Align(
                              alignment:
                                  Alignment.centerLeft,
                              child:
                                  _BackButton(
                                onTap:
                                    _goBack,
                              ),
                            ),

                            SizedBox(
                              height:
                                  compact
                                      ? 15
                                      : 25,
                            ),

                            // =================================
                            // AVATAR
                            // =================================

                            Container(
                              width:
                                  90,
                              height:
                                  90,
                              alignment:
                                  Alignment.center,
                              decoration:
                                  BoxDecoration(
                                color:
                                    Colors.white,
                                shape:
                                    BoxShape.circle,
                                border:
                                    Border.all(
                                  color:
                                      const Color(
                                    0xFF59B83A,
                                  ),
                                  width:
                                      3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        Colors.black.withValues(
                                      alpha:
                                          0.16,
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
                              child:
                                  Text(
                                widget.avatar,
                                style:
                                    const TextStyle(
                                  fontSize:
                                      52,
                                ),
                              ),
                            ),

                            const SizedBox(
                              height:
                                  14,
                            ),

                            // =================================
                            // NOMBRE
                            // =================================

                            Text(
                              'Hola ${widget.playerName}',
                              textAlign:
                                  TextAlign.center,
                              style:
                                  const TextStyle(
                                color:
                                    Color(
                                  0xFF176B32,
                                ),
                                fontSize:
                                    28,
                                fontWeight:
                                    FontWeight.w800,
                                shadows: [
                                  Shadow(
                                    color:
                                        Colors.white70,
                                    blurRadius:
                                        4,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(
                              height:
                                  6,
                            ),

                            const Text(
                              'Ingresa tu PIN para continuar',
                              textAlign:
                                  TextAlign.center,
                              style:
                                  TextStyle(
                                color:
                                    Color(
                                  0xFF2D7A3F,
                                ),
                                fontSize:
                                    14,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),

                            SizedBox(
                              height:
                                  compact
                                      ? 18
                                      : 24,
                            ),

                            // =================================
                            // INDICADORES
                            // =================================

                            Container(
                              width:
                                  double.infinity,
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal:
                                    22,
                                vertical:
                                    15,
                              ),
                              decoration:
                                  BoxDecoration(
                                color:
                                    Colors.white.withValues(
                                  alpha:
                                      0.94,
                                ),
                                borderRadius:
                                    BorderRadius.circular(
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
                                      2,
                                ),
                              ),
                              child:
                                  Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children:
                                    List.generate(
                                  _pinLength,
                                  (
                                    int index,
                                  ) {
                                    final bool filled =
                                        index <
                                            _pin.length;

                                    return Container(
                                      width:
                                          42,
                                      height:
                                          42,
                                      decoration:
                                          BoxDecoration(
                                        shape:
                                            BoxShape.circle,
                                        color:
                                            filled
                                                ? const Color(
                                                    0xFF59B83A,
                                                  )
                                                : Colors.white,
                                        border:
                                            Border.all(
                                          color:
                                              _hasError
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
                                      child:
                                          filled
                                              ? const Icon(
                                                  Icons.circle,
                                                  color:
                                                      Colors.white,
                                                  size:
                                                      14,
                                                )
                                              : null,
                                    );
                                  },
                                ),
                              ),
                            ),

                            // =================================
                            // ERROR
                            // =================================

                            SizedBox(
                              height:
                                  45,
                              child:
                                  Center(
                                child:
                                    _hasError
                                        ? Text(
                                            _errorMessage,
                                            textAlign:
                                                TextAlign.center,
                                            style:
                                                const TextStyle(
                                              color:
                                                  Color(
                                                0xFFC62828,
                                              ),
                                              fontSize:
                                                  12,
                                              fontWeight:
                                                  FontWeight.w700,
                                            ),
                                          )
                                        : null,
                              ),
                            ),

                            // =================================
                            // TECLADO 1-9
                            // =================================

                            SizedBox(
                              width:
                                  265,
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
                                  BuildContext context,
                                  int index,
                                ) {
                                  final String number =
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
                              height:
                                  12,
                            ),

                            // =================================
                            // 0 + BORRAR
                            // =================================

                            SizedBox(
                              width:
                                  265,
                              child:
                                  Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    width:
                                        72,
                                  ),

                                  const SizedBox(
                                    width:
                                        14,
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
                                    width:
                                        14,
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
                                      : 28,
                            ),

                            // =================================
                            // ENTRAR
                            // =================================

                            SizedBox(
                              width:
                                  220,
                              height:
                                  54,
                              child:
                                  ElevatedButton(
                                onPressed:
                                    _pin.length ==
                                                _pinLength &&
                                            !_isChecking
                                        ? _submitPin
                                        : null,
                                style:
                                    ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color(
                                    0xFF45A049,
                                  ),
                                  foregroundColor:
                                      Colors.white,
                                  disabledBackgroundColor:
                                      const Color(
                                    0xFF59B83A,
                                  ).withValues(
                                    alpha:
                                        0.45,
                                  ),
                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(
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
                              height:
                                  30,
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
// VOLVER
// =====================================================================

class _BackButton
    extends StatelessWidget {
  final VoidCallback onTap;

  const _BackButton({
    required this.onTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return GestureDetector(
      onTap:
          onTap,
      child:
          Container(
        width:
            44,
        height:
            44,
        decoration:
            BoxDecoration(
          color:
              const Color(
            0xFF45A049,
          ),
          borderRadius:
              BorderRadius.circular(
            14,
          ),
          border:
              Border.all(
            color:
                Colors.white,
            width:
                2,
          ),
        ),
        child:
            const Icon(
          Icons.arrow_back_rounded,
          color:
              Colors.white,
          size:
              27,
        ),
      ),
    );
  }
}

// =====================================================================
// NÚMERO
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
  Widget build(
    BuildContext context,
  ) {
    return SizedBox(
      width:
          72,
      height:
          60,
      child:
          Material(
        color:
            Colors.transparent,
        child:
            InkWell(
          onTap:
              onTap,
          borderRadius:
              BorderRadius.circular(
            16,
          ),
          child:
              Ink(
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
                width:
                    2,
              ),
            ),
            child:
                Center(
              child:
                  Text(
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
                      FontWeight.w800,
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
// BORRAR
// =====================================================================

class _PinDeleteButton
    extends StatelessWidget {
  final VoidCallback onTap;

  const _PinDeleteButton({
    required this.onTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return SizedBox(
      width:
          72,
      height:
          60,
      child:
          Material(
        color:
            Colors.transparent,
        child:
            InkWell(
          onTap:
              onTap,
          borderRadius:
              BorderRadius.circular(
            16,
          ),
          child:
              Ink(
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
            ),
            child:
                const Center(
              child:
                  Icon(
                Icons.backspace_rounded,
                color:
                    Colors.white,
                size:
                    28,
              ),
            ),
          ),
        ),
      ),
    );
  }
}