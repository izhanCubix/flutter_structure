// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:base_structure/data/services/api/auth_api_client.dart';
import 'package:base_structure/data/services/api/models/login_request/login_request.dart';
import 'package:base_structure/data/services/api/models/login_response/login_response.dart';
import 'package:base_structure/data/services/hive/boxes.dart';
import 'package:base_structure/data/services/hive/boxes_keys.dart';
import 'package:base_structure/data/services/hive/hive_service.dart';
import 'package:logging/logging.dart';

import '../../../../utils/result.dart';

import 'auth_repository.dart';

class AuthRepositoryImplementation extends AuthRepository {
  AuthRepositoryImplementation({required AuthApiClient authApiClient})
    : _authApiClient = authApiClient;

  final AuthApiClient _authApiClient;
  final HiveService _hiveService = HiveService.instance;
  // final ApiClient _apiClient;

  bool? _isAuthenticated;
  String? _authToken;

  final _log = Logger('AuthRepositoryImplementation');

  /// Fetch token from shared preferences
  Future<void> _fetch() async {
    final result = await _hiveService.read<String>(
      box: Boxes.user,
      key: UserBoxKeys.token,
    );
    // final result = Result.ok('mockedToken'); // Mocked for example purposes
    switch (result) {
      case Ok<String>():
        _authToken = result.value;
        _isAuthenticated = result.value != null;
      case Error<String>():
        _log.severe('Failed to fech Token from hive', result.error);
    }
  }

  @override
  Future<bool> get isAuthenticated async {
    // Status is cached
    if (_isAuthenticated != null) {
      return _isAuthenticated!;
    }
    // No status cached, fetch from storage
    await _fetch();
    return _isAuthenticated ?? false;
  }

  @override
  Future<Result<void>> login({
    required String email,
    required String password,
  }) async {
    try {
      // ======== API SERVICE CALL HERE ========
      final result = await _authApiClient.login(
        LoginRequest(email: email, password: password),
      );

      switch (result) {
        case Ok<LoginResponse>():
          _log.info('User logged int');
          // Set auth status
          _isAuthenticated = true;
          _authToken = result.value.token;
          // Store in Shared preferences
          await _hiveService.write(
            box: Boxes.user,
            key: UserBoxKeys.token,
            value: result.value.token,
          );
          return Result.ok(null);
        case Error<LoginResponse>():
          _log.warning('Error logging in: ${result.error}');
          return Result.error(result.error);
        default:
          return Result.error(Exception('Unknown error occurred during login'));
      }
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await Future.delayed(Duration(seconds: 2));
      final res = await _hiveService.delete(
        box: Boxes.user,
        key: UserBoxKeys.token,
      );
      switch (res) {
        case Ok<bool>():
          _log.info('User logged out');
          // Clear auth status
          _isAuthenticated = false;
          _authToken = null;
          return Result.ok(null);
        case Error<bool>():
          _log.severe('Failed to clear stored auth token', res.error);
          return Result.error(res.error);
        default:
          return Result.error(
            Exception('Unknown error occurred during logout'),
          );
      }
    } finally {
      notifyListeners();
    }
  }
}
