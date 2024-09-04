import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;
  final int? taskIndex;
  final Function(Task) onSave;

  const TaskFormScreen({
    Key? key,
    this.task,
    this.taskIndex,
    required this.onSave,
  }) : super(key: key);

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late DateTime _dueDate;
  late Priority _priority;

  @override
  void initState() {
    super.initState();
    _title = widget.task?.title ?? '';
    _description = widget.task?.description ?? '';
    _dueDate = widget.task?.dueDate ?? DateTime.now();
    _priority = widget.task?.priority ?? Priority.low;
  }

  void _pickDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final Task newTask = Task(
        title: _title,
        description: _description,
        dueDate: _dueDate,
        priority: _priority,
      );
      widget.onSave(newTask);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task != null ? 'Edit Task' : 'New Task'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _saveTask,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                onSaved: (value) {
                  _description = value!;
                },
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text('Due Date: ${DateFormat.yMMMd().format(_dueDate)}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _pickDueDate(context),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<Priority>(
                value: _priority,
                decoration: InputDecoration(labelText: 'Priority'),
                items: Priority.values
                    .map((priority) => DropdownMenuItem(
                          child: Text(priority.toString().split('.').last),
                          value: priority,
                        ))
                    .toList(),
                onChanged: (priority) {
                  setState(() {
                    _priority = priority!;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
