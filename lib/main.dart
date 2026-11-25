import 'package:material_ui/material_ui.dart';

void main() {
  runApp(const CounterApp());
}

class CounterApp extends StatelessWidget {
  const CounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Лабораторна робота №1',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const CounterPage(),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  static const String _resetCommand = 'Avada Kedavra';

  final TextEditingController _controller = TextEditingController();
  int _counter = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleInput() {
    final String raw = _controller.text;

    if (raw == _resetCommand) {
      setState(() {
        _counter = 0;
      });
      _controller.clear();
      return;
    }

    final int? value = int.tryParse(raw.trim());

    if (value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Введіть ціле число або команду "Avada Kedavra"'),
        ),
      );
      return;
    }

    setState(() {
      _counter += value;
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Лічильник')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('$_counter', style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 32),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Введіть число або команду',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _handleInput(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _handleInput,
              child: const Text('Застосувати'),
            ),
          ],
        ),
      ),
    );
  }
}
