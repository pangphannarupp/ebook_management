import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notification_management/commons/constants/data_menu.dart';
import 'package:notification_management/commons/controllers/language_controller.dart';
import 'package:notification_management/commons/controllers/menu_controller.dart';
import 'package:notification_management/components/app_bar_component.dart';
import 'package:notification_management/components/footer_component.dart';
import 'package:notification_management/components/left_menu_component.dart';

class DesktopMasterScreen extends StatefulWidget {
  const DesktopMasterScreen({Key key}) : super(key: key);

  @override
  _DesktopMasterScreenState createState() => _DesktopMasterScreenState();
}

class _DesktopMasterScreenState extends State<DesktopMasterScreen> {
  final menuController = Get.put(MenuController());
  final languageController = Get.put(LanguageController());

  double screenSizeWidth = 0;

  @override
  Widget build(BuildContext context) {
    screenSizeWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xfff9f9f9),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LeftMenuComponent(),
          Expanded(
              flex: 6,
              child: Stack(
                children: [
                  const Align(
                    alignment: Alignment.topCenter,
                    child: AppBarComponent(),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 60, bottom: 60),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: GetBuilder<LanguageController>(
                        builder: (_) => GetBuilder<MenuController>(
                          builder: (_) => dataMenu[languageController.languageTheme][menuController.menuIndex].content,
                        ),
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.bottomCenter,
                    child: FooterComponent(),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
