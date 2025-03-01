import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/data_model.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  
  /// Mengambil data dari API secara asynchronous
  /// Returns list of DataModel objects
  Future<List<DataModel>> fetchData() async {
    try {
      // Mengirim permintaan GET ke endpoint /posts
      final response = await http.get(Uri.parse('$baseUrl/posts'));
      
      // Memeriksa status respons
      if (response.statusCode == 200) {
        // Mengurai respons JSON
        List<dynamic> data = json.decode(response.body);
        
        // Mengubah data JSON menjadi daftar objek DataModel
        return data.map((item) => DataModel.fromJson(item)).toList();
      } else {
        // Melempar pengecualian jika status tidak 200 OK
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      // Menangkap dan melempar kembali pengecualian
      throw Exception('Error fetching data: $e');
    }
  }
  
  /// Memproses data: mengurutkan berdasarkan ID
  List<DataModel> processData(List<DataModel> data) {
    // Membuat salinan data untuk diurutkan
    final processedData = List<DataModel>.from(data);
    // Mengurutkan data berdasarkan ID
    processedData.sort((a, b) => a.id.compareTo(b.id));
    return processedData;
  }
}