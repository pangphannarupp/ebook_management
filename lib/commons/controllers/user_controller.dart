import 'package:get/get.dart';

class UserController extends GetxController {
  String email = '';

  void setEmail(String _email) {
    email = _email;
    update();
  }
}