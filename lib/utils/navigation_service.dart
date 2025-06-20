import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static GoRouter get router => GoRouter.of(navigatorKey.currentContext!);

  static BuildContext? get context => navigatorKey.currentContext;

  static void go(String route, {Object? extra}) {
    router.go(route, extra: extra);
  }

  static void push(String route, {Object? extra}) {
    router.push(route, extra: extra);
  }

  static void pop() {
    navigatorKey.currentState?.pop();
  }

  static void replace(String route, {Object? extra}) {
    router.go(route, extra: extra); // GoRouter doesn't have replace directly
  }

  static void goBackWithKeyboardHide() {
    FocusManager.instance.primaryFocus?.unfocus();
    Future.delayed(const Duration(milliseconds: 200), () {
      pop();
    });
  }
}
