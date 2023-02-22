import 'package:get/get.dart';

class MenuController extends GetxController {
  int menuIndex = 0;

  void setIndex(int _menuIndex) {
    menuIndex = _menuIndex;
    update();
  }
}