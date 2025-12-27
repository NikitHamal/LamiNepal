import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

/// Service for managing local preferences/storage
class PreferencesService {
  static PreferencesService? _instance;
  static SharedPreferences? _preferences;

  PreferencesService._();

  /// Get singleton instance
  static Future<PreferencesService> getInstance() async {
    _instance ??= PreferencesService._();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  /// Check if onboarding is complete
  bool get isOnboardingComplete =>
      _preferences?.getBool(AppConstants.onboardingCompleteKey) ?? false;

  /// Set onboarding complete status
  Future<bool> setOnboardingComplete(bool value) async {
    return await _preferences?.setBool(
          AppConstants.onboardingCompleteKey,
          value,
        ) ??
        false;
  }

  /// Get user token
  String? get userToken => _preferences?.getString(AppConstants.userTokenKey);

  /// Set user token
  Future<bool> setUserToken(String token) async {
    return await _preferences?.setString(AppConstants.userTokenKey, token) ??
        false;
  }

  /// Remove user token
  Future<bool> removeUserToken() async {
    return await _preferences?.remove(AppConstants.userTokenKey) ?? false;
  }

  /// Get theme preference
  String get themePreference =>
      _preferences?.getString(AppConstants.themePreferenceKey) ?? 'light';

  /// Set theme preference
  Future<bool> setThemePreference(String theme) async {
    return await _preferences?.setString(
          AppConstants.themePreferenceKey,
          theme,
        ) ??
        false;
  }

  /// Clear all preferences
  Future<bool> clearAll() async {
    return await _preferences?.clear() ?? false;
  }

  /// Check if user is logged in
  bool get isLoggedIn => userToken != null && userToken!.isNotEmpty;
}
