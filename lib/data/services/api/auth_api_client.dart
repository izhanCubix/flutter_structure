// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:io';
import 'package:base_structure/data/services/api/models/login_request/login_request.dart';
import 'package:base_structure/data/services/api/models/login_response/login_response.dart';
import 'package:http/http.dart' as http;

import '../../../../utils/result.dart';

class AuthApiClient {
  AuthApiClient();

  final String baseUrl = "reqres.in";
  final client = http.Client();

  Future<Result<LoginResponse>> login(LoginRequest loginRequest) async {
    try {
      final res = await client.post(
        Uri.https(baseUrl, '/api/login'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': 'reqres-free-v1',
        },
        body: jsonEncode(loginRequest.toJson()),
      );
      if (res.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(
          jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>,
        );
        return Result.ok(loginResponse);
      } else {
        return const Result.error(
          HttpException("Fetching login details failed"),
        );
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }
}
