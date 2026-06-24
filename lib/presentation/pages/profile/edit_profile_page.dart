import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:strobilus/l10n/app_localizations.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/design_system.dart';
import '../../../data/services/firebase/firestore_service.dart';
import '../../../data/services/firebase/storage_service.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../widgets/common/strobilus_snack_bar.dart';

/// Premium profile editing page with live preview of avatar and banner customisation.
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nicknameController;
  late TextEditingController _bioController;

  Uint8List? _newAvatarBytes;
  Uint8List? _newBannerBytes;
  Uint8List? _newBackgroundBytes;
  String? _selectedBgTheme;
  bool _isPublicProfile = false;
  bool _isSaving = false;

  final _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    final user = auth.userModel;

    _nicknameController = TextEditingController(
      text: user?.displayName ?? auth.firebaseUser?.displayName ?? '',
    );
    _bioController = TextEditingController(text: user?.bio ?? '');
    _selectedBgTheme = user?.profileBackgroundTheme ?? 'none';
    _isPublicProfile = user?.isPublicProfile ?? false;
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(String type) async {
    final l10n = AppLocalizations.of(context);

    // Show dialog to select source
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: Text(l10n.editProfileCamera),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l10n.editProfileGallery),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final pickedFile = await _imagePicker.pickImage(
      source: source,
      maxWidth: type == 'avatar' ? 512 : 1200,
      maxHeight: type == 'avatar' ? 512 : (type == 'background' ? 1600 : 600),
      imageQuality: 85,
    );

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        if (type == 'avatar') {
          _newAvatarBytes = bytes;
        } else if (type == 'banner') {
          _newBannerBytes = bytes;
          // If we pick a custom banner image, do not disable the preset background theme
          // because they are separate things now.
        } else if (type == 'background') {
          _newBackgroundBytes = bytes;
          _selectedBgTheme = null; // Custom photo overrides preset theme
        }
      });
    }
  }

  LinearGradient _getBannerGradient(String? themeName) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (themeName) {
      case 'forest':
        return const LinearGradient(
          colors: [Color(0xFF1B4332), Color(0xFF40916C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'arctic':
        return const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'autumn':
        return const LinearGradient(
          colors: [Color(0xFF7C2D12), Color(0xFFF97316)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'ocean':
        return const LinearGradient(
          colors: [Color(0xFF0F766E), Color(0xFF0D9488)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'none':
      default:
        final theme = Theme.of(context);
        return LinearGradient(
          colors: isDark
              ? [
                  theme.colorScheme.primary.withValues(alpha: 0.3),
                  theme.colorScheme.surface,
                ]
              : [
                  theme.colorScheme.primary.withValues(alpha: 0.15),
                  theme.colorScheme.surface,
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final l10n = AppLocalizations.of(context);
    final auth = context.read<AuthProvider>();
    final storageService = context.read<StorageService>();
    final firestoreService = context.read<FirestoreService>();

    try {
      String? avatarUrl = auth.userModel?.avatarUrl;
      String? bannerUrl = auth.userModel?.bannerUrl;
      String? backgroundImageUrl = auth.userModel?.backgroundImageUrl;

      // 1. Upload new avatar if selected
      if (_newAvatarBytes != null) {
        avatarUrl = await storageService.uploadUserAvatar(
          imageBytes: _newAvatarBytes!,
        );
      }

      // 2. Upload new banner if selected
      if (_newBannerBytes != null) {
        bannerUrl = await storageService.uploadUserBanner(
          imageBytes: _newBannerBytes!,
        );
      }
      // If user clears the background but wants the gradient theme, we don't clear the banner anymore,
      // banner and background are now distinct.

      // 3. Upload new background if selected
      if (_newBackgroundBytes != null) {
        backgroundImageUrl = await storageService.uploadUserBackground(
          imageBytes: _newBackgroundBytes!,
        );
      } else if (_selectedBgTheme != null && _selectedBgTheme != 'none') {
        // If user picked a preset theme, clear the custom background image
        backgroundImageUrl = '';
      }

      // 4. Save profile details
      await auth.updateProfile(
        displayName: _nicknameController.text.trim(),
        bio: _bioController.text.trim(),
        avatarUrl: avatarUrl,
        bannerUrl: bannerUrl,
        backgroundImageUrl: backgroundImageUrl,
        profileBackgroundTheme: _selectedBgTheme == 'none'
            ? ''
            : _selectedBgTheme,
        isPublicProfile: _isPublicProfile,
        firestoreService: firestoreService,
      );

      if (!context.mounted) return;
      StrobilusSnackBar.success(context, l10n.editProfileSaveSuccess);
      context.pop();
    } catch (e) {
      if (mounted) {
        StrobilusSnackBar.error(context, '${l10n.editProfileSaveError}: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final ext = theme.extension<StrobilusExtension>()!;
    final auth = context.watch<AuthProvider>();
    final user = auth.userModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editProfileTitle),
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: DS.lg),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            IconButton(icon: const Icon(Icons.check), onPressed: _saveProfile),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Live Preview Header ──
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // Banner Area
                  GestureDetector(
                    onTap: () => _pickImage('banner'),
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient:
                            _newBannerBytes == null && _selectedBgTheme != null
                            ? _getBannerGradient(_selectedBgTheme)
                            : null,
                        color: theme.colorScheme.surfaceContainerHighest,
                      ),
                      child: Stack(
                        children: [
                          if (_newBannerBytes != null)
                            Image.memory(
                              _newBannerBytes!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            )
                          else if (user?.bannerUrl != null &&
                              user!.bannerUrl!.isNotEmpty)
                            Image.network(
                              user.bannerUrl!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          // Dark overlay for visibility
                          Container(
                            color: Colors.black.withValues(alpha: 0.25),
                          ),
                          // Edit Banner Button overlay
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: DS.md,
                                vertical: DS.sm,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                borderRadius: DS.borderRadiusFull,
                                border: Border.all(color: Colors.white30),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: DS.xs),
                                  Text(
                                    l10n.editProfileBanner,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Avatar Area
                  Positioned(
                    bottom: 0,
                    child: GestureDetector(
                      onTap: () => _pickImage('avatar'),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 116,
                            height: 116,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.colorScheme.surface,
                            ),
                          ),
                          Container(
                            width: 108,
                            height: 108,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: ext.palette.primary,
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              backgroundColor: ext.palette.primary.withValues(
                                alpha: 0.15,
                              ),
                              backgroundImage: _newAvatarBytes != null
                                  ? MemoryImage(_newAvatarBytes!)
                                  : (user?.avatarUrl != null
                                        ? NetworkImage(user!.avatarUrl!)
                                              as ImageProvider
                                        : (auth.firebaseUser?.photoURL != null
                                              ? NetworkImage(
                                                  auth.firebaseUser!.photoURL!,
                                                )
                                              : null)),
                              child:
                                  (_newAvatarBytes == null &&
                                      user?.avatarUrl == null &&
                                      auth.firebaseUser?.photoURL == null)
                                  ? Text(
                                      _nicknameController.text.isNotEmpty
                                          ? _nicknameController.text[0]
                                                .toUpperCase()
                                          : 'U',
                                      style: theme.textTheme.displayMedium
                                          ?.copyWith(
                                            color: ext.palette.primary,
                                          ),
                                    )
                                  : null,
                            ),
                          ),
                          // Edit Camera Icon Overlay
                          Container(
                            width: 108,
                            height: 108,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.35),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 56),

              Padding(
                padding: const EdgeInsets.all(DS.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nickname Input
                    Text(
                      l10n.editProfileNickname,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: DS.sm),
                    TextFormField(
                      controller: _nicknameController,
                      style: theme.textTheme.bodyLarge,
                      decoration: InputDecoration(
                        hintText: l10n.editProfileNickname,
                        isDense: true,
                        contentPadding: const EdgeInsets.all(DS.md),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return l10n.editProfileNickname; // Validation prompt
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: DS.lg),

                    // Bio Input
                    Text(
                      l10n.editProfileBio,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: DS.sm),
                    TextFormField(
                      controller: _bioController,
                      style: theme.textTheme.bodyMedium,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: l10n.editProfileBio,
                        contentPadding: const EdgeInsets.all(DS.md),
                      ),
                    ),

                    const SizedBox(height: DS.lg),

                    // Public Profile Toggle
                    Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.3),
                        borderRadius: DS.borderRadiusMd,
                        border: Border.all(
                          color: theme.colorScheme.outlineVariant,
                        ),
                      ),
                      child: SwitchListTile(
                        title: Text(
                          'Profil Public (Classement)',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          'Participez au classement communautaire et comparez votre XP.',
                          style: theme.textTheme.bodySmall,
                        ),
                        value: _isPublicProfile,
                        onChanged: (val) =>
                            setState(() => _isPublicProfile = val),
                        secondary: const Icon(Icons.public),
                      ),
                    ),

                    const SizedBox(height: DS.xl),

                    // Background Theme Presets Selector
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.editProfileTheme,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => _pickImage('background'),
                          icon: const Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 16,
                          ),
                          label: Text(l10n.editProfileGallery),
                        ),
                      ],
                    ),
                    if (_newBackgroundBytes != null ||
                        user?.backgroundImageUrl != null) ...[
                      const SizedBox(height: DS.sm),
                      Container(
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(DS.radiusMd),
                          border: Border.all(
                            color: theme.colorScheme.primary,
                            width: 2.5,
                          ),
                          image: _newBackgroundBytes != null
                              ? DecorationImage(
                                  image: MemoryImage(_newBackgroundBytes!),
                                  fit: BoxFit.cover,
                                )
                              : (user?.backgroundImageUrl != null
                                    ? DecorationImage(
                                        image: NetworkImage(
                                          user!.backgroundImageUrl!,
                                        ),
                                        fit: BoxFit.cover,
                                      )
                                    : null),
                        ),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.black45,
                            ),
                            onPressed: () {
                              setState(() {
                                _newBackgroundBytes = null;
                                _selectedBgTheme = 'none';
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: DS.md),
                    SizedBox(
                      height: 80,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildThemeOption('none', l10n.editProfileThemeNone),
                          _buildThemeOption(
                            'forest',
                            l10n.editProfileThemeForest,
                          ),
                          _buildThemeOption(
                            'arctic',
                            l10n.editProfileThemeArctic,
                          ),
                          _buildThemeOption(
                            'autumn',
                            l10n.editProfileThemeAutumn,
                          ),
                          _buildThemeOption(
                            'ocean',
                            l10n.editProfileThemeOcean,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeOption(String themeKey, String label) {
    final isSelected = _selectedBgTheme == themeKey;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedBgTheme = themeKey;
          // Clear any unsaved customized banner photo since user is selecting a preset
          _newBannerBytes = null;
        });
      },
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: DS.md),
        decoration: BoxDecoration(
          borderRadius: DS.borderRadiusMd,
          border: isSelected
              ? Border.all(color: theme.colorScheme.primary, width: 2.5)
              : Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(DS.radiusMd - 2),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: _getBannerGradient(themeKey),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                color: theme.colorScheme.surfaceContainer,
                child: Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: 8,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
