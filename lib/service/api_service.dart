import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/perpustakaan.dart';

class ApiService {
  static const String baseUrl = "http://10.43.164.144:8000/api/perpustakaan";

  // Ambil semua data perpustakaan
  static Future<List<Perpustakaan>> fetchPerpustakaan() async {
    try {
      final res = await http.get(Uri.parse(baseUrl));
      if (res.statusCode == 200) {
        final jsonRes = json.decode(res.body);
        List jsonData = jsonRes['data'];
        return jsonData.map((e) => Perpustakaan.fromJson(e)).toList();
      } else {
        throw Exception('Gagal memuat data. Status: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengambil data: $e');
    }
  }

  // Tambah data perpustakaan
  static Future<Map<String, dynamic>> tambahPerpustakaan(Perpustakaan perpustakaan) async {
    try {
      print("Data yang dikirim ke API:");
      print(jsonEncode(perpustakaan.toJson()));

      final res = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(perpustakaan.toJson()),
      );

      if (res.statusCode == 201) {
        return {'success': true, 'message': 'Data berhasil ditambahkan'};
      } else {
        return {
          'success': false,
          'message': 'Gagal menambahkan. Status: ${res.statusCode}\nBody: ${res.body}'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Update data perpustakaan
  static Future<Map<String, dynamic>> updatePerpustakaan(int id, Perpustakaan perpustakaan) async {
    try {
      final res = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(perpustakaan.toJson()),
      );

      if (res.statusCode == 200) {
        return {'success': true, 'message': 'Data berhasil diupdate'};
      } else {
        return {
          'success': false,
          'message': 'Gagal update. Status: ${res.statusCode}'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Hapus data perpustakaan
  static Future<Map<String, dynamic>> deletePerpustakaan(int id) async {
    try {
      final res = await http.delete(Uri.parse('$baseUrl/$id'));

      if (res.statusCode == 200) {
        return {'success': true, 'message': 'Data berhasil dihapus'};
      } else {
        return {
          'success': false,
          'message': 'Gagal hapus. Status: ${res.statusCode}'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }
}
