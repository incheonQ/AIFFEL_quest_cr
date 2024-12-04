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
      title: '레시피 챗봇',
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

  Future<void> _sendQuestion() async {
    final question = _questionController.text;
    final cuisine = _cuisineController.text;

    final response = await http.post(
      Uri.parse('https://5459-222-239-25-12.ngrok-free.app/chat'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'question': question, 'cuisine': cuisine}),
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
        title: Text('레시피 챗봇'),
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
