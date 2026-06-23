import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A robust image widget that automatically handles network images, local files (mobile),
/// blob URLs (web), and falls back gracefully to a premium placeholder when loading fails or is unsupported.
class StrobilusImage extends StatelessWidget {
  final String? imagePath;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget? placeholder;

  const StrobilusImage({
    super.key,
    this.imagePath,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    final defaultPlaceholder =
        placeholder ??
        Container(
          width: width,
          height: height,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Center(
            child: Opacity(
              opacity: 0.6,
              child: Image.asset(
                'assets/images/logo_squared.png',
                width: width != null ? width! * 0.4 : 40,
                height: height != null ? height! * 0.4 : 40,
                fit: BoxFit.contain,
              ),
            ),
          ),
        );

    if (imagePath == null || imagePath!.isEmpty) {
      return defaultPlaceholder;
    }

    final isNetwork =
        imagePath!.startsWith('http://') || imagePath!.startsWith('https://');

    if (isNetwork) {
      return Image.network(
        imagePath!,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) => defaultPlaceholder,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width,
            height: height,
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        },
      );
    }

    // Local images handling
    if (kIsWeb) {
      // On web, blob: and data: URLs are supported via Image.network
      if (imagePath!.startsWith('blob:') || imagePath!.startsWith('data:')) {
        return Image.network(
          imagePath!,
          fit: fit,
          width: width,
          height: height,
          errorBuilder: (context, error, stackTrace) => defaultPlaceholder,
        );
      }
      // Local mobile absolute paths (e.g. /data/user/...) are not readable in Chrome
      return defaultPlaceholder;
    } else {
      // Mobile / Desktop native platforms
      try {
        return Image.file(
          File(imagePath!),
          fit: fit,
          width: width,
          height: height,
          errorBuilder: (context, error, stackTrace) => defaultPlaceholder,
        );
      } catch (_) {
        return defaultPlaceholder;
      }
    }
  }
}
