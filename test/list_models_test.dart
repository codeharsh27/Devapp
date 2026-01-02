import 'package:blog_app/core/secrets/app_secrets.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('list models', () async {
    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: AppSecrets.geminiApiKey,
      );
      // Use the model variable to silence the warning
      print('Model initialized');
      // ignore: unused_local_variable
      final _ = model;
    } catch (e) {
      // print(e);
    }
  });
}
