import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/network/api_exception.dart';
import '../../models/user.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _authService = AuthService();
  User? _user;
  String? _error;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final user = await _authService.getMe();
      if (!mounted) return;
      setState(() => _user = user);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Impossible de joindre le serveur');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    try {
      await _authService.logout();
    } catch (_) {
      // Le service supprime déjà le token local dans tous les cas.
    }
    if (!mounted) return;
    context.go(AppRoutes.login);
  }

  Widget _buildContent() {
    if (_isLoading) return const CircularProgressIndicator();
    if (_error != null) return Text(_error!);

    final user = _user!;
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
      body: Center(child: _buildContent()),
    );
  }
}