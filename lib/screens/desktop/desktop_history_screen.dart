import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notification_management/commons/constants/colors.dart';
import 'package:notification_management/commons/constants/strings.dart';
import 'package:notification_management/commons/controllers/language_controller.dart';
import 'package:notification_management/commons/controllers/user_controller.dart';
import 'package:notification_management/commons/message.dart';
import 'package:notification_management/commons/theme/language.dart';
import 'package:notification_management/domain/entities/application.dart';
import 'package:notification_management/domain/entities/category.dart';
import 'package:notification_management/domain/entities/history.dart';
import 'package:notification_management/domain/entities/user.dart';
import 'package:notification_management/services/database.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class DesktopHistoryScreen extends StatefulWidget {
  const DesktopHistoryScreen({Key key}) : super(key: key);

  @override
  _DesktopHistoryScreenState createState() => _DesktopHistoryScreenState();
}

class _DesktopHistoryScreenState extends State<DesktopHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserApp>(context);

    return StreamProvider<List<History>>.value(
        value: DatabaseService(uid: user.uid).histories,
        initialData: const [],
        child: StreamProvider<List<Category>>.value(
          value: DatabaseService(uid: user.uid).categories,
          initialData: const [],
          child: StreamProvider<List<Category>>.value(
            value: DatabaseService(uid: user.uid).categories,
            initialData: const [],
            child: const Scaffold(
              body: Content(),
            ),
          ),
        ));
  }
}

