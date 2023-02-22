import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notification_management/commons/constants/colors.dart';
import 'package:notification_management/commons/constants/data_menu.dart';
import 'package:notification_management/commons/controllers/expand_menu_controller.dart';
import 'package:notification_management/commons/controllers/language_controller.dart';
import 'package:notification_management/commons/controllers/menu_controller.dart';
import 'package:notification_management/commons/theme/language.dart';
import 'package:notification_management/components/footer_component.dart';
import 'package:notification_management/components/left_menu_component.dart';
import 'package:notification_management/services/auth.dart';

class MobileMasterScreen extends StatefulWidget {
  const MobileMasterScreen({Key key}) : super(key: key);

  @override
  _MobileMasterScreenState createState() => _MobileMasterScreenState();
}

class _MobileMasterScreenState extends State<MobileMasterScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AuthService authService = AuthService();

  final expandMenuController = Get.put(ExpandMenuController());
  final menuController = Get.put(MenuController());
  final languageController = Get.put(LanguageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xfff9f9f9),
      appBar: AppBar(
        backgroundColor: colorPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            expandMenuController.setExpand(true);
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        title: GetBuilder<MenuController>(
          builder: (_) => Text(
            dataMenu[languageController.languageTheme]
            [menuController.menuIndex]
                .title
                .toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: languageThemeData[languageController
                  .languageTheme]['FontSecondary'],
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                menuController.setIndex(0);
                authService.signOut();
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              )),
        ],
      ),
      drawer: const LeftMenuComponent(),
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 0, bottom: 60),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: GetBuilder<LanguageController>(
                builder: (_) => GetBuilder<MenuController>(
                  builder: (_) => dataMenu[languageController.languageTheme]
                          [menuController.menuIndex]
                      .content,
                ),
              ),
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: FooterComponent(),
          ),
        ],
      ),
    );
  }
}
