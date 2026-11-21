import 'package:flutter_bloc/flutter_bloc.dart';
import '../../db/db_provider.dart';
import '../../models/kinetic_record.dart';
import '../../prefs/prefs_service.dart';
import 'main_screen_state.dart';

class MainScreenCubit extends Cubit<MainScreenState> {
  MainScreenCubit() : super(MainScreenInitialState());

  Future<void> calculateEnergy({
    required String massStr,
    required String velocityStr,
    required bool agreement,
  }) async {
    if (massStr.isEmpty || velocityStr.isEmpty) {
      emit(MainScreenErrorState('Заполните все поля!'));
      return;
    }

    if (!agreement) {
      emit(MainScreenErrorState('Поставьте галочку согласия!'));
      return;
    }

    final double? mass = double.tryParse(massStr);
    final double? velocity = double.tryParse(velocityStr);

    if (mass == null || velocity == null) {
      emit(MainScreenErrorState('Введите корректные числа!'));
      return;
    }

    if (mass <= 0) {
      emit(MainScreenErrorState('Масса должна быть больше 0!'));
      return;
    }

    final double energy = (mass * velocity * velocity) / 2;

    try {
      await DBProvider.db.insert(KineticRecord(
        mass: mass,
        velocity: velocity,
        energy: energy,
        createdAt: DateTime.now(),
      ));
      await PrefsService().saveLast(mass: mass, velocity: velocity);
    } catch (e) {
      // ignore: avoid_print
      print('Save error: $e');
    }

    emit(MainScreenResultState(
      mass: mass,
      velocity: velocity,
      energy: energy,
    ));
  }

  void reset() {
    emit(MainScreenInitialState());
  }
}