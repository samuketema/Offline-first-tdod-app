import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:taskapp/features/auth/cubit/auth_cubit.dart';
import 'package:taskapp/features/auth/home/cubit/task_cubit.dart';

class AddNewTask extends StatefulWidget {
  const AddNewTask({super.key});

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Color selectedColor = const Color.fromRGBO(246, 222, 194, 1);
  DateTime selectedDate = DateTime.now();

  @override
  void dispose() {
    // Clean up controllers to prevent memory leaks
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> createNewTask() async {
    if (formKey.currentState!.validate()) {
      try {
        AuthLoggedIn user = context.read<AuthCubit>().state as AuthLoggedIn;
        await context.read<TaskCubit>().createTask(
              title: titleController.text.trim(),
              description: descriptionController.text.trim(),
              color: selectedColor,
              token: user.user.token,
              dueAt: selectedDate,
            );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error creating task")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Task"),
        actions: [
          GestureDetector(
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 90)),
              );
              if (pickedDate != null) {
                setState(() {
                  selectedDate = pickedDate;
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(DateFormat("MM/dd/yyyy").format(selectedDate)),
            ),
          ),
        ],
      ),
      body: BlocConsumer<TaskCubit, TaskState>(
        listener: (context, state) {
          if (state is TaskFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is TaskSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text("Task added successfully!")),
              );
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(hintText: "Title"),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Title cannot be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 4,
                    decoration: const InputDecoration(hintText: "Description"),
                  ),
                  const SizedBox(height: 20),
                  ColorPicker(
                    color: selectedColor,
                    onColorChanged: (Color color) {
                      setState(() {
                        selectedColor = color;
                      });
                    },
                    pickersEnabled: const {ColorPickerType.wheel: true},
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: createNewTask,
                    child: const Text("Add Task"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
