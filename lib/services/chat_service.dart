import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:chatapp/global/environment.dart';
import 'package:chatapp/models/mensajes_response.dart';
import 'package:chatapp/services/auth_service.dart';

import 'package:chatapp/models/usuario.dart';

class ChatService with ChangeNotifier {
  late Usuario usuarioPara;

  Future<List<Mensaje>> getChat(String usuarioId) async {
    final resp = await http
        .get(Uri.parse('${Environments.apiUrl}/mensajes/$usuarioId'), headers: {
      'Content-Type': 'application/json',
      'x-token': await AuthService.getToken()
    });

    final mensajesResponse = mensajesResponseFromJson(resp.body);
    return mensajesResponse.mensajes;
  }
}
