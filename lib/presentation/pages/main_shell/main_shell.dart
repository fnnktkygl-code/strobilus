import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strobilus/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:strobilus/presentation/providers/auth_provider.dart';
import 'package:strobilus/presentation/providers/collection_provider.dart';
import '../../../core/theme/app_color_palettes.dart';

/// Bottom navigation shell wrapping tab pages.
class MainShell extends StatefulWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  static const _tabs = [
    '/map',
    '/collection',
    '/add-cone',
    '/species',
    '/profile',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (auth.isAuthenticated) {
        context.read<CollectionProvider>().loadCones(auth.firebaseUser!.uid);
      }
    });
  }

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final index = _tabs.indexOf(location);
    return index >= 0 ? index : 0;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentIndex = _currentIndex(context);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex > 2 ? currentIndex - 1 : currentIndex,
        onDestinationSelected: (index) {
          // Map indices back to routes, skipping the FAB Add button
          final route = index < 2 ? _tabs[index] : _tabs[index + 1];
          context.go(route);
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.map_outlined),
            selectedIcon: const Icon(Icons.map),
            label: l10n.navMap,
          ),
          NavigationDestination(
            icon: const Icon(Icons.collections_outlined),
            selectedIcon: const Icon(Icons.collections),
            label: l10n.navCollection,
          ),
          NavigationDestination(
            icon: const Icon(Icons.catching_pokemon_outlined),
            selectedIcon: const Icon(Icons.catching_pokemon),
            label: l10n.navSpecies,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: l10n.navProfile,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add_cone_fab',
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (ctx) => SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.auto_awesome,
                      color: SemanticColors.warningOchre,
                    ),
                    title: Text(l10n.aiQuickCaptureTitle),
                    subtitle: Text(l10n.aiQuickCaptureSubtitle),
                    onTap: () {
                      Navigator.pop(ctx);
                      context.push('/add-cone');
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.edit_note,
                      color: SemanticColors.infoSky,
                    ),
                    title: Text(l10n.manualEntryTitle),
                    subtitle: Text(l10n.manualEntrySubtitle),
                    onTap: () {
                      Navigator.pop(ctx);
                      context.push('/manual-add-cone');
                    },
                  ),
                ],
              ),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: Text(l10n.navAdd),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
