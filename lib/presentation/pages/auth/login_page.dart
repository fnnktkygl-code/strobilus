import 'package:flutter/material.dart';
import 'package:strobilus/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/design_system.dart';
import '../../widgets/common/strobilus_snack_bar.dart';
import '../../../presentation/providers/auth_provider.dart';

/// Email + password login page.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo
                    Hero(
                      tag: 'app_logo',
                      child: Transform.scale(
                        scale: 2.0,
                        child: Image.asset(
                          'assets/images/logo_squared.png',
                          height: 120,
                        ),
                      ),
                    ),
                    const SizedBox(height: DS.sm),
                    Text(
                      'STROBILUS',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        letterSpacing: 3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: DS.xxl),

                    // Email field
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: l10n.authEmail,
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.errorInvalidEmail;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: DS.md),

                    // Password field
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
                          onPressed: () {
                            setState(
                              () => _obscurePassword = !_obscurePassword,
                            );
                          },
                        ),
                      ),
                      obscureText: _obscurePassword,
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return l10n.errorWeakPassword;
                        }
                        return null;
                      },
                    ),

                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _handleForgotPassword,
                        child: Text(l10n.authForgotPassword),
                      ),
                    ),

                    // Error message
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

                    // Login button
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: auth.isLoading ? null : _handleLogin,
                        child: auth.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(l10n.authSignIn),
                      ),
                    ),
                    const SizedBox(height: DS.lg),

                    // Register link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(l10n.authNoAccount),
                        TextButton(
                          onPressed: () => context.go('/auth/register'),
                          child: Text(l10n.authSignUp),
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

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context
          .read<AuthProvider>()
          .signInWithEmail(
            _emailController.text.trim(),
            _passwordController.text,
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

  void _handleForgotPassword() {
    final email = _emailController.text.trim();
    if (email.isNotEmpty) {
      context.read<AuthProvider>().sendPasswordResetEmail(email);
      StrobilusSnackBar.success(context, AppLocalizations.of(context).authPasswordReset);
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
        return l10n.errorAuthNotEnabled;
      default:
        return errorKey;
    }
  }
}
