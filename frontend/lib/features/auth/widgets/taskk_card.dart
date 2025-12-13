// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/widgets.dart';

class TaskkCard extends StatelessWidget {
  final Color color;
  final String headerText;
  final String describtionText;
  final String dateText;
  const TaskkCard({
    Key? key,
    required this.color,
    required this.headerText,
    required this.describtionText,
    required this.dateText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(   
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      decoration: BoxDecoration(color: color,
      borderRadius: BorderRadius.circular(10)),
      
      child: Column(
        
        children: [Text(headerText,style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold),), SizedBox(width: double.infinity,child: Text(describtionText,style: TextStyle(fontSize: 14),maxLines: 4,overflow: TextOverflow.ellipsis,)), Text(dateText)],
      ),
    );
  }
}
