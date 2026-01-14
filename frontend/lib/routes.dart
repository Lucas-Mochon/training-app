import 'package:flutter/material.dart';
import 'package:frontend/views/home_view.dart';
import 'package:frontend/views/user/login.dart';
import 'package:frontend/views/user/profil.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeView());

      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfilePage());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) =>
          const Scaffold(body: Center(child: Text('Page non trouvée'))),
    );
  }
}
