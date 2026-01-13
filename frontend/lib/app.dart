import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/components/bottomNavbar.dart';
import 'package:frontend/routes.dart';
import 'package:frontend/store/auth_store.dart';
import 'package:frontend/views/user/login.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthStore>();

    if (!auth.isAuthenticated) {
      return const LoginPage();
    }

    return Scaffold(
      body: Navigator(
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
      bottomNavigationBar: const BottomNavbar(),
    );
  }
}
