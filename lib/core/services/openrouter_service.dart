import 'dart:convert';
import 'dart:io';
import 'package:admin_product_app/core/constants/env.dart';
import 'package:http/http.dart' as http;

class ProductSuggestion {
  final String name;
  final String category;
  final double price;
  final String notes;

  ProductSuggestion({
    required this.name,
    required this.category,
    required this.price,
    required this.notes,
  });

  factory ProductSuggestion.fromJson(Map<String, dynamic> json) {
    return ProductSuggestion(
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      notes: json['notes'] ?? '',
    );
  }
}

class OpenRouterService {
  static final _apiKey = Env.openRouterApiKey;
  static const _url = 'https://openrouter.ai/api/v1/chat/completions';

  static const _model = 'google/gemini-2.0-flash-001';

  Future<ProductSuggestion?> suggestFromImage(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);
    final ext = imageFile.path.split('.').last.toLowerCase();
    final mediaType = ext == 'png' ? 'image/png' : 'image/jpeg';

    final body = jsonEncode({
      "model": _model,
      "messages": [
        {
          "role": "user",
          "content": [
            {
              "type": "image_url",
              "image_url": {
                "url": "data:$mediaType;base64,$base64Image",
              }
            },
            {
              "type": "text",
              "text": """Phân tích hình ảnh sản phẩm này và trả về JSON duy nhất (không markdown, không giải thích):
{
  "name": "tên sản phẩm tiếng Việt ngắn gọn",
  "category": "loại sản phẩm (Skincare / Makeup / Haircare / Food / Electronics / Fashion / Other)",
  "price": giá ước tính bằng VND (số nguyên),
  "notes": "mô tả ngắn 1 câu"
}"""
            }
          ]
        }
      ],
      "max_tokens": 512,
    });

    final response = await http.post(
      Uri.parse(_url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
        'HTTP-Referer': 'https://yourapp.com', // tuỳ chọn, OpenRouter recommend
        'X-Title': 'Admin Product App',         // tuỳ chọn
      },
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final text = data['choices'][0]['message']['content'] as String;
      final clean = text.replaceAll(RegExp(r'```json|```'), '').trim();
      final json = jsonDecode(clean);
      return ProductSuggestion.fromJson(json);
    } else {
      // Debug nếu lỗi
      print('OpenRouter error ${response.statusCode}: ${response.body}');
      return null;
    }
  }
}