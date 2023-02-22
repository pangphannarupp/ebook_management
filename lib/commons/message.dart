import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notification_management/commons/constants/colors.dart';
import 'package:notification_management/commons/controllers/language_controller.dart';
import 'package:notification_management/commons/theme/language.dart';

class Message {
  final BuildContext context;
  Message({this.context});

  final languageController = Get.put(LanguageController());

  void showErrorMessage(String title, String message) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: colorSecondary,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.warning,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(title,
                    style: const TextStyle(
                      color: Colors.white,
                    ))
              ],
            ),
            content: SizedBox(
              width: 300,
              height: 50,
              child: Center(
                  child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                ),
              )),
            ),
            actions: <Widget>[
              GestureDetector(
                onTap: () {
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
            ],
          );
        });
  }

  void showSuccessMessage(String title, String message) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.green,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.verified,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(title,
                    style: const TextStyle(
                      color: Colors.white,
                    ))
              ],
            ),
            content: SizedBox(
              width: 300,
              height: 50,
              child: Center(
                  child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                ),
              )),
            ),
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 130,
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(color: Colors.green),
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
            ],
          );
        });
  }

  void showConfirmMessage(String title, String message, Function confirm) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: colorSecondary,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.warning,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                )
              ],
            ),
            content: SizedBox(
              width: 350,
              height: 100,
              child: Center(
                  child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                ),
              )),
            ),
            actions: <Widget>[
              GestureDetector(
                onTap: () {
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
                onTap: () async {
                  confirm();
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
                        Icons.delete,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        languageThemeData[languageController.languageTheme]
                            ['Delete'],
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
}
