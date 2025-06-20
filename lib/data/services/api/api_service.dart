import 'dart:io';
import 'package:base_structure/data/services/hive/boxes.dart';
import 'package:base_structure/data/services/hive/boxes_keys.dart';
import 'package:base_structure/data/services/hive/hive_service.dart';
import 'package:base_structure/data/services/webservice/api_route.dart';
import 'package:base_structure/data/services/webservice/request_type.dart';
import 'package:base_structure/data/services/webservice/webservice.dart';
import 'package:base_structure/utils/result.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;

  late Dio dio;

  ApiService._internal() {
    final options = BaseOptions(
      baseUrl: WebService.baseUrl, // Replace this
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Agent': 'mobile',
        'Accept': 'application/json',
        'x-api-key': 'reqres-free-v1',
      },
    );

    dio = Dio(options);

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }
  }

  /// General API request
  Future<Result<T>> callRequest<T>({
    required ApiRoute apiRoute,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? payload,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) async {
    try {
      final mergedHeaders = {
        ...dio.options.headers,
        if (headers != null) ...headers,
      };

      // Add token if required
      if (apiRoute.accessTokenRequired) {
        final tokenResult = await HiveService.instance.read<String>(
          box: Boxes.user,
          key: UserBoxKeys.token,
        );

        if (tokenResult is! Ok) {
          return Result.error(Exception("Authorization token not found."));
        }

        mergedHeaders['Authorization'] =
            'Bearer ${(tokenResult as Ok<String>).value}';
      }

      final response = await dio.request(
        apiRoute.route,
        data: payload,
        queryParameters: queryParams,
        options: Options(
          method: _mapMethod(apiRoute.type),
          headers: mergedHeaders,
          responseType: ResponseType.json,
        ),
      );
      if (_isValidResponse(response)) {
        final data = fromJson(response.data);
        return Result.ok(data);
      }

      return Result.error(
        Exception(response.data?['message'] ?? 'Unexpected error occurred.'),
      );
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? 'Network or server error';
      return Result.error(Exception(message));
    } catch (e) {
      return Result.error(Exception('Unexpected error: $e'));
    }
  }

  /// File upload (image, PDF, etc.) with typed response
  Future<Result<T>> callRequestFileUpload<T>({
    required ApiRoute apiRoute,
    required File file,
    required String fileField,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? fields,
    Map<String, String>? headers,
    ProgressCallback? onSendProgress,
  }) async {
    final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
    final contentType = MediaType.parse(mimeType);
    final fileName = file.path.split('/').last;

    final formData = FormData.fromMap({
      if (fields != null) ...fields,
      fileField: await MultipartFile.fromFile(
        file.path,
        filename: fileName,
        contentType: contentType,
      ),
    });

    final mergedHeaders = {
      'Content-Type': 'multipart/form-data',
      'Agent': 'mobile',
      if (headers != null) ...headers,
    };

    // Add token if required
    if (apiRoute.accessTokenRequired) {
      final tokenResult = await HiveService.instance.read<String>(
        box: Boxes.user,
        key: UserBoxKeys.token,
      );

      if (tokenResult is! Ok) {
        return Result.error(Exception("Authorization token not found."));
      }

      mergedHeaders['Authorization'] =
          'Bearer ${(tokenResult as Ok<String>).value}';
    }

    try {
      final response = await dio.post(
        apiRoute.route,
        data: formData,
        options: Options(headers: mergedHeaders),
        onSendProgress: onSendProgress,
      );

      if (_isValidResponse(response)) {
        final data = fromJson(response.data);
        return Result.ok(data);
      }

      return Result.error(
        Exception(response.data?['message'] ?? 'Upload failed.'),
      );
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? 'File upload network error';
      return Result.error(Exception(message));
    } catch (e) {
      return Result.error(Exception('Unexpected upload error: $e'));
    }
  }

  String _mapMethod(RequestType type) {
    switch (type) {
      case RequestType.get:
        return 'GET';
      case RequestType.post:
        return 'POST';
      case RequestType.put:
        return 'PUT';
      case RequestType.patch:
        return 'PATCH';
      case RequestType.delete:
        return 'DELETE';
    }
  }

  bool _isValidResponse(Response response) {
    final statusCode = response.statusCode ?? 0;
    return statusCode >= 200 &&
        statusCode < 300 &&
        response.data is Map<String, dynamic>;
  }
}
