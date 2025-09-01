import 'package:analytics_manager/src/index.dart';

class BranchAnalyticsAdapter implements AnalyticsService {
  BranchAnalyticsAdapter({required this.logger}) {
    FlutterBranchSdk.init();
  }

  @override
  final AnalysisLogger logger;

  @override
  Future<void> logEvent(String name, {Map<String, Object>? params}) async {
    var event = BranchEvent.customEvent(name);

    if (params != null) {
      for (var key in params.keys) {
        event.addCustomData(key, params[key]);
      }
    }

    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: event);
  }

  @override
  Future<void> setUserId(String userId) async {
    FlutterBranchSdk.setIdentity(userId);
  }

  @override
  Future<void> setUserProperty(String key, String value) async {
    FlutterBranchSdk.setRequestMetadata(key, value);
  }
}
