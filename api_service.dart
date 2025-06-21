import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl =
      'http://127.0.0.1:5000'; // Update with your Flask server URL

  Future<String> getChatbotResponse(String userInput) async {
    final url = Uri.parse('$_baseUrl/chat');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'message': userInput}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['reply'];
    } else {
      throw Exception('Failed to get response from API');
    }
  }
}
