import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SubmitGuessService {
  final String baseUrl = 'http://192.168.0.29:8080/api/v1/game';

  Future<Map<String, dynamic>?> submitGuess(String guessedWord) async {
    final url = Uri.parse('$baseUrl/submit-guess');
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedId = prefs.getString('playerId');

      final requestBody = {
        'playerId': storedId,
        'guessedWord': guessedWord,
      };

      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      final decodedBody = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        final data = json.decode(decodedBody);
        final playerId = data['playerId'] as String?;
        if (playerId != null) {
          await prefs.setString('playerId', playerId);
        }
        return data;
      } else {
        final errorData = json.decode(decodedBody);
        throw Exception(errorData['message'] ??
            'Received status code ${response.statusCode}');
      }
    } catch (e) {
      print('Exception in submitGuess(): $e');
      rethrow;
    }
  }
}
