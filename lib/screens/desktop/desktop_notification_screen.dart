import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notification_management/commons/constants/colors.dart';
import 'package:notification_management/commons/constants/strings.dart';
import 'package:notification_management/commons/controllers/expand_menu_controller.dart';
import 'package:notification_management/commons/controllers/language_controller.dart';
import 'package:notification_management/commons/controllers/user_controller.dart';
import 'package:notification_management/commons/message.dart';
import 'package:notification_management/commons/theme/language.dart';
import 'package:http/http.dart' as http;
import 'package:notification_management/domain/entities/application.dart';
import 'package:notification_management/domain/entities/category.dart';
import 'package:notification_management/domain/entities/history.dart';
import 'package:notification_management/domain/entities/user.dart';
import 'package:notification_management/services/database.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class DesktopNotificationScreen extends StatefulWidget {
  const DesktopNotificationScreen({Key key}) : super(key: key);

  @override
  _DesktopNotificationScreenState createState() =>
      _DesktopNotificationScreenState();
}

class _DesktopNotificationScreenState extends State<DesktopNotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserApp>(context);

    return StreamProvider<List<Category>>.value(
        value: DatabaseService(uid: user.uid).categories,
        initialData: const [],
        child: StreamProvider<List<Application>>.value(
            value: DatabaseService(uid: user.uid).applications,
            initialData: const [],
            child: const Scaffold(
              body: Content(),
            )));
  }
}

