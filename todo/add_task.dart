import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_viewmodel.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final todoText = TextEditingController(); // Controller to manage text input

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Adjust modal size to its content
      children: [
        const SizedBox(height: 16),
        const Text(
          "Add Task",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            controller: todoText,
            onSubmitted: (value) {
              if (todoText.text.isNotEmpty) {
                context.read<TaskViewModel>().addTask(todoText.text);  // Add task through ViewModel
                todoText.clear();
                Navigator.of(context).pop();  // Close the modal
              }
            },
            decoration: const InputDecoration(
              hintText: "할일을 입력해주세요.",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (todoText.text.isNotEmpty) {
              context.read<TaskViewModel>().addTask(todoText.text);  // Add task through ViewModel
              todoText.clear();
              Navigator.of(context).pop();  // Close the modal
            }
          },
          child: const Text("Add"),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  void dispose() {
    todoText.dispose(); // Dispose of the controller to prevent memory leaks
    super.dispose();
  }
}
