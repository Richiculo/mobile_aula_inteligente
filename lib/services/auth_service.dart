import '../config/api_config.dart';
import 'package:dio/dio.dart';

class AuthService {
  Future<Map<String, dynamic>?> register({
    required String nombre,
    required String apellidos,
    required String email,
    required String password,
    required String tipoUsuario,
    required Map<String, dynamic> direccion,
  }) async {
    final dio = Dio();
    try {
      final response = await dio.post(
        '$baseUrl/register/',
        data: {
          'nombre': nombre,
          'apellidos': apellidos,
          'email': email,
          'tipo_usuario': tipoUsuario,
          'password': password,
          'direccion': direccion,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      if (response.statusCode == 201) {
        return response.data;
      } else {
        return null;
      }
    } on DioException catch (e) {
      print('Error en el registro: ${e.response?.data ?? e.message}');
      return null;
    }
  }

  Future<Map<String, dynamic>?> login(String email, String password) async {
    final dio = Dio();
    try {
      final response = await dio.post(
        '$baseUrl/usuarios/login/',
        data: {'email': email, 'password': password},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return null;
      }
    } on DioException catch (e) {
      print('Error en el login: ${e.response?.data ?? e.message}');
      return null;
    }
  }
}
