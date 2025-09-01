abstract class AnalysisLogger {
  const AnalysisLogger();

  void log({required String text, required String source});
  void logSuccess({required String text, required String source, required String eventName, Map<String, Object>? params});
  void logError({required String text, StackTrace? stack, required String source, required String eventName, Map<String, Object>? params});
}