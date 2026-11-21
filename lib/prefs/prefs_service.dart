import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static const _kMass = 'last_mass';
  static const _kVelocity = 'last_velocity';

  Future<void> saveLast({required double mass, required double velocity}) async {
    final p = await SharedPreferences.getInstance();
    await p.setDouble(_kMass, mass);
    await p.setDouble(_kVelocity, velocity);
  }

  Future<({double? mass, double? velocity})> loadLast() async {
    final p = await SharedPreferences.getInstance();
    return (mass: p.getDouble(_kMass), velocity: p.getDouble(_kVelocity));
  }

  Future<void> clear() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_kMass);
    await p.remove(_kVelocity);
  }
}