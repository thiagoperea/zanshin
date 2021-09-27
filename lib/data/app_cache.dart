/// Simple class to hold data about the app.
class AppCache {
  AppCache._internal();

  static final AppCache _instance = AppCache._internal();

  factory AppCache() => _instance;

  /// returns if the app is in the foreground.
  bool isInForeground = true;
}
