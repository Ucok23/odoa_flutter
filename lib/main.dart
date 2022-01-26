import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Ayah> fetchAyah() async {
  final response = await http.get(Uri.parse('https://odoa.herokuapp.com/'));

  if (response.statusCode == 200) {
    return Ayah.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load ayah');
  }
}

class Ayah {
  final String nameOfSurah;
  final int numberOfAyah;
  final String arabText;
  final String idTranslation;

  const Ayah({
    required this.nameOfSurah,
    required this.numberOfAyah,
    required this.arabText,
    required this.idTranslation,
  });

  factory Ayah.fromJson(Map<String, dynamic> dataJson) {
    var json = dataJson['data'];
    return Ayah(
      nameOfSurah: json['nameOfSurah']['transliteration']['id'] as String,
      numberOfAyah: json['numberOfAyah'] as int,
      arabText: json['ayah']['text']['arab'],
      idTranslation: json['ayah']['translation']['id'] as String,
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Ayah> futureAyah;

  @override
  void initState() {
    super.initState();
    futureAyah = fetchAyah();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('One Day One Ayah'),
        ),
        body: Center(
          child: FutureBuilder<Ayah>(
            future: futureAyah,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.arabText);
              } else if (snapshot.hasError) {
                return Text('${snapshot.hasError}');
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
