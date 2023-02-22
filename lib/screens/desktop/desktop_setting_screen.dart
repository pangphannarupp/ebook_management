import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:html_editor_enhanced/html_editor.dart';
import 'package:notification_management/domain/entities/setting.dart';
import 'package:provider/provider.dart';
import 'package:notification_management/commons/constants/colors.dart';
import 'package:notification_management/commons/controllers/expand_menu_controller.dart';
import 'package:notification_management/commons/controllers/language_controller.dart';
import 'package:notification_management/commons/message.dart';
import 'package:notification_management/commons/theme/language.dart';
import 'package:notification_management/domain/entities/user.dart';
import 'package:notification_management/services/database.dart';

class DesktopSettingScreen extends StatefulWidget {
  const DesktopSettingScreen({Key key}) : super(key: key);

  @override
  _DesktopSettingScreenState createState() => _DesktopSettingScreenState();
}

class _DesktopSettingScreenState extends State<DesktopSettingScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserApp>(context);
    return StreamProvider<List<Setting>>.value(
        value: DatabaseService(uid: user.uid).settings,
        initialData: const [],
        child: const Scaffold(
          body: Content(),
        ));
  }
}

class Content extends StatefulWidget {
  const Content({Key key}) : super(key: key);

  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content> {
  final languageController = Get.put(LanguageController());
  final expandMenuController = Get.put(ExpandMenuController());

  TextEditingController titleController = TextEditingController();
  String valueChooseStatus;
  String valueChooseSpecial;

  String uid = '';
  List<Setting> settingList = <Setting>[];

  Future<void> saveSetting(bool isUpdated, Setting setting) async {
    if (titleController.text == '' || valueChooseStatus == '') {
      Message(context: context).showErrorMessage(
          languageThemeData[languageController.languageTheme]
              ['InformationTitle'],
          languageThemeData[languageController.languageTheme]
              ['FillAllInformation']);
    } else {
      DatabaseService(uid: uid).updateSettingData(Setting(
        id: setting != null
            ? setting.id
            : -1 * DateTime.now().millisecondsSinceEpoch,
        title: titleController.text,
        status: valueChooseStatus == 'True',
        special: valueChooseSpecial == 'True',
        createTimestamp: setting != null
            ? setting.createTimestamp
            : -1 * DateTime.now().millisecondsSinceEpoch,
        updateTimestamp: -1 * DateTime.now().millisecondsSinceEpoch,
      ));
      Message(context: context).showSuccessMessage(
          languageThemeData[languageController.languageTheme]
              ['InformationTitle'],
          languageThemeData[languageController.languageTheme]
          ['SaveSuccess']);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserApp>(context);
    setState(() {
      uid = user.uid;
    });
    settingList = Provider.of<List<Setting>>(context) ?? [];
    if(settingList.isNotEmpty && valueChooseStatus == null) {
      titleController.text = settingList[0].title;
      valueChooseStatus = settingList[0].status ? 'True' : 'False';
      valueChooseSpecial = settingList[0].special ? 'True' : 'False';
    }

    return Container(
        alignment: Alignment.topCenter,
        child: SizedBox(
            width: 600,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        languageThemeData[languageController.languageTheme]
                            ['Title'],
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: languageThemeData[languageController
                                .languageTheme]['FontSecondary']),
                      ),
                      const SizedBox(height: 10.0),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(width: 0.3)),
                        // height: 60.0,
                        child: TextField(
                          controller: titleController,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: languageThemeData[languageController
                                  .languageTheme]['FontSecondary']),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: languageThemeData[
                                languageController.languageTheme]['Title'],
                            hintStyle: TextStyle(
                                fontSize: 14,
                                fontFamily: languageThemeData[languageController
                                    .languageTheme]['FontSecondary']),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        languageThemeData[languageController.languageTheme]
                            ['Status'],
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: languageThemeData[languageController
                                .languageTheme]['FontSecondary']),
                      ),
                      const SizedBox(height: 10.0),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(width: 0.3)),
                        child: DropdownButton<String>(
                          underline: Container(),
                          value: valueChooseStatus,
                          style: TextStyle(
                              fontFamily: languageThemeData[languageController
                                  .languageTheme]['FontSecondary']),
                          items: [
                            languageThemeData[languageController.languageTheme]
                                ['True'],
                            languageThemeData[languageController.languageTheme]
                                ['False']
                          ].map((String status) {
                            return DropdownMenuItem<String>(
                              value: status.contains(languageThemeData[
                                      languageController.languageTheme]['True'])
                                  ? 'True'
                                  : 'False',
                              // value: status,
                              child: SizedBox(
                                width: (600 - 40).floorToDouble(),
                                child: Text(
                                  status,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String val) {
                            setState(() {
                              valueChooseStatus = val;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        languageThemeData[languageController.languageTheme]
                        ['Special'],
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: languageThemeData[languageController
                                .languageTheme]['FontSecondary']),
                      ),
                      const SizedBox(height: 10.0),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(width: 0.3)),
                        child: DropdownButton<String>(
                          underline: Container(),
                          value: valueChooseSpecial,
                          style: TextStyle(
                              fontFamily: languageThemeData[languageController
                                  .languageTheme]['FontSecondary']),
                          items: [
                            languageThemeData[languageController.languageTheme]
                            ['True'],
                            languageThemeData[languageController.languageTheme]
                            ['False']
                          ].map((String status) {
                            return DropdownMenuItem<String>(
                              value: status.contains(languageThemeData[
                              languageController.languageTheme]['True'])
                                  ? 'True'
                                  : 'False',
                              // value: status,
                              child: SizedBox(
                                width: (600 - 40).floorToDouble(),
                                child: Text(
                                  status,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String val) {
                            setState(() {
                              valueChooseSpecial = val;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      bool isUpdated = false;
                      Setting setting;
                      if (settingList.isNotEmpty) {
                        isUpdated = true;
                        setting = settingList[0];
                      }
                      saveSetting(isUpdated, setting);
                    },
                    child: Container(
                      width: 200,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(color: colorPrimary),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.save,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            languageThemeData[languageController.languageTheme]
                                ['Save'],
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: languageThemeData[languageController
                                    .languageTheme]['FontSecondary']),
                          ),
                          const SizedBox(
                            width: 5,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )));
  }
}
