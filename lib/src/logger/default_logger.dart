import 'package:analytics_manager/src/index.dart';

class DefaultLogger implements AnalysisLogger {
  static DefaultLogger? _instance;

  static DefaultLogger get instance => _instance ??= DefaultLogger();

  @override
  void log({required String text, required String source}) {
    debugPrint('☑️ [$source]  → $text',);
  }

  @override
  void logSuccess({required String text, required String source, required String eventName, Map<String, Object>? params}) {
    debugPrint('✅ [$source]  → $text\nName: $eventName${params != null ? '\nParams: $params' : ''}',);
  }

  @override
  void logError({required String text, StackTrace? stack,required String source, required String eventName, Map<String, Object>? params}) {
    debugPrint('❌ [$source]  → $text\nName: $eventName${params != null ? '\nParams: $params' : ''}${stack != null? '\nStack: $stack' : ''}',);
  }
}