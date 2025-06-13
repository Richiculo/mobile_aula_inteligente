import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';

class AlumnoServices {
  final Dio _dio = Dio();
  final _storage = FlutterSecureStorage();

  Future<List<Map<String, dynamic>>?> getAlumnosPorMateria(int mgcId) async {
    try {
      final token = await _storage.read(key: 'token');
      final res = await _dio.get(
        '$baseUrl/alumnos/profesores/$mgcId/alumnos',
        options: Options(headers: {'Authorization': 'Token $token'}),
      );
      if (res.statusCode == 200) {
        return List<Map<String, dynamic>>.from(res.data);
      }
    } catch (e) {
      print('Error al obtener alumnos (service): $e');
    }
    return null;
  }

  Future<bool> calificarAlumno({
    required int alumnoId,
    required int materiaId,
    required int gestionCursoId,
    double? ser,
    double? saber,
    double? hacer,
    double? decidir,
    double? notaFinal,
  }) async {
    try {
      final token = await _storage.read(key: 'token');
      final data = {
        'alumno_id': alumnoId,
        'materia_id': materiaId,
        'gestion_curso': gestionCursoId,
        if (ser != null) 'ser': ser,
        if (saber != null) 'saber': saber,
        if (hacer != null) 'hacer': hacer,
        if (decidir != null) 'decidir': decidir,
        if (notaFinal != null) 'nota_final': notaFinal,
      };

      final res = await _dio.post(
        '$baseUrl/alumnos/profesores/calificar/',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Token $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      return res.statusCode == 200;
    } catch (e) {
      print('Error al calificar alumno (service): $e');
      return false;
    }
  }

  Future<bool> registrarAsistencia({
    required int alumnoId,
    required int materiaId,
    required int gestionCursoId,
    required DateTime fecha,
    required bool asistio,
  }) async {
    try {
      final token = await _storage.read(key: 'token');

      final data = {
        'alumno_id': alumnoId,
        'materia_id': materiaId,
        'gestion_curso_id': gestionCursoId,
        'fecha': fecha.toIso8601String().split('T').first,
        'asistio': asistio,
      };

      final response = await _dio.post(
        '$baseUrl/alumnos/profesores/registrar-asistencia/',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Token $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error registrando asistencia: $e');
      return false;
    }
  }

  Future<bool> registrarParticipacion({
    required int alumnoId,
    required int materiaId,
    required int gestionCursoId,
    required DateTime fecha,
    required String descripcion,
  }) async {
    try {
      final token = await _storage.read(key: 'token');

      final data = {
        'alumno_id': alumnoId,
        'materia_id': materiaId,
        'gestion_curso_id': gestionCursoId,
        'fecha': fecha.toIso8601String().split('T').first,
        'descripcion': descripcion,
      };

      final response = await _dio.post(
        '$baseUrl/alumnos/profesores/registrar-participacion/',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Token $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error registrando participación: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getNotaAlumno({
    required int alumnoId,
    required int materiaId,
    required int gestionCursoId,
    required int gestionId,
  }) async {
    try {
      final token = await _storage.read(key: 'token');
      final response = await _dio.get(
        '$baseUrl/alumnos/profesores/ver-nota/',
        queryParameters: {
          'alumno_id': alumnoId,
          'materia_id': materiaId,
          'gestion_curso_id': gestionCursoId,
          'gestion_id': gestionId,
        },
        options: Options(headers: {'Authorization': 'Token $token'}),
      );

      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data);
      }
    } catch (e) {
      print('Error al obtener nota: $e');
    }
    return null;
  }

  Future<List<Map<String, dynamic>>?> getMisMaterias(int gestionId) async {
    try {
      final token = await _storage.read(key: 'token');
      final res = await _dio.get(
        '$baseUrl/alumnos/vista-alumno/mis-materias/?gestion_id=$gestionId',
        options: Options(headers: {'Authorization': 'Token $token'}),
      );
      if (res.statusCode == 200) {
        return List<Map<String, dynamic>>.from(res.data);
      }
    } catch (e) {
      print('Error al obtener materias: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> getNotasDetalle(
    int materiaId,
    int gestionCursoId,
  ) async {
    try {
      final token = await _storage.read(key: 'token');
      final res = await _dio.get(
        '$baseUrl/alumnos/vista-alumno/mis-notas/',
        queryParameters: {
          'materia_id': materiaId,
          'gestion_curso_id': gestionCursoId,
        },
        options: Options(headers: {'Authorization': 'Token $token'}),
      );
      if (res.statusCode == 200) return Map<String, dynamic>.from(res.data);
    } catch (e) {
      print('Error en getNotasDetalle: $e');
    }
    return null;
  }

  Future<List<Map<String, dynamic>>?> getAsistencias(
    int materiaId,
    int gestionCursoId,
  ) async {
    try {
      final token = await _storage.read(key: 'token');
      final res = await _dio.get(
        '$baseUrl/alumnos/vista-alumno/mis-asistencias/',
        queryParameters: {
          'materia_id': materiaId,
          'gestion_curso_id': gestionCursoId,
        },
        options: Options(headers: {'Authorization': 'Token $token'}),
      );
      if (res.statusCode == 200)
        return List<Map<String, dynamic>>.from(res.data);
    } catch (e) {
      print('Error en getAsistencias: $e');
    }
    return null;
  }

  Future<List<Map<String, dynamic>>?> getParticipaciones(
    int materiaId,
    int gestionCursoId,
  ) async {
    try {
      final token = await _storage.read(key: 'token');
      final res = await _dio.get(
        '$baseUrl/alumnos/vista-alumno/mis-participaciones/',
        queryParameters: {
          'materia_id': materiaId,
          'gestion_curso_id': gestionCursoId,
        },
        options: Options(headers: {'Authorization': 'Token $token'}),
      );
      if (res.statusCode == 200)
        return List<Map<String, dynamic>>.from(res.data);
    } catch (e) {
      print('Error en getParticipaciones: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> getResumenDashboard(int gestionId) async {
    try {
      final token = await _storage.read(key: 'token');
      final response = await _dio.get(
        '$baseUrl/alumnos/vista-alumno/dashboard/',
        queryParameters: {'gestion_id': gestionId},
        options: Options(headers: {'Authorization': 'Token $token'}),
      );
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print('Error al obtener resumen dashboard: $e');
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getPrediccionRendimiento(
    int gestionId,
  ) async {
    try {
      final token = await _storage.read(key: 'token');
      final response = await _dio.get(
        '$baseUrl/alumnos/vista-alumno/predecir-rendimiento/?gestion_id=$gestionId',
        options: Options(headers: {'Authorization': 'Token $token'}),
      );
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      }
    } catch (e) {
      print('Error al obtener predicción de rendimiento: $e');
    }
    return [];
  }

  Future<bool> registrarAsistenciaConQr({
    required int materiaId,
    required int gestionCursoId,
    required String fecha,
  }) async {
    try {
      final token = await _storage.read(key: 'token');
      final res = await _dio.post(
        '$baseUrl/alumnos/registrar-asistencia-con-qr/',
        data: {
          'materia_id': materiaId,
          'gestion_curso_id': gestionCursoId,
          'fecha': fecha,
        },
        options: Options(headers: {'Authorization': 'Token $token'}),
      );
      return res.statusCode == 200;
    } catch (e) {
      print('Error al registrar asistencia con QR: $e');
      return false;
    }
  }
}
