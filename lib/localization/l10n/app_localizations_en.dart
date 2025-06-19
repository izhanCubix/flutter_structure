// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get login => 'Login';

  @override
  String get confirm => 'Confirm';

  @override
  String userProfile(Object name) {
    return '$name\'s Profile';
  }

  @override
  String get tryAgain => 'Try again';

  @override
  String friends(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count friends',
      one: '1 friend',
    );
    return '$_temp0';
  }

  @override
  String get errorMsgNoInternet =>
      'No internet connection. Make sure Wi-Fi or cellular data is turned on, then try again.';

  @override
  String get errorMsgLogin => 'Invalid Credentials';
}
