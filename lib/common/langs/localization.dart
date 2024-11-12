import 'package:chatty/common/langs/en_US.dart';
import 'package:flutter_localization/flutter_localization.dart';

abstract class Localization {
  static FlutterLocalization localization = FlutterLocalization.instance;

  static init() async {
    await localization.init(mapLocales: [
      MapLocale('en', en_US),
      MapLocale('id', {
        'title': 'Chatty',
        'subtitle': 'Aplikasi Chatting',
        'login': 'Masuk',
        'register': 'Daftar',
        'email': 'Email',
        'password:': 'Kata Sandi',
      })
    ], initLanguageCode: 'en');
  }
}
