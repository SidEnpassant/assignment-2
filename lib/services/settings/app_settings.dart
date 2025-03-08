class AppSettings {
  bool isDarkMode = true;
  String language = 'en';
  bool enableNotifications = true;

  void toggleDarkMode() {
    isDarkMode = !isDarkMode;
  }

  void setLanguage(String lang) {
    language = lang;
  }

  void toggleNotifications() {
    enableNotifications = !enableNotifications;
  }
}
