import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:taskapp/core/constants/utils.dart';
import 'package:taskapp/features/auth/cubit/auth_cubit.dart';
import 'package:taskapp/features/auth/home/cubit/task_cubit.dart';
import 'package:taskapp/features/auth/pages/add_new_task.dart';
import 'package:taskapp/features/auth/widgets/date_selector.dart';
import 'package:taskapp/features/auth/widgets/taskk_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().state as AuthLoggedIn;
    context.read<TaskCubit>().getTask(token: user.user.token);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Tasks"),
        actions: [
          IconButton(onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddNewTask()));
          }, icon: const Icon(CupertinoIcons.add))
        ],
      ),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return Center(child: CircularProgressIndicator(),);
          }

          if (state is TaskFailure) {
            return Center(  child: Text(state.message),);
          }

          if (state is TaskFetchSuccess) {
            final tasks = state.tasks.where((elem)=>DateFormat('d').format(elem.dueAt)==DateFormat('d').format(selectedDate) && selectedDate.month == elem.dueAt.month && selectedDate.year == elem.dueAt.year).toList();  
            return Column(
              children: [
                 DateSelector(selectedDate: selectedDate,ontap: (date) {
                    
                  setState(() {
                     selectedDate = date;
                  });
                 
              
                 },),
                Expanded(
                  child: ListView.builder(
                    itemCount:tasks.length ,
                    itemBuilder: (context,index) {
                    final task = tasks[index];
                      return Row(
                        children: [ 
                         
                          // ✅ Expanded constrains TaskkCard width
                          Expanded(
                            child: TaskkCard(
                              color: task.color,
                              headerText:task.title,
                              describtionText:
                                  task.description,
                              dateText: DateFormat.jm().format(task.dueAt),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              color: strengthenColor(
                                  task.color, 0.69),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child:  Text(
                              DateFormat.jm().format(task.dueAt),
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                        ],
                      );
                    }
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}