import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/app/modules/home/widgets/home_controller.dart';
import 'package:provider/provider.dart';

import '../../../models/task_model.dart';

class Task extends StatefulWidget {
  final TaskModel model;

  const Task({Key? key, required this.model}) : super(key: key);

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  final dateFormat = DateFormat('dd/MM/y');

  @override
  Widget build(BuildContext context) {
    Color? getColor(Set<MaterialState> states) {
      return Colors.grey.shade300;
    }

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Colors.grey),
          ]),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: IntrinsicHeight(
        child: Dismissible(
          onDismissed: (direction) {
            context.read<HomeController>().deleteTask(widget.model);
          },
          background: Container(
            child: const Align(
              alignment: Alignment(-0.9, 0),
              child: Icon(Icons.delete, color: Colors.black),
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.red),
          ),
          key: ValueKey(widget.model.id),
          child: ListTile(
            contentPadding: const EdgeInsets.all(8),
            leading: Checkbox(
              fillColor: MaterialStateProperty.resolveWith(getColor),
              value: widget.model.finished,
              onChanged: (value) => context
                  .read<HomeController>()
                  .checkOrUncheckTask(widget.model),
            ),
            title: Text(
              widget.model.description,
              style: TextStyle(
                  decoration:
                      widget.model.finished ? TextDecoration.lineThrough : null,
                  color: Colors.black),
            ),
            subtitle: Text(
              dateFormat.format(widget.model.dateTime),
              style: TextStyle(
                  decoration:
                      widget.model.finished ? TextDecoration.lineThrough : null,
                  color: Colors.black),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: const BorderSide(width: 1),
            ),
          ),
        ),
      ),
    );
  }
}
