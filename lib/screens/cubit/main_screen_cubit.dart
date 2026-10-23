import 'package:flutter_bloc/flutter_bloc.dart';
import 'main_screen_state.dart';

class MainScreenCubit extends Cubit<MainScreenState> {
  MainScreenCubit() : super(MainScreenInitialState());

  void calculateEnergy({
    required String massStr,
    required String velocityStr,
    required bool agreement,
  }) {
    if (massStr.isEmpty || velocityStr.isEmpty) {
      emit(MainScreenErrorState('Заполните все поля!'));
      return;
    }

    if (!agreement) {
      emit(MainScreenErrorState('Поставьте галочку согласия!'));
      return;
    }

    double? mass = double.tryParse(massStr);
    double? velocity = double.tryParse(velocityStr);

    if (mass == null || velocity == null) {
      emit(MainScreenErrorState('Введите корректные числа!'));
      return;
    }

    if (mass <= 0) {
      emit(MainScreenErrorState('Масса должна быть больше 0!'));
      return;
    }

    double energy = (mass * velocity * velocity) / 2;

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