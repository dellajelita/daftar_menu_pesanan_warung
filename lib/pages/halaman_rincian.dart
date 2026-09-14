import 'package:flutter/material.dart';
import '../models/menu_warung.dart';

class HalamanRincian extends StatelessWidget {
  final MenuWarung menu;

  const HalamanRincian({
    super.key,
    required this.menu,
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

  @override
  Widget build(BuildContext context) {
    final bool tersedia =
        menu.tersedia && menu.porsiTersisa > 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F7),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 285,
            pinned: true,
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF252929),
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Color(0xFF252929),
                  ),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'menu-${menu.namaMenu}',
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
                          color: const Color(0xFFE9EFED),
                          child: const Center(
                            child: Icon(
                              Icons.broken_image_outlined,
                              size: 65,
                              color: Color(0xFFB2BEBC),
                            ),
                          ),
                        );
                      },
                    ),
                    if (!tersedia)
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 17,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF454B4A),
                            borderRadius:
                                BorderRadius.circular(25),
                          ),
                          child: const Text(
                            'MENU HABIS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                24,
                20,
                40,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2EEEC),
                          borderRadius:
                              BorderRadius.circular(18),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              getIconKategori(),
                              size: 14,
                              color:
                                  const Color(0xFF1F5C5B),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              menu.kategori,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight:
                                    FontWeight.w600,
                                color:
                                    Color(0xFF1F5C5B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        tersedia
                            ? Icons.check_circle_rounded
                            : Icons.cancel_rounded,
                        size: 17,
                        color: tersedia
                            ? const Color(0xFF1F5C5B)
                            : const Color(0xFFD96C4A),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        tersedia ? 'Tersedia' : 'Habis',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: tersedia
                              ? const Color(0xFF1F5C5B)
                              : const Color(0xFFD96C4A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    menu.namaMenu,
                    style: const TextStyle(
                      fontSize: 28,
                      height: 1.15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF252929),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rp${formatRupiah(menu.harga)}',
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F5C5B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    menu.deskripsi,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: Color(0xFF6F7774),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Ketersediaan Menu',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF252929),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration:
                                    const BoxDecoration(
                                  color: Color(0xFFE8F0EF),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.inventory_2_outlined,
                                  size: 19,
                                  color:
                                      Color(0xFF1F5C5B),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [
                                    const Text(
                                      'Stok',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color:
                                            Color(0xFF858B8A),
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      '${menu.porsiTersisa} porsi',
                                      style:
                                          const TextStyle(
                                        fontSize: 14,
                                        fontWeight:
                                            FontWeight.bold,
                                        color:
                                            Color(0xFF252929),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration:
                                    const BoxDecoration(
                                  color: Color(0xFFE8F0EF),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  tersedia
                                      ? Icons
                                          .check_circle_outline_rounded
                                      : Icons
                                          .highlight_off_rounded,
                                  size: 20,
                                  color: tersedia
                                      ? const Color(
                                          0xFF1F5C5B)
                                      : const Color(
                                          0xFFD96C4A),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [
                                    const Text(
                                      'Status',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color:
                                            Color(0xFF858B8A),
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      tersedia
                                          ? 'Tersedia'
                                          : 'Habis',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight:
                                            FontWeight.bold,
                                        color: tersedia
                                            ? const Color(
                                                0xFF1F5C5B)
                                            : const Color(
                                                0xFFD96C4A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: tersedia
                          ? const Color(0xFFEAF2F0)
                          : const Color(0xFFFFEEEA),
                      borderRadius:
                          BorderRadius.circular(18),
                    ),
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Icon(
                          tersedia
                              ? Icons.info_outline_rounded
                              : Icons.warning_amber_rounded,
                          size: 21,
                          color: tersedia
                              ? const Color(0xFF1F5C5B)
                              : const Color(0xFFD96C4A),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            tersedia
                                ? 'Menu ini masih tersedia. Jumlah pesanan dapat diatur langsung pada kartu menu di halaman utama.'
                                : 'Menu ini sedang habis dan tidak dapat dipesan sampai stok tersedia kembali.',
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.5,
                              color: tersedia
                                  ? const Color(0xFF53615F)
                                  : const Color(0xFF8E5B50),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}