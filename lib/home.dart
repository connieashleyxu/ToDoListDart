import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'database.dart';

class Home extends StatefulWidget {
  // Constructor
  Home({required this.userName});

  // Instance variables
  final String userName;

  @override
  _HomeState createState() => _HomeState();
}

// User Id for testing purposes
String uId = "HXHOJgbEsVaGfd2Fdlp2KCG3T9U2";

class _HomeState extends State<Home> {
  // Instance variables
  Stream<QuerySnapshot>? taskStream;
  DatabaseServices databaseServices = new DatabaseServices();
  late String date;
  TextEditingController taskEditingController = new TextEditingController();
  bool _visible = true;

  @override
  void initState() {
    // Find current date
    var now = DateTime.now();
    date = "${now.month}.${now.day}.${now.year}"; // Format: MM/DD/YYYY

    // Get tasks from database for a given userID
    databaseServices.getTasks(uId).then((val){
      taskStream = val;
      setState(() {});
    });

    super.initState();
  }

  // List of all tasks
  Widget taskList() {
    return StreamBuilder<QuerySnapshot>(
      stream: taskStream,
      builder: (context, snapshot) {
        return snapshot.hasData ? // If there is data of tasks, display list
        ListView.separated(
            padding: EdgeInsets.only(top: 12),
            itemCount: snapshot.data!.docs.length,
            shrinkWrap: true,
            separatorBuilder: (context, index) => SizedBox(
              height: 10,
            ),
            itemBuilder: (context, index) {
              // Retrieve data for each task to be displayed using TaskTile
              return TaskTile(
                snapshot.data!.docs[index].get("isCompleted"),
                snapshot.data!.docs[index].get("task"),
                snapshot.data!.docs[index].id,
              );
            }) : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.fromLTRB(25, 30, 25, 30),
          width: 500, // Width of home page display
          child: Column(
            children: [
              // Title
              Text(
                "${widget.userName}'s Tasks",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),

              // Date
              Text(
                "$date",
                style: TextStyle(
                  fontSize: 12,
                ),
              ),

              // Add task input field
              Row(
                children: [
                  // Add task text field
                  Expanded(
                    child: TextField(
                      controller: taskEditingController,
                      decoration: InputDecoration(
                        hintText: "Add a task...",
                      ),
                      onChanged: (val) {
                        setState(() {
                        });
                      },
                    ),
                  ),

                  SizedBox(width: 5,),

                  // If there is text in the text field, display "ADD" button. Else, display nothing
                  taskEditingController.text.isNotEmpty ?
                  GestureDetector(
                    // When "Add" button is taped, add task to database and task list
                    onTap: (){
                      Map<String, dynamic> taskMap = {
                        "task": taskEditingController.text,
                        "isCompleted": false,
                      };

                      databaseServices.createTask(uId, taskMap);
                      taskEditingController.text = "";
                    },
                      child: Container(
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Text("ADD"))) : Container(),
                ],
              ),
              // Fade in animated display list of tasks
              AnimatedOpacity(
                  opacity: _visible ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 500),
                  child: taskList(),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class TaskTile extends StatefulWidget {
  // Constructor
  TaskTile(this.isCompleted, this.task, this.documentId);

  // Instance variables
  final bool isCompleted;
  final String task;
  final String documentId;

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  //Instance variables
  bool _visible = true;

  // Display task list
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
          children: [
            // If check button is pressed, task is completed
            GestureDetector(
              onTap: (){
                Map<String, dynamic> taskMap = {
                  "isCompleted" : !widget.isCompleted,
                };

                DatabaseServices().updateTask(uId, taskMap, widget.documentId);
              },
              // Check button
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black87, width: 1),
                  borderRadius: BorderRadius.circular(30),
                ),
                // If task is completed, fill with pink check mark. Else, leave blank
                child: widget.isCompleted ?
                Icon(Icons.check, color: Colors.pink,) : Container(),
              ),
            ),

            SizedBox(width: 12,),

            // Delete "x" button
            Text(
              widget.task,
              style: TextStyle(
                color: widget.isCompleted ? Colors.black87 :
                Colors.black87.withOpacity(0.5),
                fontSize: 14,
                decoration: widget.isCompleted ?
                TextDecoration.lineThrough : TextDecoration.none,
              ),
            ),

            // Pushes delete "x" the the end of the display
            Spacer(),

            // On tap, delete task and remove from task list and database
            GestureDetector(
              onTap: (){
                DatabaseServices().deleteTask(uId, widget.documentId);
              },
              child: Icon(
                Icons.close, size: 13, color: Colors.black87.withOpacity(0.5),
              ),
            ),
          ],
        ),
    );
  }
}