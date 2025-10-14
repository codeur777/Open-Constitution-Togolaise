import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HelloPage(),
    );
  }
}

class HelloPage extends StatefulWidget {
  const HelloPage({super.key});

  @override
  State<HelloPage> createState() => _HelloPageState();
}

class _HelloPageState extends State<HelloPage> {
  String message = "Chargement...";

  Future<void> fetchHello() async {
    final response = await http.get(Uri.parse("http://192.168.1.67:8080/hello"));
    if (response.statusCode == 200) {
      setState(() {
        message = response.body;
      });
    } else {
      setState(() {
        message = "Erreur ${response.statusCode}";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchHello();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
          title: const Text("Hello App")),
      body: Center(
        child: Text(
          message,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
