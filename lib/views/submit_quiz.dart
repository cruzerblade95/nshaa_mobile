import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:quizapp2/services/database.dart';

import 'home.dart';

class SubmitQuiz extends StatefulWidget{

  final int total, correct, incorrect, notattempted;
  final String quizTitle, userEmail;
  SubmitQuiz({this.incorrect, this.total, this.correct, this.notattempted, this.quizTitle, this.userEmail});

  @override
  _SubmitQuizState createState() => _SubmitQuizState();

}

class _SubmitQuizState extends State<SubmitQuiz>{

  DatabaseService databaseService = new DatabaseService();

  @override
  void initState() {

    Map<String, String> questionMap = {
      "email": widget.userEmail,
      "quizTitle": widget.quizTitle,
      "correct": widget.correct.toString(),
      "incorrect": widget.incorrect.toString(),
      "total": widget.total.toString(),
      "notattempted": widget.notattempted.toString()
    };

    databaseService.addUserQuizData(widget.quizTitle, questionMap);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => Home()
      ));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }

  }