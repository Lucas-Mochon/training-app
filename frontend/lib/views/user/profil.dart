import 'package:flutter/material.dart';
import 'package:frontend/store/auth_store.dart';
import 'package:frontend/store/page/user/profil_store.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileStore(authStore: context.read<AuthStore>()),
      child: Consumer<ProfileStore>(
        builder: (context, store, _) {
          if (store.isLoading || store.user == null) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (store.error != null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Profile')),
              body: Center(child: Text('Erreur lors de la connexion')),
            );
          }

          final user = store.user!;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Mon Profil'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    store.logout();
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('Email', user['email'] ?? '—'),
                  _buildInfoRow('Level', user['level'] ?? '—'),
                  _buildInfoRow('Goal', user['goal'] ?? '—'),
                  _buildInfoRow('Créé le', _formatDateSafe(user['createdAt'])),
                  _buildInfoRow(
                    'Dernière mise à jour',
                    _formatDateSafe(user['updatedAt']),
                  ),
                  const SizedBox(height: 20),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     // TODO: Ajouter édition du profil
                  //   },
                  //   child: const Text('Modifier mon profil'),
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label : ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _formatDateSafe(String? isoDate) {
    if (isoDate == null) return '—';
    try {
      final date = DateTime.parse(isoDate);
      return '${date.day}/${date.month}/${date.year} à ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return isoDate;
    }
  }
}
