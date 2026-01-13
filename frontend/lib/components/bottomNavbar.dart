import 'package:flutter/material.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
        BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center),
          label: 'Exercices',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Entrainement'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
      ],
      currentIndex: 0,
      selectedItemColor: Color(0xFFD32F2F),
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/');
            break;
          case 1:
            Navigator.pushNamed(context, '/exercises');
            break;
          case 2:
            Navigator.pushNamed(context, '/workouts');
            break;
          case 3:
            Navigator.pushNamed(context, '/profil');
        }
      },
    );
  }
}
