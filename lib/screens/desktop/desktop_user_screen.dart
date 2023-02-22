import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notification_management/commons/constants/colors.dart';
import 'package:notification_management/commons/constants/strings.dart';
import 'package:notification_management/commons/controllers/expand_menu_controller.dart';
import 'package:notification_management/commons/controllers/language_controller.dart';
import 'package:notification_management/commons/controllers/user_controller.dart';
import 'package:notification_management/commons/message.dart';
import 'package:notification_management/commons/theme/language.dart';
import 'package:notification_management/services/auth.dart';

class DesktopUserScreen extends StatefulWidget {
  const DesktopUserScreen({Key key}) : super(key: key);

  @override
  _DesktopUserScreenState createState() => _DesktopUserScreenState();
}

class _DesktopUserScreenState extends State<DesktopUserScreen> {
  final languageController = Get.put(LanguageController());
  final expandMenuController = Get.put(ExpandMenuController());
  final userController = Get.put(UserController());
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();

  AuthService authService = AuthService();
  bool isRegistering = false;

  Future<void> registerUser(String email, String password, String repassword) async {
    if(email == '' || password == '' || repassword == '') {
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
    } else if(password != repassword) {
      Message(context: context)
          .showErrorMessage(
          languageThemeData[
          languageController
              .languageTheme]
          ['InformationTitle'],
          languageThemeData[
          languageController
              .languageTheme]
          ['WrongPassword']);
    } else if(password.length < 6) {
      Message(context: context)
          .showErrorMessage(
          languageThemeData[
          languageController
              .languageTheme]
          ['InformationTitle'],
          languageThemeData[
          languageController
              .languageTheme]
          ['LimitPassword']);
    } else {
      setState(() {
        isRegistering = true;
      });
      dynamic result = await authService.registerWithEmailAndPassword(email, password);
      if(result == null) {
        setState(() {
          isRegistering = false;
        });
        Message(context: context)
            .showErrorMessage(
            languageThemeData[
            languageController
                .languageTheme]
            ['InformationTitle'],
            languageThemeData[
            languageController
                .languageTheme]
            ['InvalidEmail']);
      } else {
        emailController.clear();
        passwordController.clear();
        rePasswordController.clear();
        setState(() {
          isRegistering = false;
        });
        Message(context: context)
            .showSuccessMessage(
            languageThemeData[
            languageController
                .languageTheme]
            ['InformationTitle'],
            languageThemeData[
            languageController
                .languageTheme]
            ['RegisterSuccess']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LanguageController>(builder: (_) => Container(
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
                    languageThemeData[languageController.languageTheme]['Email'],
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: languageThemeData[languageController.languageTheme]['FontSecondary']
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(
                            width: 0.3
                        )
                    ),
                    // height: 60.0,
                    child: TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      // obscureText: true,
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: languageThemeData[languageController.languageTheme]['FontSecondary']
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Colors.black,
                        ),
                        hintText: languageThemeData[languageController.languageTheme]['Email'],
                        hintStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: languageThemeData[languageController.languageTheme]['FontSecondary']
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    languageThemeData[languageController.languageTheme]['Password'],
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: languageThemeData[languageController.languageTheme]['FontSecondary']
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(
                            width: 0.3
                        )
                    ),
                    // height: 60.0,
                    child: TextField(
                      controller: passwordController,
                      focusNode: FocusNode(),
                      obscureText: true,
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: languageThemeData[languageController.languageTheme]['FontSecondary']
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.black,
                        ),
                        hintText: '*********',
                        hintStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: languageThemeData[languageController.languageTheme]['FontSecondary']
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    languageThemeData[languageController.languageTheme]['RePassword'],
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: languageThemeData[languageController.languageTheme]['FontSecondary']
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(
                            width: 0.3
                        )
                    ),
                    // height: 60.0,
                    child: TextField(
                      controller: rePasswordController,
                      obscureText: true,
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: languageThemeData[languageController.languageTheme]['FontSecondary']
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.black,
                        ),
                        hintText: '*********',
                        hintStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: languageThemeData[languageController.languageTheme]['FontSecondary']
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              GestureDetector(
                onTap: () {
                  if (!STRING_EMAIL_TOP_ADMIN
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
                    registerUser(emailController.text, passwordController
                        .text, rePasswordController.text);
                  }
                },
                child: Container(
                  width: 200,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(color: colorPrimary),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isRegistering ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      ) : const Icon(
                        Icons.person_add,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 5,),
                      Text(
                        languageThemeData[languageController.languageTheme]['CreateUser'],
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: languageThemeData[languageController.languageTheme]['FontSecondary']
                        ),
                      ),
                      const SizedBox(width: 5,)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
