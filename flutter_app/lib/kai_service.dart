import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatMessage {
  final String role; // 'user' | 'bot'
  final String text;
  final DateTime time;

  ChatMessage({required this.role, required this.text, DateTime? time})
      : time = time ?? DateTime.now();
}

class KaiService {
  static const String _apiUrl =
      'https://api-inference.huggingface.co/models/microsoft/DialoGPT-medium';

  final String hfToken;

  KaiService({required this.hfToken});

  Future<String> sendMessage(
      String userMessage, List<ChatMessage> history) async {
    final pastUserInputs = history
        .where((m) => m.role == 'user')
        .map((m) => m.text)
        .toList();

    final generatedResponses = history
        .where((m) => m.role == 'bot')
        .map((m) => m.text)
        .toList();

    final payload = {
      'inputs': {
        'past_user_inputs': pastUserInputs,
        'generated_responses': generatedResponses,
        'text': userMessage,
      },
      'parameters': {
        'max_length': 200,
        'temperature': 0.7,
        'repetition_penalty': 1.3,
      },
    };

    final headers = {'Content-Type': 'application/json'};
    if (hfToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $hfToken';
    }

    final response = await http
        .post(
          Uri.parse(_apiUrl),
          headers: headers,
          body: jsonEncode(payload),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 503) {
      throw Exception('המודל נטען, נסה שוב בעוד מספר שניות...');
    }

    if (response.statusCode != 200) {
      final body = jsonDecode(response.body);
      throw Exception(body['error'] ?? 'שגיאה ${response.statusCode}');
    }

    final data = jsonDecode(response.body);
    return (data['generated_text'] as String?) ??
        'אני Kai. לא הצלחתי להבין, תוכל לנסח מחדש?';
  }
}
