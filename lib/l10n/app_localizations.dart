import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Strobilus'**
  String get appName;

  /// No description provided for @navMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get navMap;

  /// No description provided for @navCollection.
  ///
  /// In en, this message translates to:
  /// **'Collection'**
  String get navCollection;

  /// No description provided for @navAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get navAdd;

  /// No description provided for @navSpecies.
  ///
  /// In en, this message translates to:
  /// **'Species'**
  String get navSpecies;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @collectionEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your collection is empty'**
  String get collectionEmpty;

  /// No description provided for @collectionEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Go outside and find your first pine cone!'**
  String get collectionEmptySubtitle;

  /// No description provided for @collectionTotal.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No cones} =1{1 cone} other{{count} cones}}'**
  String collectionTotal(int count);

  /// No description provided for @collectionGridView.
  ///
  /// In en, this message translates to:
  /// **'Grid view'**
  String get collectionGridView;

  /// No description provided for @collectionListView.
  ///
  /// In en, this message translates to:
  /// **'List view'**
  String get collectionListView;

  /// No description provided for @collectionSortDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get collectionSortDate;

  /// No description provided for @collectionSortSpecies.
  ///
  /// In en, this message translates to:
  /// **'Species'**
  String get collectionSortSpecies;

  /// No description provided for @collectionSortRarity.
  ///
  /// In en, this message translates to:
  /// **'Rarity'**
  String get collectionSortRarity;

  /// No description provided for @collectionSortCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get collectionSortCountry;

  /// No description provided for @collectionSearch.
  ///
  /// In en, this message translates to:
  /// **'Search cones…'**
  String get collectionSearch;

  /// No description provided for @rarityCommon.
  ///
  /// In en, this message translates to:
  /// **'Common'**
  String get rarityCommon;

  /// No description provided for @rarityUncommon.
  ///
  /// In en, this message translates to:
  /// **'Uncommon'**
  String get rarityUncommon;

  /// No description provided for @rarityRare.
  ///
  /// In en, this message translates to:
  /// **'Rare'**
  String get rarityRare;

  /// No description provided for @rarityVeryRare.
  ///
  /// In en, this message translates to:
  /// **'Very Rare'**
  String get rarityVeryRare;

  /// No description provided for @rarityLegendary.
  ///
  /// In en, this message translates to:
  /// **'Legendary'**
  String get rarityLegendary;

  /// No description provided for @sizeXs.
  ///
  /// In en, this message translates to:
  /// **'Tiny (< 2 cm)'**
  String get sizeXs;

  /// No description provided for @sizeS.
  ///
  /// In en, this message translates to:
  /// **'Small (2–4 cm)'**
  String get sizeS;

  /// No description provided for @sizeM.
  ///
  /// In en, this message translates to:
  /// **'Medium (4–7 cm)'**
  String get sizeM;

  /// No description provided for @sizeL.
  ///
  /// In en, this message translates to:
  /// **'Large (7–12 cm)'**
  String get sizeL;

  /// No description provided for @sizeXl.
  ///
  /// In en, this message translates to:
  /// **'Giant (> 12 cm)'**
  String get sizeXl;

  /// No description provided for @conditionPristine.
  ///
  /// In en, this message translates to:
  /// **'Pristine'**
  String get conditionPristine;

  /// No description provided for @conditionGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get conditionGood;

  /// No description provided for @conditionWorn.
  ///
  /// In en, this message translates to:
  /// **'Worn'**
  String get conditionWorn;

  /// No description provided for @conditionFragmented.
  ///
  /// In en, this message translates to:
  /// **'Fragmented'**
  String get conditionFragmented;

  /// No description provided for @habitatForest.
  ///
  /// In en, this message translates to:
  /// **'Forest'**
  String get habitatForest;

  /// No description provided for @habitatPark.
  ///
  /// In en, this message translates to:
  /// **'Park'**
  String get habitatPark;

  /// No description provided for @habitatGarden.
  ///
  /// In en, this message translates to:
  /// **'Garden'**
  String get habitatGarden;

  /// No description provided for @habitatMountain.
  ///
  /// In en, this message translates to:
  /// **'Mountain'**
  String get habitatMountain;

  /// No description provided for @habitatCoastal.
  ///
  /// In en, this message translates to:
  /// **'Coastal'**
  String get habitatCoastal;

  /// No description provided for @habitatOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get habitatOther;

  /// No description provided for @addConeTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a Pine Cone'**
  String get addConeTitle;

  /// No description provided for @stepPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get stepPhoto;

  /// No description provided for @stepLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get stepLocation;

  /// No description provided for @stepDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get stepDetails;

  /// No description provided for @stepConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get stepConfirm;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

  /// No description provided for @skipPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add photo later'**
  String get skipPhoto;

  /// No description provided for @useMyLocation.
  ///
  /// In en, this message translates to:
  /// **'Use my location'**
  String get useMyLocation;

  /// No description provided for @adjustPinOnMap.
  ///
  /// In en, this message translates to:
  /// **'Drag pin to adjust'**
  String get adjustPinOnMap;

  /// No description provided for @searchSpecies.
  ///
  /// In en, this message translates to:
  /// **'Search species…'**
  String get searchSpecies;

  /// No description provided for @unknownSpecies.
  ///
  /// In en, this message translates to:
  /// **'Unknown species'**
  String get unknownSpecies;

  /// No description provided for @personalNotes.
  ///
  /// In en, this message translates to:
  /// **'Personal notes (optional)'**
  String get personalNotes;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'What makes this cone special to you?'**
  String get notesHint;

  /// No description provided for @tagsHint.
  ///
  /// In en, this message translates to:
  /// **'Add tags…'**
  String get tagsHint;

  /// No description provided for @addVoiceNote.
  ///
  /// In en, this message translates to:
  /// **'Record a voice note'**
  String get addVoiceNote;

  /// No description provided for @voiceNoteMaxDuration.
  ///
  /// In en, this message translates to:
  /// **'Maximum 90 seconds'**
  String get voiceNoteMaxDuration;

  /// No description provided for @addToCollection.
  ///
  /// In en, this message translates to:
  /// **'Add to Collection'**
  String get addToCollection;

  /// No description provided for @coneAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Pine cone added to your collection!'**
  String get coneAddedSuccess;

  /// No description provided for @manualEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Manual Entry'**
  String get manualEntryTitle;

  /// No description provided for @tapToSelectPhoto.
  ///
  /// In en, this message translates to:
  /// **'Tap to select photo'**
  String get tapToSelectPhoto;

  /// No description provided for @commonNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Common Name'**
  String get commonNameLabel;

  /// No description provided for @scientificNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Scientific Name (Optional)'**
  String get scientificNameLabel;

  /// No description provided for @locationNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Location Name'**
  String get locationNameLabel;

  /// No description provided for @sizeLabel.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get sizeLabel;

  /// No description provided for @conditionLabel.
  ///
  /// In en, this message translates to:
  /// **'Condition'**
  String get conditionLabel;

  /// No description provided for @rarityLabel.
  ///
  /// In en, this message translates to:
  /// **'Rarity'**
  String get rarityLabel;

  /// No description provided for @saveManualEntry.
  ///
  /// In en, this message translates to:
  /// **'Save Manual Entry'**
  String get saveManualEntry;

  /// No description provided for @editDetails.
  ///
  /// In en, this message translates to:
  /// **'Edit Details'**
  String get editDetails;

  /// No description provided for @gpsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'GPS unavailable. Please enter the location manually later.'**
  String get gpsUnavailable;

  /// No description provided for @aiQuickCaptureTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Quick Capture'**
  String get aiQuickCaptureTitle;

  /// No description provided for @aiQuickCaptureSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Take a photo and auto-identify'**
  String get aiQuickCaptureSubtitle;

  /// No description provided for @manualEntrySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick a photo and fill details manually'**
  String get manualEntrySubtitle;

  /// No description provided for @aiPendingMessage.
  ///
  /// In en, this message translates to:
  /// **'Captured offline. AI identification pending.'**
  String get aiPendingMessage;

  /// No description provided for @aiIdentificationComplete.
  ///
  /// In en, this message translates to:
  /// **'AI Identification complete!'**
  String get aiIdentificationComplete;

  /// No description provided for @coneUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Pine cone updated successfully.'**
  String get coneUpdatedSuccess;

  /// No description provided for @editConeTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Pine Cone'**
  String get editConeTitle;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @errorFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get errorFieldRequired;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Pine Cone Collector'**
  String get appTagline;

  /// No description provided for @mapFilterComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Filter coming soon'**
  String get mapFilterComingSoon;

  /// No description provided for @conesCollected.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No cones collected} =1{1 cone collected} other{{count} cones collected}}'**
  String conesCollected(int count);

  /// No description provided for @errorAuthNotEnabled.
  ///
  /// In en, this message translates to:
  /// **'Email/Password authentication is not enabled.'**
  String get errorAuthNotEnabled;

  /// No description provided for @firstConeFromCountry.
  ///
  /// In en, this message translates to:
  /// **'First cone from {country}! 🎉'**
  String firstConeFromCountry(String country);

  /// No description provided for @aiIdentifyButton.
  ///
  /// In en, this message translates to:
  /// **'Identify with AI'**
  String get aiIdentifyButton;

  /// No description provided for @aiIdentifying.
  ///
  /// In en, this message translates to:
  /// **'Identifying…'**
  String get aiIdentifying;

  /// No description provided for @aiDailyLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Daily identification limit reached. Try again tomorrow.'**
  String get aiDailyLimitReached;

  /// No description provided for @aiConfidence.
  ///
  /// In en, this message translates to:
  /// **'{percent}% confidence'**
  String aiConfidence(int percent);

  /// No description provided for @aiTopMatches.
  ///
  /// In en, this message translates to:
  /// **'Top matches'**
  String get aiTopMatches;

  /// No description provided for @aiNoMatch.
  ///
  /// In en, this message translates to:
  /// **'Could not identify this pine cone. Try another photo.'**
  String get aiNoMatch;

  /// No description provided for @errorNoLocation.
  ///
  /// In en, this message translates to:
  /// **'Location is required to add a cone.'**
  String get errorNoLocation;

  /// No description provided for @errorNoPhoto.
  ///
  /// In en, this message translates to:
  /// **'Please add at least one photo.'**
  String get errorNoPhoto;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @errorNetworkOffline.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. Changes will sync when you reconnect.'**
  String get errorNetworkOffline;

  /// No description provided for @errorWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak. Use at least 6 characters.'**
  String get errorWeakPassword;

  /// No description provided for @errorEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered.'**
  String get errorEmailInUse;

  /// No description provided for @errorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get errorInvalidEmail;

  /// No description provided for @errorWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password. Please try again.'**
  String get errorWrongPassword;

  /// No description provided for @errorUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'No account found for this email.'**
  String get errorUserNotFound;

  /// No description provided for @authLogin.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get authLogin;

  /// No description provided for @authRegister.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authRegister;

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmail;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get authConfirmPassword;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get authForgotPassword;

  /// No description provided for @authNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get authNoAccount;

  /// No description provided for @authHasAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get authHasAccount;

  /// No description provided for @authSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get authSignUp;

  /// No description provided for @authSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get authSignIn;

  /// No description provided for @authSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get authSignOut;

  /// No description provided for @authPasswordReset.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent.'**
  String get authPasswordReset;

  /// No description provided for @authDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get authDisplayName;

  /// No description provided for @authUsername.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get authUsername;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccount;

  /// No description provided for @settingsApp.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get settingsApp;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsPrivacy;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsLightDark.
  ///
  /// In en, this message translates to:
  /// **'Light / Dark'**
  String get settingsLightDark;

  /// No description provided for @settingsColorTheme.
  ///
  /// In en, this message translates to:
  /// **'Color Theme'**
  String get settingsColorTheme;

  /// No description provided for @settingsExportData.
  ///
  /// In en, this message translates to:
  /// **'Export my data'**
  String get settingsExportData;

  /// No description provided for @settingsDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get settingsDeleteAccount;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersion;

  /// No description provided for @settingsLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open Source Licenses'**
  String get settingsLicenses;

  /// No description provided for @settingsDeleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete your account? This action cannot be undone and will erase all your pine cones, collections, and profile data.'**
  String get settingsDeleteAccountConfirm;

  /// No description provided for @settingsDeleteAccountCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get settingsDeleteAccountCancel;

  /// No description provided for @settingsDeleteAccountAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get settingsDeleteAccountAction;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get settingsTerms;

  /// No description provided for @settingsDailyReminder.
  ///
  /// In en, this message translates to:
  /// **'Daily reminder'**
  String get settingsDailyReminder;

  /// No description provided for @settingsNewSpeciesAlert.
  ///
  /// In en, this message translates to:
  /// **'New species alerts'**
  String get settingsNewSpeciesAlert;

  /// No description provided for @settingsUnits.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get settingsUnits;

  /// No description provided for @settingsMetric.
  ///
  /// In en, this message translates to:
  /// **'Metric'**
  String get settingsMetric;

  /// No description provided for @settingsImperial.
  ///
  /// In en, this message translates to:
  /// **'Imperial'**
  String get settingsImperial;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Type your username to confirm'**
  String get deleteAccountConfirm;

  /// No description provided for @deleteAccountWarning.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete all your cones and photos.'**
  String get deleteAccountWarning;

  /// No description provided for @privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Privacy'**
  String get privacyTitle;

  /// No description provided for @privacySubtitle.
  ///
  /// In en, this message translates to:
  /// **'We care about your data. Here\'s what we collect and why.'**
  String get privacySubtitle;

  /// No description provided for @privacyLocationData.
  ///
  /// In en, this message translates to:
  /// **'Location data is stored only when you add a cone.'**
  String get privacyLocationData;

  /// No description provided for @privacyPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos are stored securely and only visible to you.'**
  String get privacyPhotos;

  /// No description provided for @privacyAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics (helps us improve)'**
  String get privacyAnalytics;

  /// No description provided for @privacyPersonalization.
  ///
  /// In en, this message translates to:
  /// **'Personalization'**
  String get privacyPersonalization;

  /// No description provided for @privacyAgree.
  ///
  /// In en, this message translates to:
  /// **'I understand and agree'**
  String get privacyAgree;

  /// No description provided for @privacyMustScroll.
  ///
  /// In en, this message translates to:
  /// **'Please read the full privacy information above.'**
  String get privacyMustScroll;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Your Pine Cones,\nMapped'**
  String get onboardingTitle1;

  /// No description provided for @onboardingBody1.
  ///
  /// In en, this message translates to:
  /// **'Pin every cone to the exact spot where you found it — across parks, forests, and continents.'**
  String get onboardingBody1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Identify & Catalog'**
  String get onboardingTitle2;

  /// No description provided for @onboardingBody2.
  ///
  /// In en, this message translates to:
  /// **'Photograph your cones, identify the species, and build a living botanical collection.'**
  String get onboardingBody2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Track Your Journey'**
  String get onboardingTitle3;

  /// No description provided for @onboardingBody3.
  ///
  /// In en, this message translates to:
  /// **'See at a glance how many species and countries your collection spans.'**
  String get onboardingBody3;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingGetStarted;

  /// No description provided for @speciesLibrary.
  ///
  /// In en, this message translates to:
  /// **'Strobilodex'**
  String get speciesLibrary;

  /// No description provided for @speciesFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get speciesFamily;

  /// No description provided for @speciesGenus.
  ///
  /// In en, this message translates to:
  /// **'Genus'**
  String get speciesGenus;

  /// No description provided for @speciesNativeRegion.
  ///
  /// In en, this message translates to:
  /// **'Native Region'**
  String get speciesNativeRegion;

  /// No description provided for @speciesSizeRange.
  ///
  /// In en, this message translates to:
  /// **'Size Range'**
  String get speciesSizeRange;

  /// No description provided for @speciesHabitat.
  ///
  /// In en, this message translates to:
  /// **'Habitat'**
  String get speciesHabitat;

  /// No description provided for @speciesYourSpecimens.
  ///
  /// In en, this message translates to:
  /// **'Your Specimens'**
  String get speciesYourSpecimens;

  /// No description provided for @speciesInterestingFacts.
  ///
  /// In en, this message translates to:
  /// **'Did you know?'**
  String get speciesInterestingFacts;

  /// No description provided for @speciesDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get speciesDescription;

  /// No description provided for @speciesInCollection.
  ///
  /// In en, this message translates to:
  /// **'in your collection'**
  String get speciesInCollection;

  /// No description provided for @speciesNotInCollection.
  ///
  /// In en, this message translates to:
  /// **'Not yet discovered'**
  String get speciesNotInCollection;

  /// No description provided for @speciesTotalCount.
  ///
  /// In en, this message translates to:
  /// **'{count} species'**
  String speciesTotalCount(int count);

  /// No description provided for @pokedexProgress.
  ///
  /// In en, this message translates to:
  /// **'{discovered} / {total} discovered'**
  String pokedexProgress(int discovered, int total);

  /// No description provided for @pokedexAllFilter.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get pokedexAllFilter;

  /// No description provided for @pokedexHardPines.
  ///
  /// In en, this message translates to:
  /// **'Hard Pines'**
  String get pokedexHardPines;

  /// No description provided for @pokedexSoftPines.
  ///
  /// In en, this message translates to:
  /// **'Soft Pines'**
  String get pokedexSoftPines;

  /// No description provided for @pokedexOtherConifers.
  ///
  /// In en, this message translates to:
  /// **'Other Conifers'**
  String get pokedexOtherConifers;

  /// No description provided for @pokedexSortStrobilodex.
  ///
  /// In en, this message translates to:
  /// **'Strobilodex #'**
  String get pokedexSortStrobilodex;

  /// No description provided for @pokedexSortName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get pokedexSortName;

  /// No description provided for @pokedexSortRarity.
  ///
  /// In en, this message translates to:
  /// **'Rarity'**
  String get pokedexSortRarity;

  /// No description provided for @pokedexSortDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get pokedexSortDifficulty;

  /// No description provided for @pokedexDiscovered.
  ///
  /// In en, this message translates to:
  /// **'Discovered!'**
  String get pokedexDiscovered;

  /// No description provided for @pokedexUndiscovered.
  ///
  /// In en, this message translates to:
  /// **'Undiscovered'**
  String get pokedexUndiscovered;

  /// No description provided for @taxonomyTitle.
  ///
  /// In en, this message translates to:
  /// **'Taxonomy'**
  String get taxonomyTitle;

  /// No description provided for @taxonomySubgenus.
  ///
  /// In en, this message translates to:
  /// **'Subgenus'**
  String get taxonomySubgenus;

  /// No description provided for @taxonomySection.
  ///
  /// In en, this message translates to:
  /// **'Section'**
  String get taxonomySection;

  /// No description provided for @taxonomySubsection.
  ///
  /// In en, this message translates to:
  /// **'Subsection'**
  String get taxonomySubsection;

  /// No description provided for @morphologyTitle.
  ///
  /// In en, this message translates to:
  /// **'Cone Morphology'**
  String get morphologyTitle;

  /// No description provided for @morphologyConeSize.
  ///
  /// In en, this message translates to:
  /// **'Cone Size'**
  String get morphologyConeSize;

  /// No description provided for @morphologyConeShape.
  ///
  /// In en, this message translates to:
  /// **'Shape'**
  String get morphologyConeShape;

  /// No description provided for @morphologyUmbo.
  ///
  /// In en, this message translates to:
  /// **'Umbo'**
  String get morphologyUmbo;

  /// No description provided for @morphologyUmboDorsal.
  ///
  /// In en, this message translates to:
  /// **'Dorsal'**
  String get morphologyUmboDorsal;

  /// No description provided for @morphologyUmboTerminal.
  ///
  /// In en, this message translates to:
  /// **'Terminal'**
  String get morphologyUmboTerminal;

  /// No description provided for @morphologyMucro.
  ///
  /// In en, this message translates to:
  /// **'Mucro (Spine)'**
  String get morphologyMucro;

  /// No description provided for @morphologyMucroPresent.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get morphologyMucroPresent;

  /// No description provided for @morphologyMucroAbsent.
  ///
  /// In en, this message translates to:
  /// **'Absent'**
  String get morphologyMucroAbsent;

  /// No description provided for @morphologyApophysis.
  ///
  /// In en, this message translates to:
  /// **'Apophysis'**
  String get morphologyApophysis;

  /// No description provided for @morphologySerotiny.
  ///
  /// In en, this message translates to:
  /// **'Serotiny'**
  String get morphologySerotiny;

  /// No description provided for @morphologySerotinous.
  ///
  /// In en, this message translates to:
  /// **'Fire-dependent (serotinous)'**
  String get morphologySerotinous;

  /// No description provided for @morphologyNonSerotinous.
  ///
  /// In en, this message translates to:
  /// **'Standard opening'**
  String get morphologyNonSerotinous;

  /// No description provided for @morphologyNeedles.
  ///
  /// In en, this message translates to:
  /// **'Needles / fascicle'**
  String get morphologyNeedles;

  /// No description provided for @morphologySeedType.
  ///
  /// In en, this message translates to:
  /// **'Seed Type'**
  String get morphologySeedType;

  /// No description provided for @morphologySeedWinged.
  ///
  /// In en, this message translates to:
  /// **'Winged (wind)'**
  String get morphologySeedWinged;

  /// No description provided for @morphologySeedWingless.
  ///
  /// In en, this message translates to:
  /// **'Wingless'**
  String get morphologySeedWingless;

  /// No description provided for @morphologySeedEdible.
  ///
  /// In en, this message translates to:
  /// **'Edible nut'**
  String get morphologySeedEdible;

  /// No description provided for @morphologySeedBird.
  ///
  /// In en, this message translates to:
  /// **'Bird-dispersed'**
  String get morphologySeedBird;

  /// No description provided for @morphologyConeWeight.
  ///
  /// In en, this message translates to:
  /// **'Max Weight'**
  String get morphologyConeWeight;

  /// No description provided for @distributionTitle.
  ///
  /// In en, this message translates to:
  /// **'Distribution'**
  String get distributionTitle;

  /// No description provided for @distributionNative.
  ///
  /// In en, this message translates to:
  /// **'Native Range'**
  String get distributionNative;

  /// No description provided for @distributionIntroduced.
  ///
  /// In en, this message translates to:
  /// **'Widely planted ornamental'**
  String get distributionIntroduced;

  /// No description provided for @distributionNotIntroduced.
  ///
  /// In en, this message translates to:
  /// **'Restricted to native range'**
  String get distributionNotIntroduced;

  /// No description provided for @conservationTitle.
  ///
  /// In en, this message translates to:
  /// **'Conservation'**
  String get conservationTitle;

  /// No description provided for @conservationLC.
  ///
  /// In en, this message translates to:
  /// **'Least Concern'**
  String get conservationLC;

  /// No description provided for @conservationNT.
  ///
  /// In en, this message translates to:
  /// **'Near Threatened'**
  String get conservationNT;

  /// No description provided for @conservationVU.
  ///
  /// In en, this message translates to:
  /// **'Vulnerable'**
  String get conservationVU;

  /// No description provided for @conservationEN.
  ///
  /// In en, this message translates to:
  /// **'Endangered'**
  String get conservationEN;

  /// No description provided for @conservationCR.
  ///
  /// In en, this message translates to:
  /// **'Critically Endangered'**
  String get conservationCR;

  /// No description provided for @discoveryDifficultyTitle.
  ///
  /// In en, this message translates to:
  /// **'Discovery Difficulty'**
  String get discoveryDifficultyTitle;

  /// No description provided for @profileCones.
  ///
  /// In en, this message translates to:
  /// **'Cones'**
  String get profileCones;

  /// No description provided for @profileSpecies.
  ///
  /// In en, this message translates to:
  /// **'Species'**
  String get profileSpecies;

  /// No description provided for @profileCountries.
  ///
  /// In en, this message translates to:
  /// **'Countries'**
  String get profileCountries;

  /// No description provided for @profileStreak.
  ///
  /// In en, this message translates to:
  /// **'🔥 {days}-day streak'**
  String profileStreak(int days);

  /// No description provided for @profileRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get profileRecentActivity;

  /// No description provided for @profileEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileEditProfile;

  /// No description provided for @profileBio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get profileBio;

  /// No description provided for @achievementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievementsTitle;

  /// No description provided for @achievementLocked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get achievementLocked;

  /// No description provided for @achievementFirstCone.
  ///
  /// In en, this message translates to:
  /// **'First Cone'**
  String get achievementFirstCone;

  /// No description provided for @achievementFirstConeDesc.
  ///
  /// In en, this message translates to:
  /// **'The beginning of a great adventure. You\'ve cataloged your first pine cone.'**
  String get achievementFirstConeDesc;

  /// No description provided for @achievementExplorer.
  ///
  /// In en, this message translates to:
  /// **'Explorer'**
  String get achievementExplorer;

  /// No description provided for @achievementExplorerDesc.
  ///
  /// In en, this message translates to:
  /// **'You have added 10 pine cones to your collection.'**
  String get achievementExplorerDesc;

  /// No description provided for @achievementNaturalist.
  ///
  /// In en, this message translates to:
  /// **'Naturalist'**
  String get achievementNaturalist;

  /// No description provided for @achievementNaturalistDesc.
  ///
  /// In en, this message translates to:
  /// **'You have identified 5 different species of strobiles.'**
  String get achievementNaturalistDesc;

  /// No description provided for @achievementWorldTraveler.
  ///
  /// In en, this message translates to:
  /// **'World Traveler'**
  String get achievementWorldTraveler;

  /// No description provided for @achievementWorldTravelerDesc.
  ///
  /// In en, this message translates to:
  /// **'You have found cones in 3 different countries!'**
  String get achievementWorldTravelerDesc;

  /// No description provided for @achievementWorldTravelerHint.
  ///
  /// In en, this message translates to:
  /// **'Borders to cross, cultures to discover...'**
  String get achievementWorldTravelerHint;

  /// No description provided for @achievementLegendaryFind.
  ///
  /// In en, this message translates to:
  /// **'Gold Digger'**
  String get achievementLegendaryFind;

  /// No description provided for @achievementLegendaryFindDesc.
  ///
  /// In en, this message translates to:
  /// **'Identified 50 cones across the world.'**
  String get achievementLegendaryFindDesc;

  /// No description provided for @achievementLegendaryFindHint.
  ///
  /// In en, this message translates to:
  /// **'Only the most persistent will gather a treasure.'**
  String get achievementLegendaryFindHint;

  /// No description provided for @achievementTheWalker.
  ///
  /// In en, this message translates to:
  /// **'The Walker'**
  String get achievementTheWalker;

  /// No description provided for @achievementTheWalkerDesc.
  ///
  /// In en, this message translates to:
  /// **'From beaten paths to deep forests, you collected 25 cones.'**
  String get achievementTheWalkerDesc;

  /// No description provided for @achievementTheWalkerHint.
  ///
  /// In en, this message translates to:
  /// **'From beaten paths to deep forests... Keep walking.'**
  String get achievementTheWalkerHint;

  /// No description provided for @boardUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get boardUnlocked;

  /// No description provided for @boardScore.
  ///
  /// In en, this message translates to:
  /// **'Rare Score'**
  String get boardScore;

  /// No description provided for @boardShowcase.
  ///
  /// In en, this message translates to:
  /// **'Personal Showcase'**
  String get boardShowcase;

  /// No description provided for @boardInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get boardInProgress;

  /// No description provided for @boardTapToFlip.
  ///
  /// In en, this message translates to:
  /// **'Tap to flip'**
  String get boardTapToFlip;

  /// No description provided for @boardUnlockedDate.
  ///
  /// In en, this message translates to:
  /// **'Earned on {date}'**
  String boardUnlockedDate(String date);

  /// No description provided for @boardClaim.
  ///
  /// In en, this message translates to:
  /// **'TAP TO HATCH!'**
  String get boardClaim;

  /// No description provided for @boardHintTitle.
  ///
  /// In en, this message translates to:
  /// **'Cryptic Hint'**
  String get boardHintTitle;

  /// No description provided for @boardClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get boardClose;

  /// No description provided for @voiceNotes.
  ///
  /// In en, this message translates to:
  /// **'Voice Notes'**
  String get voiceNotes;

  /// No description provided for @voiceNoteRecording.
  ///
  /// In en, this message translates to:
  /// **'Recording…'**
  String get voiceNoteRecording;

  /// No description provided for @voiceNoteStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get voiceNoteStop;

  /// No description provided for @voiceNotePlay.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get voiceNotePlay;

  /// No description provided for @voiceNoteDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete note'**
  String get voiceNoteDelete;

  /// No description provided for @voiceNoteDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this voice note?'**
  String get voiceNoteDeleteConfirm;

  /// No description provided for @voiceNoteAdded.
  ///
  /// In en, this message translates to:
  /// **'Voice note added'**
  String get voiceNoteAdded;

  /// No description provided for @voiceNoteLimit.
  ///
  /// In en, this message translates to:
  /// **'Maximum 2 voice notes per cone'**
  String get voiceNoteLimit;

  /// No description provided for @mapFilterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter Cones'**
  String get mapFilterTitle;

  /// No description provided for @mapFilterSpecies.
  ///
  /// In en, this message translates to:
  /// **'Species'**
  String get mapFilterSpecies;

  /// No description provided for @mapFilterRarity.
  ///
  /// In en, this message translates to:
  /// **'Rarity'**
  String get mapFilterRarity;

  /// No description provided for @mapFilterDateRange.
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get mapFilterDateRange;

  /// No description provided for @mapFilterApply.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get mapFilterApply;

  /// No description provided for @mapFilterClear.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get mapFilterClear;

  /// No description provided for @mapMyLocation.
  ///
  /// In en, this message translates to:
  /// **'My location'**
  String get mapMyLocation;

  /// No description provided for @mapAddConeHere.
  ///
  /// In en, this message translates to:
  /// **'Add cone here'**
  String get mapAddConeHere;

  /// No description provided for @mapViewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get mapViewDetails;

  /// No description provided for @mapConeCount.
  ///
  /// In en, this message translates to:
  /// **'{count} cones in this area'**
  String mapConeCount(int count);

  /// No description provided for @themeForest.
  ///
  /// In en, this message translates to:
  /// **'Forest'**
  String get themeForest;

  /// No description provided for @themeArctic.
  ///
  /// In en, this message translates to:
  /// **'Arctic'**
  String get themeArctic;

  /// No description provided for @themeAutumn.
  ///
  /// In en, this message translates to:
  /// **'Autumn'**
  String get themeAutumn;

  /// No description provided for @themeOcean.
  ///
  /// In en, this message translates to:
  /// **'Ocean'**
  String get themeOcean;

  /// No description provided for @themeDesert.
  ///
  /// In en, this message translates to:
  /// **'Desert'**
  String get themeDesert;

  /// No description provided for @themeMidnight.
  ///
  /// In en, this message translates to:
  /// **'Midnight'**
  String get themeMidnight;

  /// No description provided for @themeBrightnessLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeBrightnessLight;

  /// No description provided for @themeBrightnessDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeBrightnessDark;

  /// No description provided for @themeBrightnessSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeBrightnessSystem;

  /// No description provided for @syncingData.
  ///
  /// In en, this message translates to:
  /// **'Syncing…'**
  String get syncingData;

  /// No description provided for @offlineBanner.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline — changes will sync automatically'**
  String get offlineBanner;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @locating.
  ///
  /// In en, this message translates to:
  /// **'Locating…'**
  String get locating;

  /// No description provided for @gpsLocked.
  ///
  /// In en, this message translates to:
  /// **'GPS Locked'**
  String get gpsLocked;

  /// No description provided for @gpsUnavailableShort.
  ///
  /// In en, this message translates to:
  /// **'GPS Unavailable'**
  String get gpsUnavailableShort;

  /// No description provided for @unknownCone.
  ///
  /// In en, this message translates to:
  /// **'Unknown Cone'**
  String get unknownCone;

  /// No description provided for @unknownLocation.
  ///
  /// In en, this message translates to:
  /// **'Unknown Location'**
  String get unknownLocation;

  /// No description provided for @unknownContinent.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownContinent;

  /// No description provided for @cameraError.
  ///
  /// In en, this message translates to:
  /// **'Camera error. Please try again.'**
  String get cameraError;

  /// No description provided for @aiIdentificationFailed.
  ///
  /// In en, this message translates to:
  /// **'AI identification failed. Try again or save manually.'**
  String get aiIdentificationFailed;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileTitle;

  /// No description provided for @editProfileNickname.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get editProfileNickname;

  /// No description provided for @editProfileBio.
  ///
  /// In en, this message translates to:
  /// **'Biography'**
  String get editProfileBio;

  /// No description provided for @editProfileBanner.
  ///
  /// In en, this message translates to:
  /// **'Profile Banner'**
  String get editProfileBanner;

  /// No description provided for @editProfileTheme.
  ///
  /// In en, this message translates to:
  /// **'Background Theme'**
  String get editProfileTheme;

  /// No description provided for @editProfilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Profile Photo'**
  String get editProfilePhoto;

  /// No description provided for @editProfileSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get editProfileSaveSuccess;

  /// No description provided for @editProfileSaveError.
  ///
  /// In en, this message translates to:
  /// **'Error updating profile'**
  String get editProfileSaveError;

  /// No description provided for @editProfileSelectSource.
  ///
  /// In en, this message translates to:
  /// **'Select source'**
  String get editProfileSelectSource;

  /// No description provided for @editProfileCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get editProfileCamera;

  /// No description provided for @editProfileGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get editProfileGallery;

  /// No description provided for @editProfileThemeForest.
  ///
  /// In en, this message translates to:
  /// **'Forest Gradient'**
  String get editProfileThemeForest;

  /// No description provided for @editProfileThemeArctic.
  ///
  /// In en, this message translates to:
  /// **'Arctic Mist'**
  String get editProfileThemeArctic;

  /// No description provided for @editProfileThemeAutumn.
  ///
  /// In en, this message translates to:
  /// **'Autumn Sunset'**
  String get editProfileThemeAutumn;

  /// No description provided for @editProfileThemeOcean.
  ///
  /// In en, this message translates to:
  /// **'Ocean Depth'**
  String get editProfileThemeOcean;

  /// No description provided for @editProfileThemeNone.
  ///
  /// In en, this message translates to:
  /// **'None (default color)'**
  String get editProfileThemeNone;

  /// No description provided for @locationPickerClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get locationPickerClose;

  /// No description provided for @locationPickerNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get locationPickerNoResults;

  /// No description provided for @locationPickerGps.
  ///
  /// In en, this message translates to:
  /// **'GPS Location'**
  String get locationPickerGps;

  /// No description provided for @locationPickerSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get locationPickerSearch;

  /// No description provided for @viewInteractiveMap.
  ///
  /// In en, this message translates to:
  /// **'View Interactive Map'**
  String get viewInteractiveMap;

  /// No description provided for @distributionNativeLabel.
  ///
  /// In en, this message translates to:
  /// **'Native'**
  String get distributionNativeLabel;

  /// No description provided for @distributionIntroducedLabel.
  ///
  /// In en, this message translates to:
  /// **'Introduced'**
  String get distributionIntroducedLabel;

  /// No description provided for @loadingMapData.
  ///
  /// In en, this message translates to:
  /// **'Loading map data…'**
  String get loadingMapData;

  /// No description provided for @previousSpecies.
  ///
  /// In en, this message translates to:
  /// **'Previous species'**
  String get previousSpecies;

  /// No description provided for @nextSpecies.
  ///
  /// In en, this message translates to:
  /// **'Next species'**
  String get nextSpecies;

  /// No description provided for @viewFullImage.
  ///
  /// In en, this message translates to:
  /// **'View full image'**
  String get viewFullImage;

  /// No description provided for @achVoiceForest.
  ///
  /// In en, this message translates to:
  /// **'Voice of the Forest'**
  String get achVoiceForest;

  /// No description provided for @achVoiceForestDesc.
  ///
  /// In en, this message translates to:
  /// **'You added your first voice note to document your emotions.'**
  String get achVoiceForestDesc;

  /// No description provided for @achPhotographicEye.
  ///
  /// In en, this message translates to:
  /// **'Photographic Eye'**
  String get achPhotographicEye;

  /// No description provided for @achPhotographicEyeDesc.
  ///
  /// In en, this message translates to:
  /// **'A true 3D model! You added 4 photos from different angles.'**
  String get achPhotographicEyeDesc;

  /// No description provided for @achTheMeasurer.
  ///
  /// In en, this message translates to:
  /// **'The Measurer'**
  String get achTheMeasurer;

  /// No description provided for @achTheMeasurerDesc.
  ///
  /// In en, this message translates to:
  /// **'You found and documented a specimen for each size category.'**
  String get achTheMeasurerDesc;

  /// No description provided for @achTheMeasurerHint.
  ///
  /// In en, this message translates to:
  /// **'Strobiles come in all sizes. Find them from Tiny to Giant.'**
  String get achTheMeasurerHint;

  /// No description provided for @achImperfectBeauty.
  ///
  /// In en, this message translates to:
  /// **'Imperfect Beauty'**
  String get achImperfectBeauty;

  /// No description provided for @achImperfectBeautyDesc.
  ///
  /// In en, this message translates to:
  /// **'You scanned 10 cones in \'Fragmented\' or \'Worn\' condition.'**
  String get achImperfectBeautyDesc;

  /// No description provided for @achImperfectBeautyHint.
  ///
  /// In en, this message translates to:
  /// **'Nature is not perfect... Look for damaged cones.'**
  String get achImperfectBeautyHint;

  /// No description provided for @achTheWalker.
  ///
  /// In en, this message translates to:
  /// **'The Walker'**
  String get achTheWalker;

  /// No description provided for @achTheWalkerDesc.
  ///
  /// In en, this message translates to:
  /// **'You walked long kilometers to find 50 pine cones.'**
  String get achTheWalkerDesc;

  /// No description provided for @achFamilyTree.
  ///
  /// In en, this message translates to:
  /// **'Family Tree'**
  String get achFamilyTree;

  /// No description provided for @achFamilyTreeDesc.
  ///
  /// In en, this message translates to:
  /// **'You 100% completed the family tree of a botanical Genus.'**
  String get achFamilyTreeDesc;

  /// No description provided for @achFamilyTreeHint.
  ///
  /// In en, this message translates to:
  /// **'Find all species of the same Genus (e.g., all local Pinus).'**
  String get achFamilyTreeHint;

  /// No description provided for @achFreneticHarvest.
  ///
  /// In en, this message translates to:
  /// **'Frenetic Harvest'**
  String get achFreneticHarvest;

  /// No description provided for @achFreneticHarvestDesc.
  ///
  /// In en, this message translates to:
  /// **'You scanned 10 cones in under 24 hours.'**
  String get achFreneticHarvestDesc;

  /// No description provided for @achFreneticHarvestHint.
  ///
  /// In en, this message translates to:
  /// **'A very productive day awaits you. Go outside!'**
  String get achFreneticHarvestHint;

  /// No description provided for @achRooted.
  ///
  /// In en, this message translates to:
  /// **'Rooted'**
  String get achRooted;

  /// No description provided for @achRootedDesc.
  ///
  /// In en, this message translates to:
  /// **'You scanned a specimen for 30 consecutive days.'**
  String get achRootedDesc;

  /// No description provided for @achRootedHint.
  ///
  /// In en, this message translates to:
  /// **'Consistency is key. Open the Strobilodex every day.'**
  String get achRootedHint;

  /// No description provided for @achSeaWolf.
  ///
  /// In en, this message translates to:
  /// **'Sea Wolf'**
  String get achSeaWolf;

  /// No description provided for @achSeaWolfDesc.
  ///
  /// In en, this message translates to:
  /// **'Find a strobile less than 500 meters from the ocean.'**
  String get achSeaWolfDesc;

  /// No description provided for @achUrbanExplorer.
  ///
  /// In en, this message translates to:
  /// **'Urban Explorer'**
  String get achUrbanExplorer;

  /// No description provided for @achUrbanExplorerDesc.
  ///
  /// In en, this message translates to:
  /// **'You cataloged a specimen in a downtown park.'**
  String get achUrbanExplorerDesc;

  /// No description provided for @achBotanicalClimber.
  ///
  /// In en, this message translates to:
  /// **'Botanical Climber'**
  String get achBotanicalClimber;

  /// No description provided for @achBotanicalClimberDesc.
  ///
  /// In en, this message translates to:
  /// **'You found a specimen above 2000m altitude.'**
  String get achBotanicalClimberDesc;

  /// No description provided for @achBotanicalClimberHint.
  ///
  /// In en, this message translates to:
  /// **'Go higher. Search where the air gets thin.'**
  String get achBotanicalClimberHint;

  /// No description provided for @achContinentConqueror.
  ///
  /// In en, this message translates to:
  /// **'Continent Conqueror'**
  String get achContinentConqueror;

  /// No description provided for @achContinentConquerorDesc.
  ///
  /// In en, this message translates to:
  /// **'Find specimens on 3 different continents.'**
  String get achContinentConquerorDesc;

  /// No description provided for @achContinentConquerorHint.
  ///
  /// In en, this message translates to:
  /// **'The world is your forest. Travel!'**
  String get achContinentConquerorHint;

  /// No description provided for @achNightOwl.
  ///
  /// In en, this message translates to:
  /// **'Night Owl'**
  String get achNightOwl;

  /// No description provided for @achNightOwlDesc.
  ///
  /// In en, this message translates to:
  /// **'You braved the dark to scan a cone between 2am and 4am.'**
  String get achNightOwlDesc;

  /// No description provided for @achFlameSurvivor.
  ///
  /// In en, this message translates to:
  /// **'Flame Survivor'**
  String get achFlameSurvivor;

  /// No description provided for @achFlameSurvivorDesc.
  ///
  /// In en, this message translates to:
  /// **'You found a serotinous pine cone opened by fire.'**
  String get achFlameSurvivorDesc;

  /// No description provided for @achFlameSurvivorHint.
  ///
  /// In en, this message translates to:
  /// **'Some pine cones only open under extreme heat...'**
  String get achFlameSurvivorHint;

  /// No description provided for @achThunderstruck.
  ///
  /// In en, this message translates to:
  /// **'Thunderstruck'**
  String get achThunderstruck;

  /// No description provided for @achThunderstruckDesc.
  ///
  /// In en, this message translates to:
  /// **'You scanned under pouring rain.'**
  String get achThunderstruckDesc;

  /// No description provided for @achThunderstruckHint.
  ///
  /// In en, this message translates to:
  /// **'Nature doesn\'t stop when it rains. Why should you?'**
  String get achThunderstruckHint;

  /// No description provided for @achWoodPineapple.
  ///
  /// In en, this message translates to:
  /// **'Wood Pineapple'**
  String get achWoodPineapple;

  /// No description provided for @achWoodPineappleDesc.
  ///
  /// In en, this message translates to:
  /// **'You scanned an Araucaria cone that looks like a pineapple.'**
  String get achWoodPineappleDesc;

  /// No description provided for @achWoodPineappleHint.
  ///
  /// In en, this message translates to:
  /// **'Some pine cones think they are exotic fruits...'**
  String get achWoodPineappleHint;

  /// No description provided for @achCrystalCone.
  ///
  /// In en, this message translates to:
  /// **'Crystal Cone'**
  String get achCrystalCone;

  /// No description provided for @achCrystalConeDesc.
  ///
  /// In en, this message translates to:
  /// **'You identified 15 \'Legendary\' rarity species.'**
  String get achCrystalConeDesc;

  /// No description provided for @achTaxonomist.
  ///
  /// In en, this message translates to:
  /// **'The Taxonomist'**
  String get achTaxonomist;

  /// No description provided for @achTaxonomistDesc.
  ///
  /// In en, this message translates to:
  /// **'Absolute precision. 50 cones with 100% metadata filled.'**
  String get achTaxonomistDesc;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
