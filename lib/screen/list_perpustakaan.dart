import 'package:flutter/material.dart';
import '../model/perpustakaan.dart';
import '../service/api_service.dart';
import 'tambah_perpustakaan.dart';
import 'edit_perpustakaan.dart';
import 'detail_perpustakaan.dart';

class ListPerpustakaanScreen extends StatefulWidget {
  @override
  State<ListPerpustakaanScreen> createState() => _ListPerpustakaanScreenState();
}

class _ListPerpustakaanScreenState extends State<ListPerpustakaanScreen> {
  late Future<List<Perpustakaan>> perpustakaanList;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      perpustakaanList = ApiService.fetchPerpustakaan();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2FDFB),
      appBar: AppBar(
        title: const Text(
          "Daftar Perpustakaan",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF00897B),
        elevation: 0,
      ),
      body: FutureBuilder<List<Perpustakaan>>(
        future: perpustakaanList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.teal));
          } else if (snapshot.hasError) {
            return const Center(child: Text("Gagal memuat data"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Data perpustakaan kosong"));
          } else {
            final list = snapshot.data!;
            return RefreshIndicator(
              onRefresh: () async => _refresh(),
              color: Colors.teal,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final perpustakaan = list[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFF80CBC4),
                        child: const Icon(Icons.local_library, color: Colors.white),
                      ),
                      title: Text(
                        perpustakaan.nama,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(perpustakaan.alamat, maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.teal.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              perpustakaan.tipe,
                              style: const TextStyle(
                                color: Color(0xFF00796B),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) async {
                          if (value == 'edit') {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => EditPerpustakaanScreen(perpustakaan: perpustakaan)),
                            );
                            if (result == true) _refresh();
                          } else if (value == 'delete') {
                            final confirm = await showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text("Konfirmasi"),
                                content: const Text("Hapus perpustakaan ini?"),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
                                  TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Hapus")),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              final res = await ApiService.deletePerpustakaan(perpustakaan.id!);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(res['message']),
                                  backgroundColor: res['success'] ? Colors.teal : Colors.red,
                                ),
                              );
                              if (res['success']) _refresh();
                            }
                          }
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: 'edit', child: Text("Edit")),
                          PopupMenuItem(value: 'delete', child: Text("Hapus")),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => DetailPerpustakaanScreen(perpustakaan: perpustakaan)),
                        );
                      },
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TambahPerpustakaanScreen()),
          );
          if (result == true) _refresh();
        },
        backgroundColor: const Color(0xFF00897B),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text("Tambah"),
      ),
    );
  }
}
