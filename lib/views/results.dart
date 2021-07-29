import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizapp2/views/submit_quiz.dart';
import 'package:flutter_session/flutter_session.dart';

class Results extends StatefulWidget {
  final int total, correct, incorrect, notattempted;
  final String quizTitle;
  Results({this.incorrect, this.total, this.correct, this.notattempted, this.quizTitle});

  @override
  _ResultsState createState() => _ResultsState();
}

String _quizTitle, _userEmail;
int _total, _correct, _incorrect, _notattempted;

class _ResultsState extends State<Results> {

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState(){

    _total = widget.total;
    _quizTitle = widget.quizTitle;
    _correct = widget.correct;
    _incorrect = widget.incorrect;
    _notattempted = widget.notattempted;

    firebaseGetEmail();

    super.initState();
  }

  Future<String> firebaseGetEmail() async {
    final FirebaseUser user = await auth.currentUser();
    await FlutterSession().set("email", user.email);
    _userEmail = await FlutterSession().get("email");
    // return emailUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("${widget.correct}/ ${widget.total}",
                style: TextStyle(fontSize: 25),),
              SizedBox(height: 5,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "you answered ${widget.correct} answers correctly and ${widget
                      .incorrect} answers incorrectly",
                  textAlign: TextAlign.center,),

              ),
              SizedBox(height: 24,),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => SubmitQuiz(
                        total: _total,
                        correct: _correct,
                        incorrect: _incorrect,
                        notattempted: _notattempted,
                        quizTitle: _quizTitle,
                        userEmail: _userEmail,
                      )
                  ));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: Text("Go to home",
                    style: TextStyle(color: Colors.white, fontSize: 19),),
                ),
              )
            ],),
        ),
      ),
    );
  }

}

