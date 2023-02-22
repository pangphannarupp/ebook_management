import 'package:flutter/material.dart';
import 'package:notification_management/screens/desktop/desktop_master_screen.dart';
import 'package:notification_management/screens/mobile/mobile_master_screen.dart';
import 'package:responsive_builder/responsive_builder.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, size) {
        if (size.deviceScreenType == DeviceScreenType.desktop) {
          return const DesktopMasterScreen();
        } else if (size.deviceScreenType == DeviceScreenType.tablet) {
          return const MobileMasterScreen();
        } else {
          return const MobileMasterScreen();
        }
      },
    );
  }
}
