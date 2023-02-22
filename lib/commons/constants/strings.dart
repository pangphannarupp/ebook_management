const STRING_APP_NAME = 'EBook Management';
const STRING_APP_VERSION = '1.0.3';
//=========== TYPE OF USERS ===========/
//Manage all functions
const STRING_EMAIL_TOP_ADMIN = 'admin@gmail.com' +
  '&pangphannarupp@gmail.com';
//Manage all functions except registering new user
const STRING_EMAIL_ADMIN = STRING_EMAIL_TOP_ADMIN + '&pangphannarupp@gmail.com';
//Send notification for app and category
const STRING_EMAIL_SPECIAL_USER = STRING_EMAIL_ADMIN + '&user-ytpl@gmail.com';
//Send notification for app only
const STRING_EMAIL_USER = STRING_EMAIL_SPECIAL_USER + '&user1@gmail.com';
//=========== FIREBASE ===========/
const STRING_DATABASE_NAME = 'notification-management';
const STRING_STORAGE_PATH = 'gs://test-e8b7f.appspot.com';
const STRING_COLLECTION_CATEGORY = 'category';
const STRING_COLLECTION_APPLICATION = 'application';
const STRING_COLLECTION_HISTORY = 'history';
const STRING_COLLECTION_SETTING = 'setting';