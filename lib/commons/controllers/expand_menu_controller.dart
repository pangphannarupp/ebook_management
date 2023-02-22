import 'package:get/get.dart';

class ExpandMenuController extends GetxController {
  bool isExpand = false;

  void setExpand(bool _isExpand) {
    isExpand = _isExpand;
    update();
  }
}