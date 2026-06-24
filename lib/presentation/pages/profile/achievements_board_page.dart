import 'dart:math' as math;
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strobilus/l10n/app_localizations.dart';

import '../../../core/theme/design_system.dart';
import '../../../data/models/achievement_model.dart';
import '../../../data/models/pine_cone_model.dart';
import '../../../data/services/firebase/firestore_service.dart';
import '../../providers/auth_provider.dart';

class AchievementsBoardPage extends StatefulWidget {
  const AchievementsBoardPage({super.key});

  @override
  State<AchievementsBoardPage> createState() => _AchievementsBoardPageState();
}

class _AchievementsBoardPageState extends State<AchievementsBoardPage>
    with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  void _fireConfetti() {
    _confettiController.play();
  }

  BadgeState _getBadgeState(
    AchievementModel badge,
    List<String> unlockedIds,
    List<String> claimableIds,
  ) {
    if (claimableIds.contains(badge.id)) return BadgeState.claimable;
    if (unlockedIds.contains(badge.id)) return BadgeState.unlocked;
    return BadgeState.locked;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.userModel;
    final l10n = AppLocalizations.of(context);

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    const allAchievements = AchievementModel.phase1Achievements;
    final unlockedIds = user.unlockedAchievementIds;
    final claimableIds = user.claimableAchievementIds;

    // Categories
    final showcaseBadges = allAchievements
        .where((a) => a.category == AchievementCategory.showcase)
        .toList();
    final docBadges = allAchievements
        .where((a) => a.category == AchievementCategory.documentation)
        .toList();
    final colBadges = allAchievements
        .where((a) => a.category == AchievementCategory.collection)
        .toList();
    final expBadges = allAchievements
        .where((a) => a.category == AchievementCategory.exploration)
        .toList();
    final secBadges = allAchievements
        .where((a) => a.category == AchievementCategory.secret)
        .toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          '',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF064E3B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(DS.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Board
                  _buildHeaderBoard(
                    context,
                    user,
                    unlockedIds.length,
                    allAchievements.length,
                    l10n,
                  ),
                  const SizedBox(height: DS.xl),

                  if (showcaseBadges.isNotEmpty) ...[
                    _buildSectionTitle(
                      Icons.stars,
                      Colors.amber,
                      'Vitrine Personnelle',
                    ),
                    const SizedBox(height: DS.md),
                    _buildBadgeGrid(
                      showcaseBadges,
                      unlockedIds,
                      claimableIds,
                      user,
                    ),
                    const SizedBox(height: DS.xl),
                  ],

                  if (docBadges.isNotEmpty) ...[
                    _buildSectionTitle(
                      Icons.menu_book,
                      Colors.blue,
                      "L'Art de la Botanique & Documentation",
                    ),
                    const SizedBox(height: DS.md),
                    _buildBadgeGrid(docBadges, unlockedIds, claimableIds, user),
                    const SizedBox(height: DS.xl),
                  ],

                  if (colBadges.isNotEmpty) ...[
                    _buildSectionTitle(
                      Icons.layers,
                      Colors.pinkAccent,
                      'Collectionneurs & Acharnés',
                    ),
                    const SizedBox(height: DS.md),
                    _buildBadgeGrid(colBadges, unlockedIds, claimableIds, user),
                    const SizedBox(height: DS.xl),
                  ],

                  if (expBadges.isNotEmpty) ...[
                    _buildSectionTitle(
                      Icons.public,
                      const Color(0xFF10B981),
                      'Exploration & Biomes',
                    ),
                    const SizedBox(height: DS.md),
                    _buildBadgeGrid(expBadges, unlockedIds, claimableIds, user),
                    const SizedBox(height: DS.xl),
                  ],

                  if (secBadges.isNotEmpty) ...[
                    _buildSectionTitle(
                      Icons.lock_outline,
                      Colors.deepPurpleAccent,
                      'Défis Secrets & Insolites',
                    ),
                    const SizedBox(height: DS.md),
                    _buildBadgeGrid(secBadges, unlockedIds, claimableIds, user),
                    const SizedBox(height: DS.xxl),
                  ],
                ],
              ),
            ),
          ),

          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.amber,
                Colors.green,
                Colors.purple,
                Colors.blue,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeGrid(
    List<AchievementModel> badges,
    List<String> unlockedIds,
    List<String> claimableIds,
    dynamic user,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: DS.md,
        mainAxisSpacing: DS.md,
      ),
      itemCount: badges.length,
      itemBuilder: (ctx, i) {
        final badge = badges[i];
        final state = _getBadgeState(badge, unlockedIds, claimableIds);
        return _BadgeCard3D(
          badge: badge,
          state: state,
          floatController: _floatController,
          unlockDate: user.achievementUnlockDates[badge.id],
          userTotalCones: user.totalCones,
          onClaim: () {
            _fireConfetti();
            context.read<AuthProvider>().claimAchievement(
              achievementId: badge.id,
              xpReward: badge.xpReward,
              firestoreService: context.read<FirestoreService>(),
            );
          },
        );
      },
    );
  }

  Widget _buildSectionTitle(IconData icon, Color color, String title) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.5)),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: DS.sm),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderBoard(
    BuildContext context,
    dynamic user,
    int unlockedCount,
    int totalCount,
    AppLocalizations l10n,
  ) {
    final double completionPct = totalCount > 0
        ? (unlockedCount / totalCount) * 100
        : 0;

    return Container(
      padding: const EdgeInsets.all(DS.lg),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF34D399), Color(0xFF047857)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF34D399).withValues(alpha: 0.5),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: user.avatarUrl != null
                        ? ClipOval(
                            child: Image.network(
                              user.avatarUrl!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Center(
                            child: Text(
                              user.displayName.isNotEmpty
                                  ? user.displayName[0].toUpperCase()
                                  : 'U',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                  Positioned(
                    bottom: -8,
                    right: -8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF0F172A),
                          width: 2,
                        ),
                      ),
                      child: Text(
                        'Niv.${user.level}',
                        style: const TextStyle(
                          color: Color(0xFF0F172A),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: DS.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tableau des Succès',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Botaniste • ${user.xpPoints} XP',
                      style: const TextStyle(
                        color: Color(0xFF6EE7B7),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: DS.lg),
          Container(
            padding: const EdgeInsets.all(DS.md),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      'COMPLÉTION',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${completionPct.toInt()}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          '%',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
                Column(
                  children: [
                    Text(
                      'BADGES',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$unlockedCount',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.amber,
                        shadows: [
                          Shadow(color: Color(0x4DFBBF24), blurRadius: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum BadgeState { locked, claimable, unlocked }

class _BadgeCard3D extends StatefulWidget {
  final AchievementModel badge;
  final BadgeState state;
  final AnimationController floatController;
  final VoidCallback? onClaim;
  final DateTime? unlockDate;
  final int userTotalCones;

  const _BadgeCard3D({
    required this.badge,
    required this.state,
    required this.floatController,
    this.onClaim,
    this.unlockDate,
    this.userTotalCones = 0,
  });

  @override
  State<_BadgeCard3D> createState() => _BadgeCard3DState();
}

class _BadgeCard3DState extends State<_BadgeCard3D>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _flip() {
    if (widget.state == BadgeState.locked) {
      if (widget.badge.isSecret && widget.badge.hintKey != null) {
        _showHintModal();
      } else {
        _showHintModal(
          defaultHint: _getTranslatedString(
            context,
            widget.badge.hintKey ?? widget.badge.descriptionKey,
          ),
        );
      }
      return;
    }

    if (widget.state == BadgeState.claimable) {
      widget.onClaim?.call();
      return;
    }

    if (_isFront) {
      _flipController.forward();
    } else {
      _flipController.reverse();
    }
    _isFront = !_isFront;
  }

  void _showHintModal({String? defaultHint}) {
    final hint =
        defaultHint ??
        _getTranslatedString(context, widget.badge.hintKey ?? '');

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: const Color(0xFF0F172A).withValues(alpha: 0.9),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: ScaleTransition(
              scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: DS.xl),
                padding: const EdgeInsets.all(DS.xl),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(24),
                  border: const Border(
                    top: BorderSide(color: Colors.blue, width: 4),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF475569)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withValues(alpha: 0.2),
                            blurRadius: 30,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.fingerprint,
                        size: 32,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: DS.lg),
                    const Text(
                      'Indice du Strobilodex',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: DS.md),
                    Container(
                      width: 48,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: DS.lg),
                    Text(
                      '« $hint »',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                        fontSize: 18,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: DS.xl),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.1),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: DS.md),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'FERMER',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getRarityColor(ConeRarity rarity) {
    switch (rarity) {
      case ConeRarity.uncommon:
        return const Color(0xFF34D399); // Emerald
      case ConeRarity.rare:
        return const Color(0xFF60A5FA); // Blue
      case ConeRarity.veryRare:
        return const Color(0xFFA78BFA); // Purple (Epic)
      case ConeRarity.legendary:
        return const Color(0xFFFBBF24); // Amber
      case ConeRarity.common:
        return const Color(0xFF9CA3AF); // Gray
    }
  }

  String _getRarityLabel(ConeRarity rarity) {
    switch (rarity) {
      case ConeRarity.uncommon:
        return 'PEU COMMUN';
      case ConeRarity.rare:
        return 'RARE';
      case ConeRarity.veryRare:
        return 'ÉPIQUE';
      case ConeRarity.legendary:
        return 'LÉGENDAIRE';
      case ConeRarity.common:
        return 'COMMUN';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flip,
      child: AnimatedBuilder(
        animation: Listenable.merge([_flipController, widget.floatController]),
        builder: (context, child) {
          final isClaimable = widget.state == BadgeState.claimable;
          final flipAngle = _flipController.value * math.pi;

          // Floating offset for claimable
          final double floatOffset = isClaimable
              ? math.sin(widget.floatController.value * 2 * math.pi) * 8
              : 0;

          return Transform.translate(
            offset: Offset(0, -floatOffset),
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(flipAngle),
              alignment: Alignment.center,
              child: flipAngle < math.pi / 2 ? _buildFront() : _buildBack(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFront() {
    final isLocked = widget.state == BadgeState.locked;
    final isClaimable = widget.state == BadgeState.claimable;
    final isUnlocked = widget.state == BadgeState.unlocked;

    final color = _getRarityColor(widget.badge.rarity);
    final rarityLabel = _getRarityLabel(widget.badge.rarity);
    final title = _getTranslatedString(context, widget.badge.titleKey);

    return Container(
      decoration: BoxDecoration(
        color: isLocked
            ? Colors.black.withValues(alpha: 0.5)
            : (isClaimable
                  ? color.withValues(alpha: 0.15)
                  : Colors.white.withValues(alpha: 0.05)),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isLocked
              ? Colors.white.withValues(alpha: 0.1)
              : (isClaimable ? color : Colors.white.withValues(alpha: 0.15)),
          width: isClaimable ? 2 : 1,
          style: BorderStyle.solid,
        ),
        boxShadow: isClaimable
            ? [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 25)]
            : null,
      ),
      padding: const EdgeInsets.all(DS.md),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon Wrapper
          Stack(
            alignment: Alignment.center,
            children: [
              if (isLocked)
                SizedBox(
                  width: 70,
                  height: 70,
                  child: CircularProgressIndicator(
                    value: widget.badge.progressTarget > 0
                        ? (widget.userTotalCones / widget.badge.progressTarget)
                              .clamp(0.0, 1.0)
                        : 0,
                    strokeWidth: 4,
                    color: color,
                    backgroundColor: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isLocked
                      ? Colors.white.withValues(alpha: 0.02)
                      : (isClaimable
                            ? color
                            : Colors.white.withValues(alpha: 0.1)),
                  border: isLocked
                      ? Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                          style: BorderStyle.none,
                        )
                      : (isUnlocked
                            ? Border.all(color: color, width: 2)
                            : null),
                  boxShadow: isUnlocked
                      ? [
                          BoxShadow(
                            color: color.withValues(alpha: 0.3),
                            blurRadius: 15,
                          ),
                        ]
                      : (isClaimable
                            ? [
                                BoxShadow(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  blurRadius: 10,
                                ),
                              ]
                            : null),
                ),
                child: Center(
                  child: widget.badge.isSecret && isLocked
                      ? Icon(
                          Icons.help_outline,
                          size: 30,
                          color: color.withValues(alpha: 0.5),
                        )
                      : Icon(
                          widget.badge.icon,
                          size: 28,
                          color: isLocked
                              ? Colors.white.withValues(alpha: 0.15)
                              : (isClaimable ? Colors.white : color),
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(height: DS.md),
          Text(
            widget.badge.isSecret && isLocked ? 'Secret...' : title,
            style: TextStyle(
              color: isLocked ? Colors.grey[400] : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              height: 1.1,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (isClaimable)
            Container(
              margin: const EdgeInsets.only(top: DS.sm),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.8),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: const Text(
                'TAP POUR ÉCLORE !',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
            ),
          if (isUnlocked)
            Padding(
              padding: const EdgeInsets.only(top: DS.xs),
              child: Text(
                rarityLabel,
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: color.withValues(alpha: 0.7),
                  letterSpacing: 1,
                ),
              ),
            ),
          if (isUnlocked)
            const Padding(
              padding: EdgeInsets.only(top: DS.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.rotate_right, size: 10, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    'TAP POUR DÉTAILS',
                    style: TextStyle(
                      fontSize: 8,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          if (isLocked)
            Padding(
              padding: const EdgeInsets.only(top: DS.sm),
              child: Column(
                children: [
                  if (!widget.badge.isSecret)
                    Text(
                      '${widget.userTotalCones} / ${widget.badge.progressTarget}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  const SizedBox(height: 4),
                  const Icon(Icons.lock, size: 12, color: Colors.grey),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBack() {
    final color = _getRarityColor(widget.badge.rarity);
    final title = _getTranslatedString(context, widget.badge.titleKey);
    final desc = _getTranslatedString(context, widget.badge.descriptionKey);

    String dateStr = '';
    if (widget.unlockDate != null) {
      dateStr =
          '${widget.unlockDate!.day}/${widget.unlockDate!.month}/${widget.unlockDate!.year}';
    }

    return Transform(
      transform: Matrix4.identity()..rotateY(math.pi),
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A).withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              blurRadius: 30,
              spreadRadius: -10,
              blurStyle: BlurStyle.inner,
            ),
          ],
        ),
        padding: const EdgeInsets.all(DS.md),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DS.sm),
            Text(
              desc,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DS.md),
            Container(
              width: double.infinity,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: 1.0, // Because it's unlocked
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [BoxShadow(color: color, blurRadius: 5)],
                  ),
                ),
              ),
            ),
            const SizedBox(height: DS.xs),
            Text(
              'MAXIMISÉ',
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const Spacer(),
            if (widget.unlockDate != null)
              Text(
                'Obtenu le $dateStr',
                style: const TextStyle(fontSize: 9, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }

  String _getTranslatedString(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context);
    switch (key) {
      case 'achievementFirstCone':
        return l10n.achievementFirstCone;
      case 'achievementFirstConeDesc':
        return l10n.achievementFirstConeDesc;
      case 'achievementExplorer':
        return l10n.achievementExplorer;
      case 'achievementExplorerDesc':
        return l10n.achievementExplorerDesc;
      case 'achievementNaturalist':
        return l10n.achievementNaturalist;
      case 'achievementNaturalistDesc':
        return l10n.achievementNaturalistDesc;
      case 'achievementWorldTraveler':
        return l10n.achievementWorldTraveler;
      case 'achievementWorldTravelerDesc':
        return l10n.achievementWorldTravelerDesc;
      case 'achievementWorldTravelerHint':
        return l10n.achievementWorldTravelerHint;
      case 'achievementLegendaryFind':
        return l10n.achievementLegendaryFind;
      case 'achievementLegendaryFindDesc':
        return l10n.achievementLegendaryFindDesc;
      case 'achievementLegendaryFindHint':
        return l10n.achievementLegendaryFindHint;
      case 'achievementTheWalker':
        return l10n.achievementTheWalker;
      case 'achievementTheWalkerDesc':
        return l10n.achievementTheWalkerDesc;
      case 'achievementTheWalkerHint':
        return l10n.achievementTheWalkerHint;

      // New achievements
      case 'achVoiceForest':
        return l10n.achVoiceForest;
      case 'achVoiceForestDesc':
        return l10n.achVoiceForestDesc;
      case 'achPhotographicEye':
        return l10n.achPhotographicEye;
      case 'achPhotographicEyeDesc':
        return l10n.achPhotographicEyeDesc;
      case 'achTheMeasurer':
        return l10n.achTheMeasurer;
      case 'achTheMeasurerDesc':
        return l10n.achTheMeasurerDesc;
      case 'achTheMeasurerHint':
        return l10n.achTheMeasurerHint;
      case 'achImperfectBeauty':
        return l10n.achImperfectBeauty;
      case 'achImperfectBeautyDesc':
        return l10n.achImperfectBeautyDesc;
      case 'achImperfectBeautyHint':
        return l10n.achImperfectBeautyHint;
      case 'achTheWalker':
        return l10n.achTheWalker;
      case 'achTheWalkerDesc':
        return l10n.achTheWalkerDesc;
      case 'achFamilyTree':
        return l10n.achFamilyTree;
      case 'achFamilyTreeDesc':
        return l10n.achFamilyTreeDesc;
      case 'achFamilyTreeHint':
        return l10n.achFamilyTreeHint;
      case 'achFreneticHarvest':
        return l10n.achFreneticHarvest;
      case 'achFreneticHarvestDesc':
        return l10n.achFreneticHarvestDesc;
      case 'achFreneticHarvestHint':
        return l10n.achFreneticHarvestHint;
      case 'achRooted':
        return l10n.achRooted;
      case 'achRootedDesc':
        return l10n.achRootedDesc;
      case 'achRootedHint':
        return l10n.achRootedHint;
      case 'achSeaWolf':
        return l10n.achSeaWolf;
      case 'achSeaWolfDesc':
        return l10n.achSeaWolfDesc;
      case 'achUrbanExplorer':
        return l10n.achUrbanExplorer;
      case 'achUrbanExplorerDesc':
        return l10n.achUrbanExplorerDesc;
      case 'achBotanicalClimber':
        return l10n.achBotanicalClimber;
      case 'achBotanicalClimberDesc':
        return l10n.achBotanicalClimberDesc;
      case 'achBotanicalClimberHint':
        return l10n.achBotanicalClimberHint;
      case 'achContinentConqueror':
        return l10n.achContinentConqueror;
      case 'achContinentConquerorDesc':
        return l10n.achContinentConquerorDesc;
      case 'achContinentConquerorHint':
        return l10n.achContinentConquerorHint;
      case 'achNightOwl':
        return l10n.achNightOwl;
      case 'achNightOwlDesc':
        return l10n.achNightOwlDesc;
      case 'achFlameSurvivor':
        return l10n.achFlameSurvivor;
      case 'achFlameSurvivorDesc':
        return l10n.achFlameSurvivorDesc;
      case 'achFlameSurvivorHint':
        return l10n.achFlameSurvivorHint;
      case 'achThunderstruck':
        return l10n.achThunderstruck;
      case 'achThunderstruckDesc':
        return l10n.achThunderstruckDesc;
      case 'achThunderstruckHint':
        return l10n.achThunderstruckHint;
      case 'achWoodPineapple':
        return l10n.achWoodPineapple;
      case 'achWoodPineappleDesc':
        return l10n.achWoodPineappleDesc;
      case 'achWoodPineappleHint':
        return l10n.achWoodPineappleHint;
      case 'achCrystalCone':
        return l10n.achCrystalCone;
      case 'achCrystalConeDesc':
        return l10n.achCrystalConeDesc;
      case 'achTaxonomist':
        return l10n.achTaxonomist;
      case 'achTaxonomistDesc':
        return l10n.achTaxonomistDesc;
      default:
        return key;
    }
  }
}
