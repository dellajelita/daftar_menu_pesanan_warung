import 'package:flutter/material.dart';
import '../models/menu_warung.dart';
import '../pages/halaman_rincian.dart';
import 'jumlah_porsi.dart';

class MenuCard extends StatelessWidget {
  final MenuWarung menu;
  final int jumlahPesanan;
  final VoidCallback onTambah;
  final VoidCallback onKurang;
  final VoidCallback onBatasStok;

  const MenuCard({
    super.key,
    required this.menu,
    required this.jumlahPesanan,
    required this.onTambah,
    required this.onKurang,
    required this.onBatasStok,
  });

  IconData getIconKategori() {
    if (menu.kategori == 'Makanan') {
      return Icons.restaurant_rounded;
    }

    if (menu.kategori == 'Minuman') {
      return Icons.local_drink_rounded;
    }

    return Icons.cookie_rounded;
  }

  String formatRupiah(int angka) {
    return angka
        .toString()
        .replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match.group(1)}.',
        );
  }

  void bukaDetail(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration:
            const Duration(milliseconds: 300),
        pageBuilder: (
          context,
          animation,
          secondaryAnimation,
        ) {
          return HalamanRincian(menu: menu);
        },
        transitionsBuilder: (
          context,
          animation,
          secondaryAnimation,
          child,
        ) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );

          return FadeTransition(
            opacity: curvedAnimation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.08, 0),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool aktif =
        menu.tersedia && menu.porsiTersisa > 0;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 1,
      shadowColor: Colors.black12,
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(21),
      ),
      child: InkWell(
        onTap: () => bukaDetail(context),
        splashColor: const Color(0x141F5C5B),
        highlightColor: const Color(0x081F5C5B),
        child: Opacity(
          opacity: aktif ? 1 : 0.55,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'menu-${menu.namaMenu}',
                child: SizedBox(
                  height: 145,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Image.asset(
                        menu.gambar,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFFEFF2F1),
                            child: const Center(
                              child: Icon(
                                Icons.broken_image_outlined,
                                size: 40,
                                color: Color(0xFFB5BFBD),
                              ),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        left: 10,
                        top: 10,
                        child: Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisSize:
                                MainAxisSize.min,
                            children: [
                              Icon(
                                getIconKategori(),
                                size: 12,
                                color:
                                    const Color(0xFF1F5C5B),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                menu.kategori,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight:
                                      FontWeight.w600,
                                  color:
                                      Color(0xFF1F5C5B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (!aktif)
                        Positioned(
                          right: 10,
                          top: 10,
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  const Color(0xFF454B4A),
                              borderRadius:
                                  BorderRadius.circular(15),
                            ),
                            child: const Text(
                              'HABIS',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight:
                                    FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    13,
                    12,
                    13,
                    10,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        menu.namaMenu,
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF252929),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rp${formatRupiah(menu.harga)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F5C5B),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(
                            Icons.inventory_2_outlined,
                            size: 13,
                            color: Color(0xFF858B8A),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              aktif
                                  ? '${menu.porsiTersisa} porsi'
                                  : 'Stok habis',
                              style:
                                  const TextStyle(
                                fontSize: 10,
                                color:
                                    Color(0xFF858B8A),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: JumlahPorsi(
                              jumlah: jumlahPesanan,
                              bisaTambah:
                                  jumlahPesanan <
                                      menu.porsiTersisa,
                              aktif: aktif,
                              onTambah: onTambah,
                              onKurang: onKurang,
                              onBatasStok:
                                  onBatasStok,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}