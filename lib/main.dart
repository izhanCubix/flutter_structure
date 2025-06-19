import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'package:base_structure/localization/l10n/app_localizations.dart';
import 'package:base_structure/config/dependecies.dart';
import 'package:base_structure/routing/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  final Locale _locale = const Locale('en'); // default language

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: Builder(
        builder: (context) => MaterialApp.router(
          debugShowCheckedModeBanner: false,
          locale: _locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          themeMode: ThemeMode.system,
          routerConfig: router(context.read()),
        ),
      ),
    );
  }
}

class App extends StatelessWidget {
  const App({super.key, required this.onChangeLocale});

  final Function(Locale) onChangeLocale;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context)!.friends(5)),
            Container(
              child: GestureDetector(
                onTap: () {
                  onChangeLocale(
                    Localizations.localeOf(context).languageCode == 'en'
                        ? const Locale('ar')
                        : const Locale('en'),
                  );
                },
                child: Icon(Icons.language),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
