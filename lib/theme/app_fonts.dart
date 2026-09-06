import 'package:flutter/services.dart';

abstract final class AppFonts {
  static const String vazirharfFamily = 'Vazirharf';
  static const String iranSansXFamily = 'IRANSansXFaNum';

  static const String iranSansXRegularAsset =
      'assets/fonts/IRANSansXFaNum-Regular.ttf';
  static const String iranSansXBoldAsset =
      'assets/fonts/IRANSansXFaNum-Bold.ttf';

  static Future<bool> loadLicensedIranSansX() async {
    final loader = FontLoader(iranSansXFamily);
    try {
      loader.addFont(rootBundle.load(iranSansXRegularAsset));
      loader.addFont(rootBundle.load(iranSansXBoldAsset));
      await loader.load();
      return true;
    } catch (_) {
      // Vazirharf v34.003 is bundled as the canonical public/default project font.
      // Licensed IRANSansX takes precedence only when private assets exist.
      return false;
    }
  }
}
