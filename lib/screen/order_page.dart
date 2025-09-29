import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodapp/model/menu_models.dart';

class OrderPage extends StatefulWidget {
  final Menu menu;

  const OrderPage({super.key, required this.menu});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final TextEditingController _quantityController = TextEditingController();
  int _totalPrice = 0;

  @override
  void initState() {
    super.initState();
    // Menambahkan listener untuk mendeteksi perubahan pada TextField
    _quantityController.addListener(_calculateTotalPrice);
  }

  void _calculateTotalPrice() {
    // Ambil jumlah dari textfield, jika kosong anggap 0
    int quantity = int.tryParse(_quantityController.text) ?? 0;
    setState(() {
      _totalPrice = widget.menu.price * quantity;
    });
  }

  @override
  void dispose() {
    // Hapus listener untuk mencegah memory leak
    _quantityController.removeListener(_calculateTotalPrice);
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pesanan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gambar dan Detail Makanan
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(widget.menu.imageUrl),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          widget.menu.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Harga: Rp ${widget.menu.price}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Input Jumlah Pesanan
            TextField(
              controller: _quantityController,
              decoration: const InputDecoration(
                labelText: 'Masukkan Jumlah',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly // Hanya izinkan angka
              ],
            ),
            const SizedBox(height: 32),

            // Tombol Pesan (Contoh)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                // Logika untuk aksi pesan, misalnya tampilkan dialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Pesanan Berhasil'),
                    content: Text('Anda memesan ${widget.menu.name} sebanyak ${_quantityController.text} porsi.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                );
              },
              child: const Text('Pesan Sekarang'),
            ),
            const SizedBox(height: 24),

            // Tampilan Total Harga
            Text(
              'Total Harga: Rp $_totalPrice',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}