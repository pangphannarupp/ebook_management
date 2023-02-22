import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:notification_management/commons/constants/data_menu.dart';
import 'package:notification_management/commons/constants/strings.dart';
import 'package:notification_management/commons/controllers/expand_menu_controller.dart';
import 'package:notification_management/commons/controllers/language_controller.dart';
import 'package:notification_management/commons/controllers/menu_controller.dart';
import 'package:notification_management/commons/controllers/user_controller.dart';
import 'package:notification_management/commons/theme/language.dart';

class LeftMenuComponent extends StatefulWidget {
  const LeftMenuComponent({Key key}) : super(key: key);

  @override
  _LeftMenuComponentState createState() => _LeftMenuComponentState();
}

class _LeftMenuComponentState extends State<LeftMenuComponent> {
  bool isKhmer = true;
  final languageController = Get.put(LanguageController());
  final menuController = Get.put(MenuController());
  final expandMenuController = Get.put(ExpandMenuController());
  final userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    isKhmer =
        languageController.languageTheme == LanguageTheme.KHMER ? true : false;

    return GetBuilder<ExpandMenuController>(
        builder: (_) => Container(
              width: expandMenuController.isExpand ? 250 : 60,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(color: Color(0xff353d47)),
              child: GetBuilder<LanguageController>(
                builder: (_) => Column(
                  children: [
                    for (int i = 0;
                        i < dataMenu[languageController.languageTheme].length;
                        i++)
                      GetBuilder<MenuController>(
                          builder: (_) => GetBuilder<UserController>(
                              builder: (_) => Container(
                                    decoration: BoxDecoration(
                                        color: menuController.menuIndex == i
                                            ? const Color(0xff252b31)
                                            : Colors.transparent),
                                    child: ListTile(
                                      onTap: () {
                                          menuController.setIndex(i);
                                      },
                                      leading: Icon(
                                        dataMenu[languageController
                                                .languageTheme][i]
                                            .icon,
                                        color: Colors.white,
                                      ),
                                      title: Text(
                                        !expandMenuController.isExpand
                                            ? ''
                                            : dataMenu[languageController
                                                    .languageTheme][i]
                                                .title,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: languageThemeData[
                                                    languageController
                                                        .languageTheme]
                                                ['FontSecondary']),
                                      ),
                                    ),
                                  )
                          )),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.all(
                          !expandMenuController.isExpand ? 0 : 10),
                      child: Row(
                        mainAxisAlignment: !expandMenuController.isExpand
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.spaceBetween,
                        children: [
                          !expandMenuController.isExpand
                              ? const SizedBox()
                              : Text(
                                  languageThemeData[languageController
                                      .languageTheme]['Language'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: languageThemeData[
                                              languageController.languageTheme]
                                          ['FontSecondary']),
                                ),
                          FlutterSwitch(
                            width: 50,
                            height: 25,
                            valueFontSize: 0,
                            toggleSize: 25,
                            value: isKhmer,
                            borderRadius: 30.0,
                            padding: 0,
                            showOnOff: true,
                            activeText: '',
                            inactiveText: '',
                            activeColor: Colors.grey,
                            inactiveColor: Colors.grey,
                            activeIcon: const CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/flag-khmer.png'),
                            ),
                            inactiveIcon: const CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/flag-english.png'),
                            ),
                            onToggle: (val) {
                              if (isKhmer) {
                                languageController
                                    .setLanguage(LanguageTheme.ENGLISH);
                              } else {
                                languageController
                                    .setLanguage(LanguageTheme.KHMER);
                              }
                              setState(() {
                                isKhmer = val;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    const Divider(
                      color: Colors.grey,
                    ),
                    ListTile(
                      title: Text(
                        (!expandMenuController.isExpand
                                ? ''
                                : languageThemeData[languageController
                                    .languageTheme]['Version']) +
                            ' ' + STRING_APP_VERSION,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: languageThemeData[languageController
                                .languageTheme]['FontSecondary']),
                      ),
                    ),
                    const SizedBox(height: 60,),
                  ],
                ),
              ),
            ));
  }
}
