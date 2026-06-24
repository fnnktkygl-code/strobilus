import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../presentation/pages/add_cone/quick_capture_page.dart';
import '../../presentation/pages/add_cone/manual_add_page.dart';
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/auth/register_page.dart';
import '../../presentation/pages/collection/collection_page.dart';
import '../../presentation/pages/cone_detail/cone_detail_page.dart';
import '../../presentation/pages/cone_detail/edit_cone_page.dart';
import '../../presentation/pages/main_shell/main_shell.dart';
import '../../presentation/pages/map/map_page.dart';
import '../../presentation/pages/onboarding/onboarding_page.dart';
import '../../presentation/pages/onboarding/privacy_consent_page.dart';
import '../../presentation/pages/onboarding/splash_page.dart';
import '../../presentation/pages/profile/achievements_board_page.dart';
import '../../presentation/pages/profile/edit_profile_page.dart';
import '../../presentation/pages/profile/profile_page.dart';
import '../../presentation/pages/profile/leaderboard_page.dart';
import '../../presentation/pages/settings/settings_page.dart';
import '../../presentation/pages/species/species_detail_page.dart';
import '../../presentation/pages/species/species_library_page.dart';
import '../../presentation/providers/auth_provider.dart';
import 'route_names.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  redirect: (context, state) {
    final auth = context.read<AuthProvider>();
    final isAuthenticated = auth.isAuthenticated;
    final isOnboarded = auth.isOnboarded;
    final currentPath = state.matchedLocation;

    // Allow splash, onboarding, privacy, and auth routes without auth
    final publicPaths = [
      '/splash',
      '/onboarding',
      '/privacy',
      '/auth/login',
      '/auth/register',
    ];
    if (publicPaths.contains(currentPath)) return null;

    // Redirect to onboarding if not completed
    if (!isOnboarded && currentPath != '/onboarding') {
      return '/onboarding';
    }

    // Redirect to login if not authenticated
    if (!isAuthenticated) return '/auth/login';

    return null;
  },
  routes: [
    GoRoute(
      path: '/splash',
      name: RouteNames.splash,
      builder: (_, __) => const SplashPage(),
    ),
    GoRoute(
      path: '/onboarding',
      name: RouteNames.onboarding,
      builder: (_, __) => const OnboardingPage(),
    ),
    GoRoute(
      path: '/privacy',
      name: RouteNames.privacy,
      builder: (_, __) => const PrivacyConsentPage(),
    ),
    GoRoute(
      path: '/auth/login',
      name: RouteNames.login,
      builder: (_, __) => const LoginPage(),
    ),
    GoRoute(
      path: '/auth/register',
      name: RouteNames.register,
      builder: (_, __) => const RegisterPage(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (_, __, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/map',
          name: RouteNames.map,
          pageBuilder: (_, __) => const NoTransitionPage(child: MapPage()),
        ),
        GoRoute(
          path: '/collection',
          name: RouteNames.collection,
          pageBuilder: (_, __) =>
              const NoTransitionPage(child: CollectionPage()),
        ),
        GoRoute(
          path: '/species',
          name: RouteNames.species,
          pageBuilder: (_, __) =>
              const NoTransitionPage(child: SpeciesLibraryPage()),
        ),
        GoRoute(
          path: '/profile',
          name: RouteNames.profile,
          pageBuilder: (_, __) => const NoTransitionPage(child: ProfilePage()),
        ),
      ],
    ),
    GoRoute(
      path: '/add-cone',
      name: RouteNames.addCone,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const QuickCapturePage(),
    ),
    GoRoute(
      path: '/manual-add-cone',
      name: RouteNames.manualAddCone,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) {
        // Requires importing ManualAddPage
        return const ManualAddPage();
      },
    ),
    GoRoute(
      path: '/cone/:coneId',
      name: RouteNames.coneDetail,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, state) =>
          ConeDetailPage(coneId: state.pathParameters['coneId']!),
    ),
    GoRoute(
      path: '/edit-cone/:coneId',
      name: RouteNames.editCone,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, state) {
        // We need to import EditConePage for this to work
        return EditConePage(coneId: state.pathParameters['coneId']!);
      },
    ),
    GoRoute(
      path: '/species/:speciesId',
      name: RouteNames.speciesDetail,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, state) =>
          SpeciesDetailPage(speciesId: state.pathParameters['speciesId']!),
    ),
    GoRoute(
      path: '/settings',
      name: RouteNames.settings,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const SettingsPage(),
    ),
    GoRoute(
      path: '/achievements',
      name: RouteNames.achievements,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const AchievementsBoardPage(),
    ),
    GoRoute(
      path: '/profile/edit',
      name: 'editProfile',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const EditProfilePage(),
    ),
    GoRoute(
      path: '/leaderboard',
      name: RouteNames.leaderboard,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const LeaderboardPage(),
    ),
  ],
);
