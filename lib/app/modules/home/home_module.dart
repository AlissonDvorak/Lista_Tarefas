import 'package:todo_list/app/core/database/modules/todo_list_modules.dart';
import 'package:todo_list/app/modules/home/home_page.dart';
import 'package:todo_list/app/modules/home/widgets/home_controller.dart';
import 'package:provider/provider.dart';

import '../../repositories/tasks/tasks_repository.dart';
import '../../repositories/tasks/tasks_repository_impl.dart';
import '../../services/tasks/task_service.dart';
import '../../services/tasks/task_service_impl.dart';

class HomeModule extends TodoListModule {
  HomeModule()
      : super(
          bindings: [
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
              create: ((context) =>
                  HomeController(tasksService: context.read())),
            )
          ],
          routers: {
            '/home': (context) => HomePage(
                  homeController: context.read(),
                )
          },
        );
}
