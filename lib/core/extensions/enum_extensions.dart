import 'package:flutter/material.dart';
import 'package:strobilus/l10n/app_localizations.dart';

import '../../data/models/pine_cone_model.dart';
import '../../core/theme/color_themes.dart';

/// Localized labels for ConeRarity.
extension ConeRarityLocalization on ConeRarity {
  String label(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return switch (this) {
      ConeRarity.common => l10n.rarityCommon,
      ConeRarity.uncommon => l10n.rarityUncommon,
      ConeRarity.rare => l10n.rarityRare,
      ConeRarity.veryRare => l10n.rarityVeryRare,
      ConeRarity.legendary => l10n.rarityLegendary,
    };
  }
}

/// Localized labels for ConeSize.
extension ConeSizeLocalization on ConeSize {
  String label(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return switch (this) {
      ConeSize.xs => l10n.sizeXs,
      ConeSize.s => l10n.sizeS,
      ConeSize.m => l10n.sizeM,
      ConeSize.l => l10n.sizeL,
      ConeSize.xl => l10n.sizeXl,
    };
  }
}

/// Localized labels for ConeCondition.
extension ConeConditionLocalization on ConeCondition {
  String label(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return switch (this) {
      ConeCondition.pristine => l10n.conditionPristine,
      ConeCondition.good => l10n.conditionGood,
      ConeCondition.worn => l10n.conditionWorn,
      ConeCondition.fragmented => l10n.conditionFragmented,
    };
  }
}

/// Localized labels for ConeHabitat.
extension ConeHabitatLocalization on ConeHabitat {
  String label(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return switch (this) {
      ConeHabitat.forest => l10n.habitatForest,
      ConeHabitat.park => l10n.habitatPark,
      ConeHabitat.garden => l10n.habitatGarden,
      ConeHabitat.mountain => l10n.habitatMountain,
      ConeHabitat.coastal => l10n.habitatCoastal,
      ConeHabitat.other => l10n.habitatOther,
    };
  }
}

/// Localized names for StrobilusColorTheme.
extension StrobilusColorThemeLocalization on StrobilusColorTheme {
  String label(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return switch (this) {
      StrobilusColorTheme.forest => l10n.themeForest,
      StrobilusColorTheme.arctic => l10n.themeArctic,
      StrobilusColorTheme.autumn => l10n.themeAutumn,
      StrobilusColorTheme.ocean => l10n.themeOcean,
      StrobilusColorTheme.desert => l10n.themeDesert,
      StrobilusColorTheme.midnight => l10n.themeMidnight,
    };
  }
}
