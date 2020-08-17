import 'package:firebasestorage/createTask.dart';
import 'package:firebasestorage/task.dart';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:intl/intl.dart';

void main() {
  runApp(ToDo());
}

class ToDo extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase storage demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Firebase storage demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Task> tasks;

  @override
  void initState() {
    super.initState();
    tasks = [];

    // デバッグ用
//    Task devTask = Task('devTitle', 'devDescription', TaskDate(DateTime.now(), DateTime.now()));
//    tasks.add(devTask);
  }

  void _createTask(List<Task> tasks) async {
    final Task task = await Navigator.of(context).push(MaterialPageRoute(
      settings: RouteSettings(name: '/createTask'),
      builder: (BuildContext context) => CreateTask(),
      fullscreenDialog: true,
    ));
    if (task != null) {
      setState(() {
        tasks.add(task);
      });
    }
  }

  Widget _buildTaskItem(List<Task> tasks, int index) {
    final Task task = tasks[index];
    if (task == null) return Text('Error: task is null');
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        color: (task.isDone)? Color(0xFFc0c0c0): null,
        child: ListTile(
          title: Text(
            task.title,
            style: TextStyle(fontSize: 20),
          ),
          subtitle: Text(
            (task.taskDate.isAllDay)? 'All day: ' + DateFormat.yMMMd().format(task.taskDate.startDate):
            DateFormat.yMMMd().format(task.taskDate.startDate) + ' ~ ' + DateFormat.yMMMd().format(task.taskDate.endDate),
          ),
        ),
      ),
      actions: <Widget>[
        (task.isDone)? IconSlideAction(
          caption: 'Cancel',
          color: Colors.deepOrange,
          icon: Icons.cancel,
          onTap: () {
            setState(() {
              task.isDone = false;
            });
          },
        ): IconSlideAction(
          caption: 'Done',
          color: Colors.green,
          icon: Icons.done,
          onTap: () {
            setState(() {
              task.isDone = true;
            });
          },
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            setState(() {
              tasks.remove(task);
            });
          },
        ),
      ],
    );
  }

  Widget _buildTaskList(List<Task> tasks) {
    return ListView.builder(
      itemCount: tasks.length * 2,
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();
        final index = i ~/ 2;
        return _buildTaskItem(tasks, index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildTaskList(tasks),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createTask(tasks),
        tooltip: 'Create Task',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
