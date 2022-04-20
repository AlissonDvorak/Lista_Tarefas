// ignore_for_file: avoid_print

import 'package:todo_list/app/core/notifier/default_change_notifier.dart';
import 'package:todo_list/app/services/tasks/task_service.dart';

class TaskCreateController extends DefaultChangeNotifier {
  final TasksService _taskService;
  DateTime? _selectedDate;

  TaskCreateController({required TasksService taskService})
      : _taskService = taskService;

  set selectedDate(DateTime? selectedDate) {
    resetState();
    _selectedDate = selectedDate;
    notifyListeners();
  }

  DateTime? get selectedDate => _selectedDate;

  Future<void> save(String description) async {
    try {
      showLoadingAndResetState();
      notifyListeners();
      if (_selectedDate != null) {
        await _taskService.save(_selectedDate!, description);
        sucess();
      } else {
        setError('Data nao selecionada');
      }
    } catch (e, s) {
      print('Erro aqui -------------------$e');
      print('Erro aqui -------------------$s');
      setError('ERRO AO CADATRAR ATIVIDADE');
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}
