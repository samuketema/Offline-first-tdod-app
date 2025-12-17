import 'package:flex_color_picker/flex_color_picker.dart';
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
  Color selectedColor = const Color.fromRGBO(246, 222, 194, 1);
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
              child: Text(DateFormat("MM-d-y").format(selectedDate)),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          TextFormField(
            controller:titleController ,
            decoration: InputDecoration(
              hintText: "Title"
            ),
          ),
          SizedBox(height: 10,),
           TextFormField(
            controller:describtionController ,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "describtion"
              
            ),
          ) ,
          ColorPicker(onColorChanged: (Color color){
            setState(() {
              selectedColor = color;
            });

          },
          pickersEnabled:{ColorPickerType.wheel:true} ,)
        ],
      ),
    );
  }
}