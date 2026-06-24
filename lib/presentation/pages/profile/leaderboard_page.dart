import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strobilus/l10n/app_localizations.dart';

import '../../../core/theme/design_system.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/firebase/firestore_service.dart';
import '../../../presentation/providers/auth_provider.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  bool _isLoading = true;
  List<UserModel> _topUsers = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchLeaderboard();
  }

  Future<void> _fetchLeaderboard() async {
    try {
      final firestoreService = context.read<FirestoreService>();
      final users = await firestoreService.getLeaderboard();
      setState(() {
        _topUsers = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final currentUser = context.watch<AuthProvider>().userModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Classement Communautaire'), // Fallback if no l10n
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _fetchLeaderboard,
          ),
        ],
      ),
      body: _buildBody(theme, l10n, currentUser),
    );
  }

  Widget _buildBody(
    ThemeData theme,
    AppLocalizations l10n,
    UserModel? currentUser,
  ) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: DS.md),
            Text('Erreur: \$_error'),
            const SizedBox(height: DS.md),
            ElevatedButton(
              onPressed: _fetchLeaderboard,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    if (_topUsers.isEmpty) {
      return const Center(child: Text('Aucun joueur public trouvé.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(DS.md),
      itemCount: _topUsers.length,
      itemBuilder: (context, index) {
        final user = _topUsers[index];
        final isCurrentUser = currentUser?.id == user.id;

        return _buildLeaderboardTile(context, user, index + 1, isCurrentUser);
      },
    );
  }

  Widget _buildLeaderboardTile(
    BuildContext context,
    UserModel user,
    int rank,
    bool isCurrentUser,
  ) {
    final theme = Theme.of(context);

    // Logic for rank colors
    Color? rankColor;
    if (rank == 1) {
      rankColor = Colors.amber;
    } else if (rank == 2) {
      rankColor = Colors.grey.shade400;
    } else if (rank == 3) {
      rankColor = Colors.brown.shade400;
    } else {
      rankColor = theme.colorScheme.onSurfaceVariant;
    }

    return Card(
      elevation: isCurrentUser ? 4 : 1,
      color: isCurrentUser ? theme.colorScheme.primaryContainer : null,
      margin: const EdgeInsets.only(bottom: DS.sm),
      shape: RoundedRectangleBorder(
        borderRadius: DS.borderRadiusMd,
        side: isCurrentUser
            ? BorderSide(color: theme.colorScheme.primary, width: 2)
            : BorderSide.none,
      ),
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 30,
              child: Text(
                '#\$rank',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: rankColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: DS.sm),
            CircleAvatar(
              backgroundImage: user.avatarUrl != null
                  ? NetworkImage(user.avatarUrl!)
                  : null,
              child: user.avatarUrl == null
                  ? Text(
                      user.displayName.isNotEmpty
                          ? user.displayName[0].toUpperCase()
                          : 'U',
                    )
                  : null,
            ),
          ],
        ),
        title: Text(
          user.displayName,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text(
          'Niveau \${user.level} • \${user.totalCones} trouvailles',
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '\${user.xpPoints} XP',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
