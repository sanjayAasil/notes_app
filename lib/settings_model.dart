class SettingsModel {
  bool showTimeChecked, olderNotesChecked, showLabelsOnHomeScreen;

  SettingsModel._(
    this.showTimeChecked,
    this.olderNotesChecked,
    this.showLabelsOnHomeScreen,
  );

  ///from Db
  factory SettingsModel.fromJson(Map<String, dynamic> json) => SettingsModel._(
        json['showTimeChecked'] ?? true,
        json['olderNotesChecked'] ?? false,
        json['showLabelsOnHomeScreen'] ?? true,
      );

  ///To Db
  Map<String, dynamic> get json => {
        "showTimeChecked": showTimeChecked,
        'olderNotesChecked': olderNotesChecked,
        'showLabelsOnHomeScreen': showLabelsOnHomeScreen,
      };
}
