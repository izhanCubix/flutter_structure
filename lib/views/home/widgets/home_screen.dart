import 'package:base_structure/config/metrics.dart';
import 'package:base_structure/routing/routes.dart';
import 'package:base_structure/utils/navigation_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Container(
        padding: EdgeInsets.only(top: Metrics.largeMargin),
        child: ElevatedButton(
          onPressed: () {
            NavigationService.go(Routes.profile);
          },
          child: Text('Go to Profile'),
        ),
      ),
    );
  }
}
