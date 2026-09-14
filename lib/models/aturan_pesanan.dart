import 'menu_warung.dart';

int hitungDiskon(
  MenuWarung menu,
  int jumlahPesanan,
) {
  if (jumlahPesanan >= 5) {
    return (menu.harga * jumlahPesanan * 10 / 100).round();
  }

  return 0;
}

bool bisaDipesan(MenuWarung menu) {
  return menu.tersedia && menu.porsiTersisa > 0;
}

bool jumlahValid(
  MenuWarung menu,
  int jumlahPesanan,
) {
  return jumlahPesanan >= 0 &&
      jumlahPesanan <= menu.porsiTersisa;
}

int hitungTotalMenu(
  MenuWarung menu,
  int jumlahPesanan,
) {
  int totalAwal = menu.harga * jumlahPesanan;
  int diskon = hitungDiskon(
    menu,
    jumlahPesanan,
  );

  return totalAwal - diskon;
}