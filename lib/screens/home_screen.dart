import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import 'task_form_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          return ListView.builder(
            itemCount: taskProvider.tasks.length,
            itemBuilder: (context, index) {
              final task = taskProvider.tasks[index];
              return ListTile(
                title: Text(
                  task.title,
                  style: TextStyle(
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                subtitle: Text(
                    'Due: ${DateFormat.yMMMd().format(task.dueDate)} - Priority: ${task.priority.toString().split('.').last}'),
                leading: Checkbox(
                  value: task.isCompleted,
                  onChanged: (value) {
                    taskProvider.toggleTaskCompletion(index);
                  },
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => TaskFormScreen(
                              task: task,
                              taskIndex: index,
                              onSave: (editedTask) {
                                taskProvider.updateTask(index, editedTask);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        taskProvider.deleteTask(index);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TaskFormScreen(
                onSave: (newTask) {
                  Provider.of<TaskProvider>(context, listen: false)
                      .addTask(newTask);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
