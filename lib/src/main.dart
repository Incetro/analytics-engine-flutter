import 'package:analytics_manager/src/services/branch_service.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

import 'services/index.dart';
import 'utils/providers.dart';

class AnalyticsManager implements AnalyticsService {
  final Map<AnalyticsProvider, AnalyticsService> _allProviders;
  late final List<AnalyticsService> _activeProviders;
  Map<String, String> _schema = {};

  AnalyticsManager({required List<AnalyticsProvider> enabledProviders, bool enableAutoLogging = false})
  : _allProviders = {
    AnalyticsProvider.firebase: FirebaseAnalyticsAdapter(FirebaseAnalytics.instance),
    AnalyticsProvider.appMetrica: AppMetricaAdapter(),
    AnalyticsProvider.facebook: FacebookAdapter(FacebookAppEvents()..setAutoLogAppEventsEnabled(enableAutoLogging)),
    AnalyticsProvider.branch: BranchAnalyticsAdapter(),
  } {
    if (enabledProviders.isEmpty) {
      _activeProviders = _allProviders.values.toList();
    } else {
      _activeProviders = enabledProviders
          .map((p) => _allProviders[p]!)
          .toList();
    }
    debugPrint(
        '✅ [Analytics manager]  → STARTED',
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
