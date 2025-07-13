import 'package:flutter/material.dart';
import '../model/perpustakaan.dart';
import '../service/api_service.dart';

class EditPerpustakaanScreen extends StatefulWidget {
  final Perpustakaan perpustakaan;

  const EditPerpustakaanScreen({super.key, required this.perpustakaan});

  @override
  State<EditPerpustakaanScreen> createState() => _EditPerpustakaanScreenState();
}

class _EditPerpustakaanScreenState extends State<EditPerpustakaanScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _alamatController;
  late TextEditingController _telpController;
  late TextEditingController _tipeController;
  late TextEditingController _latController;
  late TextEditingController _longController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.perpustakaan.nama);
    _alamatController = TextEditingController(text: widget.perpustakaan.alamat);
    _telpController = TextEditingController(text: widget.perpustakaan.noTelpon);
    _tipeController = TextEditingController(text: widget.perpustakaan.tipe);
    _latController = TextEditingController(text: widget.perpustakaan.latitude.toString());
    _longController = TextEditingController(text: widget.perpustakaan.longitude.toString());
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    double? lat = double.tryParse(_latController.text);
    double? long = double.tryParse(_longController.text);

    if (lat == null || long == null) {
      _showMessage('Latitude dan Longitude harus berupa angka', isError: true);
      return;
    }

    final updatedPerpustakaan = Perpustakaan(
      id: widget.perpustakaan.id,
      nama: _namaController.text,
      alamat: _alamatController.text,
      noTelpon: _telpController.text,
      tipe: _tipeController.text,
      latitude: lat,
      longitude: long,
    );

    setState(() => _isLoading = true);
    final result = await ApiService.updatePerpustakaan(widget.perpustakaan.id!, updatedPerpustakaan);
    setState(() => _isLoading = false);

    _showMessage(result['message'], isError: !result['success']);
    if (result['success']) Navigator.pop(context, true);
  }

  void _showMessage(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : Colors.teal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFF00796B),
        title: const Text(
          "Edit Perpustakaan",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
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
                      _buildInput("Alamat", Icons.location_on, _alamatController, maxLines: 2),
                      _buildInput("No Telepon", Icons.phone, _telpController),
                      _buildInput("Tipe", Icons.category, _tipeController),
                      _buildInput("Latitude", Icons.explore, _latController, keyboardType: TextInputType.number),
                      _buildInput("Longitude", Icons.explore_outlined, _longController, keyboardType: TextInputType.number),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.save, color: Colors.white),
                          label: const Text("Simpan Perubahan"),
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00796B),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(fontWeight: FontWeight.bold),
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
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.teal),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
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
