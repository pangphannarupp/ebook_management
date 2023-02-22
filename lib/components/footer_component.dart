import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notification_management/commons/controllers/expand_menu_controller.dart';
import 'package:notification_management/commons/controllers/language_controller.dart';
import 'package:notification_management/commons/controllers/menu_controller.dart';
import 'package:notification_management/commons/controllers/user_controller.dart';
import 'package:notification_management/commons/theme/language.dart';
import 'package:notification_management/services/auth.dart';

class FooterComponent extends StatefulWidget {
  const FooterComponent({Key key}) : super(key: key);

  @override
  _FooterComponentState createState() => _FooterComponentState();
}

class _FooterComponentState extends State<FooterComponent> {
  final menuController = Get.put(MenuController());
  final expandMenuController = Get.put(ExpandMenuController());
  final languageController = Get.put(LanguageController());
  final userController = Get.put(UserController());

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {

    return GetBuilder<ExpandMenuController>(
        builder: (_) => Container(
              height: 60,
              padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(color: Colors.black87),
              child: GetBuilder<LanguageController>(
                builder: (_) => Row(
                  children: [
                    const Spacer(),
                    Text(
                      'Copyright © PPHANNA.  All rights reserved.',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: languageThemeData[languageController
                            .languageTheme]['FontSecondary'],
                      ),
                    ),
                    // Text(
                    //   'Anything you want',
                    //   style: TextStyle(
                    //     color: Colors.white,
                    //     fontFamily: languageThemeData[languageController
                    //         .languageTheme]['FontSecondary'],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ));
  }
}
