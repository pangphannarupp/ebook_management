class Application {
  final int id;
  final bool status;
  final int categoryId;
  final String title;
  final String message;
  String url;
  final String newUrl;
  final String oneSignalAppId;
  final String restApiKey;
  final String image;
  final int view;
  final int click;
  final bool isSpecial;
  final int createTimestamp;
  final int updateTimestamp;

  Application({
      this.id,
      this.status,
      this.categoryId,
      this.title,
      this.message,
      this.url,
      this.newUrl,
      this.oneSignalAppId,
      this.restApiKey,
      this.image,
      this.view,
      this.click,
      this.isSpecial,
      this.createTimestamp,
      this.updateTimestamp});
}