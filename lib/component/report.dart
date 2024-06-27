class Report {
  final String judul;
  final String deskripsi;
  final String alamat;
  final String kecamatan;
  final String jenis;
  final String tanggal;

  Report({
    required this.judul,
    required this.deskripsi,
    required this.alamat,
    required this.kecamatan,
    required this.jenis,
    required this.tanggal,
  });

  // Method untuk mengubah objek menjadi map yang dapat diencode sebagai JSON
  Map<String, dynamic> toJson() {
    return {
      'judul': judul,
      'deskripsi': deskripsi,
      'alamat': alamat,
      'kecamatan': kecamatan,
      'jenis': jenis,
      'tanggal': tanggal,
    };
  }
}
