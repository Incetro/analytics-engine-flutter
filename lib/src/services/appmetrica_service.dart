import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'analytics_service.dart';

class AppMetricaAdapter implements AnalyticsService {
  @override
  Future<void> logEvent(String name, {Map<String, Object>? params}) async {
    await AppMetrica.reportEventWithMap(name, params);
  }

  @override
  Future<void> setUserId(String userId) async {
    await AppMetrica.setUserProfileID(userId);
  }

  @override
  Future<void> setUserProperty(String key, String value) async {
    final profile = AppMetricaUserProfile([
      AppMetricaStringAttribute.withValue(key, value),
    ]);
    await AppMetrica.reportUserProfile(profile);
  }
}
