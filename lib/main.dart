import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Кинетическая энергия',
      home: const FirstScreen(),
    );
  }
}

// ==================== ПЕРВЫЙ ЭКРАН ====================
class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final _formKey = GlobalKey<FormState>();
  final _massController = TextEditingController();
  final _velocityController = TextEditingController();
  bool _agreement = false;

  @override
  void dispose() {
    _massController.dispose();
    _velocityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Гомбоева Долгор Пурбожаповна'), // Замените на своё ФИО
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const Text(
                'Масса тела (кг):',
                style: TextStyle(fontSize: 20.0),
              ),
              TextFormField(
                controller: _massController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Введите массу';
                  if (double.tryParse(value) == null) return 'Введите число';
                  if (double.parse(value) <= 0) return 'Масса > 0';
                  return null;
                },
              ),
              const SizedBox(height: 20.0),

              const Text(
                'Скорость (м/с):',
                style: TextStyle(fontSize: 20.0),
              ),
              TextFormField(
                controller: _velocityController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Введите скорость';
                  if (double.tryParse(value) == null) return 'Введите число';
                  return null;
                },
              ),
              const SizedBox(height: 20.0),

              CheckboxListTile(
                value: _agreement,
                title: const Text('Согласен на обработку данных'),
                onChanged: (bool? value) {
                  setState(() {
                    _agreement = value!;
                  });
                },
              ),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (!_agreement) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Поставьте галочку согласия'),
                        ),
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SecondScreen(
                          mass: double.parse(_massController.text),
                          velocity: double.parse(_velocityController.text),
                        ),
                      ),
                    );
                  }
                },
                child: const Text('Рассчитать'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== ВТОРОЙ ЭКРАН ====================
class SecondScreen extends StatelessWidget {
  final double mass;
  final double velocity;

  const SecondScreen({super.key, required this.mass, required this.velocity});

  @override
  Widget build(BuildContext context) {
    double energy = (mass * velocity * velocity) / 2;

    return Scaffold(
      appBar: AppBar(title: const Text('Результат')),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Text(
              'Кинетическая энергия: $energy Дж',
              style: const TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Назад'),
            ),
          ],
        ),
      ),
    );
  }
}