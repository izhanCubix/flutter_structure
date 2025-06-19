// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get confirm => 'تأكيد';

  @override
  String userProfile(Object name) {
    return 'الملف الشخصي لـ $name';
  }

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String friends(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count أصدقاء',
      one: 'صديق واحد',
    );
    return '$_temp0';
  }

  @override
  String get errorMsgNoInternet =>
      'لا يوجد اتصال بالإنترنت. تأكد من تشغيل Wi-Fi أو بيانات الهاتف، ثم حاول مرة أخرى.';

  @override
  String get errorMsgLogin => 'بيانات اعتماد غير صالحة';
}
