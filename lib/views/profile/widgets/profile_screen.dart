import 'package:base_structure/data/repositories/auth/auth_repository.dart';
import 'package:base_structure/views/profile/view_models/profile_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.viewmodel});

  final ProfileViewmodel viewmodel;

  void onLogout() {
    viewmodel.logout.execute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        leading: GestureDetector(
          onTap: () {
            context.pop();
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: ListenableBuilder(
        listenable: viewmodel.logout,
        builder: (context, _) => Container(
          child: ListTile(
            title: Text('Logout'),
            trailing: Icon(Icons.logout),
            onTap: onLogout,
            enabled: !viewmodel.logout.running,
          ),
        ),
      ),
    );
  }
}
