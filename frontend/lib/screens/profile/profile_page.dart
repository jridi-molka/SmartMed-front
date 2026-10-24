import 'package:flutter/material.dart';

import '../../core/network/api_exception.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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

  Widget _buildContent() {
    if (_isLoading) return const CircularProgressIndicator();
    if (_error != null) return Text(_error!);

    final user = _user!;
    final initial = user.name.isNotEmpty ? user.name[0].toUpperCase() : '?';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: CircleAvatar(
            radius: 40,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              initial,
              style: const TextStyle(fontSize: 32, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Nom'),
                subtitle: Text(user.name),
              ),
              ListTile(
                leading: const Icon(Icons.email_outlined),
                title: const Text('Email'),
                subtitle: Text(user.email),
              ),
              ListTile(
                leading: const Icon(Icons.badge_outlined),
                title: const Text('Rôle'),
                subtitle: Text(user.role),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mon profil')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: _buildContent(),
          ),
        ),
      ),
    );
  }
}