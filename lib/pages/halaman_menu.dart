import 'package:flutter/material.dart';
import '../models/data_menu.dart';
import '../models/pesanan.dart';
import '../models/aturan_pesanan.dart';
import '../widgets/menu_card.dart';

class HalamanMenu extends StatefulWidget {
  const HalamanMenu({super.key});

  @override
  State<HalamanMenu> createState() => _HalamanMenuState();
}

class _HalamanMenuState extends State<HalamanMenu> {
  late List<Pesanan> daftarPesanan;
  late TextEditingController searchController;

  String kataPencarian = '';
  String kategoriDipilih = 'Semua';
  String statusDipilih = 'Semua';
  String urutanHarga = 'Default';

  @override
  void initState() {
    super.initState();

    searchController = TextEditingController();

    daftarPesanan = daftarMenu.map((menu) {
      return Pesanan(menu: menu);
    }).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Pesanan> daftarMenuTampil() {
    List<Pesanan> hasil = List.from(daftarPesanan);

    if (kataPencarian.isNotEmpty) {
      hasil = hasil.where((pesanan) {
        return pesanan.menu.namaMenu
            .toLowerCase()
            .contains(kataPencarian.toLowerCase());
      }).toList();
    }

    if (kategoriDipilih != 'Semua') {
      hasil = hasil.where((pesanan) {
        return pesanan.menu.kategori == kategoriDipilih;
      }).toList();
    }

    if (statusDipilih == 'Tersedia') {
      hasil = hasil.where((pesanan) {
        return pesanan.menu.tersedia &&
            pesanan.menu.porsiTersisa > 0;
      }).toList();
    }

    if (statusDipilih == 'Habis') {
      hasil = hasil.where((pesanan) {
        return !pesanan.menu.tersedia ||
            pesanan.menu.porsiTersisa == 0;
      }).toList();
    }

    if (urutanHarga == 'Termurah') {
      hasil.sort(
        (a, b) => a.menu.harga.compareTo(b.menu.harga),
      );
    }

    if (urutanHarga == 'Termahal') {
      hasil.sort(
        (a, b) => b.menu.harga.compareTo(a.menu.harga),
      );
    }

    return hasil;
  }

  int hitungMenuTersedia(List<Pesanan> data) {
    int total = 0;

    for (Pesanan pesanan in data) {
      if (pesanan.menu.tersedia &&
          pesanan.menu.porsiTersisa > 0) {
        total++;
      }
    }

    return total;
  }

  int hitungMenuHabis(List<Pesanan> data) {
    int total = 0;

    for (Pesanan pesanan in data) {
      if (!pesanan.menu.tersedia ||
          pesanan.menu.porsiTersisa == 0) {
        total++;
      }
    }

    return total;
  }

  int hitungTotalPesanan() {
    int total = 0;

    for (Pesanan pesanan in daftarPesanan) {
      total += hitungTotalMenu(
        pesanan.menu,
        pesanan.jumlah,
      );
    }

    return total;
  }

  int hitungSubtotalPesanan() {
    int total = 0;

    for (Pesanan pesanan in daftarPesanan) {
      total += pesanan.menu.harga * pesanan.jumlah;
    }

    return total;
  }

  int hitungDiskonPesanan() {
    int total = 0;

    for (Pesanan pesanan in daftarPesanan) {
      total += hitungDiskon(
        pesanan.menu,
        pesanan.jumlah,
      );
    }

    return total;
  }

  int hitungJumlahItem() {
    int total = 0;

    for (Pesanan pesanan in daftarPesanan) {
      total += pesanan.jumlah;
    }

    return total;
  }

  void tambahPesanan(Pesanan pesanan) {
    final int jumlahBaru = pesanan.jumlah + 1;

    if (!bisaDipesan(pesanan.menu)) {
      return;
    }

    if (!jumlahValid(
      pesanan.menu,
      jumlahBaru,
    )) {
      tampilkanPeringatanStok(pesanan);
      return;
    }

    setState(() {
      pesanan.jumlah = jumlahBaru;
    });
  }

  void kurangPesanan(Pesanan pesanan) {
    if (pesanan.jumlah > 0) {
      setState(() {
        pesanan.jumlah--;
      });
    }
  }

  void tampilkanPeringatanStok(Pesanan pesanan) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFFD96C4A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        margin: const EdgeInsets.fromLTRB(
          18,
          0,
          18,
          18,
        ),
        content: Row(
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Pesanan ${pesanan.menu.namaMenu} melebihi jumlah porsi yang tersedia.',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  String formatRupiah(int angka) {
    return angka
        .toString()
        .replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match.group(1)}.',
        );
  }

  void bukaFilter() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFFFFCF8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(26),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                12,
                20,
                28,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD8DDDB),
                        borderRadius:
                            BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Filter Menu',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF252929),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Status',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF252929),
                    ),
                  ),
                  const SizedBox(height: 9),
                  Wrap(
                    spacing: 8,
                    children: [
                      _filterChipSheet(
                        'Semua',
                        statusDipilih,
                        (value) {
                          setSheetState(() {
                            statusDipilih = value;
                          });
                          setState(() {});
                        },
                      ),
                      _filterChipSheet(
                        'Tersedia',
                        statusDipilih,
                        (value) {
                          setSheetState(() {
                            statusDipilih = value;
                          });
                          setState(() {});
                        },
                      ),
                      _filterChipSheet(
                        'Habis',
                        statusDipilih,
                        (value) {
                          setSheetState(() {
                            statusDipilih = value;
                          });
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Urutan Harga',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF252929),
                    ),
                  ),
                  const SizedBox(height: 9),
                  Wrap(
                    spacing: 8,
                    children: [
                      _filterChipSheet(
                        'Default',
                        urutanHarga,
                        (value) {
                          setSheetState(() {
                            urutanHarga = value;
                          });
                          setState(() {});
                        },
                      ),
                      _filterChipSheet(
                        'Termurah',
                        urutanHarga,
                        (value) {
                          setSheetState(() {
                            urutanHarga = value;
                          });
                          setState(() {});
                        },
                      ),
                      _filterChipSheet(
                        'Termahal',
                        urutanHarga,
                        (value) {
                          setSheetState(() {
                            urutanHarga = value;
                          });
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF1F5C5B),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'Terapkan Filter',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _filterChipSheet(
    String label,
    String selected,
    ValueChanged<String> onSelected,
  ) {
    final bool aktif = label == selected;

    return ChoiceChip(
      label: Text(label),
      selected: aktif,
      onSelected: (_) => onSelected(label),
      selectedColor: const Color(0xFF1F5C5B),
      backgroundColor: const Color(0xFFF0F3F2),
      checkmarkColor: Colors.white,
      side: BorderSide.none,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: aktif
            ? Colors.white
            : const Color(0xFF4E5654),
      ),
    );
  }

  Widget kategoriChip(
    String label,
    IconData icon,
  ) {
    final bool aktif = kategoriDipilih == label;

    return ChoiceChip(
      avatar: Icon(
        icon,
        size: 16,
        color: aktif
            ? Colors.white
            : const Color(0xFF4E5654),
      ),
      label: Text(label),
      selected: aktif,
      onSelected: (_) {
        setState(() {
          kategoriDipilih = label;
        });
      },
      selectedColor: const Color(0xFF1F5C5B),
      backgroundColor: const Color(0xFFFFFAF4),
      checkmarkColor: Colors.white,
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: aktif
            ? Colors.white
            : const Color(0xFF4E5654),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Pesanan> menuTampil =
        daftarMenuTampil();

    final int jumlahTersedia =
        hitungMenuTersedia(menuTampil);

    final int jumlahHabis =
        hitungMenuHabis(menuTampil);

    final bool adaPesanan =
        hitungJumlahItem() > 0;

    final int subtotalPesanan =
        hitungSubtotalPesanan();

    final int diskonPesanan =
        hitungDiskonPesanan();

    final int totalAkhir =
        hitungTotalPesanan();

    return Scaffold(
      backgroundColor: const Color(0xFFF3E6D5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F5C5B),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Stack(
          children: [
            Positioned(
              left: -18,
              top: -10,
              child: Transform.rotate(
                angle: -0.35,
                child: Icon(
                  Icons.eco_rounded,
                  size: 78,
                  color: Colors.white.withValues(
                    alpha: 0.07,
                  ),
                ),
              ),
            ),
            Positioned(
              right: -12,
              top: 8,
              child: Transform.rotate(
                angle: 0.3,
                child: Icon(
                  Icons.eco_rounded,
                  size: 68,
                  color: Colors.white.withValues(
                    alpha: 0.06,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 48,
              bottom: -20,
              child: Icon(
                Icons.eco_rounded,
                size: 58,
                color: Colors.white.withValues(
                  alpha: 0.045,
                ),
              ),
            ),
            Positioned(
              left: 52,
              bottom: -24,
              child: Icon(
                Icons.eco_rounded,
                size: 52,
                color: Colors.white.withValues(
                  alpha: 0.04,
                ),
              ),
            ),
          ],
        ),
        title: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Warung Sedap',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                height: 1.1,
              ),
            ),
            SizedBox(height: 3),
            Text(
              'Rasa rumahan, harga bersahabat',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                height: 1,
                color: Color(0xFFD8E8E5),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(
                bottom: adaPesanan ? 150 : 20,
              ),
              children: [
                Container(
                  color: const Color(0xFFF3E6D5),
                  padding: const EdgeInsets.fromLTRB(
                    18,
                    14,
                    18,
                    0,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mau makan apa hari ini?',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF252929),
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'Pilih menu favorit anda dan atur jumlah pesanan.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF727A77),
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 11),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller:
                                  searchController,
                              onChanged: (value) {
                                setState(() {
                                  kataPencarian =
                                      value;
                                });
                              },
                              decoration:
                                  InputDecoration(
                                hintText:
                                    'Cari menu favoritmu...',
                                hintStyle:
                                    const TextStyle(
                                  fontSize: 12,
                                  color:
                                      Color(0xFF9CA3A1),
                                ),
                                prefixIcon:
                                    const Icon(
                                  Icons.search_rounded,
                                  size: 21,
                                  color:
                                      Color(0xFF1F5C5B),
                                ),
                                filled: true,
                                fillColor:
                                    const Color(0xFFFFFCF8),
                                border:
                                    OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                    16,
                                  ),
                                  borderSide:
                                      BorderSide.none,
                                ),
                                contentPadding:
                                    const EdgeInsets
                                        .symmetric(
                                  vertical: 0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 9),
                          Material(
                            color:
                                const Color(0xFFFFFCF8),
                            borderRadius:
                                BorderRadius.circular(15),
                            child: InkWell(
                              borderRadius:
                                  BorderRadius.circular(15),
                              onTap: bukaFilter,
                              child: const SizedBox(
                                width: 50,
                                height: 50,
                                child: Icon(
                                  Icons.tune_rounded,
                                  color:
                                      Color(0xFF1F5C5B),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 7),
                      SingleChildScrollView(
                        scrollDirection:
                            Axis.horizontal,
                        child: Row(
                          children: [
                            kategoriChip(
                              'Semua',
                              Icons.apps_rounded,
                            ),
                            const SizedBox(width: 7),
                            kategoriChip(
                              'Makanan',
                              Icons.restaurant_rounded,
                            ),
                            const SizedBox(width: 7),
                            kategoriChip(
                              'Minuman',
                              Icons.local_drink_rounded,
                            ),
                            const SizedBox(width: 7),
                            kategoriChip(
                              'Camilan',
                              Icons.cookie_rounded,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 7),
                      Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFCF8),
                          borderRadius:
                              BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color(0xFFE9DCCB),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color:
                                    const Color(0xFFE5F0ED),
                                borderRadius:
                                    BorderRadius.circular(9),
                              ),
                              child: const Icon(
                                Icons.restaurant_menu_rounded,
                                size: 15,
                                color:
                                    Color(0xFF1F5C5B),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Menu',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight:
                                    FontWeight.bold,
                                color:
                                    Color(0xFF252929),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '$jumlahTersedia tersedia',
                              style: const TextStyle(
                                fontSize: 11,
                                color:
                                    Color(0xFF1F5C5B),
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              width: 4,
                              height: 4,
                              decoration:
                                  const BoxDecoration(
                                color:
                                    Color(0xFFB4BCBA),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Text(
                              '$jumlahHabis habis',
                              style: const TextStyle(
                                fontSize: 11,
                                color:
                                    Color(0xFF858B8A),
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                if (menuTampil.isEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.fromLTRB(
                      18,
                      55,
                      18,
                      40,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 110,
                          height: 110,
                          decoration:
                              const BoxDecoration(
                            color: Color(0xFFE9EFED),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.search_off_rounded,
                            size: 52,
                            color:
                                Color(0xFF5E7D79),
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Menu tidak ditemukan',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight:
                                FontWeight.bold,
                            color:
                                Color(0xFF252929),
                          ),
                        ),
                        const SizedBox(height: 7),
                        const Text(
                          'Coba gunakan kata kunci atau filter lain.',
                          textAlign:
                              TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color:
                                Color(0xFF858B8A),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  LayoutBuilder(
                    builder:
                        (context, constraints) {
                      int jumlahKolom;

                      if (constraints.maxWidth <
                          600) {
                        jumlahKolom = 1;
                      } else if (constraints
                              .maxWidth <
                          900) {
                        jumlahKolom = 2;
                      } else {
                        jumlahKolom = 3;
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics:
                            const NeverScrollableScrollPhysics(),
                        padding:
                            const EdgeInsets.fromLTRB(
                          18,
                          0,
                          18,
                          20,
                        ),
                        itemCount:
                            menuTampil.length,
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              jumlahKolom,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          mainAxisExtent: 265,
                        ),
                        itemBuilder:
                            (context, index) {
                          final Pesanan pesanan =
                              menuTampil[index];

                          return MenuCard(
                            menu: pesanan.menu,
                            jumlahPesanan:
                                pesanan.jumlah,
                            onTambah: () {
                              tambahPesanan(
                                pesanan,
                              );
                            },
                            onKurang: () {
                              kurangPesanan(
                                pesanan,
                              );
                            },
                            onBatasStok: () {
                              tampilkanPeringatanStok(
                                pesanan,
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
              ],
            ),
          ),
          AnimatedSwitcher(
            duration:
                const Duration(milliseconds: 250),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: adaPesanan
                ? Padding(
                    key: const ValueKey(
                      'total-pesanan',
                    ),
                    padding:
                        const EdgeInsets.fromLTRB(
                      14,
                      0,
                      14,
                      14,
                    ),
                    child: Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.fromLTRB(
                        15,
                        12,
                        15,
                        12,
                      ),
                      decoration: BoxDecoration(
                        color:
                            const Color(0xFF1F5C5B),
                        borderRadius:
                            BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 16,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration:
                                    BoxDecoration(
                                  color: Colors.white
                                      .withValues(
                                    alpha: 0.15,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons
                                      .receipt_long_rounded,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Text(
                                  'Ringkasan Pesanan',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight:
                                        FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration:
                                    BoxDecoration(
                                  color: Colors.white
                                      .withValues(
                                    alpha: 0.12,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(
                                    12,
                                  ),
                                ),
                                child: Text(
                                  '${hitungJumlahItem()} item',
                                  style:
                                      const TextStyle(
                                    fontSize: 10,
                                    fontWeight:
                                        FontWeight.w600,
                                    color:
                                        Color(0xFFDCEBE8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,
                            children: [
                              const Text(
                                'Subtotal',
                                style: TextStyle(
                                  fontSize: 11,
                                  color:
                                      Color(0xFFCDE0DC),
                                ),
                              ),
                              Text(
                                'Rp${formatRupiah(subtotalPesanan)}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,
                            children: [
                              Text(
                                diskonPesanan > 0
                                    ? 'Diskon 10%'
                                    : 'Diskon 10% mulai 5 porsi',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: diskonPesanan > 0
                                      ? const Color(
                                          0xFFFFD7C8,
                                        )
                                      : const Color(
                                          0xFFCDE0DC,
                                        ),
                                ),
                              ),
                              Text(
                                diskonPesanan > 0
                                    ? '-Rp${formatRupiah(diskonPesanan)}'
                                    : 'Rp0',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight:
                                      FontWeight.w600,
                                  color: diskonPesanan > 0
                                      ? const Color(
                                          0xFFFFD7C8,
                                        )
                                      : const Color(
                                          0xFFCDE0DC,
                                        ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 1,
                            color: Colors.white
                                .withValues(
                              alpha: 0.12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,
                            children: [
                              const Text(
                                'Total Pesanan',
                                style: TextStyle(
                                  fontSize: 11,
                                  color:
                                      Color(0xFFCDE0DC),
                                ),
                              ),
                              Text(
                                'Rp${formatRupiah(totalAkhir)}',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight:
                                      FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(
                    key: ValueKey(
                      'tanpa-total',
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}