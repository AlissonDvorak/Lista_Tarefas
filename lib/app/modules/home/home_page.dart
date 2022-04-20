import 'package:flutter/material.dart';

import 'package:todo_list/app/core/database/ui/theme_extensions.dart';
import 'package:todo_list/app/core/notifier/default_listener_notifier.dart';
import 'package:todo_list/app/models/task_filter_enum.dart';
import 'package:todo_list/app/modules/home/widgets/home_controller.dart';
import 'package:todo_list/app/modules/home/widgets/home_drawer.dart';
import 'package:todo_list/app/modules/home/widgets/home_filters.dart';
import 'package:todo_list/app/modules/home/widgets/home_header.dart';
import 'package:todo_list/app/modules/home/widgets/home_tasks.dart';
import 'package:todo_list/app/modules/home/widgets/home_week_filter.dart';
import 'package:todo_list/app/modules/tasks/tasks_module.dart';
import 'package:provider/provider.dart';

import '../../core/database/ui/config_ui.dart.dart';

class HomePage extends StatefulWidget {
  final HomeController _homeController;

  const HomePage({
    Key? key,
    required HomeController homeController,
  })  : _homeController = homeController,
        super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ThemeChanger? themeChanger;

  @override
  void initState() {
    super.initState();
    DefaultListenerNotifier(changeNotifier: widget._homeController).listener(
      context: context,
      sucessCallBack: (notifier, listenerInstance) {
        listenerInstance.dispose();
      },
    );

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      widget._homeController.loadTotalTasks();
      widget._homeController.findTask(filter: TaskfilterEnum.today);
    });
  }

  Future<void> _goToCreateTask(BuildContext context) async {
    await Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          animation =
              CurvedAnimation(parent: animation, curve: Curves.easeInQuad);
          return ScaleTransition(
            scale: animation,
            alignment: Alignment.bottomRight,
            child: child,
          );
        },
        pageBuilder: (context, animation, secondaryAnimation) {
          return TasksModule().getPage('/task/create', context);
        },
      ),
    );
    widget._homeController.refreshPage();
  }

  @override
  Widget build(BuildContext context) {
    themeChanger = Provider.of<ThemeChanger>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: themeChanger?.isDark() ? Colors.grey : context.primaryColor,
        ),
        backgroundColor:
            themeChanger?.isDark() ? Colors.grey[850] : Color(0xfffAFBFE),
        title: const Text(''),
        actions: [
          IconButton(
              onPressed: (() {
                themeChanger!.setDarkStatus(!themeChanger?.isDark());
              }),
              icon: themeChanger?.isDark()
                  ? const Icon(Icons.sunny)
                  : const Icon(Icons.dark_mode_outlined)),
          PopupMenuButton(
            icon: const Icon(Icons.filter_alt),
            onSelected: (value) {
              widget._homeController.showOrHideTask();
            },
            itemBuilder: (_) => [
              PopupMenuItem<bool>(
                value: true,
                child: Text(
                  '${widget._homeController.showFinishingTasks ? 'Esconder' : 'mostrar'} tarefas concluídas',
                  style: TextStyle(
                      color:
                          themeChanger?.isDark() ? Colors.white : Colors.black),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: context.primaryColor,
        onPressed: () {
          _goToCreateTask(context);
        },
        child: Icon(
          Icons.add,
          color: themeChanger?.isDark() ? Colors.white : Colors.black,
        ),
      ),
      drawer: HomeDrawer(),
      body: LayoutBuilder(
        builder: ((context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                minWidth: constraints.maxWidth,
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      HomeHeader(),
                      HomeFilters(),
                      HomeWeekFilter(),
                      HomeTasks(),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
