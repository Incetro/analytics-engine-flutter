import 'index.dart';

class AnalyticsManager implements AnalyticsService {
  final Map<AnalyticsProvider, AnalyticsService> _allProviders;
  late final List<AnalyticsService> _activeProviders;
  Map<String, String> _schema = {};
  @override
  final AnalysisLogger logger;

  AnalyticsManager({
    required List<AnalyticsProvider> enabledProviders, 
    bool enableAutoLogging = false,
    AnalysisLogger? logger,
  })
  : logger = logger ?? DefaultLogger.instance, 
  _allProviders = {
    AnalyticsProvider.firebase: FirebaseAnalyticsAdapter(FirebaseAnalytics.instance, logger: logger ?? DefaultLogger.instance),
    AnalyticsProvider.appMetrica: AppMetricaAdapter(logger: logger ?? DefaultLogger.instance),
    AnalyticsProvider.facebook: FacebookAdapter(FacebookAppEvents()..setAutoLogAppEventsEnabled(enableAutoLogging), logger: logger ?? DefaultLogger.instance),
    AnalyticsProvider.branch: BranchAnalyticsAdapter(logger: logger ?? DefaultLogger.instance),
  } {
    if (enabledProviders.isEmpty) {
      _activeProviders = _allProviders.values.toList();
    } else {
      _activeProviders = enabledProviders
          .map((p) => _allProviders[p]!)
          .toList();
    }

    logger!.log(
      source: 'Analytics manager',
      text: 'STARTED'
    );
  }

  void setSchema(Map<String, String> schema) {
    _schema = schema;
  }

  @override
  Future<void> logEvent(String name, {Map<String, Object>? params, List<AnalyticsProvider>? targetProviders}) async {
    final realName = _schema[name] ?? name;

    final providersToUse = targetProviders == null
        ? _activeProviders
        : targetProviders.map((p) => _allProviders[p]!).toList();

    for (final service in providersToUse) {
      await service.logEvent(realName, params: params);
    }
  }

  @override
  Future<void> setUserId(String userId) async {
    for (final service in _activeProviders) {
      await service.setUserId(userId);
    }
  }

  @override
  Future<void> setUserProperty(String key, String value) async {
    for (final service in _activeProviders) {
      await service.setUserProperty(key, value);
    }
  }
}
