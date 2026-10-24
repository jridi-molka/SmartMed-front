import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    context.read<UserProvider>().loadUser();
  }

  Future<void> _logout() async {
    final userProvider = context.read<UserProvider>();
    try {
      await _authService.logout();
    } catch (_) {
      // Le service supprime déjà le token local dans tous les cas.
    }
    userProvider.clear();
    if (!mounted) return;
    context.go(AppRoutes.login);
  }

  Widget _buildContent(UserProvider provider) {
    if (provider.isLoading) return const CircularProgressIndicator();

    final error = provider.error;
    if (error != null) return Text(error);

    final user = provider.user;
    if (user == null) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Bonjour, ${user.name} !',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(user.email),
        const SizedBox(height: 4),
        Text('Rôle : ${user.role}'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartMed'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: 'Mon profil',
            onPressed: () => context.push(AppRoutes.profile),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Se déconnecter',
            onPressed: _logout,
          ),
        ],
      ),
      body: Center(child: _buildContent(provider)),
    );
  }
}