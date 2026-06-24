import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strobilus/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:confetti/confetti.dart';
import 'package:strobilus/presentation/providers/auth_provider.dart';
import 'package:strobilus/presentation/providers/collection_provider.dart';
import 'package:strobilus/presentation/providers/connectivity_provider.dart';
import 'package:strobilus/data/models/achievement_model.dart';
import '../../../core/theme/app_color_palettes.dart';
import '../../../core/theme/design_system.dart';

/// Bottom navigation shell wrapping tab pages.
class MainShell extends StatefulWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell>
    with SingleTickerProviderStateMixin {
  static const _tabs = [
    '/map',
    '/collection',
    '/add-cone',
    '/species',
    '/profile',
  ];

  bool _showCoachMark = false;
  late AnimationController _pulseController;
  StreamSubscription<String>? _achievementSub;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (auth.isAuthenticated) {
        final collectionProvider = context.read<CollectionProvider>();
        collectionProvider.loadCones(auth.firebaseUser!.uid);
        // Listen for collection loaded to decide coach mark
        collectionProvider.addListener(_checkCoachMark);
        
        // Listen for achievements
        _achievementSub = collectionProvider.onAchievementUnlocked.listen((achievementId) {
          _showAchievementDialog(achievementId);
        });
      }
    });
  }

  void _showAchievementDialog(String achievementId) {
    final achievement = AchievementModel.phase1Achievements.firstWhere(
      (a) => a.id == achievementId,
      orElse: () => AchievementModel.phase1Achievements.first,
    );
    
    final confettiController = ConfettiController(duration: const Duration(seconds: 3));
    confettiController.play();

    showDialog(
      context: context,
      builder: (context) {
        return Stack(
          alignment: Alignment.center,
          children: [
            AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: DS.borderRadiusLg),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(achievement.icon, size: 48, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: DS.md),
                  Text(
                    'Succès Déverrouillé !',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Nouveau succès (ID: \${achievement.id})',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: DS.sm),
                  Text(
                    'Bravo ! Continue tes recherches.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Génial !'),
                ),
              ],
            ),
            Positioned(
              top: 50,
              child: ConfettiWidget(
                confettiController: confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
              ),
            ),
          ],
        );
      },
    ).then((_) => confettiController.dispose());
  }

  void _checkCoachMark() {
    final collection = context.read<CollectionProvider>();
    if (collection.allCones.isEmpty && !_showCoachMark) {
      setState(() => _showCoachMark = true);
    }
  }

  void _dismissCoachMark() {
    setState(() => _showCoachMark = false);
    context.read<CollectionProvider>().removeListener(_checkCoachMark);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _achievementSub?.cancel();
    super.dispose();
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
    final theme = Theme.of(context);

    final isOffline = !context.watch<ConnectivityProvider>().isOnline;

    return Stack(
      children: [
        Scaffold(
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
          _dismissCoachMark();
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
        ),

        // Coach Mark Overlay
        if (_showCoachMark)
          GestureDetector(
            onTap: _dismissCoachMark,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Container(
                  color: Colors.black.withValues(alpha: 0.65),
                  child: Stack(
                    children: [
                      // Arrow + text pointing to FAB
                      Positioned(
                        bottom: 110,
                        left: 0,
                        right: 0,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: DS.xl),
                              padding: const EdgeInsets.all(DS.lg),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                borderRadius: DS.borderRadiusLg,
                                boxShadow: DS.shadowElevated(theme),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    l10n.coachMarkTitle,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: DS.xs),
                                  Text(
                                    l10n.coachMarkBody,
                                    style: theme.textTheme.bodyMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: DS.sm),
                            // Pulsing arrow
                            Transform.translate(
                              offset: Offset(0, _pulseController.value * 8),
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                size: 40,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

        // Offline Banner Overlay
        if (isOffline)
          Positioned(
            top: MediaQuery.of(context).padding.top + DS.xs,
            left: DS.md,
            right: DS.md,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: DS.md, vertical: DS.sm),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer.withValues(alpha: 0.9),
                borderRadius: DS.borderRadiusMd,
                boxShadow: DS.shadowElevated(theme),
              ),
              child: Row(
                children: [
                  Icon(Icons.cloud_off, color: theme.colorScheme.onErrorContainer, size: 20),
                  const SizedBox(width: DS.sm),
                  Expanded(
                    child: Text(
                      'Mode hors-ligne. Synchronisation en pause.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onErrorContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
