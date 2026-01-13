import 'package:flutter/material.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    int currentIndex = switch (currentRoute) {
      '/' => 0,
      '/exercises' => 1,
      '/workouts' => 2,
      '/profile' => 3,
      _ => 0,
    };

    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: const Color(0xFFD32F2F),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
        BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center),
          label: 'Exercices',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Entrainement'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/exercises');
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/workouts');
            break;
          case 3:
            Navigator.pushReplacementNamed(context, '/profile');
            break;
        }
      },
    );
  }
}