class Content extends StatefulWidget {
  const Content({Key key}) : super(key: key);

  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content> {
  String uid = '';
  String tempThumbnailUrl = 'https://i.ytimg.com/vi/xxxxxxxxxx/hqdefault.jpg';
  bool isSending = false;

  final languageController = Get.put(LanguageController());
  final expandMenuController = Get.put(ExpandMenuController());
  final userController = Get.put(UserController());
  List<Category> categoryList;
  List<Application> applicationList = <Application>[];
  List<Application> allApplicationList = <Application>[];
  String valueChooseSendBy;
  String valueChooseCategory;
  String valueChooseApplication;
  TextEditingController messageController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  TextEditingController thumbnailController = TextEditingController();
  List<TextEditingController> timeController = <TextEditingController>[];

  Future<void> sendNotificationByCategoryId(
      String categoryId, String content, String thumbnail, String url) async {
    if(categoryId == '' || content == '') {
      Message(context: context)
          .showErrorMessage(
          languageThemeData[
          languageController
              .languageTheme]
          ['InformationTitle'],
          languageThemeData[
          languageController
              .languageTheme]
          ['FillAllInformation']);
      return;
    }

    int countNotification = 0;
    if (timeController.isNotEmpty) {
      for (int j = 0; j < allApplicationList.length; j++) {
        for (int i = 0; i < timeController.length; i++) {
          if (allApplicationList[j]
              .categoryId
              .toString()
              .contains(categoryId)) {
            final response = await http.post(
              Uri.parse('https://onesignal.com/api/v1/notifications'),
              headers: <String, String>{
                'Authorization': 'Basic ' + allApplicationList[j].restApiKey,
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, dynamic>{
                'app_id': allApplicationList[j].oneSignalAppId,
                'included_segments': ['All'],
                'contents': {'en': content},
                'headings': {'en': allApplicationList[j].title},
                'big_picture': thumbnail,
                'url': url,
                'send_after': timeController[i].text,
              }),
            );

            var result = json.decode(response.body);
            // print(result);
            if (result['errors'] != null) {
              Message(context: context).showErrorMessage(
                  languageThemeData[languageController.languageTheme]
                      ['InformationTitle'],
                  languageThemeData[languageController.languageTheme]
                      ['SendError']);
              return;
            }

            if (countNotification == 0) {
              String categoryTitle = 'N/A';
              for (int k = 0; k < categoryList.length; k++) {
                if (categoryList[k].id.toString().contains(categoryId)) {
                  categoryTitle = categoryList[k].title;
                  k = categoryList.length;
                }
              }

              await DatabaseService(uid: uid).updateHistoryData(History(
                id: -1 * DateTime.now().millisecondsSinceEpoch,
                isCategory: true,
                categoryId: int.parse(categoryId),
                categoryTitle: categoryTitle,
                appId: 0,
                appTitle: 'N/A',
                message: content == '' ? 'N/A' : content,
                url: url == '' ? 'N/A' : url,
                image: thumbnail == '' ? 'N/A' : thumbnail,
                createTimestamp: -1 * DateTime.now().millisecondsSinceEpoch,
                updateTimestamp: -1 * DateTime.now().millisecondsSinceEpoch,
              ));
            }
            countNotification++;
          }
        }
      }

      Message(context: context).showSuccessMessage(
          languageThemeData[languageController.languageTheme]
              ['InformationTitle'],
          languageThemeData[languageController.languageTheme]['SendSuccess']);
    } else {
      for (int i = 0; i < allApplicationList.length; i++) {
        if (allApplicationList[i].categoryId.toString().contains(categoryId) &&
            applicationList[i].url != url) {
          final response = await http.post(
            Uri.parse('https://onesignal.com/api/v1/notifications'),
            headers: <String, String>{
              'Authorization': 'Basic ' + allApplicationList[i].restApiKey,
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              'app_id': allApplicationList[i].oneSignalAppId,
              'included_segments': ['All'],
              'contents': {'en': content},
              'headings': {'en': allApplicationList[i].title},
              'big_picture': thumbnail,
              'url': url,
            }),
          );
          var result = json.decode(response.body);
          // print(result);
          // print(allApplicationList[i].url);
          if (result['errors'] != null) {
            Message(context: context).showErrorMessage(
                languageThemeData[languageController.languageTheme]
                    ['InformationTitle'],
                languageThemeData[languageController.languageTheme]
                    ['SendError']);
            return;
          }

          if (countNotification == 0) {
            String categoryTitle = 'N/A';
            for (int k = 0; k < categoryList.length; k++) {
              if (categoryList[k].id.toString().contains(categoryId)) {
                categoryTitle = categoryList[k].title;
                k = categoryList.length;
              }
            }

            await DatabaseService(uid: uid).updateHistoryData(History(
              id: -1 * DateTime.now().millisecondsSinceEpoch,
              isCategory: true,
              categoryId: int.parse(categoryId),
              categoryTitle: categoryTitle,
              appId: 0,
              appTitle: 'N/A',
              message: content == '' ? 'N/A' : content,
              url: url == '' ? 'N/A' : url,
              image: thumbnail == '' ? 'N/A' : thumbnail,
              createTimestamp: -1 * DateTime.now().millisecondsSinceEpoch,
              updateTimestamp: -1 * DateTime.now().millisecondsSinceEpoch,
            ));
          }
          countNotification++;
        }
      }

      Message(context: context).showSuccessMessage(
          languageThemeData[languageController.languageTheme]
              ['InformationTitle'],
          languageThemeData[languageController.languageTheme]['SendSuccess']);
    }

    // await DatabaseService(uid: uid).updateHistoryData(History(
    //   id: -1 * DateTime.now().millisecondsSinceEpoch,
    //   isCategory: true,
    //   categoryId: int.parse(categoryId),
    //   appId: 0,
    //   message: content == '' ? 'N/A' : content,
    //   url: url == '' ? 'N/A' : url,
    //   image: thumbnail == '' ? 'N/A' : thumbnail,
    //   createTimestamp: -1 * DateTime.now().millisecondsSinceEpoch,
    //   updateTimestamp: -1 * DateTime.now().millisecondsSinceEpoch,
    // ));

    setState(() {
      valueChooseCategory = null;
      valueChooseApplication = null;
      messageController.clear();
      urlController.clear();
      thumbnailController.clear();
      thumbnailController.text = tempThumbnailUrl;
      timeController.clear();
      isSending = false;
    });
  }

