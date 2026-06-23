import 'package:flutter/material.dart';
import 'package:strobilus/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/design_system.dart';
import '../../../presentation/providers/auth_provider.dart';

/// 3-slide onboarding carousel.
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final ext = theme.extension<StrobilusExtension>()!;

    final slides = [
      _OnboardingSlide(
        icon: '🗺',
        title: l10n.onboardingTitle1,
        body: l10n.onboardingBody1,
        color: ext.palette.primary,
      ),
      _OnboardingSlide(
        icon: '🔬',
        title: l10n.onboardingTitle2,
        body: l10n.onboardingBody2,
        color: ext.palette.secondary,
      ),
      _OnboardingSlide(
        icon: '📊',
        title: l10n.onboardingTitle3,
        body: l10n.onboardingBody3,
        color: ext.palette.tertiary,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _completeOnboarding,
                child: Text(l10n.skip),
              ),
            ),

            // Carousel
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: slides.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (_, index) => slides[index],
              ),
            ),

            // Page indicators
            Padding(
              padding: const EdgeInsets.symmetric(vertical: DS.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(slides.length, (index) {
                  return AnimatedContainer(
                    duration: DS.fast,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? ext.palette.primary
                          : ext.palette.divider,
                      borderRadius: DS.borderRadiusFull,
                    ),
                  );
                }),
              ),
            ),

            // Next / Get Started button
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DS.lg,
                vertical: DS.md,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage < slides.length - 1) {
                      _pageController.nextPage(
                        duration: DS.medium,
                        curve: DS.defaultCurve,
                      );
                    } else {
                      _completeOnboarding();
                    }
                  },
                  child: Text(
                    _currentPage < slides.length - 1
                        ? l10n.next
                        : l10n.onboardingGetStarted,
                  ),
                ),
              ),
            ),
            const SizedBox(height: DS.md),
          ],
        ),
      ),
    );
  }

  void _completeOnboarding() {
    context.read<AuthProvider>().completeOnboarding();
    context.go('/privacy');
  }
}

class _OnboardingSlide extends StatelessWidget {
  final String icon;
  final String title;
  final String body;
  final Color color;

  const _OnboardingSlide({
    required this.icon,
    required this.title,
    required this.body,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DS.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated icon circle
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 72)),
            ),
          ),
          const SizedBox(height: DS.xl),
          Text(
            title,
            style: Theme.of(context).textTheme.displaySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DS.md),
          Text(
            body,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
