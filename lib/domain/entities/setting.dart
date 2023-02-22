class Setting {
  final int id;
  final String title;
  final bool status;
  final bool special;
  final int createTimestamp;
  final int updateTimestamp;

  Setting(
      {this.id,
      this.title,
      this.status,
      this.special,
      this.createTimestamp,
      this.updateTimestamp});
}
