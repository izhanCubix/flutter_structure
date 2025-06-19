// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:base_structure/data/services/api/api_service.dart';
import 'package:base_structure/data/services/api/models/login_request/login_request.dart';
import 'package:base_structure/data/services/api/models/login_response/login_response.dart';
import 'package:base_structure/data/services/webservice/webservice.dart';

import '../../../../utils/result.dart';

class AuthApiClient {
  AuthApiClient({required ApiService apiService}) : _apiService = apiService;

  final ApiService _apiService;
  final String baseUrl = "https://reqres.in";

  Future<Result<LoginResponse>> login(LoginRequest loginRequest) async {
    final response = await _apiService.callRequest(
      apiRoute: WebService.login,
      fromJson: LoginResponse.fromJson,
      payload: loginRequest.toJson(),
    );

    return response;
  }
}