  Future<void> sendNotificationByApplication(
      String appId, String content, String thumbnail, String url) async {
    if(appId == '' || content == '') {
      Message(context: context)
          .showErrorMessage(
          languageThemeData[
          languageController
              .languageTheme]
          ['InformationTitle'],
          languageThemeData[
          languageController
              .languageTheme]
          ['FillAllInformation']);
      return;
    }

    int countNotification = 0;
    if (timeController.isNotEmpty) {
      for (int i = 0; i < timeController.length; i++) {
        for (int j = 0; j < allApplicationList.length; j++) {
          if (allApplicationList[j].id.toString().contains(appId)) {
            final response = await http.post(
              Uri.parse('https://onesignal.com/api/v1/notifications'),
              headers: <String, String>{
                'Authorization': 'Basic ' + allApplicationList[j].restApiKey,
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, dynamic>{
                'app_id': allApplicationList[j].oneSignalAppId,
                'included_segments': ['All'],
                'contents': {'en': content},
                'headings': {'en': allApplicationList[j].title},
                'big_picture': thumbnail,
                'url': url,
                'send_after': timeController[i].text,
              }),
            );

            var result = json.decode(response.body);
            if (result['errors'] != null) {
              Message(context: context).showErrorMessage(
                  languageThemeData[languageController.languageTheme]
                      ['InformationTitle'],
                  languageThemeData[languageController.languageTheme]
                      ['SendError']);
              return;
            }

            if (countNotification == 0 && url != '') {
              await DatabaseService(uid: uid).updateHistoryData(History(
                id: -1 * DateTime.now().millisecondsSinceEpoch,
                isCategory: false,
                categoryId: 0,
                categoryTitle: 'N/A',
                appId: int.parse(appId),
                appTitle: allApplicationList[j].title,
                message: content == '' ? 'N/A' : content,
                url: url == '' ? 'N/A' : url,
                image: thumbnail == '' ? 'N/A' : thumbnail,
                createTimestamp: -1 * DateTime.now().millisecondsSinceEpoch,
                updateTimestamp: -1 * DateTime.now().millisecondsSinceEpoch,
              ));
            }
            countNotification++;
            j == allApplicationList.length;
          }
        }
      }

      Message(context: context).showSuccessMessage(
          languageThemeData[languageController.languageTheme]
              ['InformationTitle'],
          languageThemeData[languageController.languageTheme]['SendSuccess']);
    } else {
      for (int i = 0; i < allApplicationList.length; i++) {
        if (allApplicationList[i].id.toString().contains(appId)) {
          final response = await http.post(
            Uri.parse('https://onesignal.com/api/v1/notifications'),
            headers: <String, String>{
              'Authorization': 'Basic ' + allApplicationList[i].restApiKey,
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              'app_id': allApplicationList[i].oneSignalAppId,
              'included_segments': ['All'],
              'contents': {'en': content},
              'headings': {'en': allApplicationList[i].title},
              'big_picture': thumbnail,
              'url': url,
            }),
          );
          var result = json.decode(response.body);
          if (result['errors'] != null) {
            Message(context: context).showErrorMessage(
                languageThemeData[languageController.languageTheme]
                    ['InformationTitle'],
                languageThemeData[languageController.languageTheme]
                    ['SendError']);

            return;
          }

          if (countNotification == 0 && url != '') {
            await DatabaseService(uid: uid).updateHistoryData(History(
              id: -1 * DateTime.now().millisecondsSinceEpoch,
              isCategory: false,
              categoryId: 0,
              categoryTitle: 'N/A',
              appId: int.parse(appId),
              appTitle: allApplicationList[i].title,
              message: content == '' ? 'N/A' : content,
              url: url == '' ? 'N/A' : url,
              image: thumbnail == '' ? 'N/A' : thumbnail,
              createTimestamp: -1 * DateTime.now().millisecondsSinceEpoch,
              updateTimestamp: -1 * DateTime.now().millisecondsSinceEpoch,
            ));
          }
          countNotification++;
          i == allApplicationList.length;
        }
      }

      Message(context: context).showSuccessMessage(
          languageThemeData[languageController.languageTheme]
              ['InformationTitle'],
          languageThemeData[languageController.languageTheme]['SendSuccess']);
    }

