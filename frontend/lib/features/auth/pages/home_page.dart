import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskapp/core/constants/utils.dart';
import 'package:taskapp/features/auth/widgets/date_selector.dart';
import 'package:taskapp/features/auth/widgets/taskk_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Tasks"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.add))
        ],
      ),
      body: Column(
        children: [
           DateSelector(),
          Row(
            children: [ 
             
              // ✅ Expanded constrains TaskkCard width
              Expanded(
                child: TaskkCard(
                  color: const Color.fromRGBO(246, 222, 194, 1),
                  headerText: 'header',
                  describtionText:
                      'This is a new task. This is a new task. This is a new task. This is a new task. This is a new task. This is a new task. This is a new task.',
                  dateText: 'date',
                ),
              ),
              const SizedBox(width: 8),
              Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  color: strengthenColor(
                      const Color.fromRGBO(246, 222, 194, 1), 0.69),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.all(10),
                child: const Text(
                  "10:00 am",
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}