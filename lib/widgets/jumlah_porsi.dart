import 'package:flutter/material.dart';

class JumlahPorsi extends StatefulWidget {
  final int jumlah;
  final bool bisaTambah;
  final bool aktif;
  final VoidCallback onTambah;
  final VoidCallback onKurang;
  final VoidCallback? onBatasStok;

  const JumlahPorsi({
    super.key,
    required this.jumlah,
    required this.bisaTambah,
    required this.aktif,
    required this.onTambah,
    required this.onKurang,
    this.onBatasStok,
  });

  @override
  State<JumlahPorsi> createState() => _JumlahPorsiState();
}

class _JumlahPorsiState extends State<JumlahPorsi> {
  late int jumlah;

  @override
  void initState() {
    super.initState();
    jumlah = widget.jumlah;
  }

  @override
  void didUpdateWidget(covariant JumlahPorsi oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.jumlah != oldWidget.jumlah &&
        widget.jumlah != jumlah) {
      jumlah = widget.jumlah;
    }
  }

  void tambah() {
    if (!widget.aktif) {
      return;
    }

    if (!widget.bisaTambah) {
      widget.onBatasStok?.call();
      return;
    }

    setState(() {
      jumlah++;
    });

    widget.onTambah();
  }

  void kurang() {
    if (!widget.aktif || jumlah == 0) {
      return;
    }

    setState(() {
      jumlah--;
    });

    widget.onKurang();
  }

  @override
  Widget build(BuildContext context) {
    final Color warna = widget.aktif
        ? const Color(0xFF1F5C5B)
        : const Color(0xFFB6BCBA);

    return Container(
      height: 34,
      decoration: BoxDecoration(
        color: const Color(0xFFEAF0EF),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: widget.aktif && jumlah > 0
                ? kurang
                : null,
            borderRadius: BorderRadius.circular(17),
            child: SizedBox(
              width: 32,
              height: 34,
              child: Icon(
                Icons.remove_rounded,
                size: 17,
                color: widget.aktif && jumlah > 0
                    ? warna
                    : const Color(0xFFB6BCBA),
              ),
            ),
          ),
          SizedBox(
            width: 25,
            child: Text(
              '$jumlah',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: warna,
              ),
            ),
          ),
          InkWell(
            onTap: widget.aktif ? tambah : null,
            borderRadius: BorderRadius.circular(17),
            child: SizedBox(
              width: 32,
              height: 34,
              child: Icon(
                Icons.add_rounded,
                size: 17,
                color: widget.aktif
                    ? warna
                    : const Color(0xFFB6BCBA),
              ),
            ),
          ),
        ],
      ),
    );
  }
}