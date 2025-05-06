import 'package:flutter/material.dart';
import 'database_helper.dart';

void main() {
  runApp(DictionaryApp());
}

class DictionaryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dictionary App',
      debugShowCheckedModeBanner: false,
      home: DictionaryScreen(),
    );
  }
}

class DictionaryScreen extends StatefulWidget {
  @override
  _DictionaryScreenState createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  final TextEditingController _controller = TextEditingController();
  String _result = '';
  List<String> _suggestions = [];

  void _lookup() async {
    final input = _controller.text.trim();
    if (input.isEmpty) return;

    final dbHelper = DatabaseHelper();
    final word = await dbHelper.getDefinition(input);

    setState(() {
      _suggestions.clear();
    });

    if (word != null) {
      setState(() {
        _result = '${word['word']}: ${word['definition']}';
      });
    } else {
      final similar = await dbHelper.getSimilarWords(input);
      setState(() {
        _result = 'Word not found. You might be looking for these words?';
        _suggestions = similar.map((e) => e['word'] as String).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dictionary')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _controller, decoration: InputDecoration(labelText: 'Enter a word')),
            SizedBox(height: 10),
            ElevatedButton(onPressed: _lookup, child: Text('LOOKUP')),
            SizedBox(height: 20),
            Text(_result, style: TextStyle(fontSize: 18)),
            ..._suggestions.map((word) => Text('- $word')).toList()
          ],
        ),
      ),
    );
  }
}
