import 'package:equatable/equatable.dart';
import '../../models/kinetic_record.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();
  @override
  List<Object?> get props => [];
}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<KineticRecord> items;
  const HistoryLoaded(this.items);
  @override
  List<Object?> get props => [items];
}

class HistoryError extends HistoryState {
  final String message;
  const HistoryError(this.message);
  @override
  List<Object?> get props => [message];
}