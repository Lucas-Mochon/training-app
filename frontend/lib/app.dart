import 'package:flutter/material.dart';
import 'package:frontend/components/bottomNavbar.dart';
import 'package:frontend/routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        initialRoute: '/login',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
      bottomNavigationBar: const BottomNavbar(),
    );
  }
}
