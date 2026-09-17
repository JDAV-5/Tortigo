import 'package:flutter/foundation.dart';

class CurrentUserService extends ChangeNotifier {
  CurrentUserService._();

  static final CurrentUserService instance =
      CurrentUserService._();

  Map<String, dynamic>? _currentUser;

  Map<String, dynamic>? get currentUser =>
      _currentUser;

  bool get hasUser =>
      _currentUser != null;

  String get userId =>
      _currentUser?['userId']?.toString() ??
      '';

  String get displayName =>
      _currentUser?['displayName']?.toString() ??
      '';

  String get avatarType =>
      _currentUser?['avatarType']?.toString() ??
      '';

  String get avatarValue =>
      _currentUser?['avatarValue']?.toString() ??
      '🐢';

  int get age {
    final value = _currentUser?['age'];

    if (value is int) {
      return value;
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  String get gradeName =>
      _currentUser?['gradeName']?.toString() ??
      '';

  String get teacherName =>
      _currentUser?['teacherName']?.toString() ??
      '';

  String get playerCode =>
      _currentUser?['playerCode']?.toString() ??
      '';

  void setCurrentUser(
    Map<String, dynamic> user,
  ) {
    _currentUser =
        Map<String, dynamic>.from(user);

    notifyListeners();
  }

  void clear() {
    _currentUser = null;

    notifyListeners();
  }
}