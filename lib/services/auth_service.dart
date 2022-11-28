
import 'dart:convert';
import 'package:chat_app/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/login_response.dart';

class AuthService with ChangeNotifier {
  
  late Usuario usuario; 
  bool _autenticando = false;

  bool get autenticando => _autenticando;
  final _storage = const FlutterSecureStorage();


  set autenticando(bool valor){
    _autenticando = valor;
    notifyListeners();
  }

  // Getters del token de forma estática
  static Future<String?> getToken() async {
    // ignore: no_leading_underscores_for_local_identifiers, prefer_const_declarations
    final _storage = const FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    // ignore: no_leading_underscores_for_local_identifiers, prefer_const_declarations
    final _storage = const FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }


  Future<bool> login(String email, String password) async {

    autenticando = true;

    final data = {
      'email': email,
      'password': password
    };

    final resp = await http.post(Uri.parse('${Environment.apiUrl}/login'), 
      body: jsonEncode(data),
      headers: {
        'Content-Type' : 'application/json'
      }
    );

    // print(resp.body);
    autenticando = false;
    if(resp.statusCode == 200){
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario!;
      await _guardarToken(loginResponse.token!);
      return true;
    }

    return false;

  }


  Future register(String nombre, String email, String password ) async {

    autenticando = true;

    final data = {
      'nombre': nombre,
      'email': email,
      'password': password
    };

    final uri = Uri.parse('${ Environment.apiUrl }/login/new');
    final resp = await http.post(uri, 
      body: jsonEncode(data),
      headers: { 'Content-Type': 'application/json' }
    );

    autenticando = false;

    if ( resp.statusCode == 200 ) {
      final loginResponse = loginResponseFromJson( resp.body );
      usuario = loginResponse.usuario!;
      await _guardarToken(loginResponse.token!);

      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }

  }

  Future<bool> isLoggedIn() async {

    final token = await _storage.read(key: 'token') ?? '';

    final uri = Uri.parse('${ Environment.apiUrl }/login/renew');
    final resp = await http.get(uri, 
      headers: { 
        'Content-Type': 'application/json',
        'x-token': token
      }
    );

    if ( resp.statusCode == 200 ) {
      final loginResponse = loginResponseFromJson( resp.body );
      usuario = loginResponse.usuario!;
      await _guardarToken(loginResponse.token!);
      return true;
    } else {
      logout();
      return false;
    }

  }



  Future _guardarToken( String token ) async {
    return await _storage.write(key: 'token', value: token );
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }


}