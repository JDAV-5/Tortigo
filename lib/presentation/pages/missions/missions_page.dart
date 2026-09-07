import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MissionsPage extends StatelessWidget {
  const MissionsPage({super.key});

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
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemStatusBarContrastEnforced: false,
      ),
      child: Scaffold(
        extendBody: true,
        backgroundColor: const Color(0xFF59B83A),

        body: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;
            final topPadding = MediaQuery.paddingOf(context).top;

            return Stack(
              fit: StackFit.expand,
              children: [
                // =====================================================
                // FONDO
                // =====================================================
                Image.asset(
                  'assets/images/missions/missions_background.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),

                // =====================================================
                // SOMBRA SUPERIOR SUAVE
                // =====================================================
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 150,
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(
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
                // LOGO / TÍTULO "MISIONES ECOLÓGICAS"
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
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),

                // =====================================================
                // MASCOTA
                //
                // La bajamos para que no choque con el botón.
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

        bottomNavigationBar: const MissionsBottomNavigation(),
      ),
    );
  }

  // =============================================================
  // ABRIR MISIÓN
  // =============================================================
  void _openMission(
    BuildContext context,
    MissionData mission,
  ) {
    if (mission.status == MissionStatus.locked) {
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

    if (mission.route != null) {
      Navigator.pushNamed(
        context,
        mission.route!,
      );

      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
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

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF59B83A),
      shape: const CircleBorder(),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
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
// TARJETA DE NIVEL
// =====================================================================

class _ProgressCard extends StatelessWidget {
  const _ProgressCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.95,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.11,
            ),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // PLANETA
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: Color(0xFFE7F4FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.public_rounded,
              color: Color(0xFF2F92E3),
              size: 23,
            ),
          ),

          const SizedBox(width: 9),

          // NIVEL
          const Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Nivel 1',
                  style: TextStyle(
                    color: Color(0xFF59A83B),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: 1),

                Text(
                  'Guardián verde',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF003D5B),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                SizedBox(height: 4),

                _ProgressBar(),
              ],
            ),
          ),

          const SizedBox(width: 6),

          // ESTRELLA
          const Icon(
            Icons.star_rounded,
            color: Color(0xFFFFD23F),
            size: 25,
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// BARRA DE PROGRESO
// =====================================================================

class _ProgressBar extends StatelessWidget {
  const _ProgressBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: const LinearProgressIndicator(
              value: 0.05,
              minHeight: 6,
              backgroundColor: Color(0xFFE5EAED),
              valueColor:
                  AlwaysStoppedAnimation<Color>(
                Color(0xFF59B83A),
              ),
            ),
          ),
        ),

        const SizedBox(width: 5),

        const Text(
          '5%',
          style: TextStyle(
            color: Color(0xFF59A83B),
            fontSize: 9,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

// =====================================================================
// NODO DE MISIÓN
// =====================================================================

class MissionNode extends StatelessWidget {
  final MissionData mission;
  final VoidCallback onTap;

  const MissionNode({
    super.key,
    required this.mission,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final locked =
        mission.status == MissionStatus.locked;

    final completed =
        mission.status == MissionStatus.completed;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 116,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // =====================================================
            // ICONO DE MISIÓN
            // =====================================================
            Container(
              width: 66,
              height: 66,
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: 0.97,
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: locked
                      ? const Color(0xFFC6D0D5)
                      : const Color(0xFFE8D786),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: 0.17,
                    ),
                    blurRadius: 9,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: locked
                          ? const Color(0xFFE8EEF1)
                          : const Color(0xFFF4FBEF),
                    ),
                    child: Icon(
                      mission.icon,
                      size: 30,
                      color: locked
                          ? const Color(0xFF9CAEB7)
                          : _missionColor(mission),
                    ),
                  ),

                  // CANDADO
                  if (locked)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration:
                            const BoxDecoration(
                          color: Color(0xFF647984),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lock_rounded,
                          color: Colors.white,
                          size: 13,
                        ),
                      ),
                    ),

                  // COMPLETADA
                  if (completed)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration:
                            const BoxDecoration(
                          color: Color(0xFF59B83A),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 5),

            // =====================================================
            // TARJETA CON INFORMACIÓN
            // =====================================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 7,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: 0.93,
                ),
                borderRadius:
                    BorderRadius.circular(14),
                border: Border.all(
                  color: locked
                      ? const Color(0xFFD6DEE2)
                      : const Color(0xFFDDE9D3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: 0.08,
                    ),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    mission.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: locked
                          ? const Color(0xFF7F8D93)
                          : const Color(0xFF2D7A3F),
                      fontSize: 10,
                      height: 1.1,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: locked
                            ? const Color(0xFFC7CED2)
                            : const Color(0xFFFFD23F),
                        size: 18,
                      ),

                      const SizedBox(width: 2),

                      Text(
                        '+${mission.reward}',
                        style: TextStyle(
                          color: locked
                              ? const Color(0xFF9AA6AC)
                              : const Color(0xFF6B5200),
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
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
        Icons.local_florist_rounded) {
      return const Color(0xFF59B83A);
    }

    if (mission.icon ==
        Icons.water_drop_rounded) {
      return const Color(0xFF3BAEEB);
    }

    if (mission.icon ==
        Icons.recycling_rounded) {
      return const Color(0xFF45A049);
    }

    if (mission.icon ==
        Icons.directions_bike_rounded) {
      return const Color(0xFF006080);
    }

    return const Color(0xFF4C82D8);
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
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        14,
        0,
        14,
        10,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.96,
        ),
        borderRadius:
            BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.15,
            ),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.home_rounded,
              label: 'Inicio',
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/home',
                );
              },
            ),

            const _NavItem(
              icon:
                  Icons.sports_esports_rounded,
              label: 'Juegos',
            ),

            const _NavItem(
              icon: Icons.menu_book_rounded,
              label: 'Aprender',
            ),

            const _NavItem(
              icon:
                  Icons.emoji_events_rounded,
              label: 'Logros',
            ),

            const _NavItem(
              icon:
                  Icons.chat_bubble_rounded,
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

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: const Color(0xFF718089),
              size: 22,
            ),

            const SizedBox(height: 2),

            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF718089),
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}