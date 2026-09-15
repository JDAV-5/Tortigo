class PlayerProfile {
  final String id;
  final String name;
  final String avatar;

  final int stars;

  final Set<String> completedMissionIds;
  final Set<String> purchasedMedalIds;

  const PlayerProfile({
    required this.id,
    required this.name,
    required this.avatar,
    this.stars = 0,
    this.completedMissionIds = const {},
    this.purchasedMedalIds = const {},
  });

  // ============================================================
  // MISIÓN COMPLETADA
  // ============================================================

  bool hasCompletedMission(String missionId) {
    return completedMissionIds.contains(
      missionId,
    );
  }

  // ============================================================
  // MEDALLA COMPRADA
  // ============================================================

  bool ownsMedal(String medalId) {
    return purchasedMedalIds.contains(
      medalId,
    );
  }

  // ============================================================
  // COPY WITH
  // ============================================================

  PlayerProfile copyWith({
    String? id,
    String? name,
    String? avatar,
    int? stars,
    Set<String>? completedMissionIds,
    Set<String>? purchasedMedalIds,
  }) {
    return PlayerProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      stars: stars ?? this.stars,
      completedMissionIds:
          completedMissionIds ??
              this.completedMissionIds,
      purchasedMedalIds:
          purchasedMedalIds ??
              this.purchasedMedalIds,
    );
  }

  // ============================================================
  // GUARDAR COMO JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'stars': stars,
      'completedMissionIds':
          completedMissionIds.toList(),
      'purchasedMedalIds':
          purchasedMedalIds.toList(),
    };
  }

  // ============================================================
  // LEER JSON
  // ============================================================

  factory PlayerProfile.fromJson(
    Map<String, dynamic> json,
  ) {
    return PlayerProfile(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      avatar:
          json['avatar']?.toString() ?? '🐢',
      stars: json['stars'] is int
          ? json['stars'] as int
          : int.tryParse(
                json['stars']?.toString() ??
                    '0',
              ) ??
              0,
      completedMissionIds:
          ((json['completedMissionIds']
                      as List<dynamic>?) ??
                  const [])
              .map(
                (item) => item.toString(),
              )
              .toSet(),
      purchasedMedalIds:
          ((json['purchasedMedalIds']
                      as List<dynamic>?) ??
                  const [])
              .map(
                (item) => item.toString(),
              )
              .toSet(),
    );
  }
}