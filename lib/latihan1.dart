import 'dart:convert'; // Library untuk mengonversi JSON menjadi objek Dart.
import 'package:flutter/material.dart'; // Library untuk membuat UI menggunakan Flutter.

void main() {
  runApp(MyApp()); // Memulai aplikasi Flutter.
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transkrip Mahasiswa', // Judul aplikasi.
      home: TranskripMahasiswaPage(), // Halaman utama aplikasi.
    );
  }
}

class TranskripMahasiswaPage extends StatefulWidget {
  @override
  _TranskripMahasiswaPageState createState() => _TranskripMahasiswaPageState();
}

class _TranskripMahasiswaPageState extends State<TranskripMahasiswaPage> {
  // Variabel JSON transkrip yang akan digunakan.
  String jsonTranskrip = '''
  {
    "mahasiswa": {
      "nama": "Mohammad Fadil Hibatullah",
      "nim" : "22082010001",
      "program_studi": "Sistem Informasi",
      "transkrip": [
        {
          "mata_kuliah": "Pemrograman Mobile",
          "sks": 3,
          "nilai": "A"
        },
        {
          "mata_kuliah": "Pemrograman Web",
          "sks": 4,
          "nilai": "A"
        },
        {
          "mata_kuliah": "Statistik Komputasi",
          "sks": 4,
          "nilai": "A"
        },
        {
          "mata_kuliah": "Kecakapan Pribadi",
          "sks": 3,
          "nilai": "A"
        },
        {
          "mata_kuliah": "Basis Data",
          "sks": 3,
          "nilai": "A"
        }
      ]
    }
  }
  ''';

  // Variabel untuk menyimpan data transkrip, daftar mata kuliah, total SKS, dan total bobot nilai.
  Map<String, dynamic> transkrip = {};
  List<Map<String, dynamic>> daftarMataKuliah = [];
  double totalSKS = 0;
  double totalBobot = 0;

  @override
  void initState() {
    super.initState();
    // Mendekode JSON transkrip menjadi objek Dart.
    transkrip = jsonDecode(jsonTranskrip);
    // Mendapatkan daftar mata kuliah dari transkrip dan mengonversinya menjadi list map.
    daftarMataKuliah = (transkrip['mahasiswa']['transkrip'] as List)
        .cast<Map<String, dynamic>>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transkrip Mahasiswa'), // Judul AppBar.
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0), // Padding untuk body.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Informasi Mahasiswa', // Label informasi mahasiswa.
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8), // Spasi vertical.
            // Menampilkan nama mahasiswa.
            Text('Nama                  : ${transkrip['mahasiswa']['nama']}'),
            // Menampilkan NIM mahasiswa.
            Text('NIM                     : ${transkrip['mahasiswa']['nim']}'),
            // Menampilkan program studi mahasiswa.
            Text(
                'Program Studi   : ${transkrip['mahasiswa']['program_studi']}'),
            SizedBox(height: 16), // Spasi vertical.
            Text(
              'Data Transkrip Mahasiswa', // Label data transkrip mahasiswa.
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16), // Spasi vertical.
            // Loop untuk menampilkan daftar mata kuliah.
            for (var mataKuliah in daftarMataKuliah)
              ListTile(
                title: Text('Mata Kuliah: ${mataKuliah['mata_kuliah']}'),
                subtitle: Text(
                    'SKS: ${mataKuliah['sks']}, Nilai: ${mataKuliah['nilai']}'),
              ),
            SizedBox(height: 16), // Spasi vertical.
            // Button untuk menghitung IPK.
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('IPK'), // Judul AlertDialog.
                      content: Text(
                          'IPK Anda adalah: ${hitungIPK().toStringAsFixed(2)}'), // Isi AlertDialog.
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Menutup AlertDialog.
                          },
                          child: Text('OK'), // Tombol OK.
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Hitung IPK'), // Label tombol.
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk menghitung IPK.
  double hitungIPK() {
    // Loop untuk menghitung total SKS dan total bobot nilai.
    for (var mataKuliah in daftarMataKuliah) {
      int sks = mataKuliah['sks']; // Mendapatkan SKS dari mata kuliah.
      String nilai = mataKuliah['nilai']; // Mendapatkan nilai dari mata kuliah.

      // Mengonversi nilai menjadi bobot.
      double bobot = konversiNilaiKeBobot(nilai);
      // Menambah total SKS.
      totalSKS += sks;
      // Menambah total bobot.
      totalBobot += bobot * sks;
    }

    // Menghitung IPK.
    double ipk = totalBobot / totalSKS;
    return ipk; // Mengembalikan nilai IPK.
  }

  // Fungsi untuk mengonversi nilai menjadi bobot.
  double konversiNilaiKeBobot(String nilai) {
    switch (nilai) {
      case 'A':
        return 4.0;
      case 'A-':
        return 3.7;
      case 'B+':
        return 3.3;
      case 'B':
        return 3.0;
      case 'B-':
        return 2.7;
      case 'C+':
        return 2.3;
      case 'C':
        return 2.0;
      case 'C-':
        return 1.7;
      case 'D':
        return 1.0;
      default:
        return 0.0;
    }
  }
}
