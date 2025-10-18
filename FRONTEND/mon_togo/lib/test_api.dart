import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() => runApp(const MaterialApp(home: TestAPI()));

class TestAPI extends StatefulWidget {
  const TestAPI({super.key});

  @override
  State<TestAPI> createState() => _TestAPIState();
}

class _TestAPIState extends State<TestAPI> {
  String result = "En attente...";

  Future<void> testConnection() async {
    try {
      var response = await Dio().post(
        'http://192.168.1.67:8081/api/chat',
        data: {"content": "Bonjour"},
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );
      setState(() {
        result = response.data.toString();
      });
    } catch (e) {
      setState(() {
        result = "Erreur : $e";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    testConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test API")),
      body: Center(child: Text(result)),
    );
  }
}
