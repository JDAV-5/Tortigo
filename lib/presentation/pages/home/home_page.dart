import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../data/services/current_user_service.dart';

import '../logros/logros_page.dart';
import '../torti_chat/torti_chat_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // ============================================================
    // USUARIO AUTENTICADO
    //
    // Este servicio contiene el usuario devuelto por:
    //
    // POST /api/Users/login
    //
    // PinAccessPage ejecuta:
    //
    // CurrentUserService.instance.setCurrentUser(user);
    //
    // Por lo tanto Home ya NO depende de PlayerProgressService
    // para saber quién inició sesión.
    // ============================================================

    final CurrentUserService currentUserService =
        CurrentUserService.instance;

    // ============================================================
    // ESCUCHAR CAMBIOS DEL USUARIO
    //
    // Si cambia:
    //
    // - nombre
    // - avatar
    // - estrellas
    //
    // el Home se reconstruye automáticamente.
    // ============================================================

    return AnimatedBuilder(
      animation:
          currentUserService,
      builder: (
        BuildContext context,
        Widget? child,
      ) {
        // ========================================================
        // VALIDAR SESIÓN
        // ========================================================

        if (!currentUserService.hasUser) {
          return _NoActiveProfilePage(
            onReturnToLogin:
                () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (
                  Route<dynamic> route,
                ) =>
                    false,
              );
            },
          );
        }

        // ========================================================
        // DATOS DEL USUARIO AUTENTICADO
        // ========================================================

        final String playerName =
            currentUserService.displayName.isNotEmpty
                ? currentUserService.displayName
                : 'Jugador';

        final String avatar =
            currentUserService.avatarValue.isNotEmpty
                ? currentUserService.avatarValue
                : '🐢';

        final int stars =
            currentUserService.stars;

        // ========================================================
        // ABRIR LOGROS
        // ========================================================

        void openAchievements() {
          HapticFeedback.selectionClick();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (
                BuildContext context,
              ) {
                return const LogrosPage();
              },
            ),
          );
        }

        // ========================================================
        // ABRIR CHAT DE TORTI
        // ========================================================

        void openTortiChat() {
          HapticFeedback.selectionClick();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (
                BuildContext context,
              ) {
                return TortiChatPage(
                  playerName:
                      playerName,
                );
              },
            ),
          );
        }

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

            // =====================================================
            // BODY
            // =====================================================

            body:
                Stack(
              fit:
                  StackFit.expand,
              children: [
                // =================================================
                // FONDO
                // =================================================

                Image.asset(
                  'assets/images/fondo3.png',
                  fit:
                      BoxFit.cover,
                  alignment:
                      Alignment.center,
                ),

                // =================================================
                // CAPA SUAVE
                // =================================================

                Container(
                  color:
                      Colors.black.withValues(
                    alpha:
                        0.02,
                  ),
                ),

                // =================================================
                // CONTENIDO
                // =================================================

                SafeArea(
                  child:
                      Padding(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal:
                          20,
                    ),
                    child:
                        Column(
                      children: [
                        const SizedBox(
                          height:
                              8,
                        ),

                        // =========================================
                        // CABECERA
                        // =========================================

                        Row(
                          children: [
                            // =====================================
                            // AVATAR DEL USUARIO AUTENTICADO
                            // =====================================

                            Container(
                              width:
                                  45,
                              height:
                                  45,
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
                                      2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color(
                                      0xFF236B3A,
                                    ).withValues(
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
                              alignment:
                                  Alignment.center,

                              // ===================================
                              // AVATAR DEL BACKEND
                              //
                              // avatarValue:
                              //
                              // 🐢
                              // 🐼
                              // 🦫
                              // 🐸
                              // etc.
                              // ===================================

                              child:
                                  Text(
                                avatar,
                                style:
                                    const TextStyle(
                                  fontSize:
                                      25,
                                ),
                              ),
                            ),

                            const SizedBox(
                              width:
                                  10,
                            ),

                            // =====================================
                            // NOMBRE DEL USUARIO
                            // =====================================

                            Expanded(
                              child:
                                  Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '¡Hola, $playerName!',
                                    maxLines:
                                        1,
                                    overflow:
                                        TextOverflow.ellipsis,
                                    style:
                                        const TextStyle(
                                      color:
                                          Colors.white,
                                      fontSize:
                                          20,
                                      fontWeight:
                                          FontWeight.w800,
                                      shadows: [
                                        Shadow(
                                          color:
                                              Colors.black38,
                                          blurRadius:
                                              5,
                                          offset:
                                              Offset(
                                            0,
                                            2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Text(
                                    '¿Qué aprenderemos hoy?',
                                    style:
                                        TextStyle(
                                      color:
                                          Colors.white.withValues(
                                        alpha:
                                            0.90,
                                      ),
                                      fontSize:
                                          12,
                                      fontWeight:
                                          FontWeight.w500,
                                      shadows:
                                          const [
                                        Shadow(
                                          color:
                                              Colors.black26,
                                          blurRadius:
                                              4,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // =====================================
                            // ESTRELLAS DEL USUARIO
                            // =====================================

                            Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal:
                                    11,
                                vertical:
                                    7,
                              ),
                              decoration:
                                  BoxDecoration(
                                color:
                                    const Color(
                                  0xFF236B3A,
                                ).withValues(
                                  alpha:
                                      0.72,
                                ),
                                borderRadius:
                                    BorderRadius.circular(
                                  18,
                                ),
                                border:
                                    Border.all(
                                  color:
                                      Colors.white.withValues(
                                    alpha:
                                        0.20,
                                  ),
                                ),
                              ),
                              child:
                                  Row(
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    color:
                                        Color(
                                      0xFFFFD23F,
                                    ),
                                    size:
                                        20,
                                  ),

                                  const SizedBox(
                                    width:
                                        5,
                                  ),

                                  Text(
                                    '$stars',
                                    style:
                                        const TextStyle(
                                      color:
                                          Colors.white,
                                      fontWeight:
                                          FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // =========================================
                        // TORTI LEYENDO
                        // =========================================

                        const SizedBox(
                          height:
                              2,
                        ),

                        Align(
                          alignment:
                              Alignment.centerRight,
                          child:
                              Padding(
                            padding:
                                const EdgeInsets.only(
                              right:
                                  1,
                            ),
                            child:
                                Image.asset(
                              'assets/images/torti_read.png',
                              height:
                                  170,
                              fit:
                                  BoxFit.contain,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height:
                              5,
                        ),

                        // =========================================
                        // FILA 1
                        // =========================================

                        Row(
                          children: [
                            // =====================================
                            // MISIONES
                            // =====================================

                            Expanded(
                              child:
                                  _HomeOptionCard(
                                title:
                                    'Misiones\necológicas',
                                subtitle:
                                    'Completa retos y ayuda al planeta',
                                icon:
                                    Icons.eco_rounded,
                                iconColor:
                                    const Color(
                                  0xFF45A049,
                                ),
                                backgroundColor:
                                    const Color(
                                  0xFFE7F7D8,
                                ),
                                onTap:
                                    () {
                                  HapticFeedback.selectionClick();

                                  Navigator.pushNamed(
                                    context,
                                    '/missions',
                                  );
                                },
                              ),
                            ),

                            const SizedBox(
                              width:
                                  12,
                            ),

                            // =====================================
                            // JUEGOS
                            // =====================================

                            Expanded(
                              child:
                                  _HomeOptionCard(
                                title:
                                    'Juegos\neducativos',
                                subtitle:
                                    'Aprende jugando y diviértete',
                                icon:
                                    Icons.sports_esports_rounded,
                                iconColor:
                                    const Color(
                                  0xFF318CB8,
                                ),
                                backgroundColor:
                                    const Color(
                                  0xFFE5F6FC,
                                ),
                                onTap:
                                    () {
                                  HapticFeedback.selectionClick();

                                  debugPrint(
                                    'Juegos',
                                  );
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height:
                              12,
                        ),

                        // =========================================
                        // FILA 2
                        // =========================================

                        Row(
                          children: [
                            // =====================================
                            // APRENDE
                            // =====================================

                            Expanded(
                              child:
                                  _HomeOptionCard(
                                title:
                                    'Aprende',
                                subtitle:
                                    'Explora, escucha y descubre',
                                icon:
                                    Icons.menu_book_rounded,
                                iconColor:
                                    const Color(
                                  0xFF9C27D8,
                                ),
                                backgroundColor:
                                    const Color(
                                  0xFFF6E9FF,
                                ),
                                onTap:
                                    () {
                                  HapticFeedback.selectionClick();

                                  debugPrint(
                                    'Aprende',
                                  );
                                },
                              ),
                            ),

                            const SizedBox(
                              width:
                                  12,
                            ),

                            // =====================================
                            // LOGROS
                            // =====================================

                            Expanded(
                              child:
                                  _HomeOptionCard(
                                title:
                                    'Logros',
                                subtitle:
                                    'Gana recompensas y desbloquea medallas',
                                icon:
                                    Icons.emoji_events_rounded,
                                iconColor:
                                    const Color(
                                  0xFFE8A700,
                                ),
                                backgroundColor:
                                    const Color(
                                  0xFFFFF5D8,
                                ),
                                onTap:
                                    openAchievements,
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),

                        // =========================================
                        // FRASE
                        // =========================================

                        Container(
                          width:
                              double.infinity,
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal:
                                18,
                            vertical:
                                12,
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
                              20,
                            ),
                            border:
                                Border.all(
                              color:
                                  const Color(
                                0xFF7BCB4D,
                              ).withValues(
                                alpha:
                                    0.40,
                              ),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    const Color(
                                  0xFF236B3A,
                                ).withValues(
                                  alpha:
                                      0.15,
                                ),
                                blurRadius:
                                    10,
                                offset:
                                    const Offset(
                                  0,
                                  4,
                                ),
                              ),
                            ],
                          ),
                          child:
                              const Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.eco_rounded,
                                color:
                                    Color(
                                  0xFF59B83A,
                                ),
                                size:
                                    26,
                              ),

                              SizedBox(
                                width:
                                    9,
                              ),

                              Flexible(
                                child:
                                    Text(
                                  'Pequeñas acciones hacen grandes cambios',
                                  textAlign:
                                      TextAlign.center,
                                  style:
                                      TextStyle(
                                    color:
                                        Color(
                                      0xFF59666D,
                                    ),
                                    fontSize:
                                        13,
                                    height:
                                        1.15,
                                    fontWeight:
                                        FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height:
                              14,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // =====================================================
            // BARRA INFERIOR
            // =====================================================

            bottomNavigationBar:
                Container(
              margin:
                  const EdgeInsets.fromLTRB(
                18,
                0,
                18,
                10,
              ),
              decoration:
                  BoxDecoration(
                color:
                    Colors.white,
                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        Colors.black.withValues(
                      alpha:
                          0.16,
                    ),
                    blurRadius:
                        18,
                    offset:
                        const Offset(
                      0,
                      4,
                    ),
                  ),
                ],
              ),
              child:
                  SafeArea(
                top:
                    false,
                child:
                    SizedBox(
                  height:
                      66,
                  child:
                      Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround,
                    children: [
                      // ===========================================
                      // INICIO
                      // ===========================================

                      const _BottomNavItem(
                        icon:
                            Icons.home_rounded,
                        label:
                            'Inicio',
                        selected:
                            true,
                      ),

                      // ===========================================
                      // JUEGOS
                      // ===========================================

                      _BottomNavItem(
                        icon:
                            Icons.sports_esports_rounded,
                        label:
                            'Juegos',
                        onTap:
                            () {
                          HapticFeedback.selectionClick();

                          debugPrint(
                            'Juegos',
                          );
                        },
                      ),

                      // ===========================================
                      // APRENDE
                      // ===========================================

                      _BottomNavItem(
                        icon:
                            Icons.menu_book_rounded,
                        label:
                            'Aprende',
                        onTap:
                            () {
                          HapticFeedback.selectionClick();

                          debugPrint(
                            'Aprende',
                          );
                        },
                      ),

                      // ===========================================
                      // LOGROS
                      // ===========================================

                      _BottomNavItem(
                        icon:
                            Icons.emoji_events_rounded,
                        label:
                            'Logros',
                        onTap:
                            openAchievements,
                      ),

                      // ===========================================
                      // TORTI
                      // ===========================================

                      _BottomNavItem(
                        icon:
                            Icons.chat_bubble_rounded,
                        label:
                            'Torti',
                        onTap:
                            openTortiChat,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// =====================================================================
// SIN USUARIO AUTENTICADO
// =====================================================================

class _NoActiveProfilePage
    extends StatelessWidget {
  final VoidCallback onReturnToLogin;

  const _NoActiveProfilePage({
    required this.onReturnToLogin,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          const Color(
        0xFF236B3A,
      ),
      body:
          Stack(
        fit:
            StackFit.expand,
        children: [
          Image.asset(
            'assets/images/fondo3.png',
            fit:
                BoxFit.cover,
          ),

          Container(
            color:
                Colors.black.withValues(
              alpha:
                  0.10,
            ),
          ),

          SafeArea(
            child:
                Center(
              child:
                  Container(
                margin:
                    const EdgeInsets.all(
                  24,
                ),
                padding:
                    const EdgeInsets.all(
                  24,
                ),
                decoration:
                    BoxDecoration(
                  color:
                      Colors.white,
                  borderRadius:
                      BorderRadius.circular(
                    24,
                  ),
                ),
                child:
                    Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    const Text(
                      '🐢',
                      style:
                          TextStyle(
                        fontSize:
                            55,
                      ),
                    ),

                    const SizedBox(
                      height:
                          12,
                    ),

                    const Text(
                      'No hay un usuario activo',
                      textAlign:
                          TextAlign.center,
                      style:
                          TextStyle(
                        color:
                            Color(
                          0xFF236B3A,
                        ),
                        fontSize:
                            20,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),

                    const SizedBox(
                      height:
                          8,
                    ),

                    const Text(
                      'Selecciona tu perfil e ingresa tu PIN para continuar.',
                      textAlign:
                          TextAlign.center,
                      style:
                          TextStyle(
                        color:
                            Color(
                          0xFF718089,
                        ),
                        fontSize:
                            13,
                      ),
                    ),

                    const SizedBox(
                      height:
                          20,
                    ),

                    ElevatedButton(
                      onPressed:
                          onReturnToLogin,
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(
                          0xFF45A049,
                        ),
                        foregroundColor:
                            Colors.white,
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal:
                              24,
                          vertical:
                              13,
                        ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            14,
                          ),
                        ),
                      ),
                      child:
                          const Text(
                        'Seleccionar perfil',
                        style:
                            TextStyle(
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// TARJETA DEL HOME
// =====================================================================

class _HomeOptionCard
    extends StatelessWidget {
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
  Widget build(
    BuildContext context,
  ) {
    return Material(
      color:
          Colors.white,
      borderRadius:
          BorderRadius.circular(
        22,
      ),
      child:
          InkWell(
        onTap:
            onTap,
        borderRadius:
            BorderRadius.circular(
          22,
        ),
        child:
            Container(
          height:
              112,
          padding:
              const EdgeInsets.symmetric(
            horizontal:
                12,
            vertical:
                10,
          ),
          decoration:
              BoxDecoration(
            borderRadius:
                BorderRadius.circular(
              22,
            ),
            border:
                Border.all(
              color:
                  const Color(
                0xFF7BCB4D,
              ).withValues(
                alpha:
                    0.26,
              ),
              width:
                  1.4,
            ),
            boxShadow: [
              BoxShadow(
                color:
                    const Color(
                  0xFF236B3A,
                ).withValues(
                  alpha:
                      0.12,
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
              Row(
            children: [
              // =================================================
              // ICONO
              // =================================================

              Container(
                width:
                    46,
                height:
                    46,
                decoration:
                    BoxDecoration(
                  color:
                      backgroundColor,
                  shape:
                      BoxShape.circle,
                ),
                child:
                    Icon(
                  icon,
                  color:
                      iconColor,
                  size:
                      27,
                ),
              ),

              const SizedBox(
                width:
                    9,
              ),

              // =================================================
              // TEXTOS
              // =================================================

              Expanded(
                child:
                    Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  crossAxisAlignment:
                      CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      textAlign:
                          TextAlign.center,
                      style:
                          TextStyle(
                        color:
                            iconColor,
                        fontSize:
                            14,
                        height:
                            1.05,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),

                    const SizedBox(
                      height:
                          7,
                    ),

                    Text(
                      subtitle,
                      maxLines:
                          2,
                      overflow:
                          TextOverflow.ellipsis,
                      textAlign:
                          TextAlign.center,
                      style:
                          const TextStyle(
                        color:
                            Color(
                          0xFF59666D,
                        ),
                        fontSize:
                            8.5,
                        height:
                            1.15,
                        fontWeight:
                            FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// ITEM DE LA BARRA INFERIOR
// =====================================================================

class _BottomNavItem
    extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final Color color =
        selected
            ? const Color(
                0xFF45A049,
              )
            : const Color(
                0xFF7B878D,
              );

    return Material(
      color:
          Colors.transparent,
      child:
          InkWell(
        onTap:
            onTap,
        borderRadius:
            BorderRadius.circular(
          14,
        ),
        child:
            Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal:
                9,
            vertical:
                7,
          ),
          child:
              Column(
            mainAxisSize:
                MainAxisSize.min,
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color:
                    color,
                size:
                    23,
              ),

              const SizedBox(
                height:
                    3,
              ),

              Text(
                label,
                style:
                    TextStyle(
                  color:
                      color,
                  fontSize:
                      9,
                  fontWeight:
                      selected
                          ? FontWeight.w700
                          : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}