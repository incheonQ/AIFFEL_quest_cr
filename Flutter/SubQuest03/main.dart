import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'aiffel_quest',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FirstPage(),
    );
  }
}

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  bool is_cat = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          decoration: BoxDecoration(
            border: Border(right: BorderSide(color: Colors.black, width: 1)),
          ),
          child: Image.asset('images/cat_icon.png'),
        ),
        title: Text('First Page'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: Colors.black,
            height: 1.0,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Next'),
              onPressed: () {
                setState(() {
                  is_cat = false;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SecondPage(is_cat: is_cat),
                  ),
                ).then((value) {
                  if (value != null) {
                    setState(() {
                      is_cat = value;
                    });
                  }
                });
                print('DEBUG CONSOLE: is_cat = $is_cat');
              },
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                print('DEBUG CONSOLE: is_cat = $is_cat');
              },
              child: Image.asset(
                'images/cat.png',
                width: 300,
                height: 300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  final bool is_cat;

  SecondPage({required this.is_cat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          decoration: BoxDecoration(
            border: Border(right: BorderSide(color: Colors.black, width: 1)),
          ),
          child: Image.asset('images/dog_icon.png'),
        ),
        title: Text('Second Page'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: Colors.black,
            height: 1.0,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Back'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                print('DEBUG CONSOLE: is_cat = $is_cat');
              },
              child: Image.asset(
                'images/dog.png',
                width: 300,
                height: 300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
