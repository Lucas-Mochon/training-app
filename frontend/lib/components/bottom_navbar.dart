import 'package:flutter/material.dart';

class BottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: const Color(0xFFD32F2F),
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
        BottomNavigationBarItem(
          icon: Icon(Icons.sports_gymnastics),
          label: 'Entrainements',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.flash_on),
          label: 'Entrainements réalisé',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center),
          label: 'Exercices',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
      ],
    );
  }
}
