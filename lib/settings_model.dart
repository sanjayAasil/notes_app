class SettingsModel {
  bool showTimeChecked, olderNotesChecked;

  SettingsModel._(
    this.showTimeChecked,
    this.olderNotesChecked,
  );

  ///from Db
  factory SettingsModel.fromJson(Map<String, dynamic> json) => SettingsModel._(
        json['showTimeChecked'] ?? true,
        json['olderNotesChecked'] ?? false,
      );

  ///To Db
  Map<String, dynamic> get json => {
        "showTimeChecked": showTimeChecked,
        'olderNotesChecked': olderNotesChecked,
      };
}
