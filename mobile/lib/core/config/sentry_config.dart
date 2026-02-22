class SentryConfig {
  // DSN is set via --dart-define=SENTRY_DSN=https://... at build time.
  // Example:  flutter build apk --dart-define=SENTRY_DSN=https://...
  static const String dsn =
      String.fromEnvironment('SENTRY_DSN', defaultValue: '');

  // Keep traces sample rate LOW in production to avoid blowing through the
  // free-tier quota and adding per-request overhead on user devices.
  // - Production: 0.1 (10% of transactions)
  // - Dev/staging: 1.0 (capture everything to debug)
  static const double tracesSampleRate =
      bool.fromEnvironment('DEBUG_SENTRY', defaultValue: false) ? 1.0 : 0.1;
}
