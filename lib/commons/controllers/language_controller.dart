import 'package:get/get.dart';
import 'package:notification_management/commons/theme/language.dart';

class LanguageController extends GetxController {
  LanguageTheme languageTheme = LanguageTheme.KHMER;

  void setLanguage(LanguageTheme _languageTheme) {
    languageTheme = _languageTheme;
    update();
  }
}