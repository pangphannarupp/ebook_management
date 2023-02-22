import 'package:flutter/material.dart';
import 'package:notification_management/commons/theme/language.dart';
import 'package:notification_management/domain/entities/menu.dart';
// import 'package:notification_management/screens/desktop/desktop_application_screen.dart';
import 'package:notification_management/screens/desktop/desktop_category_screen.dart';
import 'package:notification_management/screens/desktop/desktop_dashboard_screen.dart';
import 'package:notification_management/screens/desktop/desktop_application_screen.dart';
import 'package:notification_management/screens/desktop/desktop_history_screen.dart';
import 'package:notification_management/screens/desktop/desktop_notification_screen.dart';
import 'package:notification_management/screens/desktop/desktop_setting_screen.dart';
import 'package:notification_management/screens/desktop/desktop_user_screen.dart';

var dataMenu = {
  LanguageTheme.ENGLISH: [
    Menu(
        id: 1,
        icon: Icons.dashboard,
        title: languageThemeData[LanguageTheme.ENGLISH]['MenuDashBoard'],
        content: const DesktopDashBoardScreen(),
    ),
    Menu(
        id: 1,
        icon: Icons.vibration,
        title: languageThemeData[LanguageTheme.ENGLISH]['MenuCategory'],
        content: const DesktopCategoryScreen(),
    ),
    Menu(
        id: 1,
        icon: Icons.phone_android,
        title: languageThemeData[LanguageTheme.ENGLISH]['MenuApplication'],
        content: const DesktopApplicationScreen(),
    ),
    Menu(
      id: 1,
      icon: Icons.history,
      title: languageThemeData[LanguageTheme.ENGLISH]['MenuHistory'],
      content: const DesktopHistoryScreen(),
    ),
    Menu(
        id: 1,
        icon: Icons.notifications,
        title: languageThemeData[LanguageTheme.ENGLISH]['MenuSendNotification'],
        content: const DesktopNotificationScreen(),
    ),
    Menu(
        id: 1,
        icon: Icons.person_add,
        title: languageThemeData[LanguageTheme.ENGLISH]['MenuUser'],
        content: const DesktopUserScreen(),
    ),
    Menu(
        id: 1,
        icon: Icons.settings,
        title: languageThemeData[LanguageTheme.ENGLISH]['MenuSetting'],
        content: const DesktopSettingScreen(),
    ),
  ],
  LanguageTheme.KHMER: [
    Menu(
        id: 1,
        icon: Icons.dashboard,
        title: languageThemeData[LanguageTheme.KHMER]['MenuDashBoard'],
        content: const DesktopDashBoardScreen(),
    ),
    Menu(
        id: 1,
        icon: Icons.vibration,
        title: languageThemeData[LanguageTheme.KHMER]['MenuCategory'],
        content: const DesktopCategoryScreen(),
    ),
    Menu(
        id: 1,
        icon: Icons.phone_android,
        title: languageThemeData[LanguageTheme.KHMER]['MenuApplication'],
        content: const DesktopApplicationScreen(),
    ),
    Menu(
      id: 1,
      icon: Icons.history,
      title: languageThemeData[LanguageTheme.KHMER]['MenuHistory'],
      content: const DesktopHistoryScreen(),
    ),
    Menu(
        id: 1,
        icon: Icons.notifications,
        title: languageThemeData[LanguageTheme.KHMER]['MenuSendNotification'],
        content: const DesktopNotificationScreen(),
    ),
    Menu(
        id: 1,
        icon: Icons.person_add,
        title: languageThemeData[LanguageTheme.KHMER]['MenuUser'],
        content: const DesktopUserScreen(),
    ),
    Menu(
        id: 1,
        icon: Icons.settings,
        title: languageThemeData[LanguageTheme.KHMER]['MenuSetting'],
        content: const DesktopSettingScreen(),
    ),
  ],
};