// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:base_structure/data/repositories/auth/auth_repository.dart';
import 'package:base_structure/utils/navigation_service.dart';
import 'package:base_structure/views/home/widgets/home_screen.dart';
import 'package:base_structure/views/login/view_models/login_viewmodel.dart';
import 'package:base_structure/views/login/widgets/login_screen.dart';
import 'package:base_structure/views/profile/view_models/profile_viewmodel.dart';
import 'package:base_structure/views/profile/widgets/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'routes.dart';

GoRouter router(AuthRepository authRepository) => GoRouter(
  initialLocation: Routes.login,
  navigatorKey: NavigationService.navigatorKey,
  debugLogDiagnostics: true,
  refreshListenable: authRepository,
  redirect: _redirect,
  routes: [
    GoRoute(
      path: Routes.login,
      builder: (context, state) {
        return LoginScreen(
          viewModel: LoginViewModel(authRepository: context.read()),
        );
      },
    ),
    GoRoute(
      path: Routes.home,
      builder: (context, state) {
        return HomeScreen();
      },
      routes: [
        GoRoute(
          path: Routes.profileRelative,
          builder: (context, state) {
            return ProfileScreen(
              viewmodel: ProfileViewmodel(authRepository: context.read()),
            );
          },
        ),
      ],
    ),
  ],
);

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  // if the user is not logged in, they need to login
  final loggedIn = await context.read<AuthRepository>().isAuthenticated;
  print('User logged in: $loggedIn');
  final loggingIn = state.matchedLocation == Routes.login;
  if (!loggedIn) {
    return Routes.login;
  }

  // if the user is logged in but still on the login page, send them to
  // the home page
  if (loggingIn) {
    return Routes.home;
  }

  // no need to redirect at all
  return null;
}
