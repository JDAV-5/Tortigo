import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class UserService {
  UserService._();

  static final UserService instance =
      UserService._();

  // ============================================================
  // BACKEND
  // ============================================================
  //
  // Estamos usando:
  //
  // adb reverse tcp:5000 tcp:5000
  //
  // Por eso desde Android podemos usar:
  //
  // http://127.0.0.1:5000
  //
  // ============================================================

  static const String baseUrl =
      'http://127.0.0.1:5000';

  static const Duration _timeout =
      Duration(
    seconds: 20,
  );

  // ============================================================
  // CREAR USUARIO
  // ============================================================

  Future<Map<String, dynamic>> createUser({
    required String displayName,
    required int age,
    required String gradeName,
    required String teacherName,
    required String pin,
    required String avatarType,
    required String avatarValue,
  }) async {
    final Uri uri = Uri.parse(
      '$baseUrl/api/Users/register',
    );

    try {
      final http.Response response =
          await http
              .post(
                uri,
                headers: {
                  'Content-Type':
                      'application/json; charset=UTF-8',
                  'Accept':
                      'application/json',
                },
                body: jsonEncode(
                  {
                    'displayName':
                        displayName,
                    'age':
                        age,
                    'gradeName':
                        gradeName,
                    'teacherName':
                        teacherName,
                    'pin':
                        pin,
                    'avatarType':
                        avatarType,
                    'avatarValue':
                        avatarValue,
                  },
                ),
              )
              .timeout(
                _timeout,
              );

      return _processMapResponse(
        response,
      );
    } on TimeoutException {
      throw Exception(
        'El servidor tardó demasiado en responder.',
      );
    } on SocketException {
      throw Exception(
        'No fue posible conectar con el servidor.',
      );
    } on http.ClientException catch (error) {
      throw Exception(
        'Error de conexión: $error',
      );
    }
  }

  // ============================================================
  // OBTENER PERFILES DE LA BASE DE DATOS
  //
  // GET:
  // /api/Users/profiles
  // ============================================================

  Future<List<Map<String, dynamic>>>
      getProfiles() async {
    final Uri uri = Uri.parse(
      '$baseUrl/api/Users/profiles',
    );

    try {
      final http.Response response =
          await http
              .get(
                uri,
                headers: {
                  'Accept':
                      'application/json',
                },
              )
              .timeout(
                _timeout,
              );

      final Map<String, dynamic> result =
          _processMapResponse(
        response,
      );

      final dynamic data =
          result['data'];

      if (data is! List) {
        return <Map<String, dynamic>>[];
      }

      return data
          .whereType<Map>()
          .map(
            (dynamic item) =>
                Map<String, dynamic>.from(
              item as Map,
            ),
          )
          .toList();
    } on TimeoutException {
      throw Exception(
        'El servidor tardó demasiado en cargar los perfiles.',
      );
    } on SocketException {
      throw Exception(
        'No fue posible conectar con el servidor.',
      );
    } on http.ClientException catch (error) {
      throw Exception(
        'Error de conexión: $error',
      );
    }
  }

  // ============================================================
  // LOGIN
  //
  // POST:
  // /api/Users/login
  //
  // Backend recibe:
  //
  // {
  //   "displayName": "...",
  //   "pin": "1234"
  // }
  // ============================================================

  Future<Map<String, dynamic>> login({
    required String displayName,
    required String pin,
  }) async {
    final Uri uri = Uri.parse(
      '$baseUrl/api/Users/login',
    );

    try {
      final http.Response response =
          await http
              .post(
                uri,
                headers: {
                  'Content-Type':
                      'application/json; charset=UTF-8',
                  'Accept':
                      'application/json',
                },
                body: jsonEncode(
                  {
                    'displayName':
                        displayName,
                    'pin':
                        pin,
                  },
                ),
              )
              .timeout(
                _timeout,
              );

      return _processMapResponse(
        response,
      );
    } on TimeoutException {
      throw Exception(
        'El servidor tardó demasiado en iniciar sesión.',
      );
    } on SocketException {
      throw Exception(
        'No fue posible conectar con el servidor.',
      );
    } on http.ClientException catch (error) {
      throw Exception(
        'Error de conexión: $error',
      );
    }
  }

  // ============================================================
  // ACTUALIZAR AVATAR
  // ============================================================

  Future<Map<String, dynamic>>
      updateAvatar({
    required String userId,
    required String avatarType,
    required String avatarValue,
  }) async {
    final Uri uri = Uri.parse(
      '$baseUrl/api/Users/$userId/avatar',
    );

    try {
      final http.Response response =
          await http
              .patch(
                uri,
                headers: {
                  'Content-Type':
                      'application/json; charset=UTF-8',
                  'Accept':
                      'application/json',
                },
                body: jsonEncode(
                  {
                    'avatarType':
                        avatarType,
                    'avatarValue':
                        avatarValue,
                  },
                ),
              )
              .timeout(
                _timeout,
              );

      return _processMapResponse(
        response,
      );
    } on TimeoutException {
      throw Exception(
        'El servidor tardó demasiado en actualizar el avatar.',
      );
    } on SocketException {
      throw Exception(
        'No fue posible conectar con el servidor.',
      );
    } on http.ClientException catch (error) {
      throw Exception(
        'Error de conexión: $error',
      );
    }
  }

  // ============================================================
  // PROCESAR RESPUESTA JSON
  // ============================================================

  Map<String, dynamic> _processMapResponse(
    http.Response response,
  ) {
    Map<String, dynamic> data =
        <String, dynamic>{};

    if (response.body.isNotEmpty) {
      try {
        final dynamic decoded =
            jsonDecode(
          utf8.decode(
            response.bodyBytes,
          ),
        );

        if (decoded is Map) {
          data =
              Map<String, dynamic>.from(
            decoded,
          );
        }
      } on FormatException {
        throw Exception(
          'El servidor devolvió una respuesta inválida.',
        );
      }
    }

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return data;
    }

    final String message =
        data['message']
                ?.toString() ??
            'Ocurrió un error en el servidor.';

    throw Exception(
      message,
    );
  }
}