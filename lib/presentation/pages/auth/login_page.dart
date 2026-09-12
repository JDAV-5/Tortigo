import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'pin_access_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // ============================================================
  // PERFILES
  //
  // PIN temporales para desarrollo.
  // Más adelante cada jugador tendrá su propio PIN.
  // ============================================================

  final List<PlayerProfile> _profiles = const [
    PlayerProfile(
      name: 'Ana',
      emoji: '🐢',
      accentColor: Color(0xFF7BCB4D),
      pin: '1234',
    ),
    PlayerProfile(
      name: 'Juan',
      emoji: '🦫',
      accentColor: Color(0xFF59B83A),
      pin: '2580',
    ),
    PlayerProfile(
      name: 'Sofía',
      emoji: '🐼',
      accentColor: Color(0xFF9BD56B),
      pin: '4321',
    ),
  ];

  // ============================================================
  // ABRIR PANTALLA PIN
  // ============================================================

  void _openPinForProfile(int index) {
    HapticFeedback.selectionClick();

    final player = _profiles[index];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return PinAccessPage(
            playerName: player.name,
            expectedPin: player.pin,
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
            const Color(0xFF236B3A),

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
                                  Offset(0, 2),
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
                                  Offset(0, 1),
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
                          _profiles.length,
                          (index) {
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
                                              _profiles
                                                      .length -
                                                  1
                                          ? 0
                                          : 5,
                                ),

                                child:
                                    _ProfileCard(
                                  profile:
                                      _profiles[
                                          index],

                                  onTap: () {
                                    _openPinForProfile(
                                      index,
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // =========================================
                      // ESPACIO ENTRE PERFILES Y NUEVO JUGADOR
                      // =========================================

                      const SizedBox(
                        height: 60,
                      ),

                      // =========================================
                      // NUEVO JUGADOR
                      // =========================================

                      GestureDetector(
                        onTap: _createPlayer,

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
                            color: Colors.white,

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
                                  alpha: 0.22,
                                ),
                                blurRadius: 16,
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
                              // =====================================
                              // BOTÓN +
                              // =====================================

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
                                  Icons.add_rounded,
                                  size: 38,
                                  color:
                                      Colors.white,
                                ),
                              ),

                              const SizedBox(
                                width: 16,
                              ),

                              // =====================================
                              // TEXTO
                              // =====================================

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

                              // =====================================
                              // HOJA
                              // =====================================

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
                                    alpha: 0.13,
                                  ),
                                ),

                                child:
                                    const Icon(
                                  Icons.eco_rounded,
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

                      // =========================================
                      // ESPACIO INFERIOR
                      // =========================================

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
// MODELO DEL PERFIL
// =====================================================================

class PlayerProfile {
  final String name;
  final String emoji;
  final Color accentColor;
  final String pin;

  const PlayerProfile({
    required this.name,
    required this.emoji,
    required this.accentColor,
    required this.pin,
  });
}

// =====================================================================
// TARJETA DE PERFIL
// =====================================================================

class _ProfileCard extends StatelessWidget {
  final PlayerProfile profile;
  final VoidCallback onTap;

  const _ProfileCard({
    required this.profile,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        height: 152,

        padding:
            const EdgeInsets.fromLTRB(
          8,
          10,
          8,
          8,
        ),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(
            18,
          ),

          border: Border.all(
            color:
                profile.accentColor,
            width: 2.5,
          ),

          boxShadow: [
            BoxShadow(
              color:
                  const Color(
                0xFF236B3A,
              ).withValues(
                alpha: 0.14,
              ),
              blurRadius: 10,
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

                border: Border.all(
                  color:
                      const Color(
                    0xFF7BCB4D,
                  ).withValues(
                    alpha: 0.35,
                  ),
                  width: 1.5,
                ),
              ),

              alignment:
                  Alignment.center,

              child: Text(
                profile.emoji,
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
                fontSize: 15,
                fontWeight:
                    FontWeight.w800,
              ),
            ),

            const Spacer(),

            // =================================================
            // ESTRELLA
            // =================================================

            const Align(
              alignment:
                  Alignment.bottomRight,

              child: Icon(
                Icons.star_rounded,
                color:
                    Color(
                  0xFFFFD23F,
                ),
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}