    // await DatabaseService(uid: uid).updateHistoryData(History(
    //   id: -1 * DateTime.now().millisecondsSinceEpoch,
    //   isCategory: false,
    //   categoryId: 0,
    //   appId: int.parse(appId),
    //   message: content == '' ? 'N/A' : content,
    //   url: url == '' ? 'N/A' : url,
    //   image: thumbnail == '' ? 'N/A' : thumbnail,
    //   createTimestamp: -1 * DateTime.now().millisecondsSinceEpoch,
    //   updateTimestamp: -1 * DateTime.now().millisecondsSinceEpoch,
    // ));

    setState(() {
      valueChooseCategory = null;
      valueChooseApplication = null;
      messageController.clear();
      urlController.clear();
      thumbnailController.clear();
      thumbnailController.text = tempThumbnailUrl;
      timeController.clear();
      isSending = false;
    });
  }

  Widget appendTimeTextField(
      String time, TextEditingController timeController) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              time,
              style: TextStyle(
                  color: Colors.black,
                  fontFamily:
                      languageThemeData[languageController.languageTheme]
                          ['FontSecondary']),
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
                controller: timeController,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily:
                        languageThemeData[languageController.languageTheme]
                            ['FontSecondary']),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '2021-06-11 19:43:12 GMT+0700',
                  hintStyle: TextStyle(
                      fontFamily:
                          languageThemeData[languageController.languageTheme]
                              ['FontSecondary']),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  @override
  void initState() {
    thumbnailController.text = tempThumbnailUrl;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserApp>(context);
    uid = user.uid;

    categoryList = Provider.of<List<Category>>(context) ?? [];
    categoryList.sort((a, b) => a.title.compareTo(b.title));
    allApplicationList = Provider.of<List<Application>>(context) ?? [];
    List<Application> data = Provider.of<List<Application>>(context) ?? [];
    if (data.isNotEmpty) {
      applicationList.clear();
      for (int i = 0; i < data.length; i++) {
        if (data[i].status) {
          String tempUrl = data[i].title +
              ' - ' +
              data[i]
                  .url
                  .replaceAll('https://bmoon.club/database-php/', '')
                  .replaceAll(
                      'https://play.google.com/store/apps/details?id=', '')
                  .replaceAll('/', '');
          applicationList.add(Application(
            id: data[i].id,
            title: data[i].title,
            url: tempUrl,
            categoryId: data[i].categoryId,
            restApiKey: data[i].restApiKey,
            oneSignalAppId: data[i].oneSignalAppId,
          ));
        }
      }
      applicationList.sort((a, b) => a.url.compareTo(b.url));
    }

    return GetBuilder<LanguageController>(
        builder: (_) => Container(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: 600,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '*' + languageThemeData[languageController.languageTheme]
                                ['SendBy'],
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
                            child: GetBuilder<ExpandMenuController>(
                              builder: (_) => DropdownButton<String>(
                                underline: Container(),
                                value: valueChooseSendBy,
                                style: TextStyle(
                                    fontFamily: languageThemeData[
                                            languageController.languageTheme]
                                        ['FontSecondary']),
                                items: [
                                  languageThemeData[languageController
                                      .languageTheme]['MenuCategory'],
                                  languageThemeData[languageController
                                      .languageTheme]['MenuApplication']
                                ].map((String sendBy) {
                                  return DropdownMenuItem<String>(
                                    value: sendBy.contains(languageThemeData[
                                            languageController
                                                .languageTheme]['MenuCategory'])
                                        ? 'Category'
                                        : 'Application',
                                    child: SizedBox(
                                      width: 600.0 -
                                          (expandMenuController.isExpand
                                              ? 40
                                              : 40),
                                      child: Text(
                                        sendBy,
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String val) {
                                  setState(() {
                                    valueChooseSendBy = val;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      valueChooseSendBy != null
                          ? const SizedBox(
                              height: 20,
                            )
                          : const SizedBox(),
                      valueChooseSendBy != null &&
                              valueChooseSendBy == 'Category'
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '*' +
                                      languageThemeData[languageController
                                          .languageTheme]['MenuCategory'],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: languageThemeData[
                                              languageController.languageTheme]
                                          ['FontSecondary']),
                                ),
                                const SizedBox(height: 10.0),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      border: Border.all(width: 0.3)),
                                  // height: 60.0,
                                  child: GetBuilder<ExpandMenuController>(
                                    builder: (_) => DropdownButton<String>(
                                      underline: Container(),
                                      value: valueChooseCategory,
                                      style: TextStyle(
                                          fontFamily: languageThemeData[
                                                  languageController
                                                      .languageTheme]
                                              ['FontSecondary']),
                                      items:
                                          categoryList.map((Category category) {
                                        return DropdownMenuItem<String>(
                                          value: category.id.toString(),
                                          child: SizedBox(
                                            width: 600.0 -
                                                (expandMenuController.isExpand
                                                    ? 40
                                                    : 40),
                                            child: Text(
                                              category.title,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (String val) {
                                        setState(() {
                                          valueChooseCategory = val;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                      valueChooseSendBy != null &&
                              valueChooseSendBy == 'Application'
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '*' +
                                      languageThemeData[languageController
                                          .languageTheme]['Application'],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: languageThemeData[
                                              languageController.languageTheme]
                                          ['FontSecondary']),
                                ),
                                const SizedBox(height: 10.0),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      border: Border.all(width: 0.3)),
                                  // height: 60.0,
                                  child: GetBuilder<ExpandMenuController>(
                                    builder: (_) => DropdownButton<String>(
                                      underline: Container(),
                                      value: valueChooseApplication,
                                      style: TextStyle(
                                          fontFamily: languageThemeData[
                                                  languageController
                                                      .languageTheme]
                                              ['FontSecondary']),
                                      items: applicationList
                                          .map((Application app) {
                                        return DropdownMenuItem<String>(
                                          value: app.id.toString(),
                                          child: SizedBox(
                                            width: 600.0 -
                                                (expandMenuController.isExpand
                                                    ? 40
                                                    : 40),
                                            child: Text(
                                              app.url,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (String val) {
                                        setState(() {
                                          valueChooseApplication = val;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                      const SizedBox(
                              height: 20,
                            ),
                      Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '*' +
                                      languageThemeData[languageController
                                          .languageTheme]['Message'],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: languageThemeData[
                                              languageController.languageTheme]
                                          ['FontSecondary']),
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
                                    controller: messageController,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: languageThemeData[
                                                languageController
                                                    .languageTheme]
                                            ['FontSecondary']),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: languageThemeData[
                                              languageController.languageTheme]
                                          ['Message'],
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          fontFamily: languageThemeData[
                                                  languageController
                                                      .languageTheme]
                                              ['FontSecondary']),
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
                                  languageThemeData[
                                      languageController.languageTheme]['Url'],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: languageThemeData[
                                              languageController.languageTheme]
                                          ['FontSecondary']),
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
                                    controller: urlController,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: languageThemeData[
                                                languageController
                                                    .languageTheme]
                                            ['FontSecondary']),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'https://example.com/',
                                      hintStyle: TextStyle(
                                          fontFamily: languageThemeData[
                                                  languageController
                                                      .languageTheme]
                                              ['FontSecondary']),
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
                                  languageThemeData[languageController
                                      .languageTheme]['Thumbnail'],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: languageThemeData[
                                              languageController.languageTheme]
                                          ['FontSecondary']),
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
                                    controller: thumbnailController,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: languageThemeData[
                                                languageController
                                                    .languageTheme]
                                            ['FontSecondary']),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'https://example.com/image.png',
                                      hintStyle: TextStyle(
                                          fontFamily: languageThemeData[
                                                  languageController
                                                      .languageTheme]
                                              ['FontSecondary']),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      timeController.isNotEmpty
                          ? const SizedBox(
                              height: 10,
                            )
                          : const SizedBox(),
                      timeController.isNotEmpty
                          ? const SizedBox(height: 10.0)
                          : const SizedBox(),
                      for (int i = 0; i < timeController.length; i++)
                        appendTimeTextField(
                            '*' +
                                languageThemeData[
                                    languageController.languageTheme]['Time'] +
                                (i + 1).toString(),
                            timeController[i]),
                      const SizedBox(
                              height: 20,
                            ),
                      Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    TextEditingController _timeController =
                                        TextEditingController();
                                    DateTime now = DateTime.now();
                                    String formattedDate =
                                        DateFormat('yyyy-MM-dd kk:mm:ss')
                                                .format(now) +
                                            ' GMT+0700';
                                    _timeController.text = formattedDate;

                                    setState(() {
                                      timeController.add(_timeController);
                                    });
                                  },
                                  child: Container(
                                    // width: 200,
                                    padding: const EdgeInsets.all(15),
                                    decoration:
                                        BoxDecoration(color: colorPrimary),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.timelapse,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          languageThemeData[languageController
                                                  .languageTheme][
                                              timeController.isEmpty
                                                  ? 'EditTime'
                                                  : 'AddTime'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: languageThemeData[
                                                      languageController
                                                          .languageTheme]
                                                  ['FontSecondary']),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    if (valueChooseSendBy == 'Category') {
                                      if (!STRING_EMAIL_SPECIAL_USER
                                          .contains(userController.email)) {
                                        Message(context: context)
                                            .showErrorMessage(
                                                languageThemeData[
                                                        languageController
                                                            .languageTheme]
                                                    ['InformationTitle'],
                                                languageThemeData[
                                                        languageController
                                                            .languageTheme]
                                                    ['Permission']);
                                      } else {
                                        setState(() {
                                          isSending = true;
                                        });
                                        await sendNotificationByCategoryId(
                                            valueChooseCategory,
                                            messageController.text,
                                            thumbnailController.text,
                                            urlController.text);
                                      }
                                    } else if (valueChooseSendBy ==
                                        'Application') {
                                      setState(() {
                                        isSending = true;
                                      });
                                      await sendNotificationByApplication(
                                          valueChooseApplication,
                                          messageController.text,
                                          thumbnailController.text,
                                          urlController.text);
                                    } else {
                                      Message(context: context)
                                          .showErrorMessage(
                                          languageThemeData[
                                          languageController
                                              .languageTheme]
                                          ['InformationTitle'],
                                          languageThemeData[
                                          languageController
                                              .languageTheme]
                                          ['FillAllInformation']);
                                    }
                                  },
                                  child: Container(
                                    // width: 200,
                                    padding: const EdgeInsets.all(15),
                                    decoration:
                                        BoxDecoration(color: colorPrimary),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        isSending ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation(Colors.white),
                                          ),
                                        ) : const Icon(
                                          Icons.notifications_active,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          languageThemeData[languageController
                                                  .languageTheme]
                                              ['MenuSendNotification'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: languageThemeData[
                                                      languageController
                                                          .languageTheme]
                                                  ['FontSecondary']),
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
                    ],
                  ),
                ),
              ),
            ));
  }
}
