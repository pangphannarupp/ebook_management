// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:notification_management/commons/constants/colors.dart';
import 'package:notification_management/commons/constants/strings.dart';
import 'package:notification_management/commons/controllers/language_controller.dart';
import 'package:notification_management/commons/message.dart';
import 'package:notification_management/commons/theme/language.dart';
import 'package:notification_management/commons/utils/util.dart';
import 'package:notification_management/domain/entities/application.dart';
import 'package:notification_management/domain/entities/category.dart';
import 'package:notification_management/domain/entities/user.dart';
import 'package:notification_management/services/database.dart';
import 'package:provider/provider.dart';

class DesktopApplicationScreen extends StatefulWidget {
  const DesktopApplicationScreen({Key key}) : super(key: key);

  @override
  _DesktopApplicationScreenState createState() => _DesktopApplicationScreenState();
}

class _DesktopApplicationScreenState extends State<DesktopApplicationScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserApp>(context);

    return StreamProvider<List<Application>>.value(
        value: DatabaseService(uid: user.uid).applications,
        initialData: const [],
        child: StreamProvider<List<Category>>.value(
          value: DatabaseService(uid: user.uid).categories,
          initialData: const [],
          child: const Scaffold(
            body: Content(),
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

  List<List<String>> tempData = <List<String>>[];

  List<Application> applicationList = <Application>[];
  List<Category> categoryList = <Category>[];
  List<Category> tempCategoryList = <Category>[];
  bool isUpdate = false;
  Application tempApplication;
  int tempId = 0;
  File uploadImage;
  String mainPathOfFile = STRING_DATABASE_NAME + '/'+STRING_COLLECTION_APPLICATION+'/';

  final languageController = Get.put(LanguageController());

  String tempDescription = '';

  TextEditingController searchController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  TextEditingController newUrlController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  TextEditingController oneSignalAppIdController = TextEditingController();
  TextEditingController restApiKeyController = TextEditingController();
  String valueChooseStatus;
  String valueChooseCategory;

  Future<void> _pickImage() async {
    File imageFile = await ImagePickerWeb.getImage(outputType: ImageType.file);

    if (imageFile != null) {
      setState(() {
        uploadImage = imageFile;
      });

      Navigator.pop(context);
      showPopUpUpdateData(
          context,
          languageThemeData[languageController.languageTheme]
              [isUpdate ? 'Edit' : 'Add'],
          isUpdate,
          tempApplication,
          tempId);
    }
  }

  void showPopUpUpdateData(BuildContext context, String popupTitle,
      bool isUpdateData, Application application, int id) {

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
                            items: [languageThemeData[languageController
                                .languageTheme]['True'],
                              languageThemeData[languageController
                                  .languageTheme]['False']].map((String status) {
                              return DropdownMenuItem<String>(
                                value: status.contains(languageThemeData[languageController
                                    .languageTheme]['True']) ? 'True' : 'False',
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
                              Navigator.pop(context);
                              showPopUpUpdateData(
                                  context, popupTitle, isUpdateData, application, id);
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
                          ['MenuCategory'],
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
                            value: valueChooseCategory,
                            style: TextStyle(
                                fontFamily: languageThemeData[languageController
                                    .languageTheme]['FontSecondary']),
                            items: categoryList.map((Category category) {
                              return DropdownMenuItem<String>(
                                value: category.id.toString(),
                                child: SizedBox(
                                  width: (600 - 40).floorToDouble(),
                                  child: Text(
                                    category.title,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String val) {
                              setState(() {
                                valueChooseCategory = val;
                              });
                              Navigator.pop(context);
                              showPopUpUpdateData(
                                  context, popupTitle, isUpdateData, application, id);
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
                                  fontFamily: languageThemeData[
                                          languageController.languageTheme]
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
                          languageThemeData[languageController.languageTheme]
                          ['Url'],
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
                            controller: urlController,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: languageThemeData[languageController
                                    .languageTheme]['FontSecondary']),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'https://www.example.com/',
                              hintStyle: TextStyle(
                                  fontFamily: languageThemeData[
                                  languageController.languageTheme]
                                  ['FontSecondary']),
                            ),
                          ),
                        ),
                      ],
                    ),
                    valueChooseStatus != null && valueChooseStatus == 'False' ? const SizedBox(
                      height: 20,
                    ) : const SizedBox(),
                    valueChooseStatus != null && valueChooseStatus == 'False' ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          languageThemeData[languageController.languageTheme]
                          ['NewUrl'],
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
                            controller: newUrlController,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: languageThemeData[languageController
                                    .languageTheme]['FontSecondary']),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'https://www.example.com/',
                              hintStyle: TextStyle(
                                  fontFamily: languageThemeData[
                                  languageController.languageTheme]
                                  ['FontSecondary']),
                            ),
                          ),
                        ),
                      ],
                    ) : const SizedBox(),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          languageThemeData[languageController.languageTheme]
                          ['Message'],
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
                            controller: messageController,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: languageThemeData[languageController
                                    .languageTheme]['FontSecondary']),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: languageThemeData[languageController.languageTheme]
                              ['Message'],
                              hintStyle: TextStyle(
                                  fontFamily: languageThemeData[
                                  languageController.languageTheme]
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
                          languageThemeData[languageController.languageTheme]
                          ['OneSignalAppId'],
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
                            controller: oneSignalAppIdController,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: languageThemeData[languageController
                                    .languageTheme]['FontSecondary']),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'ecfe7efc-221b-4b9e-9ddf-1abf08f370dc',
                              hintStyle: TextStyle(
                                  fontFamily: languageThemeData[
                                  languageController.languageTheme]
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
                          languageThemeData[languageController.languageTheme]
                          ['RestApiKey'],
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
                            controller: restApiKeyController,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: languageThemeData[languageController
                                    .languageTheme]['FontSecondary']),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'ZWE0OWQ4ZDMtNDJiYi00NjA5LWFhOTktMTY3MjBjMmI4OTFm',
                              hintStyle: TextStyle(
                                  fontFamily: languageThemeData[
                                  languageController.languageTheme]
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        application != null
                            ? SizedBox(
                                width: 550,
                                height: 200,
                                child: FutureBuilder(
                                  future: DatabaseService(uid: uid)
                                      .getFile(mainPathOfFile + application.image),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.waiting:
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      default:
                                        if (snapshot.hasError) {
                                          return const Center(
                                            child:
                                                CircularProgressIndicator(),
                                          );
                                        } else {
                                          return Container(
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    // image: AssetImage(
                                                    //     'assets/images/icon.png'),
                                                    image: NetworkImage(
                                                        snapshot.data),
                                                    fit: BoxFit.contain)),
                                          );
                                        }
                                    }
                                  },
                                ),
                              )
                            : Container(),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            _pickImage();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.upload_rounded,
                                  color: Colors.black,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  languageThemeData[languageController
                                      .languageTheme]['UploadImage'],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: languageThemeData[
                                              languageController.languageTheme]
                                          ['FontSecondary']),
                                ),
                                const SizedBox(
                                  width: 5,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  clearAllText();
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
                  if(valueChooseStatus == null || valueChooseStatus == 'True') {
                    newUrlController.text = 'N/A';
                  }

                  // Confirm Valid
                  if(!isUpdateData) {
                    if(valueChooseStatus == '' || valueChooseCategory == '' ||
                        titleController.text == '' || urlController.text == '' ||
                        newUrlController.text == '' || messageController.text == '' ||
                        oneSignalAppIdController.text == '' || restApiKeyController.text == '' ||
                        uploadImage == null) {
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
                  } else {
                    if(valueChooseStatus == '' || valueChooseCategory == '' ||
                        titleController.text == '' || urlController.text == '' ||
                        newUrlController.text == '' || messageController.text == '' ||
                        oneSignalAppIdController.text == '' || restApiKeyController.text == '') {
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
                  }

                  String imageName = application != null ? application.image : '';
                  if (uploadImage != null && isUpdateData) {
                    await DatabaseService(uid: uid)
                        .deleteFile(mainPathOfFile + imageName);
                  }
                  if (uploadImage != null) {
                    String extension = uploadImage.name.substring(
                        uploadImage.name.lastIndexOf('.'),
                        uploadImage.name.length);
                    imageName = id.toString() + extension;
                    await DatabaseService(uid: uid)
                        .uploadFile(uploadImage, mainPathOfFile + imageName);
                  }

                  await DatabaseService(uid: uid).updateApplicationData(
                    Application(
                      id: id,
                      status: valueChooseStatus == 'True',
                      categoryId: int.parse(valueChooseCategory),
                      title: titleController.text,
                      message: messageController.text,
                      url: urlController.text,
                      newUrl: newUrlController.text,
                      oneSignalAppId: oneSignalAppIdController.text,
                      restApiKey: restApiKeyController.text,
                      image: imageName,
                      view: application != null ? application.view : 0,
                      click: application != null ? application.click : 0,
                      isSpecial: application != null ? application.isSpecial : false,
                      createTimestamp: application != null ? application.createTimestamp : id,
                      updateTimestamp: -1 * DateTime.now().millisecondsSinceEpoch,
                    )
                  );

                  clearAllText();
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
          );
        });
  }

  void clearAllText() {
    setState(() {
      valueChooseStatus = null;
      valueChooseCategory = null;
      titleController.clear();
      urlController.clear();
      newUrlController.clear();
      messageController.clear();
      oneSignalAppIdController.clear();
      restApiKeyController.clear();
      uploadImage = null;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserApp>(context);
    setState(() {
      uid = user.uid;
    });
    // Only Categories are similar to AppId that user choose
    categoryList = Provider.of<List<Category>>(context) ?? [];
    categoryList.sort((a, b) => a.title.compareTo(b.title));
    // For Search
    List<Application> data = Provider.of<List<Application>>(context) ?? [];
    applicationList.clear();
    if (data.isNotEmpty) {
      for (int i = 0; i < data.length; i++) {
        if (data[i].title.toLowerCase().contains(search.toLowerCase()) ||
            data[i].url.toLowerCase().contains(search.toLowerCase()) ||
            data[i].newUrl.toLowerCase().contains(search.toLowerCase())) {
          applicationList.add(data[i]);
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
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isUpdate = false;
                          tempApplication = null;
                          tempId =
                              -1 * DateTime.now().millisecondsSinceEpoch;
                        });
                        showPopUpUpdateData(
                            context,
                            languageThemeData[
                                    languageController.languageTheme]
                                [isUpdate ? 'Edit' : 'Add'],
                            isUpdate,
                            tempApplication,
                            tempId);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(color: colorPrimary),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              languageThemeData[languageController
                                  .languageTheme]['Add'],
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
                    MediaQuery.of(context).size.width <= 650 ? const SizedBox(width: 10,) : const Spacer(),
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
                                contentPadding: MediaQuery.of(context).size.width <= 650 ? const EdgeInsets.fromLTRB(
                                    10, 10, 10, 10) :
                                const EdgeInsets.fromLTRB(
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
                    childAspectRatio: 500 / 450,
                    crossAxisCount:
                        (MediaQuery.of(context).size.width / 350)
                            .round()),
                itemCount: applicationList.length,
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
                        FutureBuilder(
                          future: DatabaseService(uid: uid).getFile(
                              mainPathOfFile + applicationList[index].image),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return Container(
                                  margin: const EdgeInsets.only(
                                      bottom: 60, top: 50),
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              default:
                                if (snapshot.hasError) {
                                  return Container(
                                    margin: const EdgeInsets.only(
                                        bottom: 60, top: 50),
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                } else {
                                  tempData.add([applicationList[index].id.toString(), snapshot.data]);
                                  return Container(
                                    margin: const EdgeInsets.only(
                                        bottom: 60, top: 50),
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                snapshot.data),
                                            fit: BoxFit.contain)),
                                  );
                                }
                            }
                          },
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 60, right: 10),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration:
                                  const BoxDecoration(color: Colors.blueGrey),
                              child: Text(
                                Util.numberFormat(applicationList[index].view) +
                                    ' ' +
                                    (applicationList[index].view > 1
                                        ? 'views'
                                        : 'view') + ' / ' + Util.numberFormat(applicationList[index].click) +
                                        ' ' +
                                        (applicationList[index].click > 1
                                            ? 'clicks'
                                            : 'click'),
                                textAlign: TextAlign.center,
                                maxLines: 1,
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
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.all(10),
                              decoration:
                                  BoxDecoration(color: !applicationList[index].status ? Colors.redAccent : (applicationList[index].isSpecial ? Colors.lightGreen : colorPrimary)),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      applicationList[index].title,
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
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
                                  GestureDetector(
                                    onTap: () async {
                                      await DatabaseService(uid: uid)
                                          .updateApplicationData(
                                        Application(
                                          id: applicationList[index].id,
                                          status: applicationList[index].status,
                                          categoryId: applicationList[index].categoryId,
                                          title: applicationList[index].title,
                                          message: applicationList[index].message,
                                          url: applicationList[index].url,
                                          newUrl: applicationList[index].newUrl,
                                          oneSignalAppId: applicationList[index].oneSignalAppId,
                                          restApiKey: applicationList[index].restApiKey,
                                          image: applicationList[index].image,
                                          view: applicationList[index].view,
                                          click: applicationList[index].click,
                                          isSpecial: applicationList[index].isSpecial ? false : true,
                                          createTimestamp: applicationList[index].createTimestamp,
                                          updateTimestamp: -1 * DateTime.now().millisecondsSinceEpoch,
                                        )
                                      );
                                    },
                                    child: Icon(
                                      applicationList[index].isSpecial
                                          ? Icons.toggle_on
                                          : Icons.toggle_off,
                                      color: applicationList[index].isSpecial
                                          ? Colors.green
                                          : colorSecondary,
                                      size: 30,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      await DatabaseService(uid: uid)
                                          .updateApplicationData(
                                          Application(
                                            id: applicationList[index].id,
                                            status: applicationList[index].status ? false : true,
                                            categoryId: applicationList[index].categoryId,
                                            title: applicationList[index].title,
                                            message: applicationList[index].message,
                                            url: applicationList[index].url,
                                            newUrl: applicationList[index].newUrl,
                                            oneSignalAppId: applicationList[index].oneSignalAppId,
                                            restApiKey: applicationList[index].restApiKey,
                                            image: applicationList[index].image,
                                            view: applicationList[index].view,
                                            click: applicationList[index].click,
                                            isSpecial: applicationList[index].isSpecial,
                                            createTimestamp: applicationList[index].createTimestamp,
                                            updateTimestamp: -1 * DateTime.now().millisecondsSinceEpoch,
                                          )
                                      );
                                    },
                                    child: Icon(
                                      applicationList[index].status
                                          ? Icons.radio_button_on
                                          : Icons.radio_button_off,
                                      color: applicationList[index].status
                                          ? Colors.green
                                          : colorSecondary,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      await DatabaseService(uid: uid)
                                          .updateApplicationData(
                                          Application(
                                            id: applicationList[index].id,
                                            status: applicationList[index].status,
                                            categoryId: applicationList[index].categoryId,
                                            title: applicationList[index].title,
                                            message: applicationList[index].message,
                                            url: applicationList[index].url,
                                            newUrl: applicationList[index].newUrl,
                                            oneSignalAppId: applicationList[index].oneSignalAppId,
                                            restApiKey: applicationList[index].restApiKey,
                                            image: applicationList[index].image,
                                            view: applicationList[index].view,
                                            click: applicationList[index].click,
                                            isSpecial: applicationList[index].isSpecial,
                                            createTimestamp: applicationList[index].createTimestamp,
                                            updateTimestamp: -1 * DateTime.now().millisecondsSinceEpoch,
                                          )
                                      );
                                    },
                                    child: const Icon(
                                      Icons.update,
                                      color: Colors.green,
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
                                      for(int i = 0; i < tempData.length; i++) {
                                        if(tempData[i][0].contains(applicationList[index].id.toString())) {
                                          // print(tempData[i][0]);
                                          // print(tempData[i][1]);
                                          i = tempData.length;
                                        }
                                      }

                                      setState(() {
                                        isUpdate = true;
                                        tempId = applicationList[index].id;
                                        valueChooseStatus =
                                            applicationList[index].status ? 'True' : 'False';
                                        titleController.text =
                                            applicationList[index].title;
                                        urlController.text =
                                            applicationList[index].url;
                                        newUrlController.text =
                                            applicationList[index].newUrl;
                                        messageController.text =
                                            applicationList[index].message;
                                        oneSignalAppIdController.text =
                                            applicationList[index].oneSignalAppId;
                                        restApiKeyController.text =
                                            applicationList[index].restApiKey;
                                        tempApplication = applicationList[index];
                                        // valueChooseCategory =
                                        //     applicationList[index].categoryId.toString();
                                        valueChooseCategory = null;
                                        for(int i = 0; i < categoryList.length; i++) {
                                          if(categoryList[i].id == applicationList[index].categoryId) {
                                            valueChooseCategory = applicationList[index].categoryId.toString();
                                            i = applicationList.length;
                                          }
                                        }
                                      });
                                      showPopUpUpdateData(
                                          context,
                                          languageThemeData[
                                                  languageController
                                                      .languageTheme]
                                              [isUpdate ? 'Edit' : 'Add'],
                                          isUpdate,
                                          tempApplication,
                                          tempId);
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
                                            Icons.edit,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            languageThemeData[
                                                    languageController
                                                        .languageTheme]
                                                ['Edit'],
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
                                                  'DeleteAppDescription'],
                                              () async {
                                        await DatabaseService(uid: uid)
                                            .deleteFile(mainPathOfFile +
                                            applicationList[index].image);
                                        await DatabaseService(uid: uid)
                                            .deleteApplicationData(
                                            applicationList[index].id);
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
                                  ))
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
