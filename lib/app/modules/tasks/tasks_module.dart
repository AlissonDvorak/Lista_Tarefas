import 'package:todo_list/app/core/database/modules/todo_list_modules.dart';
import 'package:todo_list/app/modules/tasks/task_create_controller.dart';
import 'package:todo_list/app/modules/tasks/task_create_page.dart';
import 'package:todo_list/app/repositories/tasks/tasks_repository_impl.dart';
import 'package:todo_list/app/services/tasks/task_service.dart';
import 'package:todo_list/app/services/tasks/task_service_impl.dart';
import 'package:provider/provider.dart';

import '../../repositories/tasks/tasks_repository.dart';

class TasksModule extends TodoListModule {
  TasksModule()
      : super(bindings: [
          Provider<TasksRepository>(
            create: (context) => TasksRepositoryImpl(
              sqliteConnectionFactory: context.read(),
            ),
          ),
          Provider<TasksService>(
            create: (context) => TasksServiceImpl(
              tasksRepository: context.read(),
            ),
          ),
          ChangeNotifierProvider(
            create: (context) =>
                TaskCreateController(taskService: context.read()),
          )
        ], routers: {
          '/task/create': (context) => TaskCreatePage(
                controller: context.read(),
              ),
        });
}
