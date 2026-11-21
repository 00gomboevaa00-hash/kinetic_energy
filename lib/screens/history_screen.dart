import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/history_cubit.dart';
import 'cubit/history_state.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HistoryCubit()..load(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('История расчётов'),
          centerTitle: true,
        ),
        body: BlocBuilder<HistoryCubit, HistoryState>(
          builder: (context, state) {
            if (state is HistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is HistoryError) {
              return Center(child: Text('Ошибка: ${state.message}'));
            }
            final items = (state as HistoryLoaded).items;
            if (items.isEmpty) {
              return const Center(child: Text('Пока пусто'));
            }
            return ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, _) => const Divider(),
              itemBuilder: (context, i) {
                final r = items[i];
                return ListTile(
                  title: Text('E = ${r.energy.toStringAsFixed(2)} Дж'),
                  subtitle: Text(
                      'm = ${r.mass} кг, v = ${r.velocity} м/с\n${r.createdAt.toString().substring(0, 19)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () =>
                        context.read<HistoryCubit>().delete(r.id!),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}