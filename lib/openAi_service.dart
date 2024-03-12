import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:voice_text/secrets.dart';

class OpenAIService {
  final List<Map<String, String>> messages = [];
  Future<String> isArtTextPromptAPI(String val) async {
    try {
      print('open_ai_api_key $open_ai_api_key');
      print('valvalvalvalvalval $val');
      final res = await http.post(
          Uri.parse('https://api.openai.com/v1/chat/completions'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $open_ai_api_key'
          },
          body: jsonEncode({
            "model": "gpt-3.5-turbo",
            "messages": [
              // {"role": "system", "content": "You are a helpful assistant."},
              {
                "role": "user",
                // "content": 'Create a unicorn image.'
                "content":
                    "Does this message want to generate an AI picture, image, art or anything simillar.? $val. Simply answer with a yes or no."
              }
            ]
          }));
      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();
        switch (content) {
          case 'Yes':
          case 'yes':
          case 'Yes.':
          case 'yes.':
            final res = await isDallEAPI(val);
            return res;
          default:
            final res = await isChatGptTextAPI(val);
            return res;
        }
      }
      return 'An internal error occured.';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> isChatGptTextAPI(String val) async {
    messages.add({
      'role': 'user',
      'content': val,
    });
    try {
      final res = await http.post(
          Uri.parse('https://api.openai.com/v1/chat/completions'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $open_ai_api_key'
          },
          body: jsonEncode({
            "model": "gpt-3.5-turbo",
            "messages": messages,
          }));

      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();
        messages.add({'role': 'assistant', 'content': content});
        return content;
      }
      return 'An internal error occured.';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> isDallEAPI(String val) async {
    messages.add({
      'role': 'user',
      'content': val,
    });
    try {
      final res = await http.post(
          Uri.parse('https://api.openai.com/v1/images/generations'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $open_ai_api_key'
          },
          body: jsonEncode({
            'prompt': val,
            'n': 1,
          }));

      if (res.statusCode == 200) {
        String imageURL = jsonDecode(res.body)['data'][0]['url'];
        imageURL = imageURL.trim();
        messages.add({'role': 'assistant', 'content': imageURL});
        return imageURL;
      }
      return 'An internal error occured.';
    } catch (e) {
      return e.toString();
    }
  }
}
