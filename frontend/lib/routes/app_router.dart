import 'package:go_router/go_router.dart';

import '../core/storage/token_storage.dart';
import '../screens/auth/login_page.dart';
import '../screens/auth/splash_page.dart';
import '../screens/home/home_page.dart';
import 'app_routes.dart';
import '../screens/auth/register_page.dart';
import '../screens/profile/profile_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  redirect: (context, state) async {
    if (state.matchedLocation == AppRoutes.splash) return null;

    final token = await TokenStorage().getToken();
    final isLoggedIn = token != null;
    const publicRoutes = [AppRoutes.login, AppRoutes.register];
    final isPublic = publicRoutes.contains(state.matchedLocation);

    if (!isLoggedIn && !isPublic) return AppRoutes.login;
    if (isLoggedIn && isPublic) return AppRoutes.home;
    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => const ProfilePage(),
    ),
  ],
);