import 'package:analytics_manager/src/index.dart';

abstract class AnalyticsService {
  const AnalyticsService({required this.logger});
  
  final AnalysisLogger logger;

  Future<void> logEvent(String name, {Map<String, Object>? params});

  Future<void> setUserId(String userId);

  Future<void> setUserProperty(String key, String value);
}