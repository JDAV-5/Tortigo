import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../data/services/user_service.dart';

import 'pin_access_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() =>
      _LoginPageState();
}

class _LoginPageState
    extends State<LoginPage> {
  // ============================================================
  // SERVICIO
  // ============================================================

  final UserService _userService =
      UserService.instance;

  // ============================================================
  // ESTADO
  // ============================================================

  List<Map<String, dynamic>> _profiles =
      <Map<String, dynamic>>[];

  bool _isLoading = true;

  String? _errorMessage;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _loadProfiles();
  }

  // ============================================================
  // CARGAR PERFILES DEL BACKEND
  // ============================================================

  Future<void> _loadProfiles() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final List<Map<String, dynamic>>
          profiles =
          await _userService
              .getProfiles();

      // ========================================================
      // ORDENAR ALFABÉTICAMENTE
      // ========================================================

      profiles.sort(
        (
          Map<String, dynamic> a,
          Map<String, dynamic> b,
        ) {
          final String nameA =
              a['displayName']
                      ?.toString()
                      .trim()
                      .toLowerCase() ??
                  '';

          final String nameB =
              b['displayName']
                      ?.toString()
                      .trim()
                      .toLowerCase() ??
                  '';

          return nameA.compareTo(
            nameB,
          );
        },
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _profiles = profiles;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage =
            _cleanError(
          error,
        );

        _isLoading = false;
      });
    }
  }

  // ============================================================
  // ABRIR PIN DEL PERFIL
  // ============================================================

  void _openProfile(
    Map<String, dynamic> profile,
  ) {
    HapticFeedback.selectionClick();

    final String displayName =
        profile['displayName']
                ?.toString() ??
            '';

    final String avatarValue =
        profile['avatarValue']
                ?.toString() ??
            '🐢';

    if (displayName.isEmpty) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (
          BuildContext context,
        ) {
          return PinAccessPage(
            playerName:
                displayName,
            avatar:
                avatarValue,
          );
        },
      ),
    );
  }

  // ============================================================
  // CREAR NUEVO PERFIL
  // ============================================================

  Future<void> _createPlayer() async {
    HapticFeedback.lightImpact();

    await Navigator.pushNamed(
      context,
      '/register',
    );

    if (!mounted) {
      return;
    }

    // Al regresar de crear usuario,
    // volvemos a consultar SQL Server.
    await _loadProfiles();
  }

  // ============================================================
  // LIMPIAR ERROR
  // ============================================================

  String _cleanError(
    Object error,
  ) {
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

    return message;
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

            // =================================================
            // CAPA SUAVE
            // =================================================

            Container(
              color:
                  Colors.black.withValues(
                alpha:
                    0.04,
              ),
            ),

            // =================================================
            // CONTENIDO
            // =================================================

            SafeArea(
              child:
                  RefreshIndicator(
                onRefresh:
                    _loadProfiles,
                color:
                    const Color(
                  0xFF45A049,
                ),
                child:
                    SingleChildScrollView(
                  physics:
                      const AlwaysScrollableScrollPhysics(
                    parent:
                        BouncingScrollPhysics(),
                  ),
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
                            12,
                      ),

                      // =======================================
                      // LOGO
                      // =======================================

                      Image.asset(
                        'assets/images/tortigo_logo1.png',
                        width:
                            250,
                        fit:
                            BoxFit.contain,
                      ),

                      const SizedBox(
                        height:
                            24,
                      ),

                      // =======================================
                      // TÍTULO
                      // =======================================

                      const Text(
                        '¿Quién está jugando?',
                        textAlign:
                            TextAlign.center,
                        style:
                            TextStyle(
                          color:
                              Colors.white,
                          fontSize:
                              24,
                          fontWeight:
                              FontWeight.w800,
                          shadows: [
                            Shadow(
                              color:
                                  Colors.black45,
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

                      const SizedBox(
                        height:
                            8,
                      ),

                      Text(
                        'Selecciona tu perfil para continuar',
                        textAlign:
                            TextAlign.center,
                        style:
                            TextStyle(
                          color:
                              Colors.white.withValues(
                            alpha:
                                0.95,
                          ),
                          fontSize:
                              14,
                          fontWeight:
                              FontWeight.w500,
                        ),
                      ),

                      const SizedBox(
                        height:
                            26,
                      ),

                      // =======================================
                      // PERFILES
                      // =======================================

                      if (_isLoading)
                        const _ProfilesLoading()
                      else if (_errorMessage !=
                          null)
                        _ProfilesError(
                          message:
                              _errorMessage!,
                          onRetry:
                              _loadProfiles,
                        )
                      else if (_profiles.isEmpty)
                        const _EmptyProfiles()
                      else
                        _ProfilesCarousel(
                          profiles:
                              _profiles,
                          onProfileTap:
                              _openProfile,
                        ),

                      const SizedBox(
                        height:
                            28,
                      ),

                      // =======================================
                      // NUEVO JUGADOR
                      // =======================================

                      Transform.translate(
                        offset:
                            const Offset(
                          0,
                          30
                        ),
                        child:
                            _NewPlayerButton(
                          onTap:
                              _createPlayer,
                        ),
                      ),

                      const SizedBox(
                        height:
                            55,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// CARRUSEL HORIZONTAL DE PERFILES
//
// 1 perfil:
//              [ PERFIL ]
//
// 2 perfiles:
//        [ PERFIL ] [ PERFIL ]
//
// 3 perfiles:
// [ PERFIL ] [ PERFIL ] [ PERFIL ]  →
//
// 4+ perfiles:
// [ PERFIL ] [ PERFIL ] [ PERFIL ] [ ... ] →
//
// NUNCA SE CREA UNA SEGUNDA FILA.
// =====================================================================

class _ProfilesCarousel
    extends StatelessWidget {
  final List<Map<String, dynamic>>
      profiles;

  final void Function(
    Map<String, dynamic> profile,
  ) onProfileTap;

  const _ProfilesCarousel({
    required this.profiles,
    required this.onProfileTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return SizedBox(
      height:
          164,
      child:
          LayoutBuilder(
        builder: (
          BuildContext context,
          BoxConstraints constraints,
        ) {
          // =====================================================
          // TAMAÑO DE CADA TARJETA
          // =====================================================

          const double cardWidth =
              124;

          const double cardHeight =
              156;

          const double spacing =
              12;

          // =====================================================
          // CALCULAR ESPACIO TOTAL
          // =====================================================

          final int gapCount =
              profiles.length > 1
                  ? profiles.length - 1
                  : 0;

          final double totalWidth =
              (
                profiles.length *
                    cardWidth
              ) +
              (
                gapCount *
                    spacing
              );

          // =====================================================
          // SI TODOS CABEN:
          // SE CENTRAN
          //
          // SI NO CABEN:
          // SE ACTIVA SCROLL HORIZONTAL
          // =====================================================

          final bool fitsOnScreen =
              totalWidth <=
                  constraints.maxWidth;

          return SingleChildScrollView(
            scrollDirection:
                Axis.horizontal,
            physics:
                fitsOnScreen
                    ? const NeverScrollableScrollPhysics()
                    : const BouncingScrollPhysics(),
            child:
                ConstrainedBox(
              constraints:
                  BoxConstraints(
                minWidth:
                    constraints.maxWidth,
              ),
              child:
                  Row(
                mainAxisSize:
                    fitsOnScreen
                        ? MainAxisSize.max
                        : MainAxisSize.min,
                mainAxisAlignment:
                    fitsOnScreen
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                crossAxisAlignment:
                    CrossAxisAlignment.center,
                children:
                    List.generate(
                  profiles.length,
                  (
                    int index,
                  ) {
                    final Map<String, dynamic>
                        profile =
                        profiles[index];

                    return Padding(
                      padding:
                          EdgeInsets.only(
                        left:
                            index ==
                                    0
                                ? fitsOnScreen
                                    ? 0
                                    : 6
                                : spacing /
                                    2,
                        right:
                            index ==
                                    profiles.length -
                                        1
                                ? fitsOnScreen
                                    ? 0
                                    : 10
                                : spacing /
                                    2,
                      ),
                      child:
                          SizedBox(
                        width:
                            cardWidth,
                        height:
                            cardHeight,
                        child:
                            _ProfileCard(
                          profile:
                              profile,
                          onTap:
                              () {
                            onProfileTap(
                              profile,
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// =====================================================================
// TARJETA DE PERFIL
// =====================================================================

class _ProfileCard
    extends StatelessWidget {
  final Map<String, dynamic>
      profile;

  final VoidCallback onTap;

  const _ProfileCard({
    required this.profile,
    required this.onTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final String displayName =
        profile['displayName']
                ?.toString() ??
            'Jugador';

    final String avatarType =
        profile['avatarType']
                ?.toString()
                .trim()
                .toLowerCase() ??
            'emoji';

    final String avatarValue =
        profile['avatarValue']
                ?.toString() ??
            '🐢';

    return Material(
      color:
          Colors.white,
      borderRadius:
          BorderRadius.circular(
        20,
      ),
      clipBehavior:
          Clip.antiAlias,
      child:
          InkWell(
        onTap:
            onTap,
        borderRadius:
            BorderRadius.circular(
          20,
        ),
        child:
            Ink(
          decoration:
              BoxDecoration(
            color:
                Colors.white.withValues(
              alpha:
                  0.96,
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
              ),
              width:
                  2.4,
            ),
            boxShadow: [
              BoxShadow(
                color:
                    const Color(
                  0xFF236B3A,
                ).withValues(
                  alpha:
                      0.13,
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
              Padding(
            padding:
                const EdgeInsets.fromLTRB(
              8,
              10,
              8,
              8,
            ),
            child:
                Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                // ===============================================
                // AVATAR
                // ===============================================

                Container(
                  width:
                      76,
                  height:
                      76,
                  alignment:
                      Alignment.center,
                  decoration:
                      BoxDecoration(
                    shape:
                        BoxShape.circle,
                    gradient:
                        const LinearGradient(
                      begin:
                          Alignment.topLeft,
                      end:
                          Alignment.bottomRight,
                      colors: [
                        Color(
                          0xFFF0FBE8,
                        ),
                        Color(
                          0xFFC8EFA9,
                        ),
                      ],
                    ),
                    border:
                        Border.all(
                      color:
                          const Color(
                        0xFF79C94D,
                      ),
                      width:
                          1.8,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            const Color(
                          0xFF59B83A,
                        ).withValues(
                          alpha:
                              0.12,
                        ),
                        blurRadius:
                            6,
                        offset:
                            const Offset(
                          0,
                          2,
                        ),
                      ),
                    ],
                  ),

                  // =============================================
                  // CONTENIDO DEL AVATAR
                  // =============================================

                  child:
                      avatarType ==
                              'emoji'
                          ? Text(
                              avatarValue,
                              style:
                                  const TextStyle(
                                fontSize:
                                    42,
                                height:
                                    1,
                              ),
                            )
                          : const Icon(
                              Icons.person_rounded,
                              color:
                                  Color(
                                0xFF45A049,
                              ),
                              size:
                                  42,
                            ),
                ),

                const SizedBox(
                  height:
                      9,
                ),

                // ===============================================
                // NOMBRE
                // ===============================================

                Expanded(
                  child:
                      Center(
                    child:
                        Text(
                      displayName,
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
                          0xFF236B3A,
                        ),
                        fontSize:
                            14,
                        height:
                            1.12,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
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

// =====================================================================
// CARGANDO
// =====================================================================

class _ProfilesLoading
    extends StatelessWidget {
  const _ProfilesLoading();

  @override
  Widget build(
    BuildContext context,
  ) {
    return const SizedBox(
      height:
          164,
      child:
          Center(
        child:
            CircularProgressIndicator(
          color:
              Colors.white,
        ),
      ),
    );
  }
}

// =====================================================================
// SIN PERFILES
// =====================================================================

class _EmptyProfiles
    extends StatelessWidget {
  const _EmptyProfiles();

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      width:
          double.infinity,
      padding:
          const EdgeInsets.symmetric(
        horizontal:
            24,
        vertical:
            28,
      ),
      decoration:
          BoxDecoration(
        color:
            Colors.white.withValues(
          alpha:
              0.95,
        ),
        borderRadius:
            BorderRadius.circular(
          22,
        ),
        border:
            Border.all(
          color:
              const Color(
            0xFF7BCB4D,
          ),
          width:
              2,
        ),
      ),
      child:
          const Column(
        children: [
          Text(
            '🌱',
            style:
                TextStyle(
              fontSize:
                  48,
            ),
          ),

          SizedBox(
            height:
                12,
          ),

          Text(
            'Todavía no hay perfiles',
            textAlign:
                TextAlign.center,
            style:
                TextStyle(
              color:
                  Color(
                0xFF236B3A,
              ),
              fontSize:
                  18,
              fontWeight:
                  FontWeight.w800,
            ),
          ),

          SizedBox(
            height:
                7,
          ),

          Text(
            'Crea el primer jugador para comenzar la aventura.',
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
        ],
      ),
    );
  }
}

// =====================================================================
// ERROR
// =====================================================================

class _ProfilesError
    extends StatelessWidget {
  final String message;

  final Future<void> Function()
      onRetry;

  const _ProfilesError({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      width:
          double.infinity,
      padding:
          const EdgeInsets.all(
        22,
      ),
      decoration:
          BoxDecoration(
        color:
            Colors.white,
        borderRadius:
            BorderRadius.circular(
          22,
        ),
        border:
            Border.all(
          color:
              const Color(
            0xFF7BCB4D,
          ),
          width:
              2,
        ),
      ),
      child:
          Column(
        children: [
          const Icon(
            Icons.cloud_off_rounded,
            color:
                Colors.redAccent,
            size:
                45,
          ),

          const SizedBox(
            height:
                12,
          ),

          const Text(
            'No pudimos cargar los perfiles',
            textAlign:
                TextAlign.center,
            style:
                TextStyle(
              color:
                  Color(
                0xFF236B3A,
              ),
              fontWeight:
                  FontWeight.w800,
              fontSize:
                  16,
            ),
          ),

          const SizedBox(
            height:
                8,
          ),

          Text(
            message,
            textAlign:
                TextAlign.center,
            style:
                const TextStyle(
              color:
                  Color(
                0xFF718089,
              ),
            ),
          ),

          const SizedBox(
            height:
                15,
          ),

          FilledButton.icon(
            onPressed:
                () {
              onRetry();
            },
            icon:
                const Icon(
              Icons.refresh_rounded,
            ),
            label:
                const Text(
              'Reintentar',
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// NUEVO JUGADOR
// =====================================================================

class _NewPlayerButton
    extends StatelessWidget {
  final VoidCallback onTap;

  const _NewPlayerButton({
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
      clipBehavior:
          Clip.antiAlias,
      child:
          InkWell(
        onTap:
            onTap,
        borderRadius:
            BorderRadius.circular(
          22,
        ),
        child:
            Ink(
          width:
              double.infinity,
          padding:
              const EdgeInsets.symmetric(
            horizontal:
                18,
            vertical:
                16,
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
              ),
              width:
                  2.5,
            ),
          ),
          child:
              const Row(
            children: [
              // ===============================================
              // BOTÓN +
              // ===============================================

              CircleAvatar(
                radius:
                    29,
                backgroundColor:
                    Color(
                  0xFF59B83A,
                ),
                child:
                    Icon(
                  Icons.add_rounded,
                  size:
                      38,
                  color:
                      Colors.white,
                ),
              ),

              SizedBox(
                width:
                    16,
              ),

              // ===============================================
              // TEXTO
              // ===============================================

              Expanded(
                child:
                    Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nuevo jugador',
                      style:
                          TextStyle(
                        color:
                            Color(
                          0xFF236B3A,
                        ),
                        fontSize:
                            18,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),

                    SizedBox(
                      height:
                          5,
                    ),

                    Text(
                      'Crea un nuevo perfil y comienza tu aventura',
                      style:
                          TextStyle(
                        color:
                            Color(
                          0xFF718089,
                        ),
                        fontSize:
                            12,
                        height:
                            1.3,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                width:
                    8,
              ),

              // ===============================================
              // HOJA
              // ===============================================

              Icon(
                Icons.eco_rounded,
                color:
                    Color(
                  0xFF45A049,
                ),
                size:
                    30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}