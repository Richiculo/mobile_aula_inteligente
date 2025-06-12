import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';

class ProfesorService {
  final Dio _dio = Dio();
  final _storage = const FlutterSecureStorage();

  Future<List<Map<String, dynamic>>?> getMateriasDocente(gestionId) async {
    try {
      final token = await _storage.read(key: 'token');
      final res = await _dio.get(
        '$baseUrl/alumnos/profesores/mis-materias/?gestion_id=$gestionId',
        options: Options(
          headers: {
            'Authorization': 'Token $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      if (res.statusCode == 200) {
        return List<Map<String, dynamic>>.from(res.data);
      }
    } catch (e) {
      print('Error al obtener materias del profe: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> obtenerDashboardGeneral() async {
    final token = await _storage.read(key: 'token');
    if (token == null) return null;

    try {
      final res = await _dio.get(
        '$baseUrl/alumnos/profesores/dashboard/',
        options: Options(headers: {'Authorization': 'Token $token'}),
      );
      return res.data;
    } catch (e) {
      print('Error obteniendo dashboard general: $e');
      return null;
    }
  }

  Future<List<dynamic>> obtenerRendimientoPredicho(
    int gestionId,
    int cursoId,
  ) async {
    final token = await _storage.read(key: 'token');
    if (token == null) return [];

    try {
      final res = await _dio.get(
        '$baseUrl/alumnos/profesores/predecir-rendimiento/',
        queryParameters: {'gestion_id': gestionId, 'curso_id': cursoId},
        options: Options(headers: {'Authorization': 'Token $token'}),
      );
      return res.data;
    } catch (e) {
      print('Error obteniendo rendimiento predicho: $e');
      return [];
    }
  }

  Future<String?> generarQrAsistencia({
    required int materiaId,
    required int gestionCursoId,
  }) async {
    try {
      final token = await _storage.read(key: 'token');
      final res = await _dio.get(
        '$baseUrl/alumnos/profesores/generar-qr-asistencia/',
        queryParameters: {
          'materia_id': materiaId,
          'gestion_curso_id': gestionCursoId,
        },
        options: Options(headers: {'Authorization': 'Token $token'}),
      );
      return res.data['qr_data'];
    } catch (e) {
      print('Error al generar el QR: $e');
      return null;
    }
  }
}
