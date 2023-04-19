import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> uploadCsvFile(
    Uint8List fileBytes, String? fileName) async {
  var request = http.MultipartRequest(
      'POST', Uri.parse('https://dev-wcf-api.edifyai.com/api/accounts/uploads'));
  request.files.add(http.MultipartFile.fromBytes('file', fileBytes,
      filename: fileName));
  var response = await request.send();

  if (response.statusCode == 200) {
    String responseBody = await response.stream.bytesToString();
    Map<String, dynamic> jsonMap = json.decode(responseBody);
    return jsonMap;
  } else {
    throw Exception('Error uploading file');
  }
}