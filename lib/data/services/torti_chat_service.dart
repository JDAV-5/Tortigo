import 'dart:convert';

import 'package:http/http.dart' as http;

class TortiChatService {
  static const String _baseUrl =
      'https://chatbot-torti.onrender.com';

  static const Duration _timeout =
      Duration(seconds: 70);

  // ============================================================
  // ENVIAR MENSAJE
  // ============================================================

  Future<String> sendMessage(
    String message,
  ) async {
    final cleanMessage = message.trim();

    if (cleanMessage.isEmpty) {
      throw Exception(
        'El mensaje está vacío.',
      );
    }

    try {
      final response = await http
          .post(
            Uri.parse(
              '$_baseUrl/chat',
            ),
            headers: {
              'Content-Type':
                  'application/json',
            },
            body: jsonEncode({
              'message': cleanMessage,
            }),
          )
          .timeout(_timeout);

      Map<String, dynamic> data = {};

      try {
        data = jsonDecode(
          utf8.decode(
            response.bodyBytes,
          ),
        ) as Map<String, dynamic>;
      } catch (_) {
        throw Exception(
          'El servidor devolvió una respuesta inválida.',
        );
      }

      if (response.statusCode == 200) {
        final reply =
            data['reply']?.toString().trim();

        if (reply == null ||
            reply.isEmpty) {
          throw Exception(
            'Torti no pudo responder.',
          );
        }

        return reply;
      }

      final error =
          data['error']?.toString();

      throw Exception(
        error ??
            'No se pudo comunicar con Torti.',
      );
    } catch (error) {
      if (error
          .toString()
          .contains(
            'TimeoutException',
          )) {
        throw Exception(
          'Torti tardó demasiado en despertar. Inténtalo nuevamente.',
        );
      }

      rethrow;
    }
  }
}