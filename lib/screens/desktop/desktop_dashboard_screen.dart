import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notification_management/commons/constants/colors.dart';
import 'package:notification_management/commons/constants/data_menu.dart';
import 'package:notification_management/commons/controllers/language_controller.dart';
import 'package:notification_management/commons/controllers/menu_controller.dart';
import 'package:notification_management/commons/controllers/user_controller.dart';
import 'package:notification_management/commons/theme/language.dart';
import 'package:notification_management/commons/utils/util.dart';
import 'package:notification_management/domain/entities/application.dart';
import 'package:notification_management/domain/entities/category.dart';
import 'package:notification_management/domain/entities/history.dart';
import 'package:notification_management/domain/entities/user.dart';
import 'package:notification_management/services/database.dart';
import 'package:provider/provider.dart';
// import 'package:charts_flutter/flutter.dart' as charts;

class DesktopDashBoardScreen extends StatefulWidget {
  const DesktopDashBoardScreen({Key key}) : super(key: key);

  @override
  _DesktopDashBoardScreenState createState() => _DesktopDashBoardScreenState();
}

class _DesktopDashBoardScreenState extends State<DesktopDashBoardScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserApp>(context);

    return StreamProvider<List<Category>>.value(
      value: DatabaseService(uid: user.uid).categories,
      initialData: const [],
      child: StreamProvider<List<Application>>.value(
        value: DatabaseService(uid: user.uid).applications,
        initialData: const [],
        child: StreamProvider<List<History>>.value(
          value: DatabaseService(uid: user.uid).histories,
          initialData: const [],
          child: const Scaffold(
            body: Content(),
          ),
        ),
      ),
    );
  }
}

