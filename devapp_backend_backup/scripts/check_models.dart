import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> main() async {
  // Replace with your actual API Key. Ensure to keep it safe.
  final apiKey = 'AIzaSyDRrKdJv-NLnyt-zbxLcHbeOWFxVMyr76o';

  if (apiKey.isEmpty) {
    print('Error: Please insert your API key inside the script.');
    return;
  }

  try {
    print('Fetching available models...');

    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models?key=$apiKey',
    );
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data.containsKey('models')) {
        final List<dynamic> models = data['models'];

        print('\n--- AVAILABLE MODELS ---');
        for (var m in models) {
          final supportedMethods =
              m['supportedGenerationMethods'] as List<dynamic>?;
          if (supportedMethods != null &&
              supportedMethods.contains('generateContent')) {
            print('Name: ${m['name']}');
            print(' - Description: ${m['displayName']}');
            print(' - Max Input Tokens: ${m['inputTokenLimit']}');
            print('-------------------------');
          }
        }
      } else {
        print('No models found in response.');
      }
    } else {
      print('Failed to fetch models. Status code: ${response.statusCode}');
      print('Response: ${response.body}');
    }
  } catch (e) {
    print('Error fetching models: $e');
  }
}
