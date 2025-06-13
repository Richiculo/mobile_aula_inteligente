import '../services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import '../config/api_config.dart';

class AuthProvider with ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  final _authService = AuthService();

  String? _token;
  bool _loading = true;

  String? get token => _token;
  bool get isAuthenticated => _token != null;
  bool get isLoading => _loading;

  Map<String, dynamic>? _user;
  Map<String, dynamic>? get user => _user;

  Future<bool> register({
    required String nombre,
    required String apellidos,
    required String email,
    required String password,
    required String tipoUsuario,
    required Map<String, dynamic> direccion,
  }) async {
    final response = await _authService.register(
      nombre: nombre,
      apellidos: apellidos,
      email: email,
      password: password,
      tipoUsuario: tipoUsuario,
      direccion: direccion,
    );

    if (response != null && response['token'] != null) {
      _token = response['token'];
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> login(String email, String password) async {
    final data = await _authService.login(email, password);
    if (data != null) {
      _token = data['token'];
      _user = data['user'];
      await _storage.write(key: 'token', value: _token);
      await _storage.write(key: 'user', value: jsonEncode(_user));
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    await _storage.delete(key: 'token');
    notifyListeners();
  }

  Future<void> tryAutoLogin() async {
    final storedToken = await _storage.read(key: 'token');
    final storedUser = await _storage.read(key: 'user');

    if (storedToken == null || storedUser == null) {
      _token = null;
      _user = null;
      _loading = false;
      notifyListeners();
      return;
    }

    // Validamos si el token sigue siendo válido haciendo una prueba real
    try {
      final response = await Dio().get(
        '$baseUrl/alumnos/vista-alumno/dashboard/', // o un endpoint que sea liviano y seguro
        options: Options(headers: {'Authorization': 'Token $storedToken'}),
      );

      if (response.statusCode == 200) {
        _token = storedToken;
        _user = jsonDecode(storedUser);
      } else {
        // Token inválido, se borra
        await logout();
      }
    } catch (e) {
      // Error de red o token inválido
      await logout();
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> enviarFcmToken(String fcmToken) async {
    final token = await _storage.read(key: 'token');
    if (token == null) return;

    await _authService.enviarFcmToken(fcmToken, token);
  }
}
