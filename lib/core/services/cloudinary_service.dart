import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CloudinaryService {
  final String cloudName = "digs0j48l";
  final String uploadPreset = "ml_default";

  Future<String?> uploadImage(File file) async {
    try {
      final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
      );

      final request = http.MultipartRequest("POST", url)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(
          await http.MultipartFile.fromPath('file', file.path),
        );

      final response = await request.send();

      if (response.statusCode == 200) {
        final data = json.decode(
          await response.stream.bytesToString(),
        );

        return data['secure_url']; // ✅ URL ảnh
      } else {
        print("Upload fail: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Upload error: $e");
      return null;
    }
  }
}