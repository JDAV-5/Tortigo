import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

class MissionsPage extends StatefulWidget {
  const MissionsPage({super.key});

  @override
  State<MissionsPage> createState() => _MissionsPageState();
}

class _MissionsPageState extends State<MissionsPage> {
  // =============================================================
  // AUDIO
  // =============================================================

  final AudioPlayer _musicPlayer = AudioPlayer();

  bool _musicEnabled = true;
  bool _musicReady = false;

  @override
  void initState() {
    super.initState();

    _startMusic();
  }

  Future<void> _startMusic() async {
    try {
      await _musicPlayer.setReleaseMode(
        ReleaseMode.loop,
      );

      await _musicPlayer.setVolume(
        0.25,
      );

      await _musicPlayer.play(
        AssetSource(
          'audio/missions/plant_seed/Camino.mp3',
        ),
      );

      if (!mounted) return;

      setState(() {
        _musicReady = true;
      });
    } catch (e) {
      debugPrint(
        'Error reproduciendo Camino.mp3: $e',
      );
    }
  }

  Future<void> _pauseMusic() async {
    try {
      await _musicPlayer.pause();
    } catch (e) {
      debugPrint(
        'Error pausando música: $e',
      );
    }
  }

  Future<void> _resumeMusic() async {
    if (!_musicEnabled) {
      return;
    }

    try {
      if (_musicReady) {
        await _musicPlayer.resume();
      } else {
        await _startMusic();
      }
    } catch (e) {
      debugPrint(
        'Error reanudando música: $e',
      );
    }
  }

  Future<void> _toggleMusic() async {
    if (_musicEnabled) {
      await _pauseMusic();

      if (!mounted) return;

      setState(() {
        _musicEnabled = false;
      });
    } else {
      if (!mounted) return;

      setState(() {
        _musicEnabled = true;
      });

      await _resumeMusic();
    }
  }

