import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/yakutsk_data.dart';

class ApiService {

  static const String baseUrl = "http://192.168.31.194:8080/api/yakutsk-summary";

  Future<YakutskData?> fetchData() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        // Декодируем UTF-8 (чтобы русский текст не превратился в каракули)
        final String decodedBody = utf8.decode(response.bodyBytes);
        return YakutskData.fromJson(json.decode(decodedBody));
      }
    } catch (e) {
      print("❌ Ошибка связи с Java: $e");
    }
    return null;
  }
}
