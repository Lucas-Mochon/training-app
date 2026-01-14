import 'package:flutter/material.dart';
import 'package:frontend/components/bottomNavbar.dart';
// import 'package:frontend/components/bottomNavbar.dart';
// import 'package:frontend/navigator.dart';
import 'package:frontend/store/auth_store.dart';
import 'package:frontend/views/exercise/index.dart';
import 'package:frontend/views/home_view.dart';
import 'package:frontend/views/user/login.dart';
import 'package:frontend/views/user/profil.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;

  final _pages = [HomeView(), ExercisePage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthStore>();

    if (!auth.isAuthenticated) {
      return const LoginPage();
    }

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavbar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
