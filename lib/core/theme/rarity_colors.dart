import 'package:flutter/material.dart';

/// Rarity badge colors — fixed across ALL themes.
/// These are semantic and carry meaning (game-like progression).
class RarityColors {
  RarityColors._();

  static const Color common = Color(0xFF6B7280);
  static const Color uncommon = Color(
    0xFF16A34A,
  ); // Darker green for light theme contrast
  static const Color rare = Color(
    0xFF2563EB,
  ); // Darker blue for light theme contrast
  static const Color veryRare = Color(
    0xFF7C3AED,
  ); // Darker purple for light theme contrast
  static const Color legendary = Color(
    0xFFD97706,
  ); // Darker amber for light theme contrast

  static Color forRarity(String rarity, {bool isDark = false}) {
    if (isDark) {
      switch (rarity) {
        case 'common':
          return const Color(0xFFD1D5DB); // Gray-300
        case 'uncommon':
          return const Color(0xFF4ADE80); // Green-400
        case 'rare':
          return const Color(0xFF60A5FA); // Blue-400
        case 'veryRare':
          return const Color(0xFFA78BFA); // Purple-400
        case 'legendary':
          return const Color(0xFFFBBF24); // Amber-400
        default:
          return const Color(0xFFD1D5DB);
      }
    } else {
      switch (rarity) {
        case 'common':
          return common;
        case 'uncommon':
          return uncommon;
        case 'rare':
          return rare;
        case 'veryRare':
          return veryRare;
        case 'legendary':
          return legendary;
        default:
          return common;
      }
    }
  }
}
