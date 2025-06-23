import 'package:base_structure/config/metrics.dart';
import 'package:base_structure/routing/routes.dart';
import 'package:base_structure/theme/fonts.dart';
import 'package:base_structure/theme/images.dart';
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
        child: Column(
          children: [
            Image.asset(Images.logo, width: 50, height: 50),
            Text(
              'Go to Profile',
              style: TextStyle(fontFamily: Fonts.dmSansMediumItalic),
            ),
            ElevatedButton(
              onPressed: () {
                NavigationService.go(Routes.profile);
              },
              child: Text('Click'),
            ),
          ],
        ),
      ),
    );
  }
}
