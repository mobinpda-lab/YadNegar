import 'package:flutter/services.dart';

abstract final class AppFonts {
  static const String vazirharfFamily = 'Vazirharf';

  static const String vazirharfRegularAsset =
      'assets/fonts/vazirharf/Vazirharf-Regular.ttf';
  static const String vazirharfBoldAsset =
      'assets/fonts/vazirharf/Vazirharf-Bold.ttf';

  static Future<bool> loadVazirharf() async {
    try {
      final loader = FontLoader(vazirharfFamily);
      loader.addFont(rootBundle.load(vazirharfRegularAsset));
      loader.addFont(rootBundle.load(vazirharfBoldAsset));
      await loader.load();
      return true;
    } catch (_) {
      return false;
    }
  }
}
