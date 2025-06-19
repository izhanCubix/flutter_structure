import 'package:base_structure/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Container(
        child: ElevatedButton(
          onPressed: () {
            context.go(Routes.profile);
          },
          child: Text('Go to Profile'),
        ),
      ),
    );
  }
}
