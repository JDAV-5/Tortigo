import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../../data/services/current_user_service.dart';

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

  // =============================================================
  // USUARIO ACTUAL Y PROGRESO DE MISIONES
  // =============================================================

  final CurrentUserService _currentUserService =
      CurrentUserService.instance;

  bool _plantSeedCompleted = false;

  bool _waterMissionUnlocked = false;

  // Controla la animación especial del nodo 2.
  bool _unlockingMission2 = false;

  // Controla el aviso superior.
  bool _showUnlockBanner = false;

  // =============================================================
  // INIT
  // =============================================================

  @override
  void initState() {
    super.initState();

    _loadCurrentUserProgress();

    _startMusic();
  }

  // =============================================================
  // CARGAR PROGRESO DEL USUARIO AUTENTICADO
  // =============================================================

  void _loadCurrentUserProgress() {
    final Map<String, dynamic>? user =
        _currentUserService.currentUser;

    if (user == null) {
      _plantSeedCompleted = false;
      _waterMissionUnlocked = false;
      return;
    }

    final dynamic rawCompletedMissions =
        user['completedMissions'];

    final List<String> completedMissions =
        rawCompletedMissions is List
            ? rawCompletedMissions
                .map(
                  (dynamic item) =>
                      item.toString(),
                )
                .toList()
            : <String>[];

    _plantSeedCompleted =
        completedMissions.contains(
      'plant_seed',
    );

    _waterMissionUnlocked =
        _plantSeedCompleted ||
        completedMissions.contains(
          'mission_2',
        );
  }

  // =============================================================
  // OBTENER MISIONES COMPLETADAS DEL USUARIO
  // =============================================================

  List<String> _getCompletedMissions() {
    final Map<String, dynamic>? user =
        _currentUserService.currentUser;

    if (user == null) {
      return <String>[];
    }

    final dynamic rawCompletedMissions =
        user['completedMissions'];

    if (rawCompletedMissions is! List) {
      return <String>[];
    }

    return rawCompletedMissions
        .map(
          (dynamic item) =>
              item.toString(),
        )
        .toList();
  }

  // =============================================================
  // MÚSICA
  // =============================================================

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

      if (!mounted) {
        return;
      }

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

      if (!mounted) {
        return;
      }

      setState(() {
        _musicEnabled = false;
      });
    } else {
      if (!mounted) {
        return;
      }

      setState(() {
        _musicEnabled = true;
      });

      await _resumeMusic();
    }
  }

  // =============================================================
  // DISPOSE
  // =============================================================

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
      // =========================================================
      // MISIÓN 1
      // =========================================================

      MissionData(
        title: 'Planta una semilla',
        reward: 20,
        icon: Icons.local_florist_rounded,
        status: _plantSeedCompleted
            ? MissionStatus.completed
            : MissionStatus.available,
        route: '/missions/plant-seed',
      ),

      // =========================================================
      // MISIÓN 2
      // =========================================================

      MissionData(
        title: 'Ahorra agua',
        reward: 15,
        icon: Icons.water_drop_rounded,
        status: _waterMissionUnlocked
            ? MissionStatus.available
            : MissionStatus.locked,
      ),

      // =========================================================
      // MISIÓN 3
      // =========================================================

      const MissionData(
        title: 'Recicla residuos',
        reward: 25,
        icon: Icons.recycling_rounded,
        status: MissionStatus.locked,
      ),

      // =========================================================
      // MISIÓN 4
      // =========================================================

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
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemStatusBarContrastEnforced: false,
      ),
      child: Scaffold(
        extendBody: true,
        backgroundColor: const Color(0xFF59B83A),

        body: LayoutBuilder(
          builder: (
            context,
            constraints,
          ) {
            final width = constraints.maxWidth;

            final height = constraints.maxHeight;

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
                          begin:
                              Alignment.topCenter,
                          end:
                              Alignment.bottomCenter,
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
                // LOGO
                // =====================================================

                Positioned(
                  top: topPadding + 40,
                  left: width * 0.10,
                  right: width * 0.05,
                  child: IgnorePointer(
                    child: Image.asset(
                      'assets/images/Misiones.png',
                      height: 110,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // =====================================================
                // BOTÓN REGRESAR
                // =====================================================

                Positioned(
                  top: topPadding + 18,
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
                  top: topPadding + 18,
                  right: 14,
                  child: _MusicButton(
                    enabled: _musicEnabled,
                    onTap: () {
                      _toggleMusic();
                    },
                  ),
                ),

                // =====================================================
                // TORTI
                // =====================================================

                Positioned(
                  top: topPadding + 90,
                  left: -8,
                  child: IgnorePointer(
                    child: Image.asset(
                      'assets/images/saludo.png',
                      width: 125,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // =====================================================
                // AVISO DE NUEVA MISIÓN DESBLOQUEADA
                // =====================================================

                Positioned(
                  top: topPadding + 165,
                  left: 25,
                  right: 25,
                  child: IgnorePointer(
                    child: AnimatedSlide(
                      duration:
                          const Duration(
                        milliseconds: 500,
                      ),
                      curve:
                          Curves.easeOutBack,
                      offset:
                          _showUnlockBanner
                              ? Offset.zero
                              : const Offset(
                                  0,
                                  -0.45,
                                ),
                      child:
                          AnimatedOpacity(
                        duration:
                            const Duration(
                          milliseconds: 350,
                        ),
                        opacity:
                            _showUnlockBanner
                                ? 1
                                : 0,
                        child:
                            const _UnlockBanner(),
                      ),
                    ),
                  ),
                ),

                // =====================================================
                // MISIÓN 1
                // =====================================================

                Positioned(
                  left: width * 0.24,
                  top: height * 0.39,
                  child: MissionNode(
                    mission: missions[0],
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
                  right: width * 0.07,
                  top: height * 0.52,
                  child: MissionNode(
                    mission: missions[1],

                    // Activa el efecto de desbloqueo.
                    animateUnlock:
                        _unlockingMission2,

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
                  left: width * 0.08,
                  top: height * 0.65,
                  child: MissionNode(
                    mission: missions[2],
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
                  right: width * 0.06,
                  top: height * 0.78,
                  child: MissionNode(
                    mission: missions[3],
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
    // ===========================================================
    // MISIÓN BLOQUEADA
    // ===========================================================

    if (mission.status ==
        MissionStatus.locked) {
      HapticFeedback.lightImpact();

      ScaffoldMessenger.of(context)
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

    // ===========================================================
    // MISIÓN CON RUTA
    // ===========================================================

    if (mission.route != null) {
      // ---------------------------------------------------------
      // PAUSAMOS LA MÚSICA DEL CAMINO
      // ---------------------------------------------------------

      await _pauseMusic();

      if (!context.mounted) {
        return;
      }

      // ---------------------------------------------------------
      // ABRIMOS LA MISIÓN
      //
      // El resultado será true cuando la misión termine.
      // ---------------------------------------------------------

      final result =
          await Navigator.pushNamed(
        context,
        mission.route!,
      );

      if (!mounted) {
        return;
      }

      // ---------------------------------------------------------
      // VOLVEMOS A REPRODUCIR CAMINO.MP3
      // ---------------------------------------------------------

      if (_musicEnabled) {
        await _resumeMusic();
      }

      if (!mounted) {
        return;
      }

      // ---------------------------------------------------------
      // MISIÓN 1 COMPLETADA
      // ---------------------------------------------------------

      if (result == true &&
          mission.route ==
              '/missions/plant-seed') {
        await _completePlantSeedMission();
      }

      return;
    }

    // ===========================================================
    // MISIÓN DESBLOQUEADA PERO AÚN SIN PANTALLA
    // ===========================================================

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Esta misión estará disponible próximamente.',
        ),
      ),
    );
  }

  // =============================================================
  // COMPLETAR MISIÓN 1 Y DESBLOQUEAR MISIÓN 2
  // =============================================================

  Future<void>
      _completePlantSeedMission() async {
    // ===========================================================
    // VALIDAR USUARIO AUTENTICADO
    // ===========================================================

    if (!_currentUserService.hasUser) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'No hay un usuario autenticado.',
            ),
          ),
        );

      return;
    }

    // ===========================================================
    // OBTENER MISIONES DEL USUARIO ACTUAL
    // ===========================================================

    final List<String> completedMissions =
        _getCompletedMissions();

    // ===========================================================
    // EVITAR ENTREGAR LA RECOMPENSA DOS VECES
    // ===========================================================

    if (completedMissions.contains(
      'plant_seed',
    )) {
      if (!mounted) {
        return;
      }

      setState(() {
        _plantSeedCompleted = true;
        _waterMissionUnlocked = true;
      });

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'Esta misión ya estaba completada. No se agregaron estrellas nuevas.',
            ),
            duration: Duration(
              milliseconds: 1800,
            ),
          ),
        );

      return;
    }

    // ===========================================================
    // GUARDAR MISIÓN COMPLETADA EN EL USUARIO ACTUAL
    // ===========================================================

    completedMissions.add(
      'plant_seed',
    );

    _currentUserService.updateCurrentUser(
      <String, dynamic>{
        'completedMissions':
            completedMissions,
      },
    );

    // ===========================================================
    // ENTREGAR 20 ESTRELLAS AL USUARIO AUTENTICADO
    // ===========================================================

    _currentUserService.addStars(
      20,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _plantSeedCompleted = true;
      _waterMissionUnlocked = true;
    });

    // ===========================================================
    // CONFIRMAR RECOMPENSA
    // ===========================================================

    HapticFeedback.mediumImpact();

    final String playerName =
        _currentUserService.displayName.isNotEmpty
            ? _currentUserService.displayName
            : 'tu perfil';

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            '+20 ⭐ para $playerName',
          ),
          duration:
              const Duration(
            milliseconds: 1700,
          ),
        ),
      );

    // Dejamos visible el check verde.
    await Future.delayed(
      const Duration(
        milliseconds: 650,
      ),
    );

    if (!mounted) {
      return;
    }

    // ===========================================================
    // MOSTRAR DESBLOQUEO DE AHORRA AGUA
    // ===========================================================

    setState(() {
      _waterMissionUnlocked = true;
      _unlockingMission2 = true;
      _showUnlockBanner = true;
    });

    HapticFeedback.heavyImpact();

    // ===========================================================
    // DEJAMOS CORRER LA ANIMACIÓN
    // ===========================================================

    await Future.delayed(
      const Duration(
        milliseconds: 1900,
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _unlockingMission2 = false;
    });

    // ===========================================================
    // EL MENSAJE QUEDA UN POCO MÁS
    // ===========================================================

    await Future.delayed(
      const Duration(
        milliseconds: 1000,
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _showUnlockBanner = false;
    });
  }

}

