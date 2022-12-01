import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import 'package:chat_app/global/environment.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/models/mensajes_response.dart';
import 'package:chat_app/models/usuario.dart';


class ChatService with ChangeNotifier {

  late Usuario usuarioPara;

  Future<List<Mensaje>?> getChat(String usuarioId) async {
    try {
      
      final resp = await http.get(Uri.parse('${Environment.apiUrl}/mensajes/$usuarioId'), 
        headers: {
          'Content-Type' : 'application/json',
          'x-token': await AuthService.getToken() ?? ''
        }
      );

      final mensajesResp = mensajesResponseFromJson(resp.body);

      return mensajesResp.mensajes;

    } catch (e) {

      return [];
      
    }
  }

}