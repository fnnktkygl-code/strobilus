import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:strobilus/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/design_system.dart';
import '../../../data/models/achievement_model.dart';
import '../../../data/models/user_model.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../../presentation/providers/collection_provider.dart';

/// User profile page with stats, avatar, and navigation to settings/achievements.
/// Redesigned with Premium Glassmorphism.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  LinearGradient _getFullScreenGradient(String? themeName) {
    switch (themeName) {
      case 'ocean':
        return const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF0D9488)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'arctic':
        return const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E3A8A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'autumn':
        return const LinearGradient(
          colors: [Color(0xFF2C1910), Color(0xFF9A3412)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'desert':
        return const LinearGradient(
          colors: [Color(0xFF2D1B0E), Color(0xFF9C4221)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'midnight':
        return const LinearGradient(
          colors: [Color(0xFF0D1117), Color(0xFF1B4332)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'forest':
      default:
        return const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF064E3B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final auth = context.watch<AuthProvider>();
    final collection = context.watch<CollectionProvider>();
    final user = auth.userModel;

    final hasAvatar =
        user?.avatarUrl != null || auth.firebaseUser?.photoURL != null;
    final avatarProvider = user?.avatarUrl != null
        ? NetworkImage(user!.avatarUrl!)
        : (auth.firebaseUser?.photoURL != null
              ? NetworkImage(auth.firebaseUser!.photoURL!)
              : null);

    final displayName =
        user?.displayName ?? auth.firebaseUser?.displayName ?? 'User';
    final profileBgTheme = user?.profileBackgroundTheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Full Screen Premium Gradient or Custom Background Image
          Container(
            decoration: BoxDecoration(
              gradient: user?.backgroundImageUrl == null ? _getFullScreenGradient(profileBgTheme) : null,
              image: user?.backgroundImageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(user!.backgroundImageUrl!),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withValues(alpha: 0.5),
                        BlendMode.darken,
                      ),
                    )
                  : null,
            ),
          ),

          // Custom Banner Image if set
          if (user?.bannerUrl != null && user?.profileBackgroundTheme == null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 250,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(user!.bannerUrl!, fit: BoxFit.cover),
                  // Gradient fade to blend image into background
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          _getFullScreenGradient(profileBgTheme).colors.first,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: DS.lg),
              child: Column(
                children: [
                  const SizedBox(height: DS.xxl),

                  // ── Avatar & Info ──
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.4),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: const Color(0xFF10B981).withValues(alpha: 0.2),
                        backgroundImage: avatarProvider as ImageProvider?,
                        child: !hasAvatar
                            ? Text(
                                displayName.isNotEmpty
                                    ? displayName[0].toUpperCase()
                                    : 'U',
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: DS.md),
                  Text(
                    displayName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    auth.firebaseUser?.email ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),

                  // Biography
                  if (user?.bio != null && user!.bio!.isNotEmpty) ...[
                    const SizedBox(height: DS.md),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: DS.lg),
                      child: Text(
                        user.bio!,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],

                  const SizedBox(height: DS.md),

                  // Action Buttons (Glassmorphism)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => context.push('/profile/edit'),
                        icon: const Icon(Icons.edit_outlined, size: 16, color: Colors.white),
                        label: Text(l10n.profileEditProfile, style: const TextStyle(color: Colors.white)),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                          backgroundColor: Colors.white.withValues(alpha: 0.1),
                          padding: const EdgeInsets.symmetric(
                            horizontal: DS.lg,
                            vertical: DS.sm,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: DS.borderRadiusFull,
                          ),
                        ),
                      ),
                      const SizedBox(width: DS.sm),
                      OutlinedButton.icon(
                        onPressed: () => context.push('/leaderboard'),
                        icon: const Icon(Icons.leaderboard, size: 16, color: Colors.white),
                        label: const Text('Classement', style: TextStyle(color: Colors.white)),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                          backgroundColor: Colors.white.withValues(alpha: 0.1),
                          padding: const EdgeInsets.symmetric(
                            horizontal: DS.lg,
                            vertical: DS.sm,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: DS.borderRadiusFull,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: DS.xl),
                  if (user != null) _GamificationBanner(user: user),
                  const SizedBox(height: DS.xl),

                  // ── Stats Row (Glassmorphism) ──
                  Row(
                    children: [
                      _GlassStatCard(
                        label: l10n.profileCones,
                        value: '${collection.totalCones}',
                        iconWidget: Transform.scale(
                          scale: 2.0,
                          child: Image.asset(
                            'assets/images/logo_squared.png',
                            width: 32,
                            height: 32,
                          ),
                        ),
                      ),
                      const SizedBox(width: DS.md),
                      _GlassStatCard(
                        label: l10n.profileSpecies,
                        value: '${collection.uniqueSpeciesCount}',
                        iconWidget: const Text('🧬', style: TextStyle(fontSize: 24)),
                      ),
                      const SizedBox(width: DS.md),
                      _GlassStatCard(
                        label: l10n.profileCountries,
                        value: '${collection.countriesCount}',
                        iconWidget: const Text('🌍', style: TextStyle(fontSize: 24)),
                      ),
                    ],
                  ),
                  const SizedBox(height: DS.xl),

                  // ── Premium Achievements Shortcut ──
                  _buildAchievementsBanner(context, user, l10n),
                  
                  const SizedBox(height: DS.xl),

                  // ── Recent Activity (Glassmorphism) ──
                  _buildRecentActivity(context, collection, l10n),
                  
                  const SizedBox(height: DS.xxxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsBanner(BuildContext context, dynamic user, AppLocalizations l10n) {
    final unlockedCount = user?.unlockedAchievementIds.length ?? 0;
    final claimableCount = user?.claimableAchievementIds.length ?? 0;
    final showBadge = claimableCount > 0;

    return GestureDetector(
      onTap: () => context.push('/achievements'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: showBadge ? Colors.amber : Colors.white.withValues(alpha: 0.1),
            width: showBadge ? 2 : 1,
          ),
          boxShadow: showBadge
              ? [BoxShadow(color: Colors.amber.withValues(alpha: 0.3), blurRadius: 15)]
              : [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10)],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: const EdgeInsets.all(DS.lg),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text('🏆', style: TextStyle(fontSize: 32)),
                          const SizedBox(width: DS.md),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.achievementsTitle,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              if (user != null)
                                Text(
                                  '${user.xpPoints} XP • Level ${user.level}',
                                  style: const TextStyle(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      if (showBadge)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '+$claimableCount',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        )
                      else
                        const Icon(Icons.chevron_right, color: Colors.white),
                    ],
                  ),
                  
                  if (unlockedCount > 0) ...[
                    const SizedBox(height: DS.md),
                    const Divider(color: Colors.white24, height: 1),
                    const SizedBox(height: DS.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: user!.unlockedAchievementIds.take(4).map<Widget>(
                        (id) {
                          final achievement = AchievementModel
                              .phase1Achievements
                              .firstWhere((a) => a.id == id, orElse: () => AchievementModel.phase1Achievements.first);
                          return Tooltip(
                            message: achievement.titleKey,
                            child: Container(
                              padding: const EdgeInsets.all(DS.sm),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                              ),
                              child: Icon(
                                achievement.icon,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context, CollectionProvider collection, AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(DS.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(Icons.history, color: Colors.white70),
                    const SizedBox(width: DS.sm),
                    Text(
                      l10n.profileRecentActivity,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: DS.md),
                if (collection.totalCones == 0)
                  Text(
                    l10n.collectionEmpty,
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                  )
                else
                  Text(
                    l10n.conesCollected(collection.totalCones),
                    style: const TextStyle(color: Colors.white),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassStatCard extends StatelessWidget {
  final String label;
  final String value;
  final Widget iconWidget;

  const _GlassStatCard({
    required this.label,
    required this.value,
    required this.iconWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: DS.lg,
                horizontal: DS.sm,
              ),
              child: Column(
                children: [
                  iconWidget,
                  const SizedBox(height: DS.sm),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GamificationBanner extends StatelessWidget {
  final UserModel user;
  
  const _GamificationBanner({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DS.md),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: DS.borderRadiusLg,
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Streak
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.local_fire_department, color: Colors.orange, size: 28),
                    const SizedBox(width: DS.xs),
                    Text(
                      '\${user.currentStreak}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Jours consécutifs',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          // Divider
          Container(
            height: 40,
            width: 1,
            color: Colors.white.withValues(alpha: 0.2),
          ),
          
          // XP & Level
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 28),
                    const SizedBox(width: DS.xs),
                    Flexible(
                      child: Text(
                        '\${user.xpPoints} XP',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              Text(
                'Niveau \${user.level}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          )
        ],
      ),
    );
  }
}
