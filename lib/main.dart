import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  List<Map> _mazeretler = [];

  Future<void> _veriGetir() async {
    // Daha detaylı kullanım için => https://excuser.herokuapp.com/

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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (final mazeret in _mazeretler)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
