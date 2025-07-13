import 'package:flutter/material.dart';
import '../model/perpustakaan.dart';
import '../service/api_service.dart';

class TambahPerpustakaanScreen extends StatefulWidget {
  @override
  State<TambahPerpustakaanScreen> createState() => _TambahPerpustakaanScreenState();
}

class _TambahPerpustakaanScreenState extends State<TambahPerpustakaanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _telponController = TextEditingController();
  final _tipeController = TextEditingController();
  final _latController = TextEditingController();
  final _longController = TextEditingController();

  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    double? lat = double.tryParse(_latController.text);
    double? long = double.tryParse(_longController.text);

    if (lat == null || long == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Latitude dan Longitude harus berupa angka'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final perpustakaan = Perpustakaan(
      nama: _namaController.text,
      alamat: _alamatController.text,
      noTelpon: _telponController.text,
      tipe: _tipeController.text,
      latitude: lat,
      longitude: long,
    );

    setState(() => _isLoading = true);
    final result = await ApiService.tambahPerpustakaan(perpustakaan);
    setState(() => _isLoading = false);

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil ditambahkan'), backgroundColor: Colors.teal),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${result['message']}'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Tambah Perpustakaan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFF00796B),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB2DFDB), Color(0xFFE0F2F1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.teal))
              : SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 8,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildInput("Nama Perpustakaan", Icons.local_library, _namaController),
                      _buildInput("Alamat", Icons.location_on, _alamatController, maxLines: 3),
                      _buildInput("No Telepon", Icons.phone, _telponController, keyboardType: TextInputType.phone),
                      _buildInput("Tipe Perpustakaan", Icons.category, _tipeController),
                      _buildInput("Latitude", Icons.explore, _latController, keyboardType: TextInputType.number),
                      _buildInput("Longitude", Icons.explore_outlined, _longController, keyboardType: TextInputType.number),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _submit,
                          icon: const Icon(Icons.save, color: Colors.white),
                          label: const Text("Simpan", style: TextStyle(fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00796B),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(fontSize: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput(
      String label,
      IconData icon,
      TextEditingController controller, {
        int maxLines = 1,
        TextInputType keyboardType = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.teal),
          labelText: label,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (val) => val == null || val.isEmpty ? "$label tidak boleh kosong" : null,
      ),
    );
  }
}
