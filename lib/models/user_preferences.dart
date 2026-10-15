class UserPreferences {
  final String languageCode;

  UserPreferences({required this.languageCode});

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(languageCode: json['language_code']);
  }
}