class Content extends StatefulWidget {
  const Content({Key key}) : super(key: key);

  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content> {
  final languageController = Get.put(LanguageController());
  final menuController = Get.put(MenuController());
  final userController = Get.put(UserController());
  List<Category> categoryList;
  List<Application> applicationList;
  List<History> historyList;
  List<Application> dataChartBar = <Application>[];
  List<Application> dataTopViewMoveChartBar = <Application>[];

  int countAppActive = 0;

  // getLatestMovieSeriesData(List<Application> data) {
  //   List<charts.Series<Application, String>> series = [
  //     charts.Series(
  //         id: 'Recently Added',
  //         displayName: 'Recently Added',
  //         data: data,
  //         domainFn: (Application movie, _) => movie.title.substring(0, movie.title.length > 10 ? 10 : movie.title.length) + (movie.title.length > 10 ? '...' : ''),
  //         measureFn: (Application movie, _) => movie.click,
  //         colorFn: (Application movie, _) => const charts.Color(r: 0, g: 90, b: 135)
  //     )
  //   ];
  //   return series;
  // }
  //
  // getTopMovieSeriesData(List<Application> data) {
  //   List<charts.Series<Application, String>> series = [
  //     charts.Series(
  //         id: 'Recently Added',
  //         displayName: 'Recently Added',
  //         data: data,
  //         domainFn: (Application movie, _) => movie.title.substring(0, movie.title.length > 10 ? 10 : movie.title.length) + (movie.title.length > 10 ? '...' : ''),
  //         measureFn: (Application movie, _) => movie.view,
  //         colorFn: (Application movie, _) => const charts.Color(r: 0, g: 90, b: 135)
  //     )
  //   ];
  //   return series;
  // }

  @override
  Widget build(BuildContext context) {
    categoryList = Provider.of<List<Category>>(context) ?? [];
    applicationList = Provider.of<List<Application>>(context) ?? [];
    historyList = Provider.of<List<History>>(context) ?? [];

    if(dataTopViewMoveChartBar.isEmpty) {
      dataChartBar.clear();
      applicationList.sort((a, b) => b.click.compareTo(a.click));
      for(int i = 0; i < applicationList.length && i < 5; i++) {
        dataChartBar.add(applicationList[i]);
      }

      dataTopViewMoveChartBar.clear();
      applicationList.sort((a, b) => b.view.compareTo(a.view));
      for(int i = 0; i < applicationList.length && i < 5; i++) {
        dataTopViewMoveChartBar.add(applicationList[i]);
      }
    }

    countAppActive = 0;
    for(int i = 0; i < applicationList.length; i++) {
      if(applicationList[i].status) {
        countAppActive++;
      }
    }

    return GetBuilder<LanguageController>(
        builder: (_) => GetBuilder<UserController>(
            builder: (_) => Container(
                  margin: const EdgeInsets.only(top: 0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // MediaQuery.of(context).size.width > 700 ? applicationList.isNotEmpty ? Row(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Expanded(
                        //       child: Container(
                        //         padding: const EdgeInsets.all(10),
                        //         decoration: const BoxDecoration(
                        //           color: Colors.white,
                        //           boxShadow: [
                        //             BoxShadow(
                        //               color: Colors.black12,
                        //               blurRadius: 6.0,
                        //               offset: Offset(0, 2),
                        //             ),
                        //           ],
                        //         ),
                        //         child: Column(
                        //         children: [
                        //           Text(
                        //               languageThemeData[languageController
                        //                   .languageTheme]['ChartBarTitleTopView'],
                        //             style: TextStyle(
                        //               fontSize: 20,
                        //               fontFamily: languageThemeData[
                        //               languageController
                        //                   .languageTheme]
                        //               ['FontSecondary'],
                        //               fontWeight: FontWeight.bold,
                        //             ),
                        //           ),
                        //           Container(
                        //             height: 400,
                        //             child: charts.BarChart(
                        //               getTopMovieSeriesData(dataTopViewMoveChartBar),
                        //               animate: true,
                        //               domainAxis: const charts.OrdinalAxisSpec(
                        //                   renderSpec: charts.SmallTickRendererSpec(labelRotation: 0)
                        //               ),
                        //             ),
                        //           )
                        //         ],
                        //       )),
                        //     ),
                        //     const SizedBox(width: 10,),
                        //     Expanded(
                        //       child: Container(
                        //         padding: const EdgeInsets.all(10),
                        //         decoration: const BoxDecoration(
                        //           color: Colors.white,
                        //           boxShadow: [
                        //             BoxShadow(
                        //               color: Colors.black12,
                        //               blurRadius: 6.0,
                        //               offset: Offset(0, 2),
                        //             ),
                        //           ],
                        //         ),
                        //         child: Column(
                        //         children: [
                        //           Text(
                        //               languageThemeData[languageController
                        //                   .languageTheme]['ChartBarTitleLatest'],
                        //             style: TextStyle(
                        //               fontSize: 20,
                        //               fontFamily: languageThemeData[
                        //               languageController
                        //                   .languageTheme]
                        //               ['FontSecondary'],
                        //               fontWeight: FontWeight.bold,
                        //             ),
                        //           ),
                        //           Container(
                        //             height: 400,
                        //             child: charts.BarChart(
                        //               getLatestMovieSeriesData(dataChartBar),
                        //               animate: true,
                        //               domainAxis: const charts.OrdinalAxisSpec(
                        //                   renderSpec: charts.SmallTickRendererSpec(labelRotation: 0)
                        //               ),
                        //             ),
                        //           )
                        //         ],
                        //       )),
                        //     ),
                        //     // Expanded(child: Text('Chart'))
                        //   ],
                        // ) : const SizedBox() : const SizedBox(),
                        // MediaQuery.of(context).size.width <= 700 ? Container(
                        //     padding: const EdgeInsets.all(10),
                        //     decoration: const BoxDecoration(
                        //       color: Colors.white,
                        //       boxShadow: [
                        //         BoxShadow(
                        //           color: Colors.black12,
                        //           blurRadius: 6.0,
                        //           offset: Offset(0, 2),
                        //         ),
                        //       ],
                        //     ),
                        //     child: Column(
                        //       children: [
                        //         Text(
                        //           languageThemeData[languageController
                        //               .languageTheme]['ChartBarTitleTopView'],
                        //           style: TextStyle(
                        //             fontSize: 20,
                        //             fontFamily: languageThemeData[
                        //             languageController
                        //                 .languageTheme]
                        //             ['FontSecondary'],
                        //             fontWeight: FontWeight.bold,
                        //           ),
                        //         ),
                        //         Container(
                        //           height: 400,
                        //           child: charts.BarChart(
                        //             getTopMovieSeriesData(dataTopViewMoveChartBar),
                        //             animate: true,
                        //             domainAxis: const charts.OrdinalAxisSpec(
                        //                 renderSpec: charts.SmallTickRendererSpec(labelRotation: 0)
                        //             ),
                        //           ),
                        //         )
                        //       ],
                        //     )) : const SizedBox(),
                        // MediaQuery.of(context).size.width <= 700 ? const SizedBox(height: 10,) : const SizedBox(),
                        // MediaQuery.of(context).size.width <= 700 ? Container(
                        //     padding: const EdgeInsets.all(10),
                        //     decoration: const BoxDecoration(
                        //       color: Colors.white,
                        //       boxShadow: [
                        //         BoxShadow(
                        //           color: Colors.black12,
                        //           blurRadius: 6.0,
                        //           offset: Offset(0, 2),
                        //         ),
                        //       ],
                        //     ),
                        //     child: Column(
                        //       children: [
                        //         Text(
                        //           languageThemeData[languageController
                        //               .languageTheme]['ChartBarTitleLatest'],
                        //           style: TextStyle(
                        //             fontSize: 20,
                        //             fontFamily: languageThemeData[
                        //             languageController
                        //                 .languageTheme]
                        //             ['FontSecondary'],
                        //             fontWeight: FontWeight.bold,
                        //           ),
                        //         ),
                        //         Container(
                        //           height: 400,
                        //           child: charts.BarChart(
                        //             getLatestMovieSeriesData(dataChartBar),
                        //             animate: true,
                        //             domainAxis: const charts.OrdinalAxisSpec(
                        //                 renderSpec: charts.SmallTickRendererSpec(labelRotation: 0)
                        //             ),
                        //           ),
                        //         )
                        //       ],
                        //     )) : const SizedBox(),
                        // MediaQuery.of(context).size.width <= 700 ? const SizedBox(height: 10,) : const SizedBox(),
                        // applicationList.isNotEmpty ? const SizedBox(height: 10,) : const SizedBox(),
                        GridView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 250 / 170,
                              crossAxisCount:
                              (MediaQuery.of(context).size.width / 300).round()),
                          itemCount: dataMenu[LanguageTheme.ENGLISH].length - 1,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                  menuController.setIndex(index + 1);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: colorPrimary,
                                  boxShadow: const [
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
                                      margin: const EdgeInsets.only(bottom: 60),
                                      padding: const EdgeInsets.all(10),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Icon(
                                          dataMenu[LanguageTheme.ENGLISH]
                                          [index + 1]
                                              .icon,
                                          size: 100,
                                          color: Colors.black.withOpacity(0.1),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 40),
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            dataMenu[languageController
                                                .languageTheme][index + 1]
                                                .title,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontFamily: languageThemeData[
                                                languageController
                                                    .languageTheme]
                                                ['FontSecondary']),
                                          ),
                                          Text(
                                            index + 1 == 1
                                                ? Util.numberFormat(categoryList.length)
                                                : (index + 1 == 2
                                                ? Util.numberFormat(countAppActive) + ' / ' + Util.numberFormat(applicationList.length)
                                                : (index + 1 == 3
                                                ? Util.numberFormat(historyList.length)
                                                : '')),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontFamily: languageThemeData[
                                                languageController
                                                    .languageTheme]
                                                ['FontSecondary']),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: SizedBox(
                                            height: 40,
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.1)),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.info,
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    languageThemeData[
                                                    languageController
                                                        .languageTheme]
                                                    ['MoreInformation'],
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
                                            )),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                )
        ));
  }
}