  @override
  void dispose() {
    _musicPlayer.stop();
    _musicPlayer.dispose();

    super.dispose();
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final missions = [
      const MissionData(
        title: 'Planta una semilla',
        reward: 20,
        icon: Icons.local_florist_rounded,
        status: MissionStatus.available,
        route: '/missions/plant-seed',
      ),
      const MissionData(
        title: 'Ahorra agua',
        reward: 15,
        icon: Icons.water_drop_rounded,
        status: MissionStatus.locked,
      ),
      const MissionData(
        title: 'Recicla residuos',
        reward: 25,
        icon: Icons.recycling_rounded,
        status: MissionStatus.locked,
      ),
      const MissionData(
        title: 'Transporte sostenible',
        reward: 30,
        icon: Icons.directions_bike_rounded,
        status: MissionStatus.locked,
      ),
    ];

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
        extendBody: true,
        backgroundColor:
            const Color(0xFF59B83A),

        body: LayoutBuilder(
          builder: (
            context,
            constraints,
          ) {
            final width =
                constraints.maxWidth;

            final height =
                constraints.maxHeight;

            final topPadding =
                MediaQuery.paddingOf(
              context,
            ).top;

            return Stack(
              fit: StackFit.expand,
              children: [
                // =====================================================
                // FONDO
                // =====================================================

                Image.asset(
                  'assets/images/missions/missions_background.png',
                  fit: BoxFit.cover,
                  alignment:
                      Alignment.topCenter,
                ),

                // =====================================================
                // SOMBRA SUPERIOR
                // =====================================================

                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 150,
                  child: IgnorePointer(
                    child: Container(
                      decoration:
                          BoxDecoration(
                        gradient:
                            LinearGradient(
                          begin: Alignment
                              .topCenter,
                          end: Alignment
                              .bottomCenter,
                          colors: [
                            Colors.black
                                .withValues(
                              alpha: 0.08,
                            ),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // =====================================================
                // LOGO MISIONES
                // =====================================================

                Positioned(
                  top:
                      topPadding + 40,
                  left: width * 0.10,
                  right:
                      width * 0.05,
                  child: IgnorePointer(
                    child: Image.asset(
                      'assets/images/Misiones.png',
                      height: 110,
                      fit:
                          BoxFit.contain,
                    ),
                  ),
                ),

                // =====================================================
                // BOTÓN REGRESAR
                // =====================================================

                Positioned(
                  top:
                      topPadding + 18,
                  left: 14,
                  child: _BackButton(
                    onTap: () async {
                      await _pauseMusic();

                      if (!context.mounted) {
                        return;
                      }

                      Navigator.pop(
                        context,
                      );
                    },
                  ),
                ),

                // =====================================================
                // BOTÓN MÚSICA
                // =====================================================

                Positioned(
                  top:
                      topPadding + 18,
                  right: 14,
                  child:
                      _MusicButton(
                    enabled:
                        _musicEnabled,
                    onTap:
                        _toggleMusic,
                  ),
                ),

                // =====================================================
                // TORTI
                // =====================================================

                Positioned(
                  top:
                      topPadding + 90,
                  left: -8,
                  child: IgnorePointer(
                    child: Image.asset(
                      'assets/images/saludo.png',
                      width: 125,
                      fit:
                          BoxFit.contain,
                    ),
                  ),
                ),

                // =====================================================
                // MISIÓN 1
                // =====================================================

                Positioned(
                  left:
                      width * 0.24,
                  top:
                      height * 0.39,
                  child: MissionNode(
                    mission:
                        missions[0],
                    onTap: () {
                      _openMission(
                        context,
                        missions[0],
                      );
                    },
                  ),
                ),

                // =====================================================
                // MISIÓN 2
                // =====================================================

                Positioned(
                  right:
                      width * 0.07,
                  top:
                      height * 0.52,
                  child: MissionNode(
                    mission:
                        missions[1],
                    onTap: () {
                      _openMission(
                        context,
                        missions[1],
                      );
                    },
                  ),
                ),

                // =====================================================
                // MISIÓN 3
                // =====================================================

                Positioned(
                  left:
                      width * 0.08,
                  top:
                      height * 0.65,
                  child: MissionNode(
                    mission:
                        missions[2],
                    onTap: () {
                      _openMission(
                        context,
                        missions[2],
                      );
                    },
                  ),
                ),

                // =====================================================
                // MISIÓN 4
                // =====================================================

                Positioned(
                  right:
                      width * 0.06,
                  top:
                      height * 0.78,
                  child: MissionNode(
                    mission:
                        missions[3],
                    onTap: () {
                      _openMission(
                        context,
                        missions[3],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),

        bottomNavigationBar:
            const MissionsBottomNavigation(),
      ),
    );
  }

  // =============================================================
  // ABRIR MISIÓN
  // =============================================================

  Future<void> _openMission(
    BuildContext context,
    MissionData mission,
  ) async {
    if (mission.status ==
        MissionStatus.locked) {
      HapticFeedback.lightImpact();

      ScaffoldMessenger.of(
        context,
      )
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'Completa la misión anterior para desbloquear esta.',
            ),
            duration: Duration(
              milliseconds: 1500,
            ),
          ),
        );

      return;
    }

    if (mission.route != null) {
      // ---------------------------------------------------------
      // PAUSAMOS LA MÚSICA DEL CAMINO
      // ---------------------------------------------------------

      await _pauseMusic();

      if (!context.mounted) {
        return;
      }

      // ---------------------------------------------------------
      // ENTRAMOS A LA MISIÓN
      // ---------------------------------------------------------

      await Navigator.pushNamed(
        context,
        mission.route!,
      );

      // ---------------------------------------------------------
      // CUANDO REGRESAMOS AL CAMINO
      // ---------------------------------------------------------

      if (!mounted) {
        return;
      }

      if (_musicEnabled) {
        await _resumeMusic();
      }

      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      const SnackBar(
        content: Text(
          'Esta misión estará disponible próximamente.',
        ),
      ),
    );
  }
}

// =====================================================================
// ESTADO DE MISIÓN
// =====================================================================

enum MissionStatus {
  completed,
  available,
  locked,
}

// =====================================================================
// MODELO DE MISIÓN
// =====================================================================

class MissionData {
  final String title;
  final int reward;
  final IconData icon;
  final MissionStatus status;
  final String? route;

  const MissionData({
    required this.title,
    required this.reward,
    required this.icon,
    required this.status,
    this.route,
  });
}

// =====================================================================
// BOTÓN REGRESAR
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
    return Material(
      color:
          const Color(0xFF59B83A),
      shape:
          const CircleBorder(),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        customBorder:
            const CircleBorder(),
        child: const SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 27,
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// BOTÓN MÚSICA
// =====================================================================

class _MusicButton
    extends StatelessWidget {
  final bool enabled;
  final VoidCallback onTap;

  const _MusicButton({
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Material(
      color:
          Colors.white.withValues(
        alpha: 0.94,
      ),
      shape:
          const CircleBorder(),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        customBorder:
            const CircleBorder(),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            enabled
                ? Icons
                    .volume_up_rounded
                : Icons
                    .volume_off_rounded,
            color:
                const Color(
              0xFF236B3A,
            ),
            size: 25,
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// NODO DE MISIÓN
// =====================================================================

class MissionNode
    extends StatelessWidget {
  final MissionData mission;
  final VoidCallback onTap;

  const MissionNode({
    super.key,
    required this.mission,
    required this.onTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final locked =
        mission.status ==
            MissionStatus.locked;

    final completed =
        mission.status ==
            MissionStatus.completed;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 116,
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            // =====================================================
            // ICONO
            // =====================================================

            Container(
              width: 66,
              height: 66,
              decoration:
                  BoxDecoration(
                color: Colors.white
                    .withValues(
                  alpha: 0.97,
                ),
                shape:
                    BoxShape.circle,
                border:
                    Border.all(
                  color: locked
                      ? const Color(
                          0xFFC6D0D5,
                        )
                      : const Color(
                          0xFFE8D786,
                        ),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withValues(
                      alpha: 0.17,
                    ),
                    blurRadius: 9,
                    offset:
                        const Offset(
                      0,
                      4,
                    ),
                  ),
                ],
              ),
              child: Stack(
                alignment:
                    Alignment.center,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration:
                        BoxDecoration(
                      shape:
                          BoxShape.circle,
                      color: locked
                          ? const Color(
                              0xFFE8EEF1,
                            )
                          : const Color(
                              0xFFF4FBEF,
                            ),
                    ),
                    child: Icon(
                      mission.icon,
                      size: 30,
                      color: locked
                          ? const Color(
                              0xFF9CAEB7,
                            )
                          : _missionColor(
                              mission,
                            ),
                    ),
                  ),

                  // =================================================
                  // CANDADO
                  // =================================================

                  if (locked)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child:
                          Container(
                        width: 22,
                        height: 22,
                        decoration:
                            const BoxDecoration(
                          color:
                              Color(
                            0xFF647984,
                          ),
                          shape:
                              BoxShape.circle,
                        ),
                        child:
                            const Icon(
                          Icons
                              .lock_rounded,
                          color:
                              Colors.white,
                          size: 13,
                        ),
                      ),
                    ),

                  // =================================================
                  // COMPLETADA
                  // =================================================

                  if (completed)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child:
                          Container(
                        width: 22,
                        height: 22,
                        decoration:
                            const BoxDecoration(
                          color:
                              Color(
                            0xFF59B83A,
                          ),
                          shape:
                              BoxShape.circle,
                        ),
                        child:
                            const Icon(
                          Icons
                              .check_rounded,
                          color:
                              Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(
              height: 5,
            ),

            // =====================================================
            // INFORMACIÓN
            // =====================================================

            Container(
              width:
                  double.infinity,
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 7,
                vertical: 6,
              ),
              decoration:
                  BoxDecoration(
                color: Colors.white
                    .withValues(
                  alpha: 0.93,
                ),
                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
                border:
                    Border.all(
                  color: locked
                      ? const Color(
                          0xFFD6DEE2,
                        )
                      : const Color(
                          0xFFDDE9D3,
                        ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withValues(
                      alpha: 0.08,
                    ),
                    blurRadius: 6,
                    offset:
                        const Offset(
                      0,
                      3,
                    ),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  Text(
                    mission.title,
                    textAlign:
                        TextAlign.center,
                    maxLines: 2,
                    overflow:
                        TextOverflow
                            .ellipsis,
                    style:
                        TextStyle(
                      color: locked
                          ? const Color(
                              0xFF7F8D93,
                            )
                          : const Color(
                              0xFF2D7A3F,
                            ),
                      fontSize: 10,
                      height: 1.1,
                      fontWeight:
                          FontWeight
                              .w800,
                    ),
                  ),

                  const SizedBox(
                    height: 3,
                  ),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .center,
                    children: [
                      Icon(
                        Icons
                            .star_rounded,
                        color: locked
                            ? const Color(
                                0xFFC7CED2,
                              )
                            : const Color(
                                0xFFFFD23F,
                              ),
                        size: 18,
                      ),

                      const SizedBox(
                        width: 2,
                      ),

                      Text(
                        '+${mission.reward}',
                        style:
                            TextStyle(
                          color: locked
                              ? const Color(
                                  0xFF9AA6AC,
                                )
                              : const Color(
                                  0xFF6B5200,
                                ),
                          fontSize: 10,
                          fontWeight:
                              FontWeight
                                  .w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _missionColor(
    MissionData mission,
  ) {
    if (mission.icon ==
        Icons
            .local_florist_rounded) {
      return const Color(
        0xFF59B83A,
      );
    }

    if (mission.icon ==
        Icons
            .water_drop_rounded) {
      return const Color(
        0xFF3BAEEB,
      );
    }

    if (mission.icon ==
        Icons.recycling_rounded) {
      return const Color(
        0xFF45A049,
      );
    }

    if (mission.icon ==
        Icons
            .directions_bike_rounded) {
      return const Color(
        0xFF006080,
      );
    }

    return const Color(
      0xFF4C82D8,
    );
  }
}

// =====================================================================
// BARRA INFERIOR
// =====================================================================

class MissionsBottomNavigation
    extends StatelessWidget {
  const MissionsBottomNavigation({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      margin:
          const EdgeInsets.fromLTRB(
        14,
        0,
        14,
        10,
      ),
      padding:
          const EdgeInsets.symmetric(
        vertical: 5,
      ),
      decoration:
          BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.96,
        ),
        borderRadius:
            BorderRadius.circular(
          22,
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(
              alpha: 0.15,
            ),
            blurRadius: 15,
            offset:
                const Offset(
              0,
              4,
            ),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment
                  .spaceAround,
          children: [
            _NavItem(
              icon:
                  Icons.home_rounded,
              label: 'Inicio',
              onTap: () {
                Navigator
                    .pushReplacementNamed(
                  context,
                  '/home',
                );
              },
            ),

            const _NavItem(
              icon:
                  Icons
                      .sports_esports_rounded,
              label: 'Juegos',
            ),

            const _NavItem(
              icon:
                  Icons
                      .menu_book_rounded,
              label: 'Aprender',
            ),

            const _NavItem(
              icon:
                  Icons
                      .emoji_events_rounded,
              label: 'Logros',
            ),

            const _NavItem(
              icon:
                  Icons
                      .chat_bubble_rounded,
              label: 'Torti',
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// ITEM NAVEGACIÓN
// =====================================================================

class _NavItem
    extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(
        14,
      ),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Icon(
              icon,
              color:
                  const Color(
                0xFF718089,
              ),
              size: 22,
            ),

            const SizedBox(
              height: 2,
            ),

            Text(
              label,
              style:
                  const TextStyle(
                color:
                    Color(
                  0xFF718089,
                ),
                fontSize: 9,
                fontWeight:
                    FontWeight
                        .w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}