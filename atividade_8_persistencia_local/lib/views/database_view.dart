import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/database_viewmodel.dart';
import '../widgets/task_list_widget.dart';
import '../widgets/task_input_widget.dart';

class DatabaseView extends StatefulWidget {
  const DatabaseView({Key? key}) : super(key: key);

  @override
  State<DatabaseView> createState() => _DatabaseViewState();
}

class _DatabaseViewState extends State<DatabaseView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DatabaseViewModel>().loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('SQLite Database'),
            backgroundColor: Colors.purple,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => viewModel.loadTasks(),
                tooltip: 'Recarregar',
              ),
              IconButton(
                icon: const Icon(Icons.delete_sweep),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Limpar todas'),
                      content: const Text(
                        'Deseja excluir todas as tarefas?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            viewModel.clearAllTasks();
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Excluir todas',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                tooltip: 'Limpar tudo',
              ),
            ],
          ),
          body: Column(
            children: [
              if (viewModel.error != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.red[100],
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          viewModel.error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: TaskListWidget(
                  tasks: viewModel.tasks,
                  onToggle: viewModel.toggleTask,
                  onDelete: viewModel.removeTask,
                  isLoading: viewModel.isLoading,
                ),
              ),
              TaskInputWidget(
                onAdd: viewModel.addTask,
              ),
            ],
          ),
        );
      },
    );
  }
}
