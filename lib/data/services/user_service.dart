import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class UserService {
  UserService._();

  static final UserService instance =
      UserService._();

  // ============================================================
  // BACKEND TORTIGO
  // ============================================================
  //
  // Estamos trabajando con un teléfono físico y ADB Reverse.
  //
  // Debes ejecutar en PowerShell:
  //
  // & "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" reverse tcp:5000 tcp:5000
  //
  // Esto permite que:
  //
  // Flutter / Android:
  // http://127.0.0.1:5000
  //
  // apunte hacia:
  //
  // PC:
  // http://localhost:5000
  //
  // ============================================================

  static const String baseUrl =
      'http://127.0.0.1:5000';

  // ============================================================
  // TIMEOUT
  // ============================================================

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

      // ========================================================
      // LEER RESPUESTA
      // ========================================================

      Map<String, dynamic> data =
          <String, dynamic>{};

      if (response.body.isNotEmpty) {
        final dynamic decoded =
            jsonDecode(
          response.body,
        );

        if (decoded
            is Map<String, dynamic>) {
          data =
              decoded;
        }
      }

      // ========================================================
      // RESPUESTA CORRECTA
      // ========================================================

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        return data;
      }

      // ========================================================
      // ERROR DEVUELTO POR EL BACKEND
      // ========================================================

      final String message =
          data['message']
                  ?.toString() ??
              'No fue posible crear el usuario.';

      final String? backendError =
          data['error']
              ?.toString();

      if (backendError != null &&
          backendError.isNotEmpty) {
        throw Exception(
          '$message\n\n$backendError',
        );
      }

      throw Exception(
        message,
      );
    }

    // ==========================================================
    // TIMEOUT
    // ==========================================================

    on TimeoutException {
      throw Exception(
        'El servidor tardó demasiado en responder.\n\n'
        'Verifica que el backend esté ejecutándose '
        'en el puerto 5000.',
      );
    }

    // ==========================================================
    // ERROR DE SOCKET
    // ==========================================================

    on SocketException catch (error) {
      throw Exception(
        'No fue posible conectar con el backend.\n\n'
        'Verifica que ASP.NET Core esté ejecutándose '
        'en el puerto 5000 y que ADB Reverse esté activo.\n\n'
        'Detalle: $error',
      );
    }

    // ==========================================================
    // ERROR HTTP
    // ==========================================================

    on http.ClientException catch (error) {
      throw Exception(
        'Error de conexión con el servidor.\n\n'
        '$error',
      );
    }

    // ==========================================================
    // ERROR DE FORMATO JSON
    // ==========================================================

    on FormatException catch (error) {
      throw Exception(
        'El servidor devolvió una respuesta inválida.\n\n'
        '$error',
      );
    }

    // ==========================================================
    // OTROS ERRORES
    // ==========================================================

    catch (error) {
      if (error is Exception) {
        rethrow;
      }

      throw Exception(
        'Ocurrió un error inesperado.\n\n'
        '$error',
      );
    }
  }
}