// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:notification_management/commons/constants/colors.dart';
import 'package:notification_management/commons/constants/strings.dart';
import 'package:notification_management/commons/controllers/language_controller.dart';
import 'package:notification_management/commons/message.dart';
import 'package:notification_management/commons/theme/language.dart';
import 'package:notification_management/domain/entities/category.dart';
import 'package:notification_management/domain/entities/user.dart';
import 'package:notification_management/services/database.dart';
import 'package:provider/provider.dart';

class DesktopCategoryScreen extends StatefulWidget {
  const DesktopCategoryScreen({Key key}) : super(key: key);

  @override
  _DesktopCategoryScreenState createState() => _DesktopCategoryScreenState();
}

class _DesktopCategoryScreenState extends State<DesktopCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserApp>(context);

    return StreamProvider<List<Category>>.value(
        value: DatabaseService(uid: user.uid).categories,
        initialData: const [],
        child: const Scaffold(
          body: Content(),
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
  bool isUpdate = false;
  List<Category> categories = <Category>[];
  Category tempCategory;
  int tempId = 0;
  File uploadImage;
  String mainPathOfFile = STRING_DATABASE_NAME + '/'+STRING_COLLECTION_CATEGORY+'/';

  final languageController = Get.put(LanguageController());

  TextEditingController searchController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  Future<void> _pickImage() async {
    File imageFile = await ImagePickerWeb.getImage(outputType: ImageType.file);

    if (imageFile != null) {
      setState(() {
        uploadImage = imageFile;
      });

      Navigator.pop(context);
      showPopUpUpdateData(context, languageThemeData[languageController.languageTheme][isUpdate ? 'Edit': 'Add'], isUpdate, tempCategory, tempId);
    }
  }

  void showPopUpUpdateData(BuildContext context, String popupTitle, bool isUpdateData, Category category, int id) {
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        category != null ? SizedBox(
                          width: 300,
                          height: 300,
                          child: FutureBuilder(
                            future: DatabaseService(uid: uid).getFile(mainPathOfFile + category.image),
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
                                              image: NetworkImage(
                                                  snapshot.data),
                                              fit: BoxFit.fill)),
                                    );
                                  }
                              }
                            },
                          ),
                        ) : Container(),
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
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    titleController.clear();
                    uploadImage = null;
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
                onTap: () async {
                  String imageName = category != null ? category.image : '';
                  if(uploadImage != null && isUpdateData) {
                    await DatabaseService(uid: uid).deleteFile(mainPathOfFile + imageName);
                  }
                  if(uploadImage != null) {
                    String extension = uploadImage.name.substring(
                        uploadImage.name.lastIndexOf('.'),
                        uploadImage.name.length);
                    imageName = id.toString() + extension;
                    await DatabaseService(uid: uid).uploadFile(uploadImage, mainPathOfFile + imageName);
                  }

                  await DatabaseService(uid: uid).updateCategoryData(
                    Category(
                      id: id,
                      title: titleController.text,
                      image: imageName,
                      createTimestamp: category != null ? category.createTimestamp : id,
                      updateTimestamp: -1 * DateTime.now().millisecondsSinceEpoch,
                    ),
                  );
                  setState(() {
                    titleController.clear();
                    uploadImage = null;
                  });
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
    List<Category> data = Provider.of<List<Category>>(context) ?? [];
    categories.clear();
    if(data.isNotEmpty) {
      for(int i = 0; i < data.length; i++) {
        if(data[i].title.toLowerCase().contains(search.toLowerCase())) {
          categories.add(data[i]);
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
                          tempCategory = null;
                          tempId = -1 * DateTime.now().millisecondsSinceEpoch;
                        });
                        showPopUpUpdateData(context, languageThemeData[languageController.languageTheme][isUpdate ? 'Edit': 'Add'], isUpdate, tempCategory, tempId);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(color: colorPrimary),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.control_point_duplicate,
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
                                    decoration:
                                    BoxDecoration(color: colorPrimary),
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
                    childAspectRatio: 250 / 350,
                    crossAxisCount:
                        (MediaQuery.of(context).size.width / 300)
                            .round()),
                itemCount: categories.length,
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
                          future: DatabaseService(uid: uid).getFile(mainPathOfFile + categories[index].image),
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
                                      child:
                                      CircularProgressIndicator(),
                                    ),
                                  );
                                } else {
                                  return Container(
                                    margin: const EdgeInsets.only(
                                        bottom: 60, top: 50),
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                          // image: AssetImage(
                                          //     'assets/images/icon.png'),
                                            image: NetworkImage(
                                                snapshot.data),
                                            fit: BoxFit.fill)),
                                  );
                                }
                            }
                          },
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
                              BoxDecoration(color: colorPrimary),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      categories[index].title,
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
                                  const SizedBox(width: 5,),
                                  GestureDetector(
                                    onTap: () async {
                                      await DatabaseService(uid: uid)
                                          .updateCategoryData(
                                        Category(
                                          id: categories[index].id,
                                          title: categories[index].title,
                                          image: categories[index].image,
                                          createTimestamp: categories[index].createTimestamp,
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
                                      // print(categories[index].id);
                                      setState(() {
                                        isUpdate = true;
                                        tempId = categories[index].id;
                                        titleController.text = categories[index].title;
                                        tempCategory = categories[index];
                                      });
                                      showPopUpUpdateData(context, languageThemeData[languageController.languageTheme][isUpdate ? 'Edit': 'Add'], isUpdate, tempCategory, tempId);
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
                                      Message(context: context).showConfirmMessage(
                                          languageThemeData[languageController.languageTheme]
                                          ['InformationTitle'],
                                          languageThemeData[languageController.languageTheme]
                                          ['DeleteCategoryDescription'],
                                              () async {
                                            await DatabaseService(uid: uid).deleteFile(mainPathOfFile + categories[index].image);
                                            await DatabaseService(uid: uid).deleteCategoryData(categories[index].id);
                                          }
                                      );
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
