import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GameService {
  final String baseUrl = 'http://192.168.0.29:8080/api/v1/game';

  Future<Map<String, dynamic>?> startGame() async {
    final url = Uri.parse('$baseUrl/start');
    await checkStorage();

    try {
      final prefs = await SharedPreferences.getInstance();
      final storedId = prefs.getString('playerId');

      Map<String, dynamic> requestBody = {};
      if (storedId != null) {
        requestBody['playerId'] = storedId;
      }

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final data = json.decode(decodedBody);
        final playerId = data['playerId'] as String?;
        if (playerId != null) {
          await prefs.setString('playerId', playerId);
          await checkStorage();
        }
        return data;
      } else {
        print('Error: Received status code ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception in startGame(): $e');
      return null;
    }
  }

  Future<void> checkStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final storedId = prefs.getString('playerId');
    print('Stored Player ID: $storedId');
  }

  Future<void> deleteStorage() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('playerId');
  }
}
