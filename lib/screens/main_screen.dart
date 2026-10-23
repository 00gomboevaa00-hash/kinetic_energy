import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/main_screen_cubit.dart';
import 'cubit/main_screen_state.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
        title: const Text('Гомбоева Долгор Пурбожаповна'), // Замени на свое ФИО
        centerTitle: true,
      ),
      body: BlocConsumer<MainScreenCubit, MainScreenState>(
        listener: (context, state) {
          if (state is MainScreenErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is MainScreenResultState) {
            return _buildResultScreen(context, state);
          }
          return _buildInputForm(context);
        },
      ),
    );
  }

  Widget _buildInputForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          const Text('Масса тела (кг):', style: TextStyle(fontSize: 20.0)),
          TextFormField(controller: _massController, keyboardType: TextInputType.number),
          const SizedBox(height: 20.0),
          const Text('Скорость (м/с):', style: TextStyle(fontSize: 20.0)),
          TextFormField(controller: _velocityController, keyboardType: TextInputType.number),
          const SizedBox(height: 20.0),
          CheckboxListTile(
            value: _agreement,
            title: const Text('Согласен на обработку данных'),
            onChanged: (bool? value) {
              setState(() { _agreement = value!; });
            },
          ),
          ElevatedButton(
            onPressed: () {
              context.read<MainScreenCubit>().calculateEnergy(
                massStr: _massController.text,
                velocityStr: _velocityController.text,
                agreement: _agreement,
              );
            },
            child: const Text('Рассчитать'),
          ),
        ],
      ),
    );
  }

  Widget _buildResultScreen(BuildContext context, MainScreenResultState state) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Кинетическая энергия: ${state.energy.toStringAsFixed(2)} Дж',
            style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20.0),
          Text('Масса: ${state.mass} кг, Скорость: ${state.velocity} м/с'),
          const SizedBox(height: 30.0),
          ElevatedButton(
            onPressed: () {
              _massController.clear();
              _velocityController.clear();
              setState(() { _agreement = false; });
              context.read<MainScreenCubit>().reset();
            },
            child: const Text('Назад'),
          ),
        ],
      ),
    );
  }
}