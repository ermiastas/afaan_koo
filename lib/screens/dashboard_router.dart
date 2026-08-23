import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_role.dart';
import '../providers/auth_provider.dart';

import 'home/home_screen.dart';
import 'parent_dashboard_screen.dart';
import 'teacher_dashboard_screen.dart';
import 'admin_dashboard_screen.dart';

class DashboardRouter extends StatelessWidget {
  const DashboardRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    // User is not logged in
    if (!auth.isLoggedIn) {
      return const Scaffold(
        body: Center(
          child: Text('Login required'),
        ),
      );
    }

    // Route according to user role
    switch (auth.role) {
      case UserRole.student:
        return const HomeScreen();

      case UserRole.parent:
        return const ParentDashboardScreen();

      case UserRole.teacher:
        return const TeacherDashboardScreen();

      case UserRole.admin:
        return const AdminDashboardScreen() as Widget;

      case null:
        return const Scaffold(
          body: Center(
            child: Text('User role not assigned'),
          ),
        );
    }
  }
}