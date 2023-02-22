class History {
  final int id;
  final bool isCategory;
  final int categoryId;
  final String categoryTitle;
  final int appId;
  final String appTitle;
  final String message;
  final String url;
  final String image;
  final int createTimestamp;
  final int updateTimestamp;

  History({
      this.id,
      this.isCategory,
      this.categoryId,
      this.categoryTitle,
      this.appId,
      this.appTitle,
      this.message,
      this.url,
      this.image,
      this.createTimestamp,
      this.updateTimestamp});
}