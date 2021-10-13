import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:chatapp/models/login_response.dart';
import 'package:chatapp/global/environment.dart';
import 'package:chatapp/models/usuario.dart';

class AuthService with ChangeNotifier {
  late Usuario usuario;
  bool _autenticar = false;
  final _storage = const FlutterSecureStorage();

  bool get autenticar => _autenticar;
  set autenticar(bool valor) {
    _autenticar = valor;
    notifyListeners();
  }

  //Getters del token estaticos
  static Future<String> getToken() async {
    const _storage = FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token!;
  }

  static Future deleteToken() async {
    const _storage = FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    autenticar = true;
    final data = {'email': email, 'password': password};
    final resp = await http.post(Uri.parse('${Environments.apiUrl}/login'),
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
    autenticar = false;
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;
      await _guardarToken(loginResponse.token);
      return true;
    } else {
      return false;
    }
  }

  Future register(String nombre, String email, String password) async {
    autenticar = true;
    final data = {'nombre': nombre, 'email': email, 'password': password};
    final resp = await http.post(Uri.parse('${Environments.apiUrl}/login/new'),
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
    autenticar = false;
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;
      await _guardarToken(loginResponse.token);
      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');
    final resp = await http.get(Uri.parse('${Environments.apiUrl}/login/renew'),
        headers: {'Content-Type': 'application/json', 'x-token': token!});
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;
      await _guardarToken(loginResponse.token);
      return true;
    } else {
      logout();
      return false;
    }
  }

  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }
}
