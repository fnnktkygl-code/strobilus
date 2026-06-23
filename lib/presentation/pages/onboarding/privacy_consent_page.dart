import 'package:flutter/material.dart';
import 'package:strobilus/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/design_system.dart';

/// GDPR-compliant privacy consent screen.
class PrivacyConsentPage extends StatefulWidget {
  const PrivacyConsentPage({super.key});

  @override
  State<PrivacyConsentPage> createState() => _PrivacyConsentPageState();
}

class _PrivacyConsentPageState extends State<PrivacyConsentPage> {
  bool _hasScrolledToBottom = false;
  bool _analyticsAccepted = false;
  bool _personalizationAccepted = false;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients &&
          _scrollController.position.maxScrollExtent <= 0) {
        setState(() => _hasScrolledToBottom = true);
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.atEdge &&
        _scrollController.position.pixels != 0) {
      setState(() => _hasScrolledToBottom = true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.privacyTitle)),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(DS.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.privacySubtitle, style: theme.textTheme.bodyLarge),
                  const SizedBox(height: DS.lg),
                  _PrivacyItem(
                    icon: Icons.location_on_outlined,
                    text: l10n.privacyLocationData,
                  ),
                  const SizedBox(height: DS.md),
                  _PrivacyItem(
                    icon: Icons.photo_camera_outlined,
                    text: l10n.privacyPhotos,
                  ),
                  const SizedBox(height: DS.xl),
                  // Toggles
                  SwitchListTile(
                    title: Text(l10n.privacyAnalytics),
                    value: _analyticsAccepted,
                    onChanged: (v) => setState(() => _analyticsAccepted = v),
                  ),
                  SwitchListTile(
                    title: Text(l10n.privacyPersonalization),
                    value: _personalizationAccepted,
                    onChanged: (v) =>
                        setState(() => _personalizationAccepted = v),
                  ),
                  const SizedBox(height: DS.xxxl),
                ],
              ),
            ),
          ),
          // Agree button
          Padding(
            padding: const EdgeInsets.all(DS.lg),
            child: Column(
              children: [
                if (!_hasScrolledToBottom)
                  Padding(
                    padding: const EdgeInsets.only(bottom: DS.sm),
                    child: Text(
                      l10n.privacyMustScroll,
                      style: theme.textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _hasScrolledToBottom
                        ? () => context.go('/auth/login')
                        : null,
                    child: Text(l10n.privacyAgree),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrivacyItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _PrivacyItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: DS.md),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}
