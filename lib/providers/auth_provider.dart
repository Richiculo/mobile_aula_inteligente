import '../services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/cupertino.dart';

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
      notifyListeners();
      return true;
    }
    return false;
  }
}
