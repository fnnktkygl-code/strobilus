import 'package:flutter/material.dart';
import 'package:strobilus/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'core/locale/locale_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/theme_provider.dart';
import 'data/services/firebase/firestore_service.dart';
import 'data/services/firebase/storage_service.dart';
import 'data/services/gemini_service.dart';
import 'data/services/local/hive_service.dart';
import 'data/services/maps_service.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/collection_provider.dart';
import 'presentation/providers/connectivity_provider.dart';
import 'presentation/providers/map_provider.dart';
import 'presentation/providers/species_provider.dart';

class StrobilusApp extends StatelessWidget {
  final HiveService hiveService;

  const StrobilusApp({super.key, required this.hiveService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // === Infrastructure Services ===
        Provider<FirestoreService>(create: (_) => FirestoreService()),
        Provider<StorageService>(create: (_) => StorageService()),
        Provider<HiveService>.value(value: hiveService),
        Provider<MapsService>(create: (_) => MapsService()),
        Provider<GeminiService>(create: (_) => GeminiService()),

        // === Global App State ===
        ChangeNotifierProvider<LocaleProvider>(
          create: (_) => LocaleProvider()..init(),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider()..init(),
        ),
        ChangeNotifierProvider<ConnectivityProvider>(
          create: (_) => ConnectivityProvider()..init(),
        ),

        // === Feature Providers ===
        ChangeNotifierProvider<AuthProvider>(
          create: (ctx) => AuthProvider(
            firestoreService: ctx.read<FirestoreService>(),
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, CollectionProvider>(
          create: (ctx) => CollectionProvider(
            firestoreService: ctx.read<FirestoreService>(),
            hiveService: ctx.read<HiveService>(),
            storageService: ctx.read<StorageService>(),
            authProvider: ctx.read<AuthProvider>(),
          ),
          update: (ctx, auth, previous) => previous!..updateAuth(auth),
        ),
        ChangeNotifierProvider<MapProvider>(create: (_) => MapProvider()),
        ChangeNotifierProvider<SpeciesProvider>(
          create: (ctx) =>
              SpeciesProvider(hiveService: ctx.read<HiveService>())..init(),
        ),
      ],
      child: Consumer2<LocaleProvider, ThemeProvider>(
        builder: (context, localeProvider, themeProvider, _) {
          return MaterialApp.router(
            title: 'Strobilus',
            debugShowCheckedModeBanner: false,
            locale: localeProvider.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
