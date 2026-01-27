import 'package:flutter/material.dart';
import 'package:frontend/components/bottom_navbar.dart';
import 'package:frontend/store/auth_store.dart';
import 'package:frontend/views/exercise/index.dart';
import 'package:frontend/views/home_view.dart';
import 'package:frontend/views/training/index.dart';
import 'package:frontend/views/user/login.dart';
import 'package:frontend/views/user/profil.dart';
import 'package:frontend/views/workout/index.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomeView(),
      const WorkoutPage(),
      const TrainingPage(),
      const ExercisePage(),
      const ProfilPage(),
    ];
  }

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
