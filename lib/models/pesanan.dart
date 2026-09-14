import 'menu_warung.dart';

class Pesanan {
  final MenuWarung menu;
  int jumlah;

  Pesanan({
    required this.menu,
    this.jumlah = 0,
  });

  int totalHarga() {
    return menu.harga * jumlah;
  }
}