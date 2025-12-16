import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddNewTask extends StatefulWidget {
  const AddNewTask({super.key});

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController describtionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Task"),
        actions: [
          GestureDetector(
            onTap: () async{
              final _selectedDate = await showDatePicker(context: context, firstDate: DateTime.now(), lastDate: DateTime.now().add(Duration(days: 90)));
              if (_selectedDate != null) {
               setState(() {
                  selectedDate = _selectedDate;
               });
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(DateFormat("MM-D-Y ").format(selectedDate)),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          TextFormField(
            controller:titleController ,
          ),
           TextFormField(
            controller:describtionController ,
          )
        ],
      ),
    );
  }
}