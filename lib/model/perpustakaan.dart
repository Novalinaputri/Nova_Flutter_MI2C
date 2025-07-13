class Perpustakaan {
  final int? id;
  final String nama;
  final String alamat;
  final String noTelpon;
  final String tipe;
  final double latitude;
  final double longitude;

  Perpustakaan({
    this.id,
    required this.nama,
    required this.alamat,
    required this.noTelpon,
    required this.tipe,
    required this.latitude,
    required this.longitude,
  });

  factory Perpustakaan.fromJson(Map<String, dynamic> json) {
    return Perpustakaan(
      id: json['id'],
      nama: json['nama_perpustakaan'],
      alamat: json['alamat'],
      noTelpon: json['no_telepon'],
      tipe: json['tipe_perpustakaan'],
      latitude: double.tryParse(json['latitude'].toString()) ?? 0.0,
      longitude: double.tryParse(json['longitude'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_perpustakaan': nama,
      'alamat': alamat,
      'no_telepon': noTelpon,
      'tipe_perpustakaan': tipe,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
