// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Strobilus';

  @override
  String get navMap => 'Map';

  @override
  String get navCollection => 'Collection';

  @override
  String get navAdd => 'Add';

  @override
  String get navSpecies => 'Strobilodex';

  @override
  String get navProfile => 'Profile';

  @override
  String get collectionEmpty => 'Your collection is empty';

  @override
  String get collectionEmptySubtitle =>
      'Go outside and find your first pine cone!';

  @override
  String collectionTotal(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cones',
      one: '1 cone',
      zero: 'No cones',
    );
    return '$_temp0';
  }

  @override
  String get collectionGridView => 'Grid view';

  @override
  String get collectionListView => 'List view';

  @override
  String get collectionSortDate => 'Date';

  @override
  String get collectionSortSpecies => 'Species';

  @override
  String get collectionSortRarity => 'Rarity';

  @override
  String get collectionSortCountry => 'Country';

  @override
  String get collectionSearch => 'Search cones…';

  @override
  String get rarityCommon => 'Common';

  @override
  String get rarityUncommon => 'Uncommon';

  @override
  String get rarityRare => 'Rare';

  @override
  String get rarityVeryRare => 'Very Rare';

  @override
  String get rarityLegendary => 'Legendary';

  @override
  String get sizeXs => 'Tiny (< 2 cm)';

  @override
  String get sizeS => 'Small (2–4 cm)';

  @override
  String get sizeM => 'Medium (4–7 cm)';

  @override
  String get sizeL => 'Large (7–12 cm)';

  @override
  String get sizeXl => 'Giant (> 12 cm)';

  @override
  String get conditionPristine => 'Pristine';

  @override
  String get conditionGood => 'Good';

  @override
  String get conditionWorn => 'Worn';

  @override
  String get conditionFragmented => 'Fragmented';

  @override
  String get habitatForest => 'Forest';

  @override
  String get habitatPark => 'Park';

  @override
  String get habitatGarden => 'Garden';

  @override
  String get habitatMountain => 'Mountain';

  @override
  String get habitatCoastal => 'Coastal';

  @override
  String get habitatOther => 'Other';

  @override
  String get addConeTitle => 'Add a Pine Cone';

  @override
  String get stepPhoto => 'Photo';

  @override
  String get stepLocation => 'Location';

  @override
  String get stepDetails => 'Details';

  @override
  String get stepConfirm => 'Confirm';

  @override
  String get takePhoto => 'Take a photo';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get skipPhoto => 'Add photo later';

  @override
  String get useMyLocation => 'Use my location';

  @override
  String get adjustPinOnMap => 'Drag pin to adjust';

  @override
  String get searchSpecies => 'Search species…';

  @override
  String get unknownSpecies => 'Unknown species';

  @override
  String get personalNotes => 'Personal notes (optional)';

  @override
  String get notesHint => 'What makes this cone special to you?';

  @override
  String get tagsHint => 'Add tags…';

  @override
  String get addVoiceNote => 'Record a voice note';

  @override
  String get voiceNoteMaxDuration => 'Maximum 90 seconds';

  @override
  String get addToCollection => 'Add to Collection';

  @override
  String get coneAddedSuccess => 'Pine cone added to your collection!';

  @override
  String get manualEntryTitle => 'Manual Entry';

  @override
  String get tapToSelectPhoto => 'Tap to select photo';

  @override
  String get commonNameLabel => 'Common Name';

  @override
  String get scientificNameLabel => 'Scientific Name (Optional)';

  @override
  String get locationNameLabel => 'Location Name';

  @override
  String get sizeLabel => 'Size';

  @override
  String get conditionLabel => 'Condition';

  @override
  String get rarityLabel => 'Rarity';

  @override
  String get saveManualEntry => 'Save Manual Entry';

  @override
  String get editDetails => 'Edit Details';

  @override
  String get gpsUnavailable =>
      'GPS unavailable. Please enter the location manually later.';

  @override
  String get aiQuickCaptureTitle => 'AI Quick Capture';

  @override
  String get aiQuickCaptureSubtitle => 'Take a photo and auto-identify';

  @override
  String get manualEntrySubtitle => 'Pick a photo and fill details manually';

  @override
  String get aiPendingMessage => 'Captured offline. AI identification pending.';

  @override
  String get aiIdentificationComplete => 'AI Identification complete!';

  @override
  String get coneUpdatedSuccess => 'Pine cone updated successfully.';

  @override
  String get editConeTitle => 'Edit Pine Cone';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get errorFieldRequired => 'Please enter a name';

  @override
  String get appTagline => 'Pine Cone Collector';

  @override
  String get mapFilterComingSoon => 'Filter coming soon';

  @override
  String conesCollected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cones collected',
      one: '1 cone collected',
      zero: 'No cones collected',
    );
    return '$_temp0';
  }

  @override
  String get errorAuthNotEnabled =>
      'Email/Password authentication is not enabled.';

  @override
  String firstConeFromCountry(String country) {
    return 'First cone from $country! 🎉';
  }

  @override
  String get aiIdentifyButton => 'Identify with AI';

  @override
  String get aiIdentifying => 'Identifying…';

  @override
  String get aiDailyLimitReached =>
      'Daily identification limit reached. Try again tomorrow.';

  @override
  String aiConfidence(int percent) {
    return '$percent% confidence';
  }

  @override
  String get aiTopMatches => 'Top matches';

  @override
  String get aiNoMatch =>
      'Could not identify this pine cone. Try another photo.';

  @override
  String get errorNoLocation => 'Location is required to add a cone.';

  @override
  String get errorNoPhoto => 'Please add at least one photo.';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorNetworkOffline =>
      'You\'re offline. Changes will sync when you reconnect.';

  @override
  String get speciesTypeLabel => 'Species (optional)';

  @override
  String get speciesTypeHint => 'Search or select a species...';

  @override
  String get coneDeletedSuccess => 'Pine cone deleted from your collection.';

  @override
  String get deleteConeConfirmation =>
      'Are you sure you want to delete this pine cone? This action cannot be undone.';

  @override
  String coneAddedToSpecies(String speciesName) {
    return 'Pine cone added to $speciesName collection!';
  }

  @override
  String aiIdentifiedAs(String speciesName) {
    return 'Identified as $speciesName';
  }

  @override
  String get coneSavedSuccess => 'Pine cone saved successfully!';

  @override
  String get errorWeakPassword =>
      'Password is too weak. Use at least 6 characters.';

  @override
  String get errorEmailInUse => 'This email is already registered.';

  @override
  String get errorInvalidEmail => 'Please enter a valid email address.';

  @override
  String get errorWrongPassword => 'Incorrect password. Please try again.';

  @override
  String get errorUserNotFound => 'No account found for this email.';

  @override
  String get authLogin => 'Log In';

  @override
  String get authRegister => 'Create Account';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Password';

  @override
  String get authConfirmPassword => 'Confirm password';

  @override
  String get authForgotPassword => 'Forgot password?';

  @override
  String get authNoAccount => 'Don\'t have an account?';

  @override
  String get authHasAccount => 'Already have an account?';

  @override
  String get authSignUp => 'Sign Up';

  @override
  String get authSignIn => 'Sign In';

  @override
  String get authSignOut => 'Sign Out';

  @override
  String get authPasswordReset => 'Password reset email sent.';

  @override
  String get authDisplayName => 'Display name';

  @override
  String get authUsername => 'Username';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAccount => 'Account';

  @override
  String get settingsApp => 'App';

  @override
  String get settingsPrivacy => 'Privacy';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsLightDark => 'Light / Dark';

  @override
  String get settingsColorTheme => 'Color Theme';

  @override
  String get settingsExportData => 'Export my data';

  @override
  String get settingsDeleteAccount => 'Delete Account';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsLicenses => 'Open Source Licenses';

  @override
  String get settingsDeleteAccountConfirm =>
      'Are you sure you want to permanently delete your account? This action cannot be undone and will erase all your pine cones, collections, and profile data.';

  @override
  String get settingsDeleteAccountCancel => 'Cancel';

  @override
  String get settingsDeleteAccountAction => 'Delete';

  @override
  String get settingsResetAccount => 'Reset Account';

  @override
  String get settingsResetAccountConfirm =>
      'Are you sure you want to reset your account? All your pine cones, collections, and achievements will be erased, but your account will remain active.';

  @override
  String get settingsResetAccountCancel => 'Cancel';

  @override
  String get settingsResetAccountAction => 'Reset';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsTerms => 'Terms of Use';

  @override
  String get settingsDailyReminder => 'Daily reminder';

  @override
  String get settingsNewSpeciesAlert => 'New species alerts';

  @override
  String get settingsUnits => 'Units';

  @override
  String get settingsMetric => 'Metric';

  @override
  String get settingsImperial => 'Imperial';

  @override
  String get deleteAccountConfirm => 'Type your username to confirm';

  @override
  String get deleteAccountWarning =>
      'This will permanently delete all your cones and photos.';

  @override
  String get privacyTitle => 'Your Privacy';

  @override
  String get privacySubtitle =>
      'We care about your data. Here\'s what we collect and why.';

  @override
  String get privacyLocationData =>
      'Location data is stored only when you add a cone.';

  @override
  String get privacyPhotos =>
      'Photos are stored securely and only visible to you.';

  @override
  String get privacyAnalytics => 'Analytics (helps us improve)';

  @override
  String get privacyPersonalization => 'Personalization';

  @override
  String get privacyAgree => 'I understand and agree';

  @override
  String get privacyMustScroll =>
      'Please read the full privacy information above.';

  @override
  String get onboardingTitle1 => 'Your Pine Cones,\nMapped';

  @override
  String get onboardingBody1 =>
      'Pin every cone to the exact spot where you found it — across parks, forests, and continents.';

  @override
  String get onboardingTitle2 => 'Identify & Catalog';

  @override
  String get onboardingBody2 =>
      'Photograph your cones, identify the species, and build a living botanical collection.';

  @override
  String get onboardingTitle3 => 'Track Your Journey';

  @override
  String get onboardingBody3 =>
      'See at a glance how many species and countries your collection spans.';

  @override
  String get onboardingGetStarted => 'Get Started';

  @override
  String get speciesLibrary => 'Strobilodex';

  @override
  String get speciesFamily => 'Family';

  @override
  String get speciesGenus => 'Genus';

  @override
  String get speciesNativeRegion => 'Native Region';

  @override
  String get speciesSizeRange => 'Size Range';

  @override
  String get speciesHabitat => 'Habitat';

  @override
  String get speciesYourSpecimens => 'Your Specimens';

  @override
  String get speciesInterestingFacts => 'Did you know?';

  @override
  String get speciesDescription => 'Description';

  @override
  String get speciesInCollection => 'in your collection';

  @override
  String get speciesFoundCTA => 'I found one!';

  @override
  String get speciesNotInCollection => 'Not yet discovered';

  @override
  String speciesTotalCount(int count) {
    return '$count species';
  }

  @override
  String pokedexProgress(int discovered, int total) {
    return '$discovered / $total discovered';
  }

  @override
  String get pokedexAllFilter => 'All';

  @override
  String get pokedexHardPines => 'Hard Pines';

  @override
  String get pokedexSoftPines => 'Soft Pines';

  @override
  String get pokedexOtherConifers => 'Other Conifers';

  @override
  String get pokedexSortStrobilodex => 'Strobilodex #';

  @override
  String get pokedexSortName => 'Name';

  @override
  String get pokedexSortRarity => 'Rarity';

  @override
  String get pokedexSortDifficulty => 'Difficulty';

  @override
  String get pokedexDiscovered => 'Discovered!';

  @override
  String get pokedexUndiscovered => 'Undiscovered';

  @override
  String get taxonomyTitle => 'Taxonomy';

  @override
  String get taxonomySubgenus => 'Subgenus';

  @override
  String get taxonomySection => 'Section';

  @override
  String get taxonomySubsection => 'Subsection';

  @override
  String get morphologyTitle => 'Cone Morphology';

  @override
  String get morphologyConeSize => 'Cone Size';

  @override
  String get morphologyConeShape => 'Shape';

  @override
  String get morphologyUmbo => 'Umbo';

  @override
  String get morphologyUmboDorsal => 'Dorsal';

  @override
  String get morphologyUmboTerminal => 'Terminal';

  @override
  String get morphologyMucro => 'Mucro (Spine)';

  @override
  String get morphologyMucroPresent => 'Present';

  @override
  String get morphologyMucroAbsent => 'Absent';

  @override
  String get morphologyApophysis => 'Apophysis';

  @override
  String get morphologySerotiny => 'Serotiny';

  @override
  String get morphologySerotinous => 'Fire-dependent (serotinous)';

  @override
  String get morphologyNonSerotinous => 'Standard opening';

  @override
  String get morphologyNeedles => 'Needles / fascicle';

  @override
  String get morphologySeedType => 'Seed Type';

  @override
  String get morphologySeedWinged => 'Winged (wind)';

  @override
  String get morphologySeedWingless => 'Wingless';

  @override
  String get morphologySeedEdible => 'Edible nut';

  @override
  String get morphologySeedBird => 'Bird-dispersed';

  @override
  String get morphologyConeWeight => 'Max Weight';

  @override
  String get distributionTitle => 'Distribution';

  @override
  String get distributionNative => 'Native Range';

  @override
  String get distributionIntroduced => 'Widely planted ornamental';

  @override
  String get distributionNotIntroduced => 'Restricted to native range';

  @override
  String get conservationTitle => 'Conservation';

  @override
  String get conservationLC => 'Least Concern';

  @override
  String get conservationNT => 'Near Threatened';

  @override
  String get conservationVU => 'Vulnerable';

  @override
  String get conservationEN => 'Endangered';

  @override
  String get conservationCR => 'Critically Endangered';

  @override
  String get discoveryDifficultyTitle => 'Discovery Difficulty';

  @override
  String get profileCones => 'Cones';

  @override
  String get profileSpecies => 'Species';

  @override
  String get profileCountries => 'Countries';

  @override
  String profileStreak(int days) {
    return '🔥 $days-day streak';
  }

  @override
  String get profileRecentActivity => 'Recent Activity';

  @override
  String get profileEditProfile => 'Edit Profile';

  @override
  String get profileBio => 'Bio';

  @override
  String get achievementsTitle => 'Achievements';

  @override
  String get achievementLocked => 'Locked';

  @override
  String get achievementFirstCone => 'First Cone';

  @override
  String get achievementFirstConeDesc =>
      'The beginning of a great adventure. You\'ve cataloged your first pine cone.';

  @override
  String get achievementExplorer => 'Explorer';

  @override
  String get achievementExplorerDesc =>
      'You have added 10 pine cones to your collection.';

  @override
  String get achievementNaturalist => 'Naturalist';

  @override
  String get achievementNaturalistDesc =>
      'You have identified 5 different species of strobiles.';

  @override
  String get achievementWorldTraveler => 'World Traveler';

  @override
  String get achievementWorldTravelerDesc =>
      'You have found cones in 3 different countries!';

  @override
  String get achievementWorldTravelerHint =>
      'Borders to cross, cultures to discover...';

  @override
  String get achievementLegendaryFind => 'Gold Digger';

  @override
  String get achievementLegendaryFindDesc =>
      'Identified 50 cones across the world.';

  @override
  String get achievementLegendaryFindHint =>
      'Only the most persistent will gather a treasure.';

  @override
  String get achievementTheWalker => 'The Walker';

  @override
  String get achievementTheWalkerDesc =>
      'From beaten paths to deep forests, you collected 25 cones.';

  @override
  String get achievementTheWalkerHint =>
      'From beaten paths to deep forests... Keep walking.';

  @override
  String get boardUnlocked => 'Unlocked';

  @override
  String get boardScore => 'Rare Score';

  @override
  String get boardShowcase => 'Personal Showcase';

  @override
  String get boardInProgress => 'In Progress';

  @override
  String get boardTapToFlip => 'Tap to flip';

  @override
  String boardUnlockedDate(String date) {
    return 'Earned on $date';
  }

  @override
  String get boardClaim => 'TAP TO HATCH!';

  @override
  String get boardHintTitle => 'Cryptic Hint';

  @override
  String get boardClose => 'Close';

  @override
  String get voiceNotes => 'Voice Notes';

  @override
  String get voiceNoteRecording => 'Recording…';

  @override
  String get voiceNoteStop => 'Stop';

  @override
  String get voiceNotePlay => 'Play';

  @override
  String get voiceNoteDelete => 'Delete note';

  @override
  String get voiceNoteDeleteConfirm => 'Delete this voice note?';

  @override
  String get voiceNoteAdded => 'Voice note added';

  @override
  String get voiceNoteLimit => 'Maximum 2 voice notes per cone';

  @override
  String get mapFilterTitle => 'Filter Cones';

  @override
  String get mapFilterSpecies => 'Species';

  @override
  String get mapFilterRarity => 'Rarity';

  @override
  String get mapFilterDateRange => 'Date Range';

  @override
  String get mapFilterApply => 'Apply Filters';

  @override
  String get mapFilterClear => 'Clear All';

  @override
  String get mapMyLocation => 'My location';

  @override
  String get mapAddConeHere => 'Add cone here';

  @override
  String get mapViewDetails => 'View Details';

  @override
  String mapConeCount(int count) {
    return '$count cones in this area';
  }

  @override
  String get themeForest => 'Forest';

  @override
  String get themeArctic => 'Arctic';

  @override
  String get themeAutumn => 'Autumn';

  @override
  String get themeOcean => 'Ocean';

  @override
  String get themeDesert => 'Desert';

  @override
  String get themeMidnight => 'Midnight';

  @override
  String get themeBrightnessLight => 'Light';

  @override
  String get themeBrightnessDark => 'Dark';

  @override
  String get themeBrightnessSystem => 'System';

  @override
  String get syncingData => 'Syncing…';

  @override
  String get offlineBanner =>
      'You\'re offline — changes will sync automatically';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get save => 'Save';

  @override
  String get edit => 'Edit';

  @override
  String get done => 'Done';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get close => 'Close';

  @override
  String get confirm => 'Confirm';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get retry => 'Retry';

  @override
  String get loading => 'Loading…';

  @override
  String get noResults => 'No results found';

  @override
  String get seeAll => 'See all';

  @override
  String get locating => 'Locating…';

  @override
  String get gpsLocked => 'GPS Locked';

  @override
  String get gpsUnavailableShort => 'GPS Unavailable';

  @override
  String get unknownCone => 'Unknown Cone';

  @override
  String get unknownLocation => 'Unknown Location';

  @override
  String get unknownContinent => 'Unknown';

  @override
  String get cameraError => 'Camera error. Please try again.';

  @override
  String get aiIdentificationFailed =>
      'AI identification failed. Try again or save manually.';

  @override
  String get editProfileTitle => 'Edit Profile';

  @override
  String get editProfileNickname => 'Nickname';

  @override
  String get editProfileBio => 'Biography';

  @override
  String get editProfileBanner => 'Profile Banner';

  @override
  String get editProfileTheme => 'Background Theme';

  @override
  String get editProfilePhoto => 'Profile Photo';

  @override
  String get editProfileSaveSuccess => 'Profile updated successfully!';

  @override
  String get editProfileSaveError => 'Error updating profile';

  @override
  String get editProfileSelectSource => 'Select source';

  @override
  String get editProfileCamera => 'Camera';

  @override
  String get editProfileGallery => 'Gallery';

  @override
  String get editProfileThemeForest => 'Forest Gradient';

  @override
  String get editProfileThemeArctic => 'Arctic Mist';

  @override
  String get editProfileThemeAutumn => 'Autumn Sunset';

  @override
  String get editProfileThemeOcean => 'Ocean Depth';

  @override
  String get editProfileThemeNone => 'None (default color)';

  @override
  String get locationPickerClose => 'Close';

  @override
  String get locationPickerNoResults => 'No results';

  @override
  String get locationPickerGps => 'GPS Location';

  @override
  String get locationPickerSearch => 'Search';

  @override
  String get viewInteractiveMap => 'View Interactive Map';

  @override
  String get distributionNativeLabel => 'Native';

  @override
  String get distributionIntroducedLabel => 'Introduced';

  @override
  String get loadingMapData => 'Loading map data…';

  @override
  String get previousSpecies => 'Previous species';

  @override
  String get nextSpecies => 'Next species';

  @override
  String get viewFullImage => 'View full image';

  @override
  String get achVoiceForest => 'Voice of the Forest';

  @override
  String get achVoiceForestDesc =>
      'You added your first voice note to document your emotions.';

  @override
  String get achPhotographicEye => 'Photographic Eye';

  @override
  String get achPhotographicEyeDesc =>
      'A true 3D model! You added 4 photos from different angles.';

  @override
  String get achTheMeasurer => 'The Measurer';

  @override
  String get achTheMeasurerDesc =>
      'You found and documented a specimen for each size category.';

  @override
  String get achTheMeasurerHint =>
      'Strobiles come in all sizes. Find them from Tiny to Giant.';

  @override
  String get achImperfectBeauty => 'Imperfect Beauty';

  @override
  String get achImperfectBeautyDesc =>
      'You scanned 10 cones in \'Fragmented\' or \'Worn\' condition.';

  @override
  String get achImperfectBeautyHint =>
      'Nature is not perfect... Look for damaged cones.';

  @override
  String get achTheWalker => 'The Walker';

  @override
  String get achTheWalkerDesc =>
      'You walked long kilometers to find 50 pine cones.';

  @override
  String get achFamilyTree => 'Family Tree';

  @override
  String get achFamilyTreeDesc =>
      'You 100% completed the family tree of a botanical Genus.';

  @override
  String get achFamilyTreeHint =>
      'Find all species of the same Genus (e.g., all local Pinus).';

  @override
  String get achFreneticHarvest => 'Frenetic Harvest';

  @override
  String get achFreneticHarvestDesc =>
      'You scanned 10 cones in under 24 hours.';

  @override
  String get achFreneticHarvestHint =>
      'A very productive day awaits you. Go outside!';

  @override
  String get achRooted => 'Rooted';

  @override
  String get achRootedDesc => 'You scanned a specimen for 30 consecutive days.';

  @override
  String get achRootedHint =>
      'Consistency is key. Open the Strobilodex every day.';

  @override
  String get achSeaWolf => 'Sea Wolf';

  @override
  String get achSeaWolfDesc =>
      'Find a strobile less than 500 meters from the ocean.';

  @override
  String get achUrbanExplorer => 'Urban Explorer';

  @override
  String get achUrbanExplorerDesc =>
      'You cataloged a specimen in a downtown park.';

  @override
  String get achBotanicalClimber => 'Botanical Climber';

  @override
  String get achBotanicalClimberDesc =>
      'You found a specimen above 2000m altitude.';

  @override
  String get achBotanicalClimberHint =>
      'Go higher. Search where the air gets thin.';

  @override
  String get achContinentConqueror => 'Continent Conqueror';

  @override
  String get achContinentConquerorDesc =>
      'Find specimens on 3 different continents.';

  @override
  String get achContinentConquerorHint => 'The world is your forest. Travel!';

  @override
  String get achNightOwl => 'Night Owl';

  @override
  String get achNightOwlDesc =>
      'You braved the dark to scan a cone between 2am and 4am.';

  @override
  String get achFlameSurvivor => 'Flame Survivor';

  @override
  String get achFlameSurvivorDesc =>
      'You found a serotinous pine cone opened by fire.';

  @override
  String get achFlameSurvivorHint =>
      'Some pine cones only open under extreme heat...';

  @override
  String get achThunderstruck => 'Thunderstruck';

  @override
  String get achThunderstruckDesc => 'You scanned under pouring rain.';

  @override
  String get achThunderstruckHint =>
      'Nature doesn\'t stop when it rains. Why should you?';

  @override
  String get achWoodPineapple => 'Wood Pineapple';

  @override
  String get achWoodPineappleDesc =>
      'You scanned an Araucaria cone that looks like a pineapple.';

  @override
  String get achWoodPineappleHint =>
      'Some pine cones think they are exotic fruits...';

  @override
  String get achCrystalCone => 'Crystal Cone';

  @override
  String get achCrystalConeDesc =>
      'You identified 15 \'Legendary\' rarity species.';

  @override
  String get achTaxonomist => 'The Taxonomist';

  @override
  String get achTaxonomistDesc =>
      'Absolute precision. 50 cones with 100% metadata filled.';

  @override
  String get scanStep1 => 'Analyzing the scales...';

  @override
  String get scanStep2 => 'Identifying the species...';

  @override
  String get scanStep3 => 'Estimating the size...';

  @override
  String get scanStep4 => 'Almost there...';

  @override
  String get emptyCollectionTitle => 'Your adventure starts here';

  @override
  String get emptyCollectionSubtitle =>
      'Go explore and add your first pine cone to your collection!';

  @override
  String get emptyCollectionCta => 'Start the adventure';

  @override
  String get emptyMapTitle => 'Explore the world';

  @override
  String get emptyMapSubtitle =>
      'Your finds will appear here on the map. Go collect!';

  @override
  String get coachMarkTitle => 'Your first find!';

  @override
  String get coachMarkBody => 'Tap here to capture your first pine cone';
}
