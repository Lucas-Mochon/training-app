import 'package:flutter/material.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '/';

    final routes = ['/', '/exercises', '/workouts', '/profile'];
    final currentIndex = routes.indexOf(currentRoute);
    final safeIndex = currentIndex == -1 ? 0 : currentIndex;

    return BottomNavigationBar(
      currentIndex: safeIndex,
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
        String route = routes[index];
        Navigator.pushReplacementNamed(context, route);
      },
    );
  }
}
