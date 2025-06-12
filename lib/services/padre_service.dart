import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';

class PadreService {
  final Dio _dio = Dio();
  final _storage = FlutterSecureStorage();

  Future<List<Map<String, dynamic>>?> getMateriasHijo({
    required int alumnoId,
    required int gestionId,
  }) async {
    try {
      final token = await _storage.read(key: 'token');
      final res = await _dio.get(
        '$baseUrl/alumnos/vista-padre/ver-materias/',
        queryParameters: {'alumno_id': alumnoId, 'gestion_id': gestionId},
        options: Options(headers: {'Authorization': 'Token $token'}),
      );
      if (res.statusCode == 200)
        return List<Map<String, dynamic>>.from(res.data);
    } catch (e) {
      print('Error al obtener materias del hijo: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> getNotaHijo({
    required int alumnoId,
    required int materiaId,
    required int gestionCursoId,
  }) async {
    try {
      final token = await _storage.read(key: 'token');
      final res = await _dio.get(
        '$baseUrl/alumnos/vista-padre/ver-nota/',
        queryParameters: {
          'alumno_id': alumnoId,
          'materia_id': materiaId,
          'gestion_curso_id': gestionCursoId,
        },
        options: Options(headers: {'Authorization': 'Token $token'}),
      );
      if (res.statusCode == 200) return Map<String, dynamic>.from(res.data);
    } catch (e) {
      print('Error al obtener nota del hijo: $e');
    }
    return null;
  }

  Future<List<Map<String, dynamic>>?> getAsistenciasHijo({
    required int alumnoId,
    required int materiaId,
    required int gestionCursoId,
  }) async {
    try {
      final token = await _storage.read(key: 'token');
      final res = await _dio.get(
        '$baseUrl/alumnos/vista-padre/ver-asistencias/',
        queryParameters: {
          'alumno_id': alumnoId,
          'materia_id': materiaId,
          'gestion_curso_id': gestionCursoId,
        },
        options: Options(headers: {'Authorization': 'Token $token'}),
      );
      if (res.statusCode == 200)
        return List<Map<String, dynamic>>.from(res.data);
    } catch (e) {
      print('Error al obtener asistencias: $e');
    }
    return null;
  }

  Future<List<Map<String, dynamic>>?> getParticipacionesHijo({
    required int alumnoId,
    required int materiaId,
    required int gestionCursoId,
  }) async {
    try {
      final token = await _storage.read(key: 'token');
      final res = await _dio.get(
        '$baseUrl/alumnos/vista-padre/ver-participaciones/',
        queryParameters: {
          'alumno_id': alumnoId,
          'materia_id': materiaId,
          'gestion_curso_id': gestionCursoId,
        },
        options: Options(headers: {'Authorization': 'Token $token'}),
      );
      if (res.statusCode == 200)
        return List<Map<String, dynamic>>.from(res.data);
    } catch (e) {
      print('Error al obtener participaciones: $e');
    }
    return null;
  }

  Future<List<Map<String, dynamic>>?> getHijos() async {
    try {
      final token = await _storage.read(key: 'token');
      final res = await _dio.get(
        '$baseUrl/alumnos/vista-padre/mis-hijos/',
        options: Options(headers: {'Authorization': 'Token $token'}),
      );
      if (res.statusCode == 200) {
        return List<Map<String, dynamic>>.from(res.data);
      }
    } catch (e) {
      print('Error al obtener hijos: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> getResumenDashboardPadre() async {
    try {
      final token = await _storage.read(key: 'token');
      final res = await _dio.get(
        '$baseUrl/alumnos/vista-padre/dashboard/',
        options: Options(headers: {'Authorization': 'Token $token'}),
      );
      if (res.statusCode == 200) return res.data;
    } catch (e) {
      print('Error al obtener dashboard padre: $e');
    }
    return null;
  }

  Future<List<Map<String, dynamic>>?> getPrediccionRendimientoPadre(
    int alumnoId,
    int gestionId,
  ) async {
    try {
      final token = await _storage.read(key: 'token');
      final res = await _dio.get(
        '$baseUrl/alumnos/vista-padre/predecir-rendimiento/',
        queryParameters: {'alumno_id': alumnoId, 'gestion_id': gestionId},
        options: Options(headers: {'Authorization': 'Token $token'}),
      );
      if (res.statusCode == 200) {
        return List<Map<String, dynamic>>.from(res.data);
      }
    } catch (e) {
      print('Error en predicción padre: $e');
    }
    return null;
  }

  Future<List<Map<String, dynamic>>?> getAsistencias(
    int alumnoId,
    int materiaId,
    int gestionCursoId,
  ) async {
    final token = await _storage.read(key: 'token');
    try {
      final response = await _dio.get(
        '$baseUrl/alumnos/vista-padre/ver-asistencias/',
        queryParameters: {
          'alumno_id': alumnoId,
          'materia_id': materiaId,
          'gestion_curso_id': gestionCursoId,
        },
        options: Options(headers: {'Authorization': 'Token $token'}),
      );
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      }
    } catch (e) {
      print('Error al obtener asistencias del hijo: $e');
    }
    return null;
  }

  Future<List<Map<String, dynamic>>?> getParticipaciones(
    int alumnoId,
    int materiaId,
    int gestionCursoId,
  ) async {
    final token = await _storage.read(key: 'token');
    try {
      final response = await _dio.get(
        '$baseUrl/alumnos/vista-padre/ver-participaciones/',
        queryParameters: {
          'alumno_id': alumnoId,
          'materia_id': materiaId,
          'gestion_curso_id': gestionCursoId,
        },
        options: Options(headers: {'Authorization': 'Token $token'}),
      );
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      }
    } catch (e) {
      print('Error al obtener participaciones del hijo: $e');
    }
    return null;
  }
}
