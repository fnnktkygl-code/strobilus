import 'package:flutter/material.dart';
import 'package:strobilus/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/extensions/enum_extensions.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/color_themes.dart';
import '../../../core/theme/design_system.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/locale/locale_provider.dart';
import '../../../data/services/firebase/firestore_service.dart';
import '../../../data/services/firebase/storage_service.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../../presentation/providers/collection_provider.dart';

/// Settings page with account, theme, language, and privacy sections.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final ext = theme.extension<StrobilusExtension>()!;
    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        children: [
          // === ACCOUNT ===
          _SectionHeader(title: l10n.settingsAccount),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(l10n.profileEditProfile),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/profile/edit'),
          ),
          const Divider(),

          // === APP ===
          _SectionHeader(title: l10n.settingsApp),

          // Language
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.settingsLanguage),
            trailing: DropdownButton<String>(
              value: localeProvider.locale.languageCode,
              underline: const SizedBox.shrink(),
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'fr', child: Text('Français')),
              ],
              onChanged: (code) {
                if (code != null) {
                  localeProvider.setLocale(Locale(code));
                }
              },
            ),
          ),

          // Brightness
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: Text(l10n.settingsLightDark),
            trailing: SegmentedButton<ThemeBrightness>(
              segments: const [
                ButtonSegment(
                  value: ThemeBrightness.light,
                  icon: Icon(Icons.light_mode, size: 18),
                ),
                ButtonSegment(
                  value: ThemeBrightness.system,
                  icon: Icon(Icons.auto_awesome, size: 18),
                ),
                ButtonSegment(
                  value: ThemeBrightness.dark,
                  icon: Icon(Icons.dark_mode, size: 18),
                ),
              ],
              selected: {themeProvider.brightness},
              onSelectionChanged: (set) {
                themeProvider.setBrightness(set.first);
              },
            ),
          ),

          // Color theme
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: Text(l10n.settingsColorTheme),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: DS.lg),
            child: Wrap(
              spacing: DS.sm,
              runSpacing: DS.sm,
              children: StrobilusColorTheme.values.map((ct) {
                final isSelected = themeProvider.colorTheme == ct;
                return GestureDetector(
                  onTap: () => themeProvider.setColorTheme(ct),
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: DS.borderRadiusMd,
                      border: isSelected
                          ? Border.all(color: ext.palette.primary, width: 3)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: _themePreviewColor(ct),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          ct.label(context),
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontSize: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: DS.md),
          const Divider(),

          // === PRIVACY ===
          _SectionHeader(title: l10n.settingsPrivacy),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(l10n.settingsPrivacyPolicy),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(l10n.settingsTerms),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(),

          // === ABOUT ===
          _SectionHeader(title: l10n.settingsAbout),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.settingsVersion),
            trailing: const Text('1.0.0'),
          ),
          ListTile(
            leading: const Icon(Icons.article_outlined),
            title: Text(l10n.settingsLicenses),
            onTap: () => showLicensePage(context: context),
          ),
          const Divider(),

          // Sign out
          ListTile(
            leading: Icon(Icons.logout, color: theme.colorScheme.onSurface),
            title: Text(l10n.authSignOut),
            onTap: () {
              context.read<CollectionProvider>().clear();
              context.read<AuthProvider>().signOut();
              context.go('/auth/login');
            },
          ),

          // Reset Account
          ListTile(
            leading: Icon(Icons.restart_alt, color: theme.colorScheme.error),
            title: Text(
              l10n.settingsResetAccount,
              style: TextStyle(color: theme.colorScheme.error),
            ),
            onTap: () => _showResetAccountDialog(context, l10n, theme),
          ),

          // Delete Account
          ListTile(
            leading: Icon(Icons.delete_forever, color: theme.colorScheme.error),
            title: Text(
              l10n.settingsDeleteAccount,
              style: TextStyle(color: theme.colorScheme.error),
            ),
            onTap: () => _showDeleteAccountDialog(context, l10n, theme),
          ),
          const SizedBox(height: DS.xxxl),
        ],
      ),
    );
  }

  Future<void> _showDeleteAccountDialog(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.settingsDeleteAccount),
        content: Text(l10n.settingsDeleteAccountConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.settingsDeleteAccountCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
            ),
            child: Text(l10n.settingsDeleteAccountAction),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final firestoreService = context.read<FirestoreService>();
      final storageService = context.read<StorageService>();
      final authProvider = context.read<AuthProvider>();

      context.read<CollectionProvider>().clear();

      await authProvider.deleteAccount(firestoreService, storageService);

      if (context.mounted) {
        if (authProvider.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Error: ${authProvider.error} - Please log in again to delete your account.',
              ),
              backgroundColor: theme.colorScheme.error,
            ),
          );
        } else {
          context.go('/auth/login');
        }
      }
    }
  }

  Future<void> _showResetAccountDialog(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.settingsResetAccount),
        content: Text(l10n.settingsResetAccountConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.settingsResetAccountCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
            ),
            child: Text(l10n.settingsResetAccountAction),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final firestoreService = context.read<FirestoreService>();
      final storageService = context.read<StorageService>();
      final authProvider = context.read<AuthProvider>();

      context.read<CollectionProvider>().clear();

      await authProvider.resetAccount(firestoreService, storageService);

      if (context.mounted) {
        if (authProvider.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${authProvider.error}'),
              backgroundColor: theme.colorScheme.error,
            ),
          );
        } else {
          // Send to main screen
          context.go('/');
        }
      }
    }
  }

  Color _themePreviewColor(StrobilusColorTheme ct) {
    return switch (ct) {
      StrobilusColorTheme.forest => const Color(0xFF2D6A4F),
      StrobilusColorTheme.arctic => const Color(0xFF2B6CB0),
      StrobilusColorTheme.autumn => const Color(0xFFC05621),
      StrobilusColorTheme.ocean => const Color(0xFF0E7490),
      StrobilusColorTheme.desert => const Color(0xFF9C4221),
      StrobilusColorTheme.midnight => const Color(0xFF39D353),
    };
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(DS.lg, DS.lg, DS.lg, DS.sm),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(letterSpacing: 1),
      ),
    );
  }
}
