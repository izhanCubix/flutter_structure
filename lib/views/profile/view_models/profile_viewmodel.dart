// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:base_structure/data/repositories/auth/auth_repository.dart';
import 'package:logging/logging.dart';

import '../../../../utils/command.dart';
import '../../../../utils/result.dart';

class ProfileViewmodel {
  ProfileViewmodel({required AuthRepository authRepository})
    : _authRepository = authRepository {
    logout = Command0(_logout);
  }

  final AuthRepository _authRepository;
  final _log = Logger('ProfileViewmodel');

  late Command0 logout;

  Future<Result<void>> _logout() async {
    //REPOSITORY API ACTION CALL HERE
    final result = await _authRepository.logout();

    if (result is Error<void>) {
      _log.warning('logout failed! ${result.error}');
    }

    return result;
  }
}
