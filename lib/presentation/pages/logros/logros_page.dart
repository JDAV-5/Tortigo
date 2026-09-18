import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../data/services/current_user_service.dart';

import '../torti_chat/torti_chat_page.dart';

class LogrosPage extends StatelessWidget {
  const LogrosPage({
    super.key,
  });

  // ===================================================================
  // CONFIGURACIÓN DE MEDALLAS
  // ===================================================================

  static const int _sembradorCost = 90;

  // ===================================================================
  // OBTENER MEDALLAS DEL USUARIO ACTUAL
  // ===================================================================

  List<String> _getOwnedMedals(
    CurrentUserService currentUserService,
  ) {
    final Map<String, dynamic>? user =
        currentUserService.currentUser;

    if (user == null) {
      return <String>[];
    }

    final dynamic rawOwnedMedals =
        user['ownedMedals'];

    if (rawOwnedMedals is! List) {
      return <String>[];
    }

    return rawOwnedMedals
        .map(
          (dynamic item) =>
              item.toString(),
        )
        .toList();
  }

  // ===================================================================
  // VERIFICAR SI EL USUARIO TIENE UNA MEDALLA
  // ===================================================================

  bool _ownsMedal(
    CurrentUserService currentUserService,
    String medalId,
  ) {
    return _getOwnedMedals(
      currentUserService,
    ).contains(
      medalId,
    );
  }

  // ===================================================================
  // COMPRAR MEDALLA SEMBRADOR
  // ===================================================================

