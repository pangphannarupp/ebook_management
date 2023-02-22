import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notification_management/commons/constants/colors.dart';
import 'package:notification_management/commons/constants/data_menu.dart';
import 'package:notification_management/commons/controllers/expand_menu_controller.dart';
import 'package:notification_management/commons/controllers/language_controller.dart';
import 'package:notification_management/commons/controllers/menu_controller.dart';
import 'package:notification_management/commons/controllers/user_controller.dart';
import 'package:notification_management/commons/theme/language.dart';
import 'package:notification_management/services/auth.dart';

class AppBarComponent extends StatefulWidget {
  const AppBarComponent({Key key}) : super(key: key);

  @override
  _AppBarComponentState createState() => _AppBarComponentState();
}

class _AppBarComponentState extends State<AppBarComponent> {
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
              decoration: BoxDecoration(
                color: colorPrimary,
              ),
              child: GetBuilder<LanguageController>(
                builder: (_) => Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          if (expandMenuController.isExpand) {
                            expandMenuController.setExpand(false);
                          } else {
                            expandMenuController.setExpand(true);
                          }
                        },
                        icon: Icon(
                          expandMenuController.isExpand
                              ? Icons.arrow_back_outlined
                              : Icons.arrow_forward_outlined,
                          color: Colors.white,
                        )),
                    const SizedBox(
                      width: 20,
                    ),
                    GetBuilder<MenuController>(
                      builder: (_) => Text(
                        dataMenu[languageController.languageTheme]
                                [menuController.menuIndex]
                            .title
                            .toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: languageThemeData[languageController
                              .languageTheme]['FontSecondary'],
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 10,),
                        GetBuilder<UserController>(builder: (_) => Text(
                          userController.email,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: languageThemeData[languageController
                                .languageTheme]['FontSecondary'],
                          ),
                        ))
                      ],
                    ),
                    const SizedBox(width: 20,),
                    IconButton(
                        onPressed: () {
                          menuController.setIndex(0);
                          authService.signOut();
                        },
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.white,
                        )),
                    GestureDetector(
                      onTap: () {
                        menuController.setIndex(0);
                        authService.signOut();
                      },
                      child: Text(
                        languageThemeData[languageController.languageTheme]['LogOut'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily:
                            languageThemeData[languageController.languageTheme]
                            ['FontSecondary']),
                      ),
                    )
                  ],
                ),
              ),
            ));
  }
}
