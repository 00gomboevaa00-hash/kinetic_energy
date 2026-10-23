abstract class MainScreenState {}

class MainScreenInitialState extends MainScreenState {}

class MainScreenResultState extends MainScreenState {
  final double mass;
  final double velocity;
  final double energy;

  MainScreenResultState({
    required this.mass,
    required this.velocity,
    required this.energy,
  });
}

class MainScreenErrorState extends MainScreenState {
  final String message;
  MainScreenErrorState(this.message);
}