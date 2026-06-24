// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Strobilus';

  @override
  String get navMap => 'Carte';

  @override
  String get navCollection => 'Collection';

  @override
  String get navAdd => 'Ajouter';

  @override
  String get navSpecies => 'Strobilodex';

  @override
  String get navProfile => 'Profil';

  @override
  String get collectionEmpty => 'Votre collection est vide';

  @override
  String get collectionEmptySubtitle =>
      'Sortez et trouvez votre première pomme de pin !';

  @override
  String collectionTotal(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pommes de pin',
      one: '1 pomme de pin',
      zero: 'Aucune pomme de pin',
    );
    return '$_temp0';
  }

  @override
  String get collectionGridView => 'Vue grille';

  @override
  String get collectionListView => 'Vue liste';

  @override
  String get collectionSortDate => 'Date';

  @override
  String get collectionSortSpecies => 'Espèce';

  @override
  String get collectionSortRarity => 'Rareté';

  @override
  String get collectionSortCountry => 'Pays';

  @override
  String get collectionSearch => 'Rechercher…';

  @override
  String get rarityCommon => 'Commun';

  @override
  String get rarityUncommon => 'Peu commun';

  @override
  String get rarityRare => 'Rare';

  @override
  String get rarityVeryRare => 'Très rare';

  @override
  String get rarityLegendary => 'Légendaire';

  @override
  String get sizeXs => 'Minuscule (< 2 cm)';

  @override
  String get sizeS => 'Petit (2–4 cm)';

  @override
  String get sizeM => 'Moyen (4–7 cm)';

  @override
  String get sizeL => 'Grand (7–12 cm)';

  @override
  String get sizeXl => 'Géant (> 12 cm)';

  @override
  String get conditionPristine => 'Parfait';

  @override
  String get conditionGood => 'Bon état';

  @override
  String get conditionWorn => 'Usé';

  @override
  String get conditionFragmented => 'Fragmenté';

  @override
  String get habitatForest => 'Forêt';

  @override
  String get habitatPark => 'Parc';

  @override
  String get habitatGarden => 'Jardin';

  @override
  String get habitatMountain => 'Montagne';

  @override
  String get habitatCoastal => 'Côtier';

  @override
  String get habitatOther => 'Autre';

  @override
  String get addConeTitle => 'Ajouter une pomme de pin';

  @override
  String get stepPhoto => 'Photo';

  @override
  String get stepLocation => 'Lieu';

  @override
  String get stepDetails => 'Détails';

  @override
  String get stepConfirm => 'Confirmer';

  @override
  String get takePhoto => 'Prendre une photo';

  @override
  String get chooseFromGallery => 'Choisir depuis la galerie';

  @override
  String get skipPhoto => 'Ajouter une photo plus tard';

  @override
  String get useMyLocation => 'Utiliser ma position';

  @override
  String get adjustPinOnMap => 'Glissez l\'épingle pour ajuster';

  @override
  String get searchSpecies => 'Rechercher une espèce…';

  @override
  String get unknownSpecies => 'Espèce inconnue';

  @override
  String get personalNotes => 'Notes personnelles (facultatif)';

  @override
  String get notesHint =>
      'Qu\'est-ce qui rend cette pomme de pin spéciale pour vous ?';

  @override
  String get tagsHint => 'Ajouter des tags…';

  @override
  String get addVoiceNote => 'Enregistrer une note vocale';

  @override
  String get voiceNoteMaxDuration => 'Maximum 90 secondes';

  @override
  String get addToCollection => 'Ajouter à la collection';

  @override
  String get coneAddedSuccess => 'Pomme de pin ajoutée à votre collection !';

  @override
  String get manualEntryTitle => 'Saisie Manuelle';

  @override
  String get tapToSelectPhoto => 'Appuyez pour choisir une photo';

  @override
  String get commonNameLabel => 'Nom commun';

  @override
  String get scientificNameLabel => 'Nom scientifique (Optionnel)';

  @override
  String get locationNameLabel => 'Lieu de découverte';

  @override
  String get sizeLabel => 'Taille';

  @override
  String get conditionLabel => 'État';

  @override
  String get rarityLabel => 'Rareté';

  @override
  String get saveManualEntry => 'Enregistrer';

  @override
  String get editDetails => 'Ajouter des détails';

  @override
  String get gpsUnavailable =>
      'GPS indisponible. Veuillez entrer le lieu manuellement.';

  @override
  String get aiQuickCaptureTitle => 'Capture Rapide IA';

  @override
  String get aiQuickCaptureSubtitle =>
      'Prenez une photo et identifiez automatiquement';

  @override
  String get manualEntrySubtitle =>
      'Choisissez une photo et remplissez les détails';

  @override
  String get aiPendingMessage =>
      'Capturé hors ligne. Identification IA en attente.';

  @override
  String get aiIdentificationComplete => 'Identification IA terminée !';

  @override
  String get coneUpdatedSuccess => 'Pomme de pin mise à jour avec succès.';

  @override
  String get editConeTitle => 'Modifier la pomme de pin';

  @override
  String get saveChanges => 'Enregistrer les modifications';

  @override
  String get errorFieldRequired => 'Veuillez entrer un nom';

  @override
  String get appTagline => 'Collecteur de Pommes de Pin';

  @override
  String get mapFilterComingSoon => 'Filtres bientôt disponibles';

  @override
  String conesCollected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pommes de pin collectées',
      one: '1 pomme de pin collectée',
      zero: 'Aucune pomme de pin collectée',
    );
    return '$_temp0';
  }

  @override
  String get errorAuthNotEnabled =>
      'L\'authentification email/mot de passe n\'est pas activée.';

  @override
  String firstConeFromCountry(String country) {
    return 'Première pomme de pin de $country ! 🎉';
  }

  @override
  String get aiIdentifyButton => 'Identifier avec l\'IA';

  @override
  String get aiIdentifying => 'Identification…';

  @override
  String get aiDailyLimitReached =>
      'Limite quotidienne atteinte. Réessayez demain.';

  @override
  String aiConfidence(int percent) {
    return '$percent% de confiance';
  }

  @override
  String get aiTopMatches => 'Meilleures correspondances';

  @override
  String get aiNoMatch =>
      'Impossible d\'identifier cette pomme de pin. Essayez une autre photo.';

  @override
  String get errorNoLocation => 'La localisation est obligatoire.';

  @override
  String get errorNoPhoto => 'Veuillez ajouter au moins une photo.';

  @override
  String get errorGeneric => 'Une erreur est survenue. Veuillez réessayer.';

  @override
  String get errorNetworkOffline =>
      'Hors ligne. Les modifications seront synchronisées à la reconnexion.';

  @override
  String get speciesTypeLabel => 'Espèce (facultatif)';

  @override
  String get speciesTypeHint => 'Rechercher ou sélectionner une espèce...';

  @override
  String get coneDeletedSuccess =>
      'Pomme de pin supprimée de votre collection.';

  @override
  String get deleteConeConfirmation =>
      'Êtes-vous sûr de vouloir supprimer cette pomme de pin ? Cette action est irréversible.';

  @override
  String coneAddedToSpecies(String speciesName) {
    return 'Pomme de pin ajoutée à la collection $speciesName !';
  }

  @override
  String aiIdentifiedAs(String speciesName) {
    return 'Identifié comme $speciesName';
  }

  @override
  String get coneSavedSuccess => 'Pomme de pin enregistrée avec succès !';

  @override
  String get errorWeakPassword =>
      'Mot de passe trop faible. Utilisez au moins 6 caractères.';

  @override
  String get errorEmailInUse => 'Cet email est déjà utilisé.';

  @override
  String get errorInvalidEmail => 'Veuillez entrer une adresse email valide.';

  @override
  String get errorWrongPassword =>
      'Mot de passe incorrect. Veuillez réessayer.';

  @override
  String get errorUserNotFound => 'Aucun compte trouvé pour cet email.';

  @override
  String get authLogin => 'Se connecter';

  @override
  String get authRegister => 'Créer un compte';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Mot de passe';

  @override
  String get authConfirmPassword => 'Confirmer le mot de passe';

  @override
  String get authForgotPassword => 'Mot de passe oublié ?';

  @override
  String get authNoAccount => 'Pas encore de compte ?';

  @override
  String get authHasAccount => 'Déjà un compte ?';

  @override
  String get authSignUp => 'S\'inscrire';

  @override
  String get authSignIn => 'Se connecter';

  @override
  String get authSignOut => 'Se déconnecter';

  @override
  String get authPasswordReset => 'Email de réinitialisation envoyé.';

  @override
  String get authDisplayName => 'Nom d\'affichage';

  @override
  String get authUsername => 'Nom d\'utilisateur';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsAccount => 'Compte';

  @override
  String get settingsApp => 'Application';

  @override
  String get settingsPrivacy => 'Confidentialité';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsAbout => 'À propos';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsTheme => 'Thème';

  @override
  String get settingsLightDark => 'Clair / Sombre';

  @override
  String get settingsColorTheme => 'Thème de couleur';

  @override
  String get settingsExportData => 'Exporter mes données';

  @override
  String get settingsDeleteAccount => 'Supprimer le compte';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsLicenses => 'Licences';

  @override
  String get settingsDeleteAccountConfirm =>
      'Êtes-vous sûr de vouloir supprimer définitivement votre compte ? Cette action est irréversible et effacera toutes vos pommes de pin, collections et données de profil.';

  @override
  String get settingsDeleteAccountCancel => 'Annuler';

  @override
  String get settingsDeleteAccountAction => 'Supprimer';

  @override
  String get settingsPrivacyPolicy => 'Politique de confidentialité';

  @override
  String get settingsTerms => 'Conditions d\'utilisation';

  @override
  String get settingsDailyReminder => 'Rappel quotidien';

  @override
  String get settingsNewSpeciesAlert => 'Alertes nouvelles espèces';

  @override
  String get settingsUnits => 'Unités';

  @override
  String get settingsMetric => 'Métrique';

  @override
  String get settingsImperial => 'Impérial';

  @override
  String get deleteAccountConfirm =>
      'Tapez votre nom d\'utilisateur pour confirmer';

  @override
  String get deleteAccountWarning =>
      'Cela supprimera définitivement toutes vos pommes de pin et photos.';

  @override
  String get privacyTitle => 'Votre confidentialité';

  @override
  String get privacySubtitle =>
      'Nous prenons soin de vos données. Voici ce que nous collectons et pourquoi.';

  @override
  String get privacyLocationData =>
      'Les données de localisation sont stockées uniquement lorsque vous ajoutez une pomme de pin.';

  @override
  String get privacyPhotos =>
      'Les photos sont stockées de manière sécurisée et visibles uniquement par vous.';

  @override
  String get privacyAnalytics => 'Analytique (nous aide à nous améliorer)';

  @override
  String get privacyPersonalization => 'Personnalisation';

  @override
  String get privacyAgree => 'Je comprends et j\'accepte';

  @override
  String get privacyMustScroll =>
      'Veuillez lire les informations de confidentialité ci-dessus.';

  @override
  String get onboardingTitle1 => 'Vos pommes de pin,\ncartographiées';

  @override
  String get onboardingBody1 =>
      'Épinglez chaque pomme de pin à l\'endroit exact où vous l\'avez trouvée — parcs, forêts et continents.';

  @override
  String get onboardingTitle2 => 'Identifiez et cataloguez';

  @override
  String get onboardingBody2 =>
      'Photographiez vos pommes de pin, identifiez l\'espèce et construisez une collection botanique vivante.';

  @override
  String get onboardingTitle3 => 'Suivez votre voyage';

  @override
  String get onboardingBody3 =>
      'Voyez en un coup d\'œil combien d\'espèces et de pays votre collection couvre.';

  @override
  String get onboardingGetStarted => 'Commencer';

  @override
  String get speciesLibrary => 'Strobilodex';

  @override
  String get speciesFamily => 'Famille';

  @override
  String get speciesGenus => 'Genre';

  @override
  String get speciesNativeRegion => 'Région d\'origine';

  @override
  String get speciesSizeRange => 'Taille';

  @override
  String get speciesHabitat => 'Habitat';

  @override
  String get speciesYourSpecimens => 'Vos spécimens';

  @override
  String get speciesInterestingFacts => 'Le saviez-vous ?';

  @override
  String get speciesDescription => 'Description';

  @override
  String get speciesInCollection => 'dans votre collection';

  @override
  String get speciesNotInCollection => 'Pas encore découvert';

  @override
  String speciesTotalCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count espèces',
      one: '1 espèce',
    );
    return '$_temp0';
  }

  @override
  String pokedexProgress(int discovered, int total) {
    return '$discovered / $total découvertes';
  }

  @override
  String get pokedexAllFilter => 'Toutes';

  @override
  String get pokedexHardPines => 'Pins durs';

  @override
  String get pokedexSoftPines => 'Pins tendres';

  @override
  String get pokedexOtherConifers => 'Autres conifères';

  @override
  String get pokedexSortStrobilodex => 'Strobilodex #';

  @override
  String get pokedexSortName => 'Nom';

  @override
  String get pokedexSortRarity => 'Rareté';

  @override
  String get pokedexSortDifficulty => 'Difficulté';

  @override
  String get pokedexDiscovered => 'Découvert !';

  @override
  String get pokedexUndiscovered => 'Non découvert';

  @override
  String get taxonomyTitle => 'Taxonomie';

  @override
  String get taxonomySubgenus => 'Sous-genre';

  @override
  String get taxonomySection => 'Section';

  @override
  String get taxonomySubsection => 'Sous-section';

  @override
  String get morphologyTitle => 'Morphologie de la pomme de pin';

  @override
  String get morphologyConeSize => 'Taille de la pomme de pin';

  @override
  String get morphologyConeShape => 'Forme';

  @override
  String get morphologyUmbo => 'Umbo';

  @override
  String get morphologyUmboDorsal => 'Dorsal';

  @override
  String get morphologyUmboTerminal => 'Terminal';

  @override
  String get morphologyMucro => 'Mucron (épine)';

  @override
  String get morphologyMucroPresent => 'Présent';

  @override
  String get morphologyMucroAbsent => 'Absent';

  @override
  String get morphologyApophysis => 'Apophyse';

  @override
  String get morphologySerotiny => 'Sérotinie';

  @override
  String get morphologySerotinous => 'Dépendant du feu (sérotineux)';

  @override
  String get morphologyNonSerotinous => 'Ouverture standard';

  @override
  String get morphologyNeedles => 'Aiguilles / fascicule';

  @override
  String get morphologySeedType => 'Type de graine';

  @override
  String get morphologySeedWinged => 'Ailée (vent)';

  @override
  String get morphologySeedWingless => 'Sans aile';

  @override
  String get morphologySeedEdible => 'Pignon comestible';

  @override
  String get morphologySeedBird => 'Dispersée par oiseaux';

  @override
  String get morphologyConeWeight => 'Poids max';

  @override
  String get distributionTitle => 'Distribution';

  @override
  String get distributionNative => 'Aire native';

  @override
  String get distributionIntroduced => 'Largement planté comme ornemental';

  @override
  String get distributionNotIntroduced => 'Limité à l\'aire native';

  @override
  String get conservationTitle => 'Conservation';

  @override
  String get conservationLC => 'Préoccupation mineure';

  @override
  String get conservationNT => 'Quasi menacé';

  @override
  String get conservationVU => 'Vulnérable';

  @override
  String get conservationEN => 'En danger';

  @override
  String get conservationCR => 'En danger critique';

  @override
  String get discoveryDifficultyTitle => 'Difficulté de découverte';

  @override
  String get profileCones => 'Pommes de pin';

  @override
  String get profileSpecies => 'Espèces';

  @override
  String get profileCountries => 'Pays';

  @override
  String profileStreak(int days) {
    return '🔥 Série de $days jours';
  }

  @override
  String get profileRecentActivity => 'Activité récente';

  @override
  String get profileEditProfile => 'Modifier le profil';

  @override
  String get profileBio => 'Bio';

  @override
  String get achievementsTitle => 'Succès';

  @override
  String get achievementLocked => 'Verrouillé';

  @override
  String get achievementFirstCone => 'Première Pomme de Pin';

  @override
  String get achievementFirstConeDesc =>
      'Le début d\'une grande aventure. Vous avez catalogué votre première pomme de pin.';

  @override
  String get achievementExplorer => 'Explorateur';

  @override
  String get achievementExplorerDesc =>
      'Vous avez ajouté 10 pommes de pin à votre collection.';

  @override
  String get achievementNaturalist => 'Naturaliste';

  @override
  String get achievementNaturalistDesc =>
      'Vous avez identifié 5 espèces différentes de strobiles.';

  @override
  String get achievementWorldTraveler => 'Voyageur du monde';

  @override
  String get achievementWorldTravelerDesc =>
      'Vous avez trouvé des pommes de pin dans 3 pays différents !';

  @override
  String get achievementWorldTravelerHint =>
      'Des frontières à traverser, des cultures à découvrir...';

  @override
  String get achievementLegendaryFind => 'Le Chercheur d\'Or';

  @override
  String get achievementLegendaryFindDesc =>
      'A identifié 50 pommes de pin à travers le monde.';

  @override
  String get achievementLegendaryFindHint =>
      'Seuls les plus persistants amasseront un trésor.';

  @override
  String get achievementTheWalker => 'Le Marcheur';

  @override
  String get achievementTheWalkerDesc =>
      'Des sentiers battus aux forêts profondes, vous avez collecté 25 pommes de pin.';

  @override
  String get achievementTheWalkerHint =>
      'Des sentiers battus aux forêts profondes... Continuez de marcher.';

  @override
  String get boardUnlocked => 'Débloqués';

  @override
  String get boardScore => 'Score Rare';

  @override
  String get boardShowcase => 'Vitrine Personnelle';

  @override
  String get boardInProgress => 'En cours de progression';

  @override
  String get boardTapToFlip => 'Tap pour retourner';

  @override
  String boardUnlockedDate(String date) {
    return 'Obtenu le $date';
  }

  @override
  String get boardClaim => 'TAP POUR ÉCLORE !';

  @override
  String get boardHintTitle => 'Indice Cryptique';

  @override
  String get boardClose => 'Fermer';

  @override
  String get voiceNotes => 'Notes vocales';

  @override
  String get voiceNoteRecording => 'Enregistrement…';

  @override
  String get voiceNoteStop => 'Arrêter';

  @override
  String get voiceNotePlay => 'Écouter';

  @override
  String get voiceNoteDelete => 'Supprimer la note';

  @override
  String get voiceNoteDeleteConfirm => 'Supprimer cette note vocale ?';

  @override
  String get voiceNoteAdded => 'Note vocale ajoutée';

  @override
  String get voiceNoteLimit => 'Maximum 2 notes vocales par pomme de pin';

  @override
  String get mapFilterTitle => 'Filtrer les pommes de pin';

  @override
  String get mapFilterSpecies => 'Espèce';

  @override
  String get mapFilterRarity => 'Rareté';

  @override
  String get mapFilterDateRange => 'Période';

  @override
  String get mapFilterApply => 'Appliquer les filtres';

  @override
  String get mapFilterClear => 'Tout effacer';

  @override
  String get mapMyLocation => 'Ma position';

  @override
  String get mapAddConeHere => 'Ajouter une pomme de pin ici';

  @override
  String get mapViewDetails => 'Voir les détails';

  @override
  String mapConeCount(int count) {
    return '$count pommes de pin dans cette zone';
  }

  @override
  String get themeForest => 'Forêt';

  @override
  String get themeArctic => 'Arctique';

  @override
  String get themeAutumn => 'Automne';

  @override
  String get themeOcean => 'Océan';

  @override
  String get themeDesert => 'Désert';

  @override
  String get themeMidnight => 'Minuit';

  @override
  String get themeBrightnessLight => 'Clair';

  @override
  String get themeBrightnessDark => 'Sombre';

  @override
  String get themeBrightnessSystem => 'Système';

  @override
  String get syncingData => 'Synchronisation…';

  @override
  String get offlineBanner =>
      'Hors ligne — synchronisation automatique à la reconnexion';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get save => 'Enregistrer';

  @override
  String get edit => 'Modifier';

  @override
  String get done => 'Terminé';

  @override
  String get skip => 'Ignorer';

  @override
  String get next => 'Suivant';

  @override
  String get back => 'Retour';

  @override
  String get close => 'Fermer';

  @override
  String get confirm => 'Confirmer';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get retry => 'Réessayer';

  @override
  String get loading => 'Chargement…';

  @override
  String get noResults => 'Aucun résultat';

  @override
  String get seeAll => 'Voir tout';

  @override
  String get locating => 'Localisation…';

  @override
  String get gpsLocked => 'GPS verrouillé';

  @override
  String get gpsUnavailableShort => 'GPS indisponible';

  @override
  String get unknownCone => 'Pomme de pin inconnue';

  @override
  String get unknownLocation => 'Lieu inconnu';

  @override
  String get unknownContinent => 'Inconnu';

  @override
  String get cameraError => 'Erreur caméra. Veuillez réessayer.';

  @override
  String get aiIdentificationFailed =>
      'L\'identification IA a échoué. Réessayez ou enregistrez manuellement.';

  @override
  String get editProfileTitle => 'Modifier le profil';

  @override
  String get editProfileNickname => 'Surnom';

  @override
  String get editProfileBio => 'Biographie';

  @override
  String get editProfileBanner => 'Bannière de profil';

  @override
  String get editProfileTheme => 'Thème de fond d\'écran';

  @override
  String get editProfilePhoto => 'Photo de profil';

  @override
  String get editProfileSaveSuccess => 'Profil mis à jour avec succès !';

  @override
  String get editProfileSaveError => 'Erreur lors de la mise à jour du profil';

  @override
  String get editProfileSelectSource => 'Choisir une source';

  @override
  String get editProfileCamera => 'Appareil photo';

  @override
  String get editProfileGallery => 'Galerie';

  @override
  String get editProfileThemeForest => 'Dégradé Forestier';

  @override
  String get editProfileThemeArctic => 'Brume Arctique';

  @override
  String get editProfileThemeAutumn => 'Crépuscule d\'Automne';

  @override
  String get editProfileThemeOcean => 'Profondeur Océane';

  @override
  String get editProfileThemeNone => 'Aucun (couleur par défaut)';

  @override
  String get locationPickerClose => 'Fermer';

  @override
  String get locationPickerNoResults => 'Aucun résultat';

  @override
  String get locationPickerGps => 'Position GPS';

  @override
  String get locationPickerSearch => 'Rechercher';

  @override
  String get viewInteractiveMap => 'Voir la carte interactive';

  @override
  String get distributionNativeLabel => 'Natif';

  @override
  String get distributionIntroducedLabel => 'Introduit';

  @override
  String get loadingMapData => 'Chargement des données…';

  @override
  String get previousSpecies => 'Espèce précédente';

  @override
  String get nextSpecies => 'Espèce suivante';

  @override
  String get viewFullImage => 'Voir l\'image complète';

  @override
  String get achVoiceForest => 'La Voix de la Forêt';

  @override
  String get achVoiceForestDesc =>
      'Vous avez ajouté votre première note vocale pour documenter vos émotions.';

  @override
  String get achPhotographicEye => 'L\'Œil Photographique';

  @override
  String get achPhotographicEyeDesc =>
      'Un vrai modèle 3D ! Vous avez ajouté 4 photos sous différents angles.';

  @override
  String get achTheMeasurer => 'Le Mesureur';

  @override
  String get achTheMeasurerDesc =>
      'Vous avez trouvé et documenté un spécimen pour chaque catégorie de taille.';

  @override
  String get achTheMeasurerHint =>
      'Les strobiles viennent de toutes les tailles. Trouvez-les de Minuscule à Géant.';

  @override
  String get achImperfectBeauty => 'Beauté Imparfaite';

  @override
  String get achImperfectBeautyDesc =>
      'Vous avez scanné 10 pommes de pin en état \'Fragmenté\' ou \'Usé\'.';

  @override
  String get achImperfectBeautyHint =>
      'La nature n\'est pas parfaite... Cherchez des pommes de pin abimés.';

  @override
  String get achTheWalker => 'L\'Arpenteur';

  @override
  String get achTheWalkerDesc =>
      'Vous avez marché de longs kilomètres pour trouver 50 pommes de pin.';

  @override
  String get achFamilyTree => 'L\'Arbre Généalogique';

  @override
  String get achFamilyTreeDesc =>
      'Vous avez complété à 100% l\'arbre généalogique d\'un Genre botanique.';

  @override
  String get achFamilyTreeHint =>
      'Trouvez toutes les espèces d\'un même Genre (ex: tous les Pinus locaux).';

  @override
  String get achFreneticHarvest => 'Récolte Frénétique';

  @override
  String get achFreneticHarvestDesc =>
      'Vous avez scanné 10 pommes de pin en moins de 24 heures.';

  @override
  String get achFreneticHarvestHint =>
      'Une journée très productive vous attend. Sortez !';

  @override
  String get achRooted => 'Enraciné';

  @override
  String get achRootedDesc =>
      'Vous avez scanné un spécimen 30 jours consécutifs.';

  @override
  String get achRootedHint =>
      'La régularité est la clé du botaniste. Ouvrez le Strobilodex tous les jours.';

  @override
  String get achSeaWolf => 'Loup de Mer';

  @override
  String get achSeaWolfDesc =>
      'Trouvez un strobile à moins de 500 mètres de l\'océan.';

  @override
  String get achUrbanExplorer => 'Explorateur Urbain';

  @override
  String get achUrbanExplorerDesc =>
      'Vous avez catalogué un spécimen dans un parc en plein centre-ville.';

  @override
  String get achBotanicalClimber => 'Alpiniste Botanique';

  @override
  String get achBotanicalClimberDesc =>
      'Vous avez trouvé un spécimen au-dessus de 2000m d\'altitude.';

  @override
  String get achBotanicalClimberHint =>
      'Prenez de la hauteur. Cherchez là où l\'air se fait rare.';

  @override
  String get achContinentConqueror => 'Conquérant des Continents';

  @override
  String get achContinentConquerorDesc =>
      'Trouvez des spécimens sur 3 continents différents.';

  @override
  String get achContinentConquerorHint => 'Le monde est votre forêt. Voyagez !';

  @override
  String get achNightOwl => 'Oiseau de Nuit';

  @override
  String get achNightOwlDesc =>
      'Vous avez bravé l\'obscurité pour scanner un pomme de pin entre 2h et 4h du matin.';

  @override
  String get achFlameSurvivor => 'Survivant des Flammes';

  @override
  String get achFlameSurvivorDesc =>
      'Vous avez trouvé une pomme de pin sérotineuse ouverte par le feu.';

  @override
  String get achFlameSurvivorHint =>
      'Certaines pommes de pin s\'ouvrent uniquement sous une chaleur extrême...';

  @override
  String get achThunderstruck => 'Coup de Foudre';

  @override
  String get achThunderstruckDesc =>
      'Vous avez scanné sous une pluie battante.';

  @override
  String get achThunderstruckHint =>
      'La nature ne s\'arrête pas quand il pleut. Pourquoi le feriez-vous ?';

  @override
  String get achWoodPineapple => 'Ananas des Bois';

  @override
  String get achWoodPineappleDesc =>
      'Vous avez scanné un pomme de pin d\'Araucaria qui ressemble à un ananas.';

  @override
  String get achWoodPineappleHint =>
      'Certaines pommes de pin se prennent pour des fruits exotiques...';

  @override
  String get achCrystalCone => 'Le Conifère de Cristal';

  @override
  String get achCrystalConeDesc =>
      'Vous avez identifié 15 espèces de rareté \'Légendaire\'.';

  @override
  String get achTaxonomist => 'Le Taxinomiste';

  @override
  String get achTaxonomistDesc =>
      'Précision absolue. 50 pommes de pin avec 100% de métadonnées remplies.';
}
