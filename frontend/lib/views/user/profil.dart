import 'package:flutter/material.dart';
import 'package:frontend/store/page/user/profil_store.dart';
import 'package:provider/provider.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileStore>().fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileStore>(
      builder: (context, store, _) {
        if (store.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (store.error != null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Erreur : ${store.error}', textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: store.fetchProfile,
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            ),
          );
        }

        final user = store.user;

        if (user == null) {
          return const Scaffold(
            body: Center(child: Text('Aucune donnée utilisateur')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Mon Profil'),
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  store.logout();
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ],
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Column(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      child: Icon(Icons.person, size: 40),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user['email'] ?? '—',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Informations',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        _infoRow(
                          Icons.bar_chart,
                          'Niveau',
                          user['level'] ?? '—',
                        ),
                        _infoRow(Icons.flag, 'Objectif', user['goal'] ?? '—'),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dates',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        _infoRow(
                          Icons.calendar_today,
                          'Créé le',
                          _formatDateSafe(user['createdAt']),
                        ),
                        _infoRow(
                          Icons.update,
                          'Dernière mise à jour',
                          _formatDateSafe(user['updatedAt']),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }

  String _formatDateSafe(String? isoDate) {
    if (isoDate == null) return '—';
    try {
      final date = DateTime.parse(isoDate);
      return '${date.day}/${date.month}/${date.year} à '
          '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return isoDate;
    }
  }
}