// =====================================================================
// ESTADOS
// =====================================================================

enum MissionStatus {
  completed,
  available,
  locked,
}

// =====================================================================
// MODELO
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
      shape: const CircleBorder(),
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
      shape: const CircleBorder(),
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
// AVISO NUEVA MISIÓN
// =====================================================================

class _UnlockBanner
    extends StatelessWidget {
  const _UnlockBanner();

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color:
            Colors.white.withValues(
          alpha: 0.97,
        ),
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color:
              const Color(0xFFFFD23F),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(
              alpha: 0.16,
            ),
            blurRadius: 15,
            offset:
                const Offset(
              0,
              5,
            ),
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_open_rounded,
            color:
                Color(0xFF59B83A),
            size: 26,
          ),

          SizedBox(width: 8),

          Flexible(
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                Text(
                  '¡Nueva misión desbloqueada!',
                  textAlign:
                      TextAlign.center,
                  style: TextStyle(
                    color:
                        Color(
                      0xFF236B3A,
                    ),
                    fontSize: 13,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),

                SizedBox(height: 2),

                Text(
                  'Ahorra agua',
                  textAlign:
                      TextAlign.center,
                  style: TextStyle(
                    color:
                        Color(
                      0xFF3BAEEB,
                    ),
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 7),

          Icon(
            Icons.auto_awesome_rounded,
            color:
                Color(0xFFFFD23F),
            size: 23,
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// NODO DE MISIÓN
// =====================================================================

class MissionNode
    extends StatefulWidget {
  final MissionData mission;

  final VoidCallback onTap;

  final bool animateUnlock;

  const MissionNode({
    super.key,
    required this.mission,
    required this.onTap,
    this.animateUnlock = false,
  });

  @override
  State<MissionNode> createState() =>
      _MissionNodeState();
}

class _MissionNodeState
    extends State<MissionNode>
    with
        SingleTickerProviderStateMixin {
  late final AnimationController
      _unlockController;

  late final Animation<double>
      _scaleAnimation;

  late final Animation<double>
      _glowAnimation;

  // =============================================================
  // INIT
  // =============================================================

  @override
  void initState() {
    super.initState();

    _unlockController =
        AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1100,
      ),
      value: 1,
    );

    _scaleAnimation =
        Tween<double>(
      begin: 0.70,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent:
            _unlockController,
        curve:
            Curves.elasticOut,
      ),
    );

    _glowAnimation =
        TweenSequence<double>(
      [
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 0,
            end: 1,
          ).chain(
            CurveTween(
              curve:
                  Curves.easeOut,
            ),
          ),
          weight: 40,
        ),
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 1,
            end: 0,
          ).chain(
            CurveTween(
              curve:
                  Curves.easeIn,
            ),
          ),
          weight: 60,
        ),
      ],
    ).animate(
      _unlockController,
    );
  }

  // =============================================================
  // DETECTAR DESBLOQUEO
  // =============================================================

  @override
  void didUpdateWidget(
    covariant MissionNode oldWidget,
  ) {
    super.didUpdateWidget(
      oldWidget,
    );

    if (widget.animateUnlock &&
        !oldWidget.animateUnlock) {
      _unlockController.forward(
        from: 0,
      );
    }
  }

  // =============================================================
  // DISPOSE
  // =============================================================

  @override
  void dispose() {
    _unlockController.dispose();

    super.dispose();
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    final locked =
        widget.mission.status ==
            MissionStatus.locked;

    final completed =
        widget.mission.status ==
            MissionStatus.completed;

    return AnimatedBuilder(
      animation:
          _unlockController,
      builder: (
        context,
        child,
      ) {
        final scale =
            _scaleAnimation.value;

        final glow =
            _glowAnimation.value;

        return Transform.scale(
          scale: scale,
          child: Stack(
            clipBehavior:
                Clip.none,
            alignment:
                Alignment.center,
            children: [
              GestureDetector(
                onTap:
                    widget.onTap,
                child: SizedBox(
                  width: 116,
                  child: Column(
                    mainAxisSize:
                        MainAxisSize
                            .min,
                    children: [
                      // =========================================
                      // ICONO
                      // =========================================

                      AnimatedContainer(
                        duration:
                            const Duration(
                          milliseconds:
                              450,
                        ),
                        width: 66,
                        height: 66,
                        decoration:
                            BoxDecoration(
                          color:
                              Colors.white
                                  .withValues(
                            alpha: 0.97,
                          ),
                          shape:
                              BoxShape
                                  .circle,

                          border:
                              Border.all(
                            color: widget
                                    .animateUnlock
                                ? const Color(
                                    0xFFFFD23F,
                                  )
                                : locked
                                    ? const Color(
                                        0xFFC6D0D5,
                                      )
                                    : const Color(
                                        0xFFE8D786,
                                      ),
                            width: widget
                                    .animateUnlock
                                ? 4
                                : 3,
                          ),

                          boxShadow: [
                            BoxShadow(
                              color: widget
                                      .animateUnlock
                                  ? const Color(
                                      0xFFFFD23F,
                                    ).withValues(
                                      alpha:
                                          0.15 +
                                              (glow *
                                                  0.55),
                                    )
                                  : Colors
                                      .black
                                      .withValues(
                                      alpha:
                                          0.17,
                                    ),
                              blurRadius: widget
                                      .animateUnlock
                                  ? 10 +
                                      (glow *
                                          18)
                                  : 9,
                              spreadRadius:
                                  widget
                                          .animateUnlock
                                      ? glow *
                                          5
                                      : 0,
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
                              Alignment
                                  .center,
                          children: [
                            // =====================================
                            // CÍRCULO INTERIOR
                            // =====================================

                            AnimatedContainer(
                              duration:
                                  const Duration(
                                milliseconds:
                                    450,
                              ),
                              width: 52,
                              height: 52,
                              decoration:
                                  BoxDecoration(
                                shape:
                                    BoxShape
                                        .circle,
                                color: locked
                                    ? const Color(
                                        0xFFE8EEF1,
                                      )
                                    : const Color(
                                        0xFFF4FBEF,
                                      ),
                              ),
                              child: Icon(
                                widget
                                    .mission
                                    .icon,
                                size: 30,
                                color: locked
                                    ? const Color(
                                        0xFF9CAEB7,
                                      )
                                    : _missionColor(
                                        widget
                                            .mission,
                                      ),
                              ),
                            ),

                            // =====================================
                            // CANDADO / CHECK
                            // =====================================

                            Positioned(
                              right: 0,
                              bottom: 0,
                              child:
                                  AnimatedSwitcher(
                                duration:
                                    const Duration(
                                  milliseconds:
                                      450,
                                ),
                                transitionBuilder:
                                    (
                                  child,
                                  animation,
                                ) {
                                  return ScaleTransition(
                                    scale:
                                        animation,
                                    child:
                                        FadeTransition(
                                      opacity:
                                          animation,
                                      child:
                                          child,
                                    ),
                                  );
                                },
                                child: locked
                                    ? Container(
                                        key:
                                            const ValueKey(
                                          'locked',
                                        ),
                                        width:
                                            22,
                                        height:
                                            22,
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
                                          size:
                                              13,
                                        ),
                                      )
                                    : completed
                                        ? Container(
                                            key:
                                                const ValueKey(
                                              'completed',
                                            ),
                                            width:
                                                22,
                                            height:
                                                22,
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
                                              size:
                                                  14,
                                            ),
                                          )
                                        : const SizedBox(
                                            key:
                                                ValueKey(
                                              'unlocked',
                                            ),
                                            width:
                                                22,
                                            height:
                                                22,
                                          ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      // =========================================
                      // TARJETA
                      // =========================================

                      AnimatedContainer(
                        duration:
                            const Duration(
                          milliseconds:
                              450,
                        ),
                        width:
                            double.infinity,
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 7,
                          vertical: 6,
                        ),
                        decoration:
                            BoxDecoration(
                          color:
                              Colors.white
                                  .withValues(
                            alpha: 0.93,
                          ),
                          borderRadius:
                              BorderRadius
                                  .circular(
                            14,
                          ),
                          border:
                              Border.all(
                            color: widget
                                    .animateUnlock
                                ? const Color(
                                    0xFFFFD23F,
                                  )
                                : locked
                                    ? const Color(
                                        0xFFD6DEE2,
                                      )
                                    : const Color(
                                        0xFFDDE9D3,
                                      ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black
                                      .withValues(
                                alpha:
                                    0.08,
                              ),
                              blurRadius:
                                  6,
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
                              MainAxisSize
                                  .min,
                          children: [
                            Text(
                              widget
                                  .mission
                                  .title,
                              textAlign:
                                  TextAlign
                                      .center,
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
                                fontSize:
                                    10,
                                height:
                                    1.1,
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
                                  size:
                                      18,
                                ),

                                const SizedBox(
                                  width: 2,
                                ),

                                Text(
                                  '+${widget.mission.reward}',
                                  style:
                                      TextStyle(
                                    color: locked
                                        ? const Color(
                                            0xFF9AA6AC,
                                          )
                                        : const Color(
                                            0xFF6B5200,
                                          ),
                                    fontSize:
                                        10,
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
              ),

              // ===============================================
              // DESTELLOS
              // ===============================================

              if (widget
                  .animateUnlock) ...[
                Positioned(
                  top: -18,
                  right: 4,
                  child: Transform.scale(
                    scale:
                        0.8 +
                            (glow *
                                0.4),
                    child:
                        const Icon(
                      Icons
                          .auto_awesome_rounded,
                      color:
                          Color(
                        0xFFFFD23F,
                      ),
                      size: 25,
                    ),
                  ),
                ),

                Positioned(
                  top: 17,
                  left: -12,
                  child: Transform.scale(
                    scale:
                        0.7 +
                            (glow *
                                0.4),
                    child:
                        const Icon(
                      Icons.star_rounded,
                      color:
                          Color(
                        0xFFFFE27A,
                      ),
                      size: 18,
                    ),
                  ),
                ),

                Positioned(
                  right: -9,
                  bottom: 21,
                  child: Transform.scale(
                    scale:
                        0.7 +
                            (glow *
                                0.4),
                    child:
                        const Icon(
                      Icons
                          .auto_awesome_rounded,
                      color:
                          Color(
                        0xFF8FD14F,
                      ),
                      size: 19,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  // =============================================================
  // COLOR DE MISIÓN
  // =============================================================

  Color _missionColor(
    MissionData mission,
  ) {
    if (mission.icon ==
        Icons.local_florist_rounded) {
      return const Color(
        0xFF59B83A,
      );
    }

    if (mission.icon ==
        Icons.water_drop_rounded) {
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
        Icons.directions_bike_rounded) {
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
        color:
            Colors.white.withValues(
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
              icon: Icons
                  .sports_esports_rounded,
              label: 'Juegos',
            ),

            const _NavItem(
              icon: Icons
                  .menu_book_rounded,
              label: 'Aprender',
            ),

            const _NavItem(
              icon: Icons
                  .emoji_events_rounded,
              label: 'Logros',
            ),

            const _NavItem(
              icon: Icons
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
// ITEM DE NAVEGACIÓN
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
                    FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}