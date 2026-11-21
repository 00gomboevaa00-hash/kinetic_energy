import 'package:flutter_bloc/flutter_bloc.dart';
import '../../db/db_provider.dart';
import 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(HistoryLoading());

  Future<void> load() async {
    emit(HistoryLoading());
    try {
      final items = await DBProvider.db.getAll();
      emit(HistoryLoaded(items));
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }

  Future<void> delete(int id) async {
    await DBProvider.db.delete(id);
    await load();
  }
}