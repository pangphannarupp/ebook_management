import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:notification_management/commons/constants/colors.dart';
import 'package:notification_management/commons/controllers/language_controller.dart';
import 'package:notification_management/commons/controllers/user_controller.dart';
import 'package:notification_management/commons/message.dart';
import 'package:notification_management/commons/theme/language.dart';
import 'package:notification_management/services/auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();

  final userController = Get.put(UserController());
  final languageController = Get.put(LanguageController());

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmEmailController = TextEditingController();

  bool isLogining = false;

  void showPopUpConfirmForgetPassword(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.info,
                  color: Colors.black,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  languageThemeData[languageController.languageTheme]
                      ['ConfirmEmail'],
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily:
                          languageThemeData[languageController.languageTheme]
                              ['FontSecondary']),
                ),
              ],
            ),
            content: SizedBox(
              width: 350,
              // height: 470,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(width: 0.3)),
                      // height: 60.0,
                      child: TextField(
                        controller: confirmEmailController,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: languageThemeData[languageController
                                .languageTheme]['FontSecondary']),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: languageThemeData[
                              languageController.languageTheme]['ConfirmEmail'],
                          hintStyle: TextStyle(
                              fontFamily: languageThemeData[languageController
                                  .languageTheme]['FontSecondary']),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    confirmEmailController.clear();
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
                  setState(() {
                    confirmEmailController.clear();
                  });
                  _auth.forgetPassword(confirmEmailController.text);
                  Navigator.pop(context);
                },
                child: Container(
                  width: 130,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(color: colorPrimary),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.email,
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
              ),
            ],
          );
        });
  }

  Widget _buildLanguageBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(image: logo, fit: BoxFit.fitHeight),
        ),
      ),
    );
  }

  Widget _languageButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildLanguageBtn(
          () => languageController.setLanguage(LanguageTheme.KHMER),
          const AssetImage(
            'assets/images/flag-khmer.png',
          ),
        ),
        const SizedBox(width: 30),
        _buildLanguageBtn(
          () => languageController.setLanguage(LanguageTheme.ENGLISH),
          const AssetImage(
            'assets/images/flag-english.png',
          ),
        ),
      ],
    );
  }

  Widget _email() {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              languageThemeData[languageController.languageTheme]['Email'],
            ),
            const SizedBox(height: 10.0),
            Container(
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(width: 0.3)),
              height: 60.0,
              child: TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily:
                        languageThemeData[languageController.languageTheme]
                            ['FontSecondary']),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(top: 10),
                  prefixIcon: const Icon(
                    Icons.email,
                    color: Colors.black,
                  ),
                  hintText: languageThemeData[languageController.languageTheme]
                      ['Email'],
                  hintStyle: TextStyle(
                      fontSize: 14,
                      fontFamily:
                          languageThemeData[languageController.languageTheme]
                              ['FontSecondary']),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _password() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          languageThemeData[languageController.languageTheme]['Password'],
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              border: Border.all(width: 0.3)),
          height: 60.0,
          child: TextField(
            controller: passwordController,
            obscureText: true,
            style: const TextStyle(
              color: Colors.black,
              // fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 10),
              prefixIcon: const Icon(
                Icons.lock,
                color: Colors.black,
              ),
              hintText: '*********',
              hintStyle: TextStyle(
                  fontSize: 14,
                  fontFamily:
                      languageThemeData[languageController.languageTheme]
                          ['FontSecondary']),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: MaterialButton(
        onPressed: () => showPopUpConfirmForgetPassword(context),
        padding: const EdgeInsets.only(right: 0.0),
        child: Text(
          languageThemeData[languageController.languageTheme]['ForgetPassword'],
          style: TextStyle(color: colorPrimary, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _loginButton() {
    return GestureDetector(
      onTap: () async {
        setState(() {
          isLogining = true;
        });
        dynamic result = await _auth.signInWithEmailAndPassword(
            emailController.text, passwordController.text);
        if (result == null) {
          Message(context: context).showErrorMessage(
              languageThemeData[languageController.languageTheme]
                  ['InformationTitle'],
              languageThemeData[languageController.languageTheme]['LoginFail']);
          setState(() {
            isLogining = false;
          });
        } else {
          setState(() {
            isLogining = false;
          });

        }
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: colorPrimary),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isLogining
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
            const SizedBox(
              width: 5,
            ),
            Text(
              languageThemeData[languageController.languageTheme]['Login'],
              style: TextStyle(
                  color: Colors.white,
                  fontFamily:
                      languageThemeData[languageController.languageTheme]
                          ['FontSecondary']),
            ),
            const SizedBox(
              width: 5,
            )
          ],
        ),
      ),
    );
  }

  Widget loginForm() {
    return Container(
        width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    padding: const EdgeInsets.all(50),
    decoration: const BoxDecoration(color: Colors.white),
    child: Center(
      // width: 600,
      // margin: const EdgeInsets.all(50),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              languageThemeData[languageController.languageTheme]['AppTitle']
                  .toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontFamily: languageThemeData[languageController.languageTheme]
                ['FontSecondary'],
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30.0),
            _email(),
            const SizedBox(
              height: 30.0,
            ),
            _password(),
            const SizedBox(
              height: 10,
            ),
            _buildForgotPasswordBtn(),
            const SizedBox(
              height: 30.0,
            ),
            _loginButton(),
            const SizedBox(
              height: 30.0,
            ),
            _languageButtons(),
          ],
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;
    //print(sizeWidth);

    return GetBuilder<LanguageController>(
        builder: (_) => Scaffold(
              body: AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.light,
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: BoxDecoration(color: colorPrimary
                            ),
                      ),
                      sizeWidth > 600 ? Row(
                        children: [
                          Expanded(
                            flex: sizeWidth < 1400 ? 1 : 2,
                            child: Center(
                              child: Icon(Icons.menu_book,
                              color: Colors.black.withOpacity(0.1),
                              size: 200,),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                              child: loginForm())
                        ],
                      ) : loginForm()
                    ],
                  ),
                ),
              ),
            ));
  }
}
