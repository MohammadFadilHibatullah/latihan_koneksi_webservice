import 'package:flutter/material.dart'; // Import modul flutter material untuk membangun UI.
import 'package:http/http.dart'
    as http; // Import modul http untuk melakukan request HTTP.
import 'dart:convert'; // Import modul json untuk melakukan parsing JSON.

// Deklarasi class University untuk merepresentasikan data universitas.
class University {
  String name; // Nama universitas.
  String website; // Situs web universitas.

  // Konstruktor untuk inisialisasi objek University.
  University({required this.name, required this.website});
}

// Deklarasi class MyApp sebagai widget Stateful.
class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState(); // Membuat instance dari MyAppState.
  }
}

// Deklarasi class MyAppState sebagai state dari MyApp.
class MyAppState extends State<MyApp> {
  late Future<List<University>>
      futureUniversities; // Future untuk menyimpan hasil request universitas.

  String url =
      "http://universities.hipolabs.com/search?country=Indonesia"; // URL API untuk mendapatkan data universitas Indonesia.

  // Method untuk melakukan request data universitas.
  Future<List<University>> fetchUniversities() async {
    final response = await http.get(Uri.parse(url)); // Melakukan request HTTP.

    if (response.statusCode == 200) {
      // Jika response berhasil (status code 200).
      List<dynamic> data = json.decode(response.body); // Parsing JSON response.
      List<University> universities =
          []; // List untuk menyimpan data universitas.

      // Iterasi data JSON untuk membuat objek University dan menambahkannya ke dalam list universities.
      for (var item in data) {
        universities.add(
          University(
            name: item['name'], // Mendapatkan nama universitas.
            website: item['web_pages']
                [0], // Mendapatkan situs web pertama universitas.
          ),
        );
      }

      return universities; // Mengembalikan list universitas.
    } else {
      throw Exception('Gagal load'); // Jika request gagal, lemparkan exception.
    }
  }

  @override
  void initState() {
    super.initState();
    futureUniversities =
        fetchUniversities(); // Memanggil method fetchUniversities() saat inisialisasi state.
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Universities App', // Judul aplikasi.
      home: Scaffold(
        appBar: AppBar(
          title: Text('Universitas Indonesia'), // Judul AppBar.
        ),
        body: FutureBuilder<List<University>>(
          future:
              futureUniversities, // Future yang diharapkan akan menghasilkan list universitas.
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Jika sedang dalam proses fetching data.
              return Center(
                child:
                    CircularProgressIndicator(), // Tampilkan indikator loading.
              );
            } else if (snapshot.hasError) {
              // Jika terjadi error saat fetching data.
              return Center(
                child: Text('${snapshot.error}'), // Tampilkan pesan error.
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              // Jika tidak ada data atau data kosong.
              return Center(
                child: Text(
                    'No data available'), // Tampilkan pesan bahwa tidak ada data.
              );
            } else {
              // Jika data berhasil diambil.
              return ListView.separated(
                shrinkWrap:
                    true, // Agar ListView hanya menggunakan ruang yang diperlukan.
                itemCount: snapshot.data!.length, // Jumlah item dalam ListView.
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(), // Widget pembatas antar item ListView.
                itemBuilder: (context, index) {
                  // Builder untuk setiap item dalam ListView.
                  return ListTile(
                    title: Text(snapshot
                        .data![index].name), // Judul item: nama universitas.
                    subtitle: Text(snapshot.data![index]
                        .website), // Subtitle item: situs web universitas.
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

// Fungsi main untuk menjalankan aplikasi.
void main() {
  runApp(MyApp());
}
