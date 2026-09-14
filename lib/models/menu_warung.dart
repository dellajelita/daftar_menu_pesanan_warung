class MenuWarung {
  String namaMenu;
  String kategori;
  int harga;
  bool tersedia;
  int porsiTersisa;
  String gambar;
  String deskripsi;

  MenuWarung({
    required this.namaMenu,
    required this.kategori,
    required this.harga,
    required this.tersedia,
    required this.porsiTersisa,
    required this.gambar,
    required this.deskripsi,
  });

  String statusMenu() {
    if (tersedia && porsiTersisa > 0) {
      return 'Tersedia';
    }

    return 'Habis';
  }
}