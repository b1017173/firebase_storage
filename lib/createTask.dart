import 'package:firebasestorage/task.dart';
import 'package:firebasestorage/taskDate.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class CreateTask extends StatefulWidget {
  CreateTask({Key key}) : super(key: key);

  @override
  _CreateTaskState createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  final _formKey = GlobalKey<FormState>();
  String _title;
  String _description;
  TaskDate _date;

  @override
  void initState() {
    super.initState();
    _date = TaskDate(DateTime.now(), DateTime.now());
    _date.isAllDay = false;
  }

  Future<DateTime> _selectDate(BuildContext context, DateTime dateTime) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(2019),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      return picked;
    } else {
      return null;
    }
  }

  void _taskSave() {
    if (_formKey.currentState.validate()) {
      this._formKey.currentState.save();

      Task task = Task(_title, _description, _date);
      Navigator.of(context).pop(task);
    }
  }

  Widget _buildTaskTitle() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Enter your task',
        labelText: 'Task Title',
      ),
      autovalidate: false,
      maxLines: 1,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter your task title';
        } else {
          return null;
        }
      },
      onSaved: (value) {
        setState(() {
          _title = value;
        });
      },
    );
  }

  Widget _buildTaskDescription() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Enter your task description',
        labelText: 'Memo',
      ),
      autovalidate: false,
      validator: (value) {
        return null;
      },
      onSaved: (value) {
        setState(() {
          _description = value;
        });
      },
    );
  }

  Widget _buildTaskIsAllDay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'All day',
          style: TextStyle(fontSize: 18.0),
        ),
        Switch(
          value: _date.isAllDay,
          onChanged: (bool value) {
            setState(() {
              _date.isAllDay = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildTaskBeginDate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Begin date',
          style: TextStyle(fontSize: 18.0),
        ),
        FlatButton(
          child: Text(
            DateFormat.yMMMd().format(_date.startDate),
          ),
          onPressed: () async {
            DateTime picked = await _selectDate(context, _date.startDate);
            if (picked != null) {
              setState(() {
                _date.startDate = picked;
              });
            }
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
      ],
    );
  }

  Widget _buildTaskFinishDate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Finish date',
          style: TextStyle(fontSize: 18.0),
        ),
        FlatButton(
          child: Text(
            DateFormat.yMMMd().format(_date.endDate),
          ),
          onPressed: () async {
            DateTime picked = await _selectDate(context, _date.endDate);
            if (picked != null) {
              setState(() {
                _date.endDate = picked;
              });
            }
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            _buildTaskTitle(),
            _buildTaskDescription(),
            SizedBox(height: 24.0),
            _buildTaskIsAllDay(),
            _buildTaskBeginDate(),
            (_date.isAllDay) ? Container() : _buildTaskFinishDate(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Task'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Complete',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: _taskSave,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(70.0)),
            ),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }
}
