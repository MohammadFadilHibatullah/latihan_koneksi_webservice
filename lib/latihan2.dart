import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http; // Import paket http untuk melakukan request HTTP.
import 'dart:convert'; // Import paket dart:convert untuk mengubah data JSON menjadi objek Dart.

void main() {
  runApp(const MyApp());
}

// Class Activity digunakan untuk menampung data hasil pemanggilan API.
class Activity {
  String aktivitas; // Atribut untuk menampung aktivitas.
  String jenis; // Atribut untuk menampung jenis aktivitas.

  // Constructor untuk membuat objek Activity dengan nilai awal.
  Activity({required this.aktivitas, required this.jenis});

  // Factory method untuk membuat objek Activity dari JSON.
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      aktivitas: json['activity'], // Mengambil nilai 'activity' dari JSON.
      jenis: json['type'], // Mengambil nilai 'type' dari JSON.
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  late Future<Activity>
      futureActivity; // Variabel untuk menampung hasil pemanggilan API.

  //late Future<Activity>? futureActivity; // Variabel alternatif jika tidak menggunakan metode initState.
  String url = "https://www.boredapi.com/api/activity"; // URL endpoint API.

  // Metode untuk menginisialisasi futureActivity dengan nilai awal.
  Future<Activity> init() async {
    return Activity(aktivitas: "", jenis: "");
  }

  // Metode untuk melakukan request HTTP dan mendapatkan data aktivitas dari API.
  Future<Activity> fetchData() async {
    final response =
        await http.get(Uri.parse(url)); // Melakukan request GET ke URL.
    if (response.statusCode == 200) {
      // Jika server mengembalikan status code 200 (OK),
      // parse JSON dan buat objek Activity dari respons.
      return Activity.fromJson(jsonDecode(response.body));
    } else {
      // Jika request gagal, lempar exception.
      throw Exception('Gagal load');
    }
  }

  @override
  void initState() {
    super.initState();
    futureActivity =
        init(); // Memanggil metode init() saat initState dipanggil.
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  futureActivity =
                      fetchData(); // Memanggil metode fetchData() saat tombol ditekan.
                });
              },
              child: Text("Saya bosan ..."),
            ),
          ),
          FutureBuilder<Activity>(
            future:
                futureActivity, // Menyediakan future yang akan digunakan oleh FutureBuilder.
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Jika future mengandung data,
                // tampilkan data aktivitas dan jenis.
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Text(snapshot.data!.aktivitas), // Tampilkan aktivitas.
                      Text(
                          "Jenis: ${snapshot.data!.jenis}") // Tampilkan jenis aktivitas.
                    ]));
              } else if (snapshot.hasError) {
                // Jika terjadi error dalam future,
                // tampilkan pesan error.
                return Text('${snapshot.error}');
              }
              // Jika future masih dalam proses loading,
              // tampilkan indikator loading.
              return const CircularProgressIndicator();
            },
          ),
        ]),
      ),
    ));
  }
}
