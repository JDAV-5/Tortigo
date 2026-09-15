import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../data/services/player_progress_service.dart';
import '../../../domain/entities/player_profile.dart';

import 'pin_access_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() =>
      _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // ============================================================
  // SERVICIO CENTRAL DE PERFILES
  // ============================================================

  final PlayerProgressService _progressService =
      PlayerProgressService.instance;

  // ============================================================
  // PIN TEMPORALES
  // ============================================================
  //
  // Los nombres y avatares YA NO están aquí.
  //
  // Ahora vienen de PlayerProgressService.
  //
  // Estos PIN son temporales mientras desarrollamos
  // el sistema de perfiles.
  // ============================================================

  static const Map<String, String> _profilePins = {
    'ana': '1234',
    'juan': '2580',
    'sofia': '4321',
  };

  // ============================================================
  // ABRIR PANTALLA DEL PIN
  // ============================================================

  void _openPinForProfile(
    PlayerProfile player,
  ) {
    HapticFeedback.selectionClick();

    final pin =
        _profilePins[player.id];

    if (pin == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              'No se encontró el PIN para ${player.name}.',
            ),
          ),
        );

      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return PinAccessPage(
            playerName: player.name,
            expectedPin: pin,
          );
        },
      ),
    );
  }

  // ============================================================
  // CREAR JUGADOR
  // ============================================================

  void _createPlayer() {
    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(
            'Próximamente: crear nuevo jugador',
          ),
          duration: Duration(
            milliseconds: 1500,
          ),
        ),
      );
  }

  // ============================================================
  // COLOR DEL PERFIL
  // ============================================================

  Color _getProfileColor(
    String profileId,
  ) {
    switch (profileId) {
      case 'ana':
        return const Color(
          0xFF7BCB4D,
        );

      case 'juan':
        return const Color(
          0xFF59B83A,
        );

      case 'sofia':
        return const Color(
          0xFF9BD56B,
        );

      default:
        return const Color(
          0xFF7BCB4D,
        );
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    // ==========================================================
    // PERFILES DESDE EL SISTEMA CENTRAL
    // ==========================================================

    final profiles =
        _progressService.profiles;

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
            // CAPA SUAVE
            // =================================================

            Container(
              color: Colors.black.withValues(
                alpha: 0.04,
              ),
            ),

            // =================================================
            // CONTENIDO
            // =================================================

            SafeArea(
              child: SingleChildScrollView(
                physics:
                    const BouncingScrollPhysics(),

                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 22,
                  ),

                  child: Column(
                    children: [
                      const SizedBox(
                        height: 12,
                      ),

                      // =========================================
                      // LOGO
                      // =========================================

                      Image.asset(
                        'assets/images/tortigo_logo1.png',
                        width: 250,
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(
                        height: 24,
                      ),

                      // =========================================
                      // TÍTULO
                      // =========================================

                      const Text(
                        '¿Quién está jugando?',
                        textAlign:
                            TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight:
                              FontWeight.w800,
                          shadows: [
                            Shadow(
                              color:
                                  Colors.black45,
                              blurRadius: 6,
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
                        height: 8,
                      ),

                      Text(
                        'Selecciona tu perfil para continuar',
                        textAlign:
                            TextAlign.center,
                        style: TextStyle(
                          color: Colors.white
                              .withValues(
                            alpha: 0.95,
                          ),
                          fontSize: 14,
                          fontWeight:
                              FontWeight.w500,
                          shadows: const [
                            Shadow(
                              color:
                                  Colors.black38,
                              blurRadius: 4,
                              offset:
                                  Offset(
                                0,
                                1,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 28,
                      ),

                      // =========================================
                      // PERFILES
                      // =========================================

                      Row(
                        children:
                            List.generate(
                          profiles.length,
                          (
                            index,
                          ) {
                            final profile =
                                profiles[index];

                            return Expanded(
                              child: Padding(
                                padding:
                                    EdgeInsets.only(
                                  left:
                                      index == 0
                                          ? 0
                                          : 5,
                                  right:
                                      index ==
                                              profiles
                                                      .length -
                                                  1
                                          ? 0
                                          : 5,
                                ),

                                child:
                                    _ProfileCard(
                                  profile:
                                      profile,

                                  accentColor:
                                      _getProfileColor(
                                    profile.id,
                                  ),

                                  onTap: () {
                                    _openPinForProfile(
                                      profile,
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // =========================================
                      // ESPACIO
                      // =========================================

                      const SizedBox(
                        height: 60,
                      ),

                      // =========================================
                      // NUEVO JUGADOR
                      // =========================================

                      GestureDetector(
                        onTap:
                            _createPlayer,

                        child: Container(
                          width:
                              double.infinity,

                          padding:
                              const EdgeInsets
                                  .symmetric(
                            horizontal: 18,
                            vertical: 16,
                          ),

                          decoration:
                              BoxDecoration(
                            color:
                                Colors.white,

                            borderRadius:
                                BorderRadius
                                    .circular(
                              22,
                            ),

                            border:
                                Border.all(
                              color:
                                  const Color(
                                0xFF7BCB4D,
                              ),
                              width: 2.5,
                            ),

                            boxShadow: [
                              BoxShadow(
                                color:
                                    const Color(
                                  0xFF236B3A,
                                ).withValues(
                                  alpha:
                                      0.22,
                                ),
                                blurRadius:
                                    16,
                                offset:
                                    const Offset(
                                  0,
                                  7,
                                ),
                              ),
                            ],
                          ),

                          child: Row(
                            children: [
                              // =================================
                              // +
                              // =================================

                              Container(
                                width: 58,
                                height: 58,

                                decoration:
                                    const BoxDecoration(
                                  shape:
                                      BoxShape.circle,

                                  gradient:
                                      LinearGradient(
                                    begin:
                                        Alignment
                                            .topLeft,
                                    end:
                                        Alignment
                                            .bottomRight,
                                    colors: [
                                      Color(
                                        0xFF72CB43,
                                      ),
                                      Color(
                                        0xFF45A049,
                                      ),
                                    ],
                                  ),
                                ),

                                child:
                                    const Icon(
                                  Icons
                                      .add_rounded,
                                  size: 38,
                                  color:
                                      Colors.white,
                                ),
                              ),

                              const SizedBox(
                                width: 16,
                              ),

                              // =================================
                              // TEXTO
                              // =================================

                              const Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,

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
                                            FontWeight
                                                .w800,
                                      ),
                                    ),

                                    SizedBox(
                                      height: 5,
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

                              // =================================
                              // HOJA
                              // =================================

                              Container(
                                width: 50,
                                height: 50,

                                decoration:
                                    BoxDecoration(
                                  shape:
                                      BoxShape.circle,

                                  color:
                                      const Color(
                                    0xFF59B83A,
                                  ).withValues(
                                    alpha:
                                        0.13,
                                  ),
                                ),

                                child:
                                    const Icon(
                                  Icons
                                      .eco_rounded,
                                  color:
                                      Color(
                                    0xFF45A049,
                                  ),
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 55,
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
// TARJETA DE PERFIL
// =====================================================================

class _ProfileCard extends StatelessWidget {
  final PlayerProfile profile;

  final Color accentColor;

  final VoidCallback onTap;

  const _ProfileCard({
    required this.profile,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,

      borderRadius:
          BorderRadius.circular(
        18,
      ),

      child: InkWell(
        onTap: onTap,

        borderRadius:
            BorderRadius.circular(
          18,
        ),

        child: Container(
          height: 152,

          padding:
              const EdgeInsets.fromLTRB(
            8,
            10,
            8,
            8,
          ),

          decoration:
              BoxDecoration(
            borderRadius:
                BorderRadius.circular(
              18,
            ),

            border:
                Border.all(
              color:
                  accentColor,
              width: 2.5,
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
                    10,
                offset:
                    const Offset(
                  0,
                  5,
                ),
              ),
            ],
          ),

          child: Column(
            children: [
              // =================================================
              // AVATAR
              // =================================================

              Container(
                width: 72,
                height: 72,

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
                        0xFFE7F7D8,
                      ),
                      Color(
                        0xFFA8DF7A,
                      ),
                    ],
                  ),

                  border:
                      Border.all(
                    color:
                        accentColor
                            .withValues(
                      alpha:
                          0.50,
                    ),
                    width:
                        1.5,
                  ),
                ),

                alignment:
                    Alignment.center,

                child: Text(
                  profile.avatar,

                  style:
                      const TextStyle(
                    fontSize: 40,
                  ),
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              // =================================================
              // NOMBRE
              // =================================================

              Text(
                profile.name,

                style:
                    const TextStyle(
                  color:
                      Color(
                    0xFF236B3A,
                  ),
                  fontSize:
                      15,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),

              const Spacer(),

              // =================================================
              // ESTRELLA
              // =================================================

              Align(
                alignment:
                    Alignment.bottomRight,

                child: Row(
                  mainAxisSize:
                      MainAxisSize.min,

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
                      width: 2,
                    ),

                    Text(
                      '${profile.stars}',

                      style:
                          const TextStyle(
                        color:
                            Color(
                          0xFF59666D,
                        ),
                        fontSize:
                            10,
                        fontWeight:
                            FontWeight.w700,
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