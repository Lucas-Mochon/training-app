import 'package:flutter/material.dart';
import 'package:frontend/views/home_view.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeView());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Erreur')),
        body: const Center(child: Text('Page non trouvée!')),
      ),
    );
  }
}
