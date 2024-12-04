import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '요리사 챗봇',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _cuisineController = TextEditingController();
  String _response = '';
  double _temperature = 0.1;
  bool _useRAG = false;

  Future<void> _sendQuestion() async {
    final question = _questionController.text;
    final cuisine = _cuisineController.text;

    final response = await http.post(
      Uri.parse('https://5459-222-239-25-12.ngrok-free.app/chat'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'question': question,
        'cuisine': cuisine,
        'temperature': _temperature,
        'RAG': _useRAG,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        // UTF-8로 디코딩하여 응답을 처리
        _response = utf8.decode(response.bodyBytes);
      });
    } else {
      setState(() {
        _response = '오류 발생: ${response.statusCode}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('백종원 챗봇'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _questionController,
              decoration: InputDecoration(labelText: '질문을 입력하세요'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _cuisineController,
              decoration: InputDecoration(labelText: '요리 종류를 입력하세요'),
            ),
            SizedBox(height: 10),
            Text(
              'Temperature: ${_temperature.toStringAsFixed(1)}',
              style: TextStyle(fontSize: 16),
            ),
            Slider(
              value: _temperature,
              min: 0.0,
              max: 1.0,
              divisions: 10,
              label: _temperature.toStringAsFixed(1),
              onChanged: (value) {
                setState(() {
                  _temperature = value;
                });
              },
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Wiki RAG 사용'),
                Switch(
                  value: _useRAG,
                  onChanged: (value) {
                    setState(() {
                      _useRAG = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _sendQuestion,
              child: Text('질문하기'),
            ),
            SizedBox(height: 20),
            // 응답을 더 깔끔하게 출력
            Text(
              '응답:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              _response,
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }
}
