import 'package:flutter/material.dart';
import 'package:strobilus/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/design_system.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/firebase/firestore_service.dart';
import '../../../presentation/providers/auth_provider.dart';

/// Email + password registration page.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(DS.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.authRegister,
                      style: theme.textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: DS.xl),

                    // Display name
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: l10n.authDisplayName,
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? l10n.authDisplayName : null,
                    ),
                    const SizedBox(height: DS.md),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: l10n.authEmail,
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      validator: (v) {
                        if (v == null || !v.contains('@')) {
                          return l10n.errorInvalidEmail;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: DS.md),

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: l10n.authPassword,
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                      ),
                      obscureText: _obscurePassword,
                      validator: (v) {
                        if (v == null || v.length < 6) {
                          return l10n.errorWeakPassword;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: DS.md),

                    // Confirm password
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: l10n.authConfirmPassword,
                        prefixIcon: const Icon(Icons.lock_outline),
                      ),
                      obscureText: _obscurePassword,
                      validator: (v) {
                        if (v != _passwordController.text) {
                          return l10n.authConfirmPassword;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: DS.lg),

                    // Error
                    if (auth.error != null) ...[
                      Container(
                        padding: const EdgeInsets.all(DS.md),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error.withValues(alpha: 0.1),
                          borderRadius: DS.borderRadiusMd,
                        ),
                        child: Text(
                          _translateError(context, auth.error!),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                        ),
                      ),
                      const SizedBox(height: DS.md),
                    ],

                    // Register button
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: auth.isLoading ? null : _handleRegister,
                        child: auth.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(l10n.authSignUp),
                      ),
                    ),
                    const SizedBox(height: DS.lg),

                    // Login link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(l10n.authHasAccount),
                        TextButton(
                          onPressed: () => context.go('/auth/login'),
                          child: Text(l10n.authSignIn),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      final firestoreService = context.read<FirestoreService>();
      context
          .read<AuthProvider>()
          .registerWithEmail(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            displayName: _nameController.text.trim(),
            consent: PrivacyConsent(consentedAt: DateTime.now()),
            firestoreService: firestoreService,
          )
          .then((_) {
            if (!mounted) return;
            final auth = context.read<AuthProvider>();
            if (auth.isAuthenticated) {
              context.go('/map');
            }
          });
    }
  }

  String _translateError(BuildContext context, String errorKey) {
    final l10n = AppLocalizations.of(context);
    switch (errorKey) {
      case 'errorWeakPassword':
        return l10n.errorWeakPassword;
      case 'errorEmailInUse':
        return l10n.errorEmailInUse;
      case 'errorInvalidEmail':
        return l10n.errorInvalidEmail;
      case 'errorWrongPassword':
        return l10n.errorWrongPassword;
      case 'errorUserNotFound':
        return l10n.errorUserNotFound;
      case 'errorGeneric':
        return l10n.errorGeneric;
      case 'operation-not-allowed':
        return 'Email/Password Authentication is not enabled in Firebase Console.';
      default:
        return errorKey; // E.g., for e.toString() or other unmapped errors
    }
  }
}
