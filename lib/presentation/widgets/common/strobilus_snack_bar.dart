import 'package:flutter/material.dart';

import '../../../core/theme/app_color_palettes.dart';
import '../../../core/theme/design_system.dart';

class StrobilusSnackBar {
  StrobilusSnackBar._();

  static void success(BuildContext context, String message) {
    _show(
      context,
      message,
      SemanticColors.successLeaf,
      Icons.check_circle_outline,
    );
  }

  static void error(BuildContext context, String message) {
    _show(context, message, SemanticColors.errorRed, Icons.error_outline);
  }

  static void info(BuildContext context, String message) {
    _show(context, message, SemanticColors.infoSky, Icons.info_outline);
  }

  static void warning(BuildContext context, String message) {
    _show(
      context,
      message,
      SemanticColors.warningOchre,
      Icons.warning_amber_rounded,
    );
  }

  static void _show(
    BuildContext context,
    String message,
    Color backgroundColor,
    IconData icon,
  ) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: DS.sm),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: DS.borderRadiusMd),
        margin: const EdgeInsets.all(DS.md),
        elevation: 6,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
