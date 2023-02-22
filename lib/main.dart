import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:html_editor_enhanced/html_editor.dart';
// import 'package:html_editor_enhanced/utils/callbacks.dart';
// import 'package:html_editor_enhanced/utils/options.dart';
import 'package:provider/provider.dart';
import 'package:notification_management/screens/login_screen.dart';
import 'package:notification_management/screens/main_screen.dart';
import 'package:notification_management/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'commons/constants/strings.dart';
import 'commons/controllers/user_controller.dart';
import 'domain/entities/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserApp>.value(
      value: AuthService().userApp,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: STRING_APP_NAME,
        theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: 'Siemreap'
        ),
        home: const Wrapper(),
      ),
    );
  }
}

class Wrapper extends StatefulWidget {
  const Wrapper({Key key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  final userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserApp>(context);
    print(user);
    if(user != null) {
      userController.setEmail(user.email);
    }

    // return either the Home or Authenticate widget
    if (user == null){
      return LoginScreen();
    } else {
      return MainScreen();
    }

  }
}