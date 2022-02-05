import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:translator/translator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MazerApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'MazerApp Anasayfa'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final translator = GoogleTranslator();
  List<Map> _mazeretler = [];

  String _cevirilmisMetin = "";

  Future<void> _veriGetir() async {
    // Daha detaylı kullanım için => https://excuser.herokuapp.com/

    _cevirilmisMetin = "";
    _mazeretler = [];
    setState(() {});

    final cevap = await get(
      Uri(
        host: "excuser.herokuapp.com",
        scheme: "https",
        pathSegments: ["v1", "excuse"],
      ),
    );

    // JSON =>
    _mazeretler = (jsonDecode(cevap.body) as List).cast();

    setState(() {});
  }

  @override
  void initState() {
    _veriGetir();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: _veriGetir,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _mazeretler.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: <Widget>[
                for (final mazeret in _mazeretler)
                  Column(
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("category: ${mazeret['category']}"),
                                Text(
                                  mazeret['excuse'],
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (_cevirilmisMetin.isNotEmpty)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(
                                _cevirilmisMetin,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_mazeretler.isNotEmpty) {
            final mazeret = _mazeretler.first;

            translator.translate(mazeret['excuse'], to: 'tr').then((ceviri) {
              _cevirilmisMetin = ceviri.text;
              setState(() {});
            });
          }
        },
        tooltip: 'Translate',
        child: const Icon(Icons.translate),
      ),
    );
  }
}