  Future<void> _buySembrador(
    BuildContext context,
    CurrentUserService currentUserService,
  ) async {
    // ================================================================
    // VALIDAR USUARIO
    // ================================================================

    if (!currentUserService.hasUser) {
      return;
    }

    // ================================================================
    // YA TIENE LA MEDALLA
    // ================================================================

    if (_ownsMedal(
      currentUserService,
      'sembrador',
    )) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'Ya tienes la medalla Sembrador. 🌱',
            ),
          ),
        );

      return;
    }

    // ================================================================
    // NO TIENE SUFICIENTES ESTRELLAS
    // ================================================================

    if (currentUserService.stars <
        _sembradorCost) {
      final int missing =
          _sembradorCost -
              currentUserService.stars;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              'Te faltan $missing estrellas para conseguir Sembrador. ⭐',
            ),
          ),
        );

      return;
    }

    // ================================================================
    // CONFIRMACIÓN
    // ================================================================

    final bool? confirmed =
        await showDialog<bool>(
      context:
          context,
      builder: (
        BuildContext dialogContext,
      ) {
        return AlertDialog(
          backgroundColor:
              Colors.white,
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              24,
            ),
          ),
          title:
              const Row(
            children: [
              Text(
                '🌱',
                style:
                    TextStyle(
                  fontSize:
                      30,
                ),
              ),
              SizedBox(
                width:
                    10,
              ),
              Expanded(
                child:
                    Text(
                  'Medalla Sembrador',
                  style:
                      TextStyle(
                    color:
                        Color(
                      0xFF236B3A,
                    ),
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          content:
              const Text(
            '¿Quieres comprar la medalla Sembrador por 90 estrellas?\n\n'
            'Tus estrellas se descontarán y la medalla quedará desbloqueada en tu perfil.',
            style:
                TextStyle(
              color:
                  Color(
                0xFF59666D,
              ),
              height:
                  1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed:
                  () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child:
                  const Text(
                'Cancelar',
              ),
            ),
            ElevatedButton.icon(
              onPressed:
                  () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              icon:
                  const Icon(
                Icons.star_rounded,
              ),
              label:
                  const Text(
                'Comprar 90',
              ),
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(
                  0xFF45A049,
                ),
                foregroundColor:
                    Colors.white,
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    if (!context.mounted) {
      return;
    }

    // ================================================================
    // VOLVER A VALIDAR LAS ESTRELLAS
    // ================================================================

    if (currentUserService.stars <
        _sembradorCost) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'No tienes suficientes estrellas.',
            ),
          ),
        );

      return;
    }

    // ================================================================
    // DESCONTAR ESTRELLAS
    // ================================================================

    final int newStars =
        currentUserService.stars -
            _sembradorCost;

    currentUserService.updateCurrentUser(
      <String, dynamic>{
        'stars':
            newStars,
      },
    );

    // ================================================================
    // GUARDAR MEDALLA EN EL USUARIO ACTUAL
    // ================================================================

    final List<String> ownedMedals =
        _getOwnedMedals(
      currentUserService,
    );

    if (!ownedMedals.contains(
      'sembrador',
    )) {
      ownedMedals.add(
        'sembrador',
      );
    }

    currentUserService.updateCurrentUser(
      <String, dynamic>{
        'ownedMedals':
            ownedMedals,
      },
    );

    if (!context.mounted) {
      return;
    }

    HapticFeedback.mediumImpact();

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(
            '¡Felicidades! 🌱 Has conseguido la medalla Sembrador.',
          ),
        ),
      );
  }

  // ===================================================================
  // BUILD
  // ===================================================================

  @override
  Widget build(BuildContext context) {
    final CurrentUserService currentUserService =
        CurrentUserService.instance;

    return AnimatedBuilder(
      animation:
          currentUserService,

      builder:
          (
        context,
        child,
      ) {
        // =============================================================
        // SIN USUARIO AUTENTICADO
        // =============================================================

        if (!currentUserService.hasUser) {
          return Scaffold(
            backgroundColor:
                const Color(
              0xFF236B3A,
            ),

            body:
                Center(
              child:
                  ElevatedButton(
                onPressed:
                    () {
                  Navigator
                      .pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (
                      route,
                    ) =>
                        false,
                  );
                },
                child:
                    const Text(
                  'Seleccionar perfil',
                ),
              ),
            ),
          );
        }

        // =============================================================
        // DATOS DEL USUARIO AUTENTICADO
        // =============================================================

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

        // =============================================================
        // MEDALLA SEMBRADOR
        // =============================================================

        const int sembradorCost =
            _sembradorCost;

        final bool ownsSembrador =
            _ownsMedal(
          currentUserService,
          'sembrador',
        );

        final int missingStars =
            stars >=
                    sembradorCost
                ? 0
                : sembradorCost -
                    stars;

        final double sembradorProgress =
            ownsSembrador
                ? 1.0
                : (stars /
                        sembradorCost)
                    .clamp(
                      0.0,
                      1.0,
                    )
                    .toDouble();

        final int progressPercent =
            (sembradorProgress *
                    100)
                .round();

        // =============================================================
        // MEDALLAS
        // =============================================================
        //
        // Solamente conocemos todavía el precio real de Sembrador.
        //
        // Las demás permanecen bloqueadas hasta que definamos
        // sus precios y condiciones.
        // =============================================================

        final achievements =
            <AchievementData>[
          AchievementData(
            id:
                'sembrador',
            title:
                'Sembrador',
            icon:
                Icons.eco_rounded,
            unlocked:
                ownsSembrador,
          ),

          const AchievementData(
            id:
                'cuidador_agua',
            title:
                'Cuidador\ndel agua',
            icon:
                Icons.water_drop_rounded,
            unlocked:
                false,
          ),

          const AchievementData(
            id:
                'reciclador',
            title:
                'Reciclador',
            icon:
                Icons.recycling_rounded,
            unlocked:
                false,
          ),

          const AchievementData(
            id:
                'energia_limpia',
            title:
                'Energía\nlimpia',
            icon:
                Icons.wb_sunny_rounded,
            unlocked:
                false,
          ),

          const AchievementData(
            id:
                'transporte_verde',
            title:
                'Transporte\nverde',
            icon:
                Icons.pedal_bike_rounded,
            unlocked:
                false,
          ),

          const AchievementData(
            id:
                'amigo_arboles',
            title:
                'Amigo de\nlos árboles',
            icon:
                Icons.park_rounded,
            unlocked:
                false,
          ),
        ];

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
          ),

          child:
              Scaffold(
            backgroundColor:
                const Color(
              0xFF236B3A,
            ),

            // =========================================================
            // BODY
            // =========================================================

            body:
                Stack(
              fit:
                  StackFit.expand,

              children: [
                // =====================================================
                // FONDO
                // =====================================================

                Image.asset(
                  'assets/images/fondo3.png',
                  fit:
                      BoxFit.cover,
                  alignment:
                      Alignment.center,
                ),

                Container(
                  color:
                      Colors.black
                          .withValues(
                    alpha:
                        0.05,
                  ),
                ),

                // =====================================================
                // CONTENIDO
                // =====================================================

                SafeArea(
                  bottom:
                      false,

                  child:
                      SingleChildScrollView(
                    padding:
                        const EdgeInsets
                            .fromLTRB(
                      18,
                      10,
                      18,
                      24,
                    ),

                    child:
                        Column(
                      children: [
                        // =============================================
                        // CABECERA
                        // =============================================

                        Row(
                          children: [
                            _CircleButton(
                              icon:
                                  Icons
                                      .arrow_back_rounded,

                              onTap:
                                  () {
                                HapticFeedback
                                    .selectionClick();

                                Navigator.pop(
                                  context,
                                );
                              },
                            ),

                            const Expanded(
                              child:
                                  Column(
                                children: [
                                  Text(
                                    'Logros',
                                    style:
                                        TextStyle(
                                      color:
                                          Color(
                                        0xFFFFD23F,
                                      ),
                                      fontSize:
                                          33,
                                      fontWeight:
                                          FontWeight
                                              .w900,
                                      shadows: [
                                        Shadow(
                                          color:
                                              Colors.black26,
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
                                    'Sigue aprendiendo y cuidando nuestro planeta',
                                    textAlign:
                                        TextAlign.center,
                                    style:
                                        TextStyle(
                                      color:
                                          Colors.white,
                                      fontSize:
                                          11,
                                      fontWeight:
                                          FontWeight
                                              .w600,
                                      shadows: [
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

                            const SizedBox(
                              width:
                                  42,
                            ),
                          ],
                        ),

                        const SizedBox(
                          height:
                              16,
                        ),

                        // =============================================
                        // PERFIL ACTIVO
                        // =============================================

                        Container(
                          width:
                              double.infinity,

                          padding:
                              const EdgeInsets
                                  .symmetric(
                            horizontal:
                                16,
                            vertical:
                                12,
                          ),

                          decoration:
                              BoxDecoration(
                            color: Colors
                                .white
                                .withValues(
                              alpha:
                                  0.95,
                            ),

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
                              ).withValues(
                                alpha:
                                    0.45,
                              ),
                            ),

                            boxShadow: [
                              BoxShadow(
                                color: Colors
                                    .black
                                    .withValues(
                                  alpha:
                                      0.10,
                                ),
                                blurRadius:
                                    12,
                                offset:
                                    const Offset(
                                  0,
                                  4,
                                ),
                              ),
                            ],
                          ),

                          child:
                              Row(
                            children: [
                              // =========================================
                              // AVATAR REAL
                              // =========================================

                              Container(
                                width:
                                    54,
                                height:
                                    54,

                                decoration:
                                    BoxDecoration(
                                  color:
                                      const Color(
                                    0xFFE7F7D8,
                                  ),

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
                                ),

                                alignment:
                                    Alignment.center,

                                child:
                                    Text(
                                  avatar,

                                  style:
                                      const TextStyle(
                                    fontSize:
                                        29,
                                  ),
                                ),
                              ),

                              const SizedBox(
                                width:
                                    12,
                              ),

                              // =========================================
                              // NOMBRE
                              // =========================================

                              Expanded(
                                child:
                                    Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,

                                  children: [
                                    Text(
                                      playerName,

                                      style:
                                          const TextStyle(
                                        color:
                                            Color(
                                          0xFF236B3A,
                                        ),
                                        fontSize:
                                            19,
                                        fontWeight:
                                            FontWeight
                                                .w800,
                                      ),
                                    ),

                                    const SizedBox(
                                      height:
                                          2,
                                    ),

                                    const Text(
                                      'Explorador ecológico',

                                      style:
                                          TextStyle(
                                        color:
                                            Color(
                                          0xFF718089,
                                        ),
                                        fontSize:
                                            12,
                                        fontWeight:
                                            FontWeight
                                                .w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal:
                                      11,
                                  vertical:
                                      7,
                                ),

                                decoration:
                                    BoxDecoration(
                                  color:
                                      const Color(
                                    0xFFFFF5D8,
                                  ),
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    16,
                                  ),
                                ),

                                child:
                                    Icon(
                                  ownsSembrador
                                      ? Icons
                                          .emoji_events_rounded
                                      : Icons
                                          .lock_outline_rounded,

                                  color:
                                      ownsSembrador
                                          ? const Color(
                                              0xFFE8A700,
                                            )
                                          : const Color(
                                              0xFF9B9B94,
                                            ),

                                  size:
                                      26,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height:
                              14,
                        ),

                        // =============================================
                        // ESTRELLAS REALES
                        // =============================================

                        Container(
                          width:
                              double.infinity,

                          padding:
                              const EdgeInsets
                                  .symmetric(
                            horizontal:
                                22,
                            vertical:
                                17,
                          ),

                          decoration:
                              BoxDecoration(
                            color:
                                Colors.white,

                            borderRadius:
                                BorderRadius
                                    .circular(
                              24,
                            ),

                            boxShadow: [
                              BoxShadow(
                                color: Colors
                                    .black
                                    .withValues(
                                  alpha:
                                      0.12,
                                ),
                                blurRadius:
                                    14,
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
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .center,

                            children: [
                              const Icon(
                                Icons
                                    .star_rounded,

                                color:
                                    Color(
                                  0xFFFFB300,
                                ),

                                size:
                                    67,

                                shadows: [
                                  Shadow(
                                    color:
                                        Colors.black12,
                                    blurRadius:
                                        3,
                                    offset:
                                        Offset(
                                      0,
                                      2,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                width:
                                    18,
                              ),

                              Column(
                                children: [
                                  const Text(
                                    'Estrellas disponibles',

                                    style:
                                        TextStyle(
                                      color:
                                          Color(
                                        0xFF236B3A,
                                      ),
                                      fontSize:
                                          15,
                                      fontWeight:
                                          FontWeight
                                              .w700,
                                    ),
                                  ),

                                  Text(
                                    '$stars',

                                    style:
                                        const TextStyle(
                                      color:
                                          Color(
                                        0xFF1B6C2D,
                                      ),
                                      fontSize:
                                          38,
                                      height:
                                          1,
                                      fontWeight:
                                          FontWeight
                                              .w900,
                                    ),
                                  ),

                                  const SizedBox(
                                    height:
                                        3,
                                  ),

                                  const Text(
                                    'Úsalas para conseguir medallas',

                                    style:
                                        TextStyle(
                                      color:
                                          Color(
                                        0xFF45A049,
                                      ),
                                      fontSize:
                                          10,
                                      fontWeight:
                                          FontWeight
                                              .w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height:
                              14,
                        ),

                        // =============================================
                        // MEDALLAS
                        // =============================================

                        Container(
                          width:
                              double.infinity,

                          padding:
                              const EdgeInsets
                                  .fromLTRB(
                            14,
                            17,
                            14,
                            18,
                          ),

                          decoration:
                              BoxDecoration(
                            color: Colors
                                .white
                                .withValues(
                              alpha:
                                  0.96,
                            ),

                            borderRadius:
                                BorderRadius
                                    .circular(
                              24,
                            ),

                            boxShadow: [
                              BoxShadow(
                                color: Colors
                                    .black
                                    .withValues(
                                  alpha:
                                      0.12,
                                ),
                                blurRadius:
                                    14,
                                offset:
                                    const Offset(
                                  0,
                                  5,
                                ),
                              ),
                            ],
                          ),

                          child:
                              Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [
                              Container(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal:
                                      15,
                                  vertical:
                                      6,
                                ),

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
                                ),

                                child:
                                    const Text(
                                  'Medallas',

                                  style:
                                      TextStyle(
                                    color:
                                        Colors.white,
                                    fontSize:
                                        12,
                                    fontWeight:
                                        FontWeight
                                            .w800,
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height:
                                    6,
                              ),

                              const Text(
                                'Todas comienzan bloqueadas. Consíguelas usando tus estrellas.',

                                style:
                                    TextStyle(
                                  color:
                                      Color(
                                    0xFF718089,
                                  ),
                                  fontSize:
                                      10,
                                ),
                              ),

                              const SizedBox(
                                height:
                                    15,
                              ),

                              GridView.builder(
                                shrinkWrap:
                                    true,

                                physics:
                                    const NeverScrollableScrollPhysics(),

                                itemCount:
                                    achievements
                                        .length,

                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      3,
                                  crossAxisSpacing:
                                      7,
                                  mainAxisSpacing:
                                      16,
                                  childAspectRatio:
                                      0.75,
                                ),

                                itemBuilder:
                                    (
                                  context,
                                  index,
                                ) {
                                  return _AchievementBadge(
                                    achievement:
                                        achievements[
                                            index],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height:
                              14,
                        ),

                        // =============================================
                        // SEMBRADOR
                        // =============================================

                        Container(
                          width:
                              double.infinity,

                          padding:
                              const EdgeInsets
                                  .all(
                            16,
                          ),

                          decoration:
                              BoxDecoration(
                            color: Colors
                                .white
                                .withValues(
                              alpha:
                                  0.97,
                            ),

                            borderRadius:
                                BorderRadius
                                    .circular(
                              24,
                            ),

                            boxShadow: [
                              BoxShadow(
                                color: Colors
                                    .black
                                    .withValues(
                                  alpha:
                                      0.12,
                                ),
                                blurRadius:
                                    14,
                                offset:
                                    const Offset(
                                  0,
                                  5,
                                ),
                              ),
                            ],
                          ),

                          child:
                              Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [
                              // =========================================
                              // TÍTULO
                              // =========================================

                              Container(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal:
                                      12,
                                  vertical:
                                      5,
                                ),

                                decoration:
                                    BoxDecoration(
                                  color:
                                      ownsSembrador
                                          ? const Color(
                                              0xFF45A049,
                                            )
                                          : const Color(
                                              0xFF318CB8,
                                            ),

                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    12,
                                  ),
                                ),

                                child:
                                    Text(
                                  ownsSembrador
                                      ? 'Medalla conseguida'
                                      : 'Primera medalla',

                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.white,
                                    fontSize:
                                        10,
                                    fontWeight:
                                        FontWeight
                                            .w700,
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height:
                                    12,
                              ),

                              Row(
                                children: [
                                  // =====================================
                                  // ICONO
                                  // =====================================

                                  Container(
                                    width:
                                        69,
                                    height:
                                        69,

                                    decoration:
                                        BoxDecoration(
                                      color:
                                          ownsSembrador
                                              ? const Color(
                                                  0xFFE7F7D8,
                                                )
                                              : const Color(
                                                  0xFFF1F1EB,
                                                ),

                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        18,
                                      ),
                                    ),

                                    child:
                                        Icon(
                                      Icons
                                          .eco_rounded,

                                      color:
                                          ownsSembrador
                                              ? const Color(
                                                  0xFF45A049,
                                                )
                                              : const Color(
                                                  0xFFB7B7B0,
                                                ),

                                      size:
                                          48,
                                    ),
                                  ),

                                  const SizedBox(
                                    width:
                                        12,
                                  ),

                                  // =====================================
                                  // INFORMACIÓN
                                  // =====================================

                                  Expanded(
                                    child:
                                        Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,

                                      children: [
                                        const Text(
                                          'Sembrador',

                                          style:
                                              TextStyle(
                                            color:
                                                Color(
                                              0xFF236B3A,
                                            ),
                                            fontSize:
                                                17,
                                            fontWeight:
                                                FontWeight
                                                    .w800,
                                          ),
                                        ),

                                        const SizedBox(
                                          height:
                                              3,
                                        ),

                                        Row(
                                          children: [
                                            const Icon(
                                              Icons
                                                  .star_rounded,
                                              color:
                                                  Color(
                                                0xFFFFB300,
                                              ),
                                              size:
                                                  18,
                                            ),

                                            const SizedBox(
                                              width:
                                                  3,
                                            ),

                                            Text(
                                              '$sembradorCost estrellas',

                                              style:
                                                  const TextStyle(
                                                color:
                                                    Color(
                                                  0xFF59666D,
                                                ),
                                                fontSize:
                                                    11,
                                                fontWeight:
                                                    FontWeight
                                                        .w700,
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(
                                          height:
                                              9,
                                        ),

                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius
                                                  .circular(
                                            20,
                                          ),

                                          child:
                                              LinearProgressIndicator(
                                            value:
                                                sembradorProgress,

                                            minHeight:
                                                10,

                                            backgroundColor:
                                                const Color(
                                              0xFFE0E0E0,
                                            ),

                                            valueColor:
                                                const AlwaysStoppedAnimation<
                                                    Color>(
                                              Color(
                                                0xFF45A049,
                                              ),
                                            ),
                                          ),
                                        ),

                                        const SizedBox(
                                          height:
                                              5,
                                        ),

                                        Text(
                                          ownsSembrador
                                              ? '¡Ya eres Sembrador! 🌱'
                                              : '$progressPercent% · Te faltan $missingStars ⭐',

                                          style:
                                              const TextStyle(
                                            color:
                                                Color(
                                              0xFF718089,
                                            ),
                                            fontSize:
                                                10,
                                            fontWeight:
                                                FontWeight
                                                    .w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height:
                                    15,
                              ),

                              // =========================================
                              // BOTÓN COMPRAR
                              // =========================================

                              SizedBox(
                                width:
                                    double.infinity,

                                height:
                                    48,

                                child:
                                    ElevatedButton.icon(
                                  onPressed:
                                      ownsSembrador
                                          ? null
                                          : () {
                                              _buySembrador(
                                                context,
                                                currentUserService,
                                              );
                                            },

                                  icon:
                                      Icon(
                                    ownsSembrador
                                        ? Icons
                                            .check_circle_rounded
                                        : stars >=
                                                sembradorCost
                                            ? Icons
                                                .shopping_cart_rounded
                                            : Icons
                                                .lock_rounded,
                                  ),

                                  label:
                                      Text(
                                    ownsSembrador
                                        ? 'Medalla desbloqueada'
                                        : stars >=
                                                sembradorCost
                                            ? 'Comprar por $sembradorCost ⭐'
                                            : 'Necesitas $sembradorCost ⭐',
                                  ),

                                  style:
                                      ElevatedButton
                                          .styleFrom(
                                    backgroundColor:
                                        const Color(
                                      0xFF45A049,
                                    ),

                                    foregroundColor:
                                        Colors.white,

                                    disabledBackgroundColor:
                                        ownsSembrador
                                            ? const Color(
                                                0xFF8ACB72,
                                              )
                                            : const Color(
                                                0xFFD6DDD2,
                                              ),

                                    disabledForegroundColor:
                                        ownsSembrador
                                            ? Colors.white
                                            : const Color(
                                                0xFF7B878D,
                                              ),

                                    shape:
                                        RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height:
                              15,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // =========================================================
            // BARRA INFERIOR
            // =========================================================

            bottomNavigationBar:
                Container(
              margin:
                  const EdgeInsets
                      .fromLTRB(
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
                    BorderRadius
                        .circular(
                  20,
                ),

                boxShadow: [
                  BoxShadow(
                    color: Colors
                        .black
                        .withValues(
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
                        MainAxisAlignment
                            .spaceAround,

                    children: [
                      // ===============================================
                      // INICIO
                      // ===============================================

                      _BottomNavItem(
                        icon:
                            Icons.home_rounded,

                        label:
                            'Inicio',

                        onTap:
                            () {
                          HapticFeedback
                              .selectionClick();

                          Navigator.pop(
                            context,
                          );
                        },
                      ),

                      // ===============================================
                      // JUEGOS
                      // ===============================================

                      _BottomNavItem(
                        icon: Icons
                            .sports_esports_rounded,

                        label:
                            'Juegos',

                        onTap:
                            () {
                          HapticFeedback
                              .selectionClick();

                          debugPrint(
                            'Juegos',
                          );
                        },
                      ),

                      // ===============================================
                      // APRENDE
                      // ===============================================

                      _BottomNavItem(
                        icon: Icons
                            .menu_book_rounded,

                        label:
                            'Aprende',

                        onTap:
                            () {
                          HapticFeedback
                              .selectionClick();

                          debugPrint(
                            'Aprende',
                          );
                        },
                      ),

                      // ===============================================
                      // LOGROS
                      // ===============================================

                      const _BottomNavItem(
                        icon: Icons
                            .emoji_events_rounded,

                        label:
                            'Logros',

                        selected:
                            true,
                      ),

                      // ===============================================
                      // TORTI
                      // ===============================================

                      _BottomNavItem(
                        icon: Icons
                            .chat_bubble_rounded,

                        label:
                            'Torti',

                        onTap:
                            () {
                          HapticFeedback
                              .selectionClick();

                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder:
                                  (
                                context,
                              ) {
                                return TortiChatPage(
                                  playerName:
                                      playerName,
                                );
                              },
                            ),
                          );
                        },
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
// DATOS VISUALES DE MEDALLA
// =====================================================================

class AchievementData {
  final String id;

  final String title;

  final IconData icon;

  final bool unlocked;

  const AchievementData({
    required this.id,
    required this.title,
    required this.icon,
    required this.unlocked,
  });
}

// =====================================================================
// MEDALLA
// =====================================================================

class _AchievementBadge
    extends StatelessWidget {
  final AchievementData achievement;

  const _AchievementBadge({
    required this.achievement,
  });

  @override
  Widget build(BuildContext context) {
    final unlocked =
        achievement.unlocked;

    return Column(
      mainAxisAlignment:
          MainAxisAlignment.start,

      children: [
        Stack(
          clipBehavior:
              Clip.none,

          children: [
            Container(
              width:
                  58,

              height:
                  58,

              decoration:
                  BoxDecoration(
                color:
                    unlocked
                        ? const Color(
                            0xFF8CD73F,
                          )
                        : const Color(
                            0xFFF1F1EB,
                          ),

                shape:
                    BoxShape.circle,

                border:
                    Border.all(
                  color:
                      unlocked
                          ? const Color(
                              0xFF45A049,
                            )
                          : const Color(
                              0xFFD7D7CE,
                            ),

                  width:
                      2,
                ),
              ),

              child:
                  Icon(
                achievement.icon,

                color:
                    unlocked
                        ? const Color(
                            0xFF236B3A,
                          )
                        : const Color(
                            0xFFD0D0C7,
                          ),

                size:
                    31,
              ),
            ),

            if (unlocked)
              Positioned(
                right:
                    -2,

                bottom:
                    -2,

                child:
                    Container(
                  width:
                      19,

                  height:
                      19,

                  decoration:
                      const BoxDecoration(
                    color:
                        Color(
                      0xFF45A049,
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
                ),
              ),

            if (!unlocked)
              Positioned(
                right:
                    -1,

                bottom:
                    -2,

                child:
                    Container(
                  width:
                      19,

                  height:
                      19,

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
                        0xFFD3D3CC,
                      ),
                    ),
                  ),

                  child:
                      const Icon(
                    Icons
                        .lock_rounded,

                    color:
                        Color(
                      0xFFB7B7B0,
                    ),

                    size:
                        12,
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(
          height:
              7,
        ),

        Text(
          achievement.title,

          textAlign:
              TextAlign.center,

          maxLines:
              2,

          style:
              TextStyle(
            color:
                unlocked
                    ? const Color(
                        0xFF236B3A,
                      )
                    : const Color(
                        0xFFB1B1AA,
                      ),

            fontSize:
                9,

            height:
                1.1,

            fontWeight:
                unlocked
                    ? FontWeight.w700
                    : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// =====================================================================
// BOTÓN CIRCULAR
// =====================================================================

class _CircleButton
    extends StatelessWidget {
  final IconData icon;

  final VoidCallback onTap;

  const _CircleButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color:
          const Color(
        0xFF45A049,
      ),

      shape:
          const CircleBorder(),

      elevation:
          4,

      child:
          InkWell(
        onTap:
            onTap,

        customBorder:
            const CircleBorder(),

        child:
            SizedBox(
          width:
              42,

          height:
              42,

          child:
              Icon(
            icon,

            color:
                Colors.white,

            size:
                26,
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// BARRA INFERIOR
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
  Widget build(BuildContext context) {
    final color =
        selected
            ? const Color(
                0xFFE8A700,
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
              const EdgeInsets
                  .symmetric(
            horizontal:
                8,

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