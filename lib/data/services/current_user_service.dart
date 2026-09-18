import 'package:flutter/foundation.dart';

class CurrentUserService
    extends ChangeNotifier {
  // ============================================================
  // SINGLETON
  // ============================================================

  CurrentUserService._();

  static final CurrentUserService instance =
      CurrentUserService._();

  // ============================================================
  // USUARIO ACTUAL
  //
  // Aquí guardamos los datos que devuelve el backend después
  // de un registro o un login correcto.
  // ============================================================

  Map<String, dynamic>? _currentUser;

  // ============================================================
  // USUARIO COMPLETO
  // ============================================================

  Map<String, dynamic>? get currentUser {
    if (_currentUser == null) {
      return null;
    }

    return Map<String, dynamic>.from(
      _currentUser!,
    );
  }

  // ============================================================
  // ¿HAY USUARIO AUTENTICADO?
  // ============================================================

  bool get hasUser =>
      _currentUser != null;

  // ============================================================
  // USER ID
  // ============================================================

  String get userId =>
      _currentUser?['userId']
              ?.toString() ??
          '';

  // ============================================================
  // PLAYER CODE
  // ============================================================

  String get playerCode =>
      _currentUser?['playerCode']
              ?.toString() ??
          '';

  // ============================================================
  // NOMBRE
  // ============================================================

  String get displayName =>
      _currentUser?['displayName']
              ?.toString() ??
          '';

  // ============================================================
  // EDAD
  // ============================================================

  int get age {
    final dynamic value =
        _currentUser?['age'];

    if (value is int) {
      return value;
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  // ============================================================
  // GRADO
  // ============================================================

  String get gradeName =>
      _currentUser?['gradeName']
              ?.toString() ??
          '';

  // ============================================================
  // PROFESOR
  // ============================================================

  String get teacherName =>
      _currentUser?['teacherName']
              ?.toString() ??
          '';

  // ============================================================
  // TIPO DE AVATAR
  // ============================================================

  String get avatarType =>
      _currentUser?['avatarType']
              ?.toString() ??
          'emoji';

  // ============================================================
  // AVATAR
  // ============================================================

  String get avatarValue =>
      _currentUser?['avatarValue']
              ?.toString() ??
          '🐢';

  // ============================================================
  // USUARIO ACTIVO
  // ============================================================

  bool get isActive {
    final dynamic value =
        _currentUser?['isActive'];

    if (value is bool) {
      return value;
    }

    return true;
  }

  // ============================================================
  // ESTRELLAS
  //
  // Por ahora las estrellas permanecen en memoria.
  //
  // Cuando conectemos progreso con SQL Server,
  // este valor deberá venir del backend.
  // ============================================================

  int get stars {
    final dynamic value =
        _currentUser?['stars'];

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  // ============================================================
  // GUARDAR USUARIO DESPUÉS DE LOGIN
  //
  // Ejemplo:
  //
  // CurrentUserService.instance.setCurrentUser(
  //   user,
  // );
  //
  // ============================================================

  void setCurrentUser(
    Map<String, dynamic> user,
  ) {
    _currentUser =
        Map<String, dynamic>.from(
      user,
    );

    // ==========================================================
    // ASEGURAR ESTRELLAS
    //
    // Si el backend todavía no manda estrellas,
    // el usuario inicia en 0.
    // ==========================================================

    _currentUser!['stars'] ??=
        0;

    notifyListeners();
  }

  // ============================================================
  // ACTUALIZAR TODO EL USUARIO
  // ============================================================

  void updateCurrentUser(
    Map<String, dynamic> values,
  ) {
    if (_currentUser == null) {
      return;
    }

    _currentUser!.addAll(
      values,
    );

    notifyListeners();
  }

  // ============================================================
  // ACTUALIZAR AVATAR
  //
  // Útil después de:
  //
  // PATCH /api/Users/{userId}/avatar
  // ============================================================

  void updateAvatar({
    required String avatarType,
    required String avatarValue,
  }) {
    if (_currentUser == null) {
      return;
    }

    _currentUser!['avatarType'] =
        avatarType;

    _currentUser!['avatarValue'] =
        avatarValue;

    notifyListeners();
  }

  // ============================================================
  // ESTABLECER CANTIDAD DE ESTRELLAS
  //
  // Ejemplo:
  //
  // setStars(50);
  // ============================================================

  void setStars(
    int value,
  ) {
    if (_currentUser == null) {
      return;
    }

    final int safeValue =
        value < 0
            ? 0
            : value;

    _currentUser!['stars'] =
        safeValue;

    notifyListeners();
  }

  // ============================================================
  // AGREGAR ESTRELLAS
  //
  // Ejemplo:
  //
  // addStars(20);
  //
  // Si tenía:
  //
  // ⭐ 40
  //
  // pasa a:
  //
  // ⭐ 60
  // ============================================================

  void addStars(
    int amount,
  ) {
    if (_currentUser == null) {
      return;
    }

    if (amount <= 0) {
      return;
    }

    _currentUser!['stars'] =
        stars + amount;

    notifyListeners();
  }

  // ============================================================
  // QUITAR ESTRELLAS
  //
  // Puede utilizarse posteriormente para compras,
  // medallas, recompensas, etc.
  // ============================================================

  bool removeStars(
    int amount,
  ) {
    if (_currentUser == null) {
      return false;
    }

    if (amount <= 0) {
      return false;
    }

    if (stars < amount) {
      return false;
    }

    _currentUser!['stars'] =
        stars - amount;

    notifyListeners();

    return true;
  }

  // ============================================================
  // CERRAR SESIÓN
  // ============================================================

  void clear() {
    _currentUser =
        null;

    notifyListeners();
  }
}