class Content extends StatefulWidget {
  const Content({Key key}) : super(key: key);

  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content> {
  String search = '';
  String uid = '';
  List<History> historyList = <History>[];
  List<Application> applicationList = <Application>[];
  List<Category> categoryList = <Category>[];

  final languageController = Get.put(LanguageController());
  final userController = Get.put(UserController());

  TextEditingController searchController = TextEditingController();
  List<TextEditingController> timeController = <TextEditingController>[];

  Future<void> sendNotificationByCategoryId(
      String categoryId, String content, String thumbnail, String url) async {
    if (timeController.isNotEmpty) {
      for (int j = 0; j < applicationList.length; j++) {
        for (int i = 0; i < timeController.length; i++) {
          if (applicationList[j].categoryId.toString().contains(categoryId)) {
            final response = await http.post(
              Uri.parse('https://onesignal.com/api/v1/notifications'),
              headers: <String, String>{
                'Authorization': 'Basic ' + applicationList[j].restApiKey,
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, dynamic>{
                'app_id': applicationList[j].oneSignalAppId,
                'included_segments': ['All'],
                'contents': {'en': content},
                'headings': {'en': applicationList[j].title},
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
          }
        }
      }

      Message(context: context).showSuccessMessage(
          languageThemeData[languageController.languageTheme]
              ['InformationTitle'],
          languageThemeData[languageController.languageTheme]['SendSuccess']);
    } else {
      for (int i = 0; i < applicationList.length; i++) {
        if (applicationList[i].categoryId.toString().contains(categoryId)) {
          final response = await http.post(
            Uri.parse('https://onesignal.com/api/v1/notifications'),
            headers: <String, String>{
              'Authorization': 'Basic ' + applicationList[i].restApiKey,
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              'app_id': applicationList[i].oneSignalAppId,
              'included_segments': ['All'],
              'contents': {'en': content},
              'headings': {'en': applicationList[i].title},
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
        }
      }

      Message(context: context).showSuccessMessage(
          languageThemeData[languageController.languageTheme]
              ['InformationTitle'],
          languageThemeData[languageController.languageTheme]['SendSuccess']);
    }

    setState(() {
      timeController.clear();
    });
  }

  Future<void> sendNotificationByApplication(
      String appId, String content, String thumbnail, String url) async {
    if (timeController.isNotEmpty) {
      for (int i = 0; i < timeController.length; i++) {
        for (int j = 0; j < applicationList.length; j++) {
          if (applicationList[j].id.toString().contains(appId)) {
            final response = await http.post(
              Uri.parse('https://onesignal.com/api/v1/notifications'),
              headers: <String, String>{
                'Authorization': 'Basic ' + applicationList[j].restApiKey,
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, dynamic>{
                'app_id': applicationList[j].oneSignalAppId,
                'included_segments': ['All'],
                'contents': {'en': content},
                'headings': {'en': applicationList[j].title},
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
            j == applicationList.length;
          }
        }
      }

      Message(context: context).showSuccessMessage(
          languageThemeData[languageController.languageTheme]
              ['InformationTitle'],
          languageThemeData[languageController.languageTheme]['SendSuccess']);
    } else {
      for (int i = 0; i < applicationList.length; i++) {
        if (applicationList[i].id.toString().contains(appId)) {
          final response = await http.post(
            Uri.parse('https://onesignal.com/api/v1/notifications'),
            headers: <String, String>{
              'Authorization': 'Basic ' + applicationList[i].restApiKey,
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              'app_id': applicationList[i].oneSignalAppId,
              'included_segments': ['All'],
              'contents': {'en': content},
              'headings': {'en': applicationList[i].title},
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
          }
          i == applicationList.length;
        }
      }

      Message(context: context).showSuccessMessage(
          languageThemeData[languageController.languageTheme]
              ['InformationTitle'],
          languageThemeData[languageController.languageTheme]['SendSuccess']);
    }

    setState(() {
      timeController.clear();
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

  void showAddTime(BuildContext context, String popupTitle, History history) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              popupTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontFamily:
                      languageThemeData[languageController.languageTheme]
                          ['FontSecondary']),
            ),
            content: SizedBox(
              width: 600,
              child: SingleChildScrollView(
                child: Column(
                  children: [
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
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    timeController.clear();
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  width: 130,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(color: colorSecondary),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.clear,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        languageThemeData[languageController.languageTheme]
                            ['Exit'],
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
              ),
              GestureDetector(
                onTap: () {
                  TextEditingController _timeController =
                      TextEditingController();
                  DateTime now = DateTime.now();
                  String formattedDate =
                      DateFormat('yyyy-MM-dd kk:mm:ss').format(now) +
                          ' GMT+0700';
                  _timeController.text = formattedDate;

                  setState(() {
                    timeController.add(_timeController);
                  });

                  Navigator.pop(context);
                  showAddTime(context, popupTitle, history);
                },
                child: Container(
                  width: 200,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(color: colorPrimary),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.timelapse,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        languageThemeData[languageController.languageTheme]
                            [timeController.isEmpty ? 'EditTime' : 'AddTime'],
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
              ),
              GestureDetector(
                onTap: () async {
                  if (history.isCategory) {
                    await sendNotificationByCategoryId(
                      history.categoryId.toString(),
                      history.message,
                      history.image,
                      history.url,
                    );
                  } else {
                    await sendNotificationByApplication(
                      history.appId.toString(),
                      history.message,
                      history.image,
                      history.url,
                    );
                  }
                },
                child: Container(
                  width: 130,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(color: colorPrimary),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.notifications_active,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        languageThemeData[languageController.languageTheme]
                            ['Send'],
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
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserApp>(context);
    uid = user.uid;
    // Only Categories are similar to AppId that user choose
    categoryList = Provider.of<List<Category>>(context) ?? [];
    // For Search
    List<History> data = Provider.of<List<History>>(context) ?? [];
    historyList.clear();
    if (data.isNotEmpty) {
      for (int i = 0; i < data.length; i++) {
        if (data[i].categoryTitle.toLowerCase().contains(search.toLowerCase()) ||
            data[i].appTitle.toLowerCase().contains(search.toLowerCase()) ||
            data[i].url.toLowerCase().contains(search.toLowerCase())) {
          historyList.add(data[i]);
        }
      }
    }

    return GetBuilder<LanguageController>(
        builder: (_) => Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6.0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // GestureDetector(
                    //   onTap: () {
                    //     setState(() {
                    //       isUpdate = false;
                    //       tempApplication = null;
                    //       tempId =
                    //           -1 * DateTime.now().millisecondsSinceEpoch;
                    //     });
                    //     showPopUpUpdateData(
                    //         context,
                    //         languageThemeData[
                    //                 languageController.languageTheme]
                    //             [isUpdate ? 'Edit' : 'Add'],
                    //         isUpdate,
                    //         tempApplication,
                    //         tempId);
                    //   },
                    //   child: Container(
                    //     padding: const EdgeInsets.all(15),
                    //     decoration: BoxDecoration(color: colorPrimary),
                    //     child: Row(
                    //       children: [
                    //         const Icon(
                    //           Icons.add,
                    //           color: Colors.white,
                    //         ),
                    //         const SizedBox(
                    //           width: 5,
                    //         ),
                    //         Text(
                    //           languageThemeData[languageController
                    //               .languageTheme]['Add'],
                    //           style: TextStyle(
                    //               color: Colors.white,
                    //               fontFamily: languageThemeData[
                    //                       languageController
                    //                           .languageTheme]
                    //                   ['FontSecondary']),
                    //         ),
                    //         const SizedBox(
                    //           width: 5,
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    MediaQuery.of(context).size.width <= 650
                        ? const SizedBox()
                        : const Spacer(),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Container(
                          decoration: BoxDecoration(
                              // color: Color(0xff0a4350),
                              border: Border.all(
                                  color: colorPrimary, width: 1)),
                          child: TextField(
                            controller: searchController,
                            onSubmitted: (word) {
                              setState(() {
                                search = word;
                              });
                            },
                            onChanged: (word) {
                              setState(() {
                                search = word;
                              });
                            },
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                focusColor: Colors.transparent,
                                fillColor: Colors.transparent,
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      search = searchController.text;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: colorPrimary),
                                    child: const Padding(
                                      padding: EdgeInsets.all(15),
                                      child: Icon(
                                        Icons.search,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                hintText: languageThemeData[
                                        languageController.languageTheme]
                                    ['Search'],
                                hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontFamily: languageThemeData[
                                            languageController
                                                .languageTheme]
                                        ['FontSecondary']),
                                contentPadding: MediaQuery.of(context)
                                            .size
                                            .width <=
                                        650
                                    ? const EdgeInsets.fromLTRB(
                                        10, 10, 10, 10)
                                    : const EdgeInsets.fromLTRB(
                                        15, 15, 15, 15),
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 90),
              child: GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 500 / 500,
                    crossAxisCount:
                        (MediaQuery.of(context).size.width / 350)
                            .round()),
                itemCount: historyList.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Container(
                          margin:
                              const EdgeInsets.only(bottom: 60, top: 70),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: historyList[index].image != 'N/A'
                                      ? NetworkImage(
                                          historyList[index].image)
                                      : const AssetImage(
                                          'assets/images/image-not-found.png'),
                                  fit: BoxFit.fitHeight)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              height: 70,
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.all(10),
                              decoration:
                                  BoxDecoration(color: colorPrimary),
                              child: Row(
                                children: [
                                  Icon(
                                    historyList[index].isCategory
                                        ? Icons.vibration
                                        : Icons.phone_android,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 10,),
                                  Expanded(
                                    child: Text(
                                      (historyList[index].isCategory
                                          ? historyList[index]
                                              .categoryTitle
                                          : historyList[index].appTitle) + '\n' +
                                          historyList[index].url
                                              .replaceAll('https://bmoon.club/database-php/', '')
                                              .replaceAll('https://play.google.com/store/apps/details?id=', '')
                                              .replaceAll('/', ''),
                                      textAlign: TextAlign.left,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.white,
                                          // fontSize: 12,
                                          fontFamily: languageThemeData[
                                                  languageController
                                                      .languageTheme]
                                              ['FontSecondary']),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              height: 40,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: GestureDetector(
                                    onTap: () {
                                      if (!STRING_EMAIL_ADMIN
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
                                        showAddTime(
                                            context,
                                            languageThemeData[
                                                    languageController
                                                        .languageTheme]
                                                ['AddTime'],
                                            historyList[index]);
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: colorPrimary),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.notifications_active,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            languageThemeData[
                                                    languageController
                                                        .languageTheme]
                                                ['Send'],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontFamily: languageThemeData[
                                                        languageController
                                                            .languageTheme]
                                                    ['FontSecondary']),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: GestureDetector(
                                    onTap: () {
                                      Message(context: context)
                                          .showConfirmMessage(
                                              languageThemeData[
                                                      languageController
                                                          .languageTheme]
                                                  ['InformationTitle'],
                                              languageThemeData[
                                                      languageController
                                                          .languageTheme][
                                                  'DeleteNotificationDescription'],
                                              () async {
                                        await DatabaseService(uid: uid)
                                            .deleteHistoryData(
                                                historyList[index].id);
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: colorSecondary),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            languageThemeData[
                                                    languageController
                                                        .languageTheme]
                                                ['Delete'],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontFamily: languageThemeData[
                                                        languageController
                                                            .languageTheme]
                                                    ['FontSecondary']),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ));
  }
}
