import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/player_profile.dart';

// =====================================================================
// DEFINICIÓN DE MISIÓN
// =====================================================================

class MissionDefinition {
  final String id;
  final String title;
  final int rewardStars;

  const MissionDefinition({
    required this.id,
    required this.title,
    required this.rewardStars,
  });
}

// =====================================================================
// DEFINICIÓN DE MEDALLA
// =====================================================================

class MedalDefinition {
  final String id;
  final String title;
  final int costStars;

  const MedalDefinition({
    required this.id,
    required this.title,
    required this.costStars,
  });
}

// =====================================================================
// RESULTADO AL COMPRAR MEDALLA
// =====================================================================

enum MedalPurchaseResult {
  success,
  alreadyOwned,
  insufficientStars,
  medalNotFound,
}

// =====================================================================
// SERVICIO DE PROGRESO
// =====================================================================

class PlayerProgressService
    extends ChangeNotifier {
  // ============================================================
  // SINGLETON
  // ============================================================

  PlayerProgressService._();

  static final PlayerProgressService instance =
      PlayerProgressService._();

  // ============================================================
  // CLAVES SHARED PREFERENCES
  // ============================================================

  static const String _profilesStorageKey =
      'tortigo_profiles_v1';

  static const String _activeProfileStorageKey =
      'tortigo_active_profile_v1';

  // ============================================================
  // PERFILES
  // ============================================================

  final Map<String, PlayerProfile> _profiles = {
    'ana': const PlayerProfile(
      id: 'ana',
      name: 'Ana',
      avatar: '🐢',
    ),
    'juan': const PlayerProfile(
      id: 'juan',
      name: 'Juan',
      avatar: '🦫',
    ),
    'sofia': const PlayerProfile(
      id: 'sofia',
      name: 'Sofía',
      avatar: '🐼',
    ),
  };

  String? _activeProfileId;

  bool _initialized = false;

  // ============================================================
  // MISIONES
  // ============================================================
  //
  // IMPORTANTE:
  // Tú ya definiste:
  //
  // Misión 1 = 20 estrellas
  // Misión 2 = 15 estrellas
  //
  // Y las cuatro deben sumar 90.
  //
  // Como todavía no hemos definido los valores exactos
  // de las misiones 3 y 4, estoy usando TEMPORALMENTE:
  //
  // Misión 3 = 25
  // Misión 4 = 30
  //
  // 20 + 15 + 25 + 30 = 90.
  //
  // Cuando definamos los valores reales solamente cambiamos
  // estos dos números.
  // ============================================================

  static const List<MissionDefinition> missions = [
    MissionDefinition(
      id: 'plant_seed',
      title: 'Planta una semilla',
      rewardStars: 20,
    ),
    MissionDefinition(
      id: 'mission_2',
      title: 'Misión 2',
      rewardStars: 15,
    ),

    // TEMPORAL
    MissionDefinition(
      id: 'mission_3',
      title: 'Misión 3',
      rewardStars: 25,
    ),

    // TEMPORAL
    MissionDefinition(
      id: 'mission_4',
      title: 'Misión 4',
      rewardStars: 30,
    ),
  ];

  // ============================================================
  // MEDALLAS
  // ============================================================

  static const List<MedalDefinition> medals = [
    MedalDefinition(
      id: 'sembrador',
      title: 'Sembrador',
      costStars: 90,
    ),
  ];

  // ============================================================
  // GETTERS
  // ============================================================

  bool get initialized => _initialized;

  String? get activeProfileId =>
      _activeProfileId;

  bool get hasActiveProfile =>
      _activeProfileId != null &&
      _profiles.containsKey(
        _activeProfileId,
      );

  List<PlayerProfile> get profiles =>
      List.unmodifiable(
        _profiles.values,
      );

  // ============================================================
  // PERFIL ACTIVO
  // ============================================================

  PlayerProfile? get activeProfile {
    final id = _activeProfileId;

    if (id == null) {
      return null;
    }

    return _profiles[id];
  }

  // ============================================================
  // OBTENER PERFIL POR ID
  // ============================================================

  PlayerProfile? getProfile(
    String profileId,
  ) {
    return _profiles[profileId];
  }

  // ============================================================
  // OBTENER PERFIL POR NOMBRE
  // ============================================================

  PlayerProfile? getProfileByName(
    String name,
  ) {
    final normalizedName =
        name.trim().toLowerCase();

    for (final profile
        in _profiles.values) {
      if (profile.name
              .trim()
              .toLowerCase() ==
          normalizedName) {
        return profile;
      }
    }

    return null;
  }

  // ============================================================
  // INICIALIZAR
  // ============================================================

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    final preferences =
        await SharedPreferences.getInstance();

    final savedProfiles =
        preferences.getString(
      _profilesStorageKey,
    );

    if (savedProfiles != null &&
        savedProfiles.isNotEmpty) {
      try {
        final decoded =
            jsonDecode(savedProfiles);

        if (decoded is Map) {
          for (final entry
              in decoded.entries) {
            final profileId =
                entry.key.toString();

            final rawProfile =
                entry.value;

            if (!_profiles.containsKey(
              profileId,
            )) {
              continue;
            }

            if (rawProfile
                is Map<String, dynamic>) {
              final savedProfile =
                  PlayerProfile.fromJson(
                rawProfile,
              );

              _profiles[profileId] =
                  _mergeWithDefaultProfile(
                profileId,
                savedProfile,
              );
            } else if (rawProfile is Map) {
              final converted =
                  rawProfile.map(
                (
                  key,
                  value,
                ) {
                  return MapEntry(
                    key.toString(),
                    value,
                  );
                },
              );

              final savedProfile =
                  PlayerProfile.fromJson(
                converted,
              );

              _profiles[profileId] =
                  _mergeWithDefaultProfile(
                profileId,
                savedProfile,
              );
            }
          }
        }
      } catch (error) {
        debugPrint(
          'No se pudo cargar el progreso: $error',
        );
      }
    }

    final savedActiveProfile =
        preferences.getString(
      _activeProfileStorageKey,
    );

    if (savedActiveProfile != null &&
        _profiles.containsKey(
          savedActiveProfile,
        )) {
      _activeProfileId =
          savedActiveProfile;
    }

    _initialized = true;

    notifyListeners();
  }

  // ============================================================
  // MEZCLAR DATOS GUARDADOS CON PERFIL BASE
  // ============================================================

  PlayerProfile _mergeWithDefaultProfile(
    String profileId,
    PlayerProfile savedProfile,
  ) {
    final defaultProfile =
        _profiles[profileId];

    if (defaultProfile == null) {
      return savedProfile;
    }

    // Conservamos siempre nombre y avatar oficiales.
    //
    // De esa forma:
    // Ana siempre será 🐢
    // Juan siempre será 🦫
    // Sofía siempre será 🐼

    return PlayerProfile(
      id: defaultProfile.id,
      name: defaultProfile.name,
      avatar: defaultProfile.avatar,
      stars: savedProfile.stars,
      completedMissionIds:
          savedProfile.completedMissionIds,
      purchasedMedalIds:
          savedProfile.purchasedMedalIds,
    );
  }

  // ============================================================
  // ACTIVAR PERFIL
  // ============================================================

  Future<bool> setActiveProfile(
    String profileId,
  ) async {
    if (!_profiles.containsKey(
      profileId,
    )) {
      return false;
    }

    _activeProfileId = profileId;

    final preferences =
        await SharedPreferences.getInstance();

    await preferences.setString(
      _activeProfileStorageKey,
      profileId,
    );

    notifyListeners();

    return true;
  }

  // ============================================================
  // ACTIVAR PERFIL USANDO NOMBRE
  // ============================================================

  Future<bool> setActiveProfileByName(
    String name,
  ) async {
    final profile =
        getProfileByName(name);

    if (profile == null) {
      return false;
    }

    return setActiveProfile(
      profile.id,
    );
  }

  // ============================================================
  // CERRAR PERFIL
  // ============================================================

  Future<void> clearActiveProfile() async {
    _activeProfileId = null;

    final preferences =
        await SharedPreferences.getInstance();

    await preferences.remove(
      _activeProfileStorageKey,
    );

    notifyListeners();
  }

  // ============================================================
  // BUSCAR MISIÓN
  // ============================================================

  MissionDefinition? getMission(
    String missionId,
  ) {
    for (final mission in missions) {
      if (mission.id == missionId) {
        return mission;
      }
    }

    return null;
  }

  // ============================================================
  // SABER SI MISIÓN ESTÁ COMPLETADA
  // ============================================================

  bool isMissionCompleted(
    String missionId,
  ) {
    final profile = activeProfile;

    if (profile == null) {
      return false;
    }

    return profile.hasCompletedMission(
      missionId,
    );
  }

  // ============================================================
  // SABER SI MISIÓN ESTÁ DESBLOQUEADA
  // ============================================================

  bool isMissionUnlocked(
    String missionId,
  ) {
    final profile = activeProfile;

    if (profile == null) {
      return false;
    }

    final missionIndex =
        missions.indexWhere(
      (mission) =>
          mission.id == missionId,
    );

    if (missionIndex == -1) {
      return false;
    }

    // La primera siempre está disponible.
    if (missionIndex == 0) {
      return true;
    }

    final previousMission =
        missions[missionIndex - 1];

    return profile.hasCompletedMission(
      previousMission.id,
    );
  }

  // ============================================================
  // COMPLETAR MISIÓN
  // ============================================================

  Future<bool> completeMission(
    String missionId,
  ) async {
    final profile = activeProfile;

    if (profile == null) {
      return false;
    }

    final mission =
        getMission(missionId);

    if (mission == null) {
      return false;
    }

    // No puede completar una misión bloqueada.
    if (!isMissionUnlocked(
      missionId,
    )) {
      return false;
    }

    // IMPORTANTE:
    // Si ya fue completada, no damos estrellas otra vez.
    if (profile.hasCompletedMission(
      missionId,
    )) {
      return false;
    }

    final updatedCompletedMissions =
        Set<String>.from(
      profile.completedMissionIds,
    );

    updatedCompletedMissions.add(
      missionId,
    );

    final updatedProfile =
        profile.copyWith(
      stars:
          profile.stars +
              mission.rewardStars,
      completedMissionIds:
          updatedCompletedMissions,
    );

    _profiles[profile.id] =
        updatedProfile;

    await _saveProfiles();

    notifyListeners();

    return true;
  }

  // ============================================================
  // MEDALLA COMPRADA
  // ============================================================

  bool ownsMedal(
    String medalId,
  ) {
    final profile = activeProfile;

    if (profile == null) {
      return false;
    }

    return profile.ownsMedal(
      medalId,
    );
  }

  // ============================================================
  // BUSCAR MEDALLA
  // ============================================================

  MedalDefinition? getMedal(
    String medalId,
  ) {
    for (final medal in medals) {
      if (medal.id == medalId) {
        return medal;
      }
    }

    return null;
  }

  // ============================================================
  // COMPRAR MEDALLA
  // ============================================================

  Future<MedalPurchaseResult>
      purchaseMedal(
    String medalId,
  ) async {
    final profile = activeProfile;

    if (profile == null) {
      return MedalPurchaseResult
          .medalNotFound;
    }

    final medal =
        getMedal(medalId);

    if (medal == null) {
      return MedalPurchaseResult
          .medalNotFound;
    }

    // Ya la compró anteriormente.
    if (profile.ownsMedal(
      medalId,
    )) {
      return MedalPurchaseResult
          .alreadyOwned;
    }

    // No tiene suficientes estrellas.
    if (profile.stars <
        medal.costStars) {
      return MedalPurchaseResult
          .insufficientStars;
    }

    final updatedMedals =
        Set<String>.from(
      profile.purchasedMedalIds,
    );

    updatedMedals.add(
      medalId,
    );

    final updatedProfile =
        profile.copyWith(
      stars:
          profile.stars -
              medal.costStars,
      purchasedMedalIds:
          updatedMedals,
    );

    _profiles[profile.id] =
        updatedProfile;

    await _saveProfiles();

    notifyListeners();

    return MedalPurchaseResult.success;
  }

  // ============================================================
  // ESTRELLAS QUE FALTAN PARA MEDALLA
  // ============================================================

  int starsMissingForMedal(
    String medalId,
  ) {
    final profile = activeProfile;
    final medal = getMedal(
      medalId,
    );

    if (profile == null ||
        medal == null) {
      return 0;
    }

    final missing =
        medal.costStars -
            profile.stars;

    if (missing < 0) {
      return 0;
    }

    return missing;
  }

  // ============================================================
  // GUARDAR PERFILES
  // ============================================================

  Future<void> _saveProfiles() async {
    final preferences =
        await SharedPreferences.getInstance();

    final data = <String, dynamic>{};

    for (final entry
        in _profiles.entries) {
      data[entry.key] =
          entry.value.toJson();
    }

    await preferences.setString(
      _profilesStorageKey,
      jsonEncode(data),
    );
  }

  // ============================================================
  // REINICIAR PROGRESO DE PERFIL
  //
  // ÚTIL DURANTE DESARROLLO.
  // ============================================================

  Future<void> resetActiveProfileProgress()
      async {
    final profile = activeProfile;

    if (profile == null) {
      return;
    }

    _profiles[profile.id] =
        PlayerProfile(
      id: profile.id,
      name: profile.name,
      avatar: profile.avatar,
      stars: 0,
      completedMissionIds: const {},
      purchasedMedalIds: const {},
    );

    await _saveProfiles();

    notifyListeners();
  }
}