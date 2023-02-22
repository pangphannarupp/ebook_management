// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:notification_management/commons/constants/strings.dart';
import 'package:notification_management/domain/entities/application.dart';
import 'package:notification_management/domain/entities/category.dart';
import 'package:notification_management/domain/entities/setting.dart';
import 'package:notification_management/domain/entities/history.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  CollectionReference setFirebaseFirestoreCollection(String uid) {
    return FirebaseFirestore.instance.collection(uid);
  }

  Future<void> deleteFile(String filePath) async {
    final ref = FirebaseStorage.instance.ref().child(uid).child(filePath);
    await ref.delete();
  }

  Future<String> getFile(String filePath) async {
    final ref = FirebaseStorage.instance.ref().child(uid).child(filePath);
    return await ref.getDownloadURL();
  }

  Future<void> uploadFile(File file, String filePath) async {
    try {
      fb
          .storage()
          .refFromURL(STRING_STORAGE_PATH)
          .child(uid)
          .child(filePath)
          .put(file);
    } catch (e) {
      // print('error:$e');
    }
  }

  ///
  /// Category
  ///

  List<Category> categoryFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Category(
        id: doc.get('id') ?? 0,
        title: doc.get('title') ?? '',
        image: doc.get('image') ?? '',
        createTimestamp: doc.get('createTimestamp') ?? 0,
        updateTimestamp: doc.get('updateTimestamp') ?? 0,
      );
    }).toList();
  }

  Future<void> deleteCategoryData(int id) async {
    CollectionReference databaseCollection =
    setFirebaseFirestoreCollection(uid);
    await databaseCollection
        .doc(STRING_DATABASE_NAME)
        .collection(STRING_COLLECTION_CATEGORY)
        .doc(id.toString())
        .delete();
  }

  Future<void> updateCategoryData(Category category) async {
    CollectionReference databaseCollection =
    setFirebaseFirestoreCollection(uid);
    return await databaseCollection
        .doc(STRING_DATABASE_NAME)
        .collection(STRING_COLLECTION_CATEGORY)
        .doc(category.id.toString())
        .set({
      'id': category.id,
      'title': category.title,
      'image': category.image,
      'createTimestamp': category.createTimestamp,
      'updateTimestamp': category.updateTimestamp,
    });
  }

  Stream<List<Category>> get categories {
    CollectionReference databaseCollection =
    setFirebaseFirestoreCollection(uid);
    return databaseCollection
        .doc(STRING_DATABASE_NAME)
        .collection(STRING_COLLECTION_CATEGORY)
        .orderBy('id')
        .snapshots()
        .map(categoryFromSnapshot);
  }

  ///
  /// End Category
  ///

  ///
  /// Application
  ///

  List<Application> applicationFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Application(
        id: doc.get('id') ?? 0,
        status: doc.get('status') ?? true,
        categoryId: doc.get('categoryId') ?? 0,
        title: doc.get('title') ?? '',
        message: doc.get('message') ?? '',
        url: doc.get('url') ?? '',
        newUrl: doc.get('newUrl') ?? '',
        oneSignalAppId: doc.get('oneSignalAppId') ?? '',
        restApiKey: doc.get('restApiKey') ?? '',
        image: doc.get('image') ?? '',
        view: doc.get('view') ?? 0,
        click: doc.get('click') ?? 0,
        isSpecial: doc.get('isSpecial') ?? false,
        createTimestamp: doc.get('createTimestamp') ?? 0,
        updateTimestamp: doc.get('updateTimestamp') ?? 0,
      );
    }).toList();
  }

  Future<void> deleteApplicationData(int id) async {
    CollectionReference databaseCollection =
    setFirebaseFirestoreCollection(uid);
    await databaseCollection
        .doc(STRING_DATABASE_NAME)
        .collection(STRING_COLLECTION_APPLICATION)
        .doc(id.toString())
        .delete();
  }

  Future<void> updateApplicationData(Application application) async {
    CollectionReference databaseCollection =
    setFirebaseFirestoreCollection(uid);
    return await databaseCollection
        .doc(STRING_DATABASE_NAME)
        .collection(STRING_COLLECTION_APPLICATION)
        .doc(application.id.toString())
        .set({
      'id': application.id,
      'status': application.status,
      'categoryId': application.categoryId,
      'title': application.title,
      'message': application.message,
      'url': application.url,
      'newUrl': application.newUrl,
      'oneSignalAppId': application.oneSignalAppId,
      'restApiKey': application.restApiKey,
      'image': application.image,
      'view': application.view,
      'click': application.click,
      'isSpecial': application.isSpecial,
      'createTimestamp': application.createTimestamp,
      'updateTimestamp': application.updateTimestamp,
    });
  }

  Stream<List<Application>> get applications {
    CollectionReference databaseCollection =
    setFirebaseFirestoreCollection(uid);
    return databaseCollection
        .doc(STRING_DATABASE_NAME)
        .collection(STRING_COLLECTION_APPLICATION)
        .orderBy('id')
        .snapshots()
        .map(applicationFromSnapshot);
  }

  ///
  /// End Application
  ///

  ///
  /// History
  ///

  List<History> historyFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return History(
        id: doc.get('id') ?? 0,
        isCategory: doc.get('isCategory') ?? true,
        categoryId: doc.get('categoryId') ?? 0,
        categoryTitle: doc.get('categoryTitle') ?? '',
        appId: doc.get('appId') ?? 0,
        appTitle: doc.get('appTitle') ?? '',
        message: doc.get('message') ?? '',
        url: doc.get('url') ?? '',
        image: doc.get('image') ?? '',
        createTimestamp: doc.get('createTimestamp') ?? 0,
        updateTimestamp: doc.get('updateTimestamp') ?? 0,
      );
    }).toList();
  }

  Future<void> deleteHistoryData(int id) async {
    CollectionReference databaseCollection =
    setFirebaseFirestoreCollection(uid);
    await databaseCollection
        .doc(STRING_DATABASE_NAME)
        .collection(STRING_COLLECTION_HISTORY)
        .doc(id.toString())
        .delete();
  }

  Future<void> updateHistoryData(History history) async {
    CollectionReference databaseCollection =
    setFirebaseFirestoreCollection(uid);
    return await databaseCollection
        .doc(STRING_DATABASE_NAME)
        .collection(STRING_COLLECTION_HISTORY)
        .doc(history.id.toString())
        .set({
      'id': history.id,
      'isCategory': history.isCategory,
      'categoryId': history.categoryId,
      'categoryTitle': history.categoryTitle,
      'appId': history.appId,
      'appTitle': history.appTitle,
      'message': history.message,
      'url': history.url,
      'image': history.image,
      'createTimestamp': history.createTimestamp,
      'updateTimestamp': history.updateTimestamp,
    });
  }

  Stream<List<History>> get histories {
    CollectionReference databaseCollection =
    setFirebaseFirestoreCollection(uid);
    return databaseCollection
        .doc(STRING_DATABASE_NAME)
        .collection(STRING_COLLECTION_HISTORY)
        .orderBy('id')
        .snapshots()
        .map(historyFromSnapshot);
  }

  ///
  /// End History
  ///

  ///
  /// Setting
  ///

  List<Setting> settingFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Setting(
        id: doc.get('id') ?? 0,
        title: doc.get('title') ?? '',
        status: doc.get('status') ?? true,
        special: doc.get('special') ?? false,
        createTimestamp: doc.get('createTimestamp') ?? 0,
        updateTimestamp: doc.get('updateTimestamp') ?? 0,
      );
    }).toList();
  }

  Future<void> updateSettingData(Setting setting) async {
    CollectionReference databaseCollection =
    setFirebaseFirestoreCollection(uid);
    return await databaseCollection
        .doc(STRING_DATABASE_NAME)
        .collection(STRING_COLLECTION_SETTING)
        .doc(STRING_COLLECTION_SETTING)
        .set({
      'id': setting.id,
      'title': setting.title,
      'status': setting.status,
      'special': setting.special,
      'createTimestamp': setting.createTimestamp,
      'updateTimestamp': setting.updateTimestamp,
    });
  }

  Stream<List<Setting>> get settings {
    CollectionReference databaseCollection =
    setFirebaseFirestoreCollection(uid);
    return databaseCollection
        .doc(STRING_DATABASE_NAME)
        .collection(STRING_COLLECTION_SETTING)
        .orderBy('id')
        .snapshots()
        .map(settingFromSnapshot);
  }

  ///
  /// End Setting
  ///
}
