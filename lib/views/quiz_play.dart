import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizapp2/models/question_model.dart';
import 'package:quizapp2/services/database.dart';
import 'package:quizapp2/views/results.dart';
import 'package:quizapp2/widget/widget.dart';
import 'package:quizapp2/widgets/quiz_play_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuizPlay extends StatefulWidget {
  final String quizId;
  final String quizTitle;
  QuizPlay(this.quizId, this.quizTitle);

  @override
  _QuizPlayState createState() => _QuizPlayState();
}

int _correct = 0;
int _incorrect = 0;
int _notAttempted = 0;
int total = 0;
String _quizTitle;

/// Stream
Stream infoStream;

class _QuizPlayState extends State<QuizPlay> {
  QuerySnapshot questionSnaphot;
  DatabaseService databaseService = new DatabaseService();

  bool isLoading = true;

  @override
  void initState() {
    databaseService.getQuestionData(widget.quizId).then((value) {
      questionSnaphot = value;
      _notAttempted = questionSnaphot.documents.length;
      _correct = 0;
      _incorrect = 0;
      _quizTitle = widget.quizTitle;
      isLoading = false;
      total = questionSnaphot.documents.length;
      setState(() {});
      print("init don $total ${widget.quizId} ");
    });

    if(infoStream == null){
      infoStream = Stream<List<int>>.periodic(
        Duration(milliseconds: 100), (x){
          print("this is x $x");
          return [_correct, _incorrect] ;
      });
    }

    super.initState();
  }


  QuestionModel getQuestionModelFromDatasnapshot(
      DocumentSnapshot questionSnapshot) {
    QuestionModel questionModel = new QuestionModel();

    questionModel.question = questionSnapshot.data["question"];

    /// shuffling the options
    List<String> options = [
      questionSnapshot.data["option1"],
      questionSnapshot.data["option2"],
      questionSnapshot.data["option3"],
      questionSnapshot.data["option4"]
    ];
    options.shuffle();

    questionModel.option1 = options[0];
    questionModel.option2 = options[1];
    questionModel.option3 = options[2];
    questionModel.option4 = options[3];
    questionModel.correctOption = questionSnapshot.data["option1"];
    questionModel.answered = false;

    print(questionModel.correctOption.toLowerCase());

    return questionModel;
  }

  @override
  void dispose() {
    infoStream = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppLogo(),
        centerTitle: true,
        backgroundColor: Colors.blue[100],
        brightness: Brightness.light,
        elevation: 0.0,

      ),
      body: isLoading
          ? Container(
        child: Center(child: CircularProgressIndicator()),
      )
          : SingleChildScrollView(
            child: Container(
                child: Column(
                  children: [
                    InfoHeader(
                      length: questionSnaphot.documents.length,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    questionSnaphot.documents == null
                        ? Container(
                      child: Center(child: Text("No Data"),),
                    )
                        : ListView.builder(
                            itemCount: questionSnaphot.documents.length,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return QuizPlayTile(
                                questionModel: getQuestionModelFromDatasnapshot(
                                    questionSnaphot.documents[index]),
                                index: index,
                              );
                            }),
                    SizedBox(
                      height: 10,
                    ),
                    InfoFooter(
                      quizId: widget.quizId,
                    ),
                  ],
                ),
              ),
          ),
    );
  }
}

class InfoHeader extends StatefulWidget {
  final int length;

  InfoHeader({@required this.length});

  @override
  _InfoHeaderState createState() => _InfoHeaderState();
}

class _InfoHeaderState extends State<InfoHeader> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: infoStream,
      builder: (context, snapshot){
        return snapshot.hasData ? Container(
          height: 40,
          margin: EdgeInsets.only(left: 14),
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: <Widget>[
              NoOfQuestionTile(
                text: "Total",
                number: widget.length,
              ),
              NoOfQuestionTile(
                text: "Correct",
                number: _correct,
              ),
              NoOfQuestionTile(
                text: "Incorrect",
                number: _incorrect,
              ),
              NoOfQuestionTile(
                text: "NotAttempted",
                number: _notAttempted,
              ),
            ],
          ),
        ) : Container();
      }
    );
  }
}


class QuizPlayTile extends StatefulWidget {
  final QuestionModel questionModel;
  final int index;

  QuizPlayTile({@required this.questionModel, @required this.index});

  @override
  _QuizPlayTileState createState() => _QuizPlayTileState();
}

class _QuizPlayTileState extends State<QuizPlayTile> {
  String optionSelected = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 20
            ),
            child: Text(
              "Q${widget.index + 1} ${widget.questionModel.question}",
              style:
                  TextStyle(fontSize: 18, color: Colors.black.withOpacity(0.8)),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                ///correct
                if (widget.questionModel.option1 ==
                    widget.questionModel.correctOption) {
                  setState(() {
                    optionSelected = widget.questionModel.option1;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    _notAttempted = _notAttempted + 1;
                  });
                } else {
                  setState(() {
                    optionSelected = widget.questionModel.option1;
                    widget.questionModel.answered = true;
                    _incorrect = _incorrect + 1;
                    _notAttempted = _notAttempted - 1;
                  });
                }
              }
            },
            child: OptionTile(
              option: "A",
              description: "${widget.questionModel.option1}",
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                ///correct
                if (widget.questionModel.option2 ==
                    widget.questionModel.correctOption) {
                  setState(() {
                    optionSelected = widget.questionModel.option2;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    _notAttempted = _notAttempted + 1;
                  });
                } else {
                  setState(() {
                    optionSelected = widget.questionModel.option2;
                    widget.questionModel.answered = true;
                    _incorrect = _incorrect + 1;
                    _notAttempted = _notAttempted - 1;
                  });
                }
              }
            },
            child: OptionTile(
              option: "B",
              description: "${widget.questionModel.option2}",
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                ///correct
                if (widget.questionModel.option3 ==
                    widget.questionModel.correctOption) {
                  setState(() {
                    optionSelected = widget.questionModel.option3;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    _notAttempted = _notAttempted + 1;
                  });
                } else {
                  setState(() {
                    optionSelected = widget.questionModel.option3;
                    widget.questionModel.answered = true;
                    _incorrect = _incorrect + 1;
                    _notAttempted = _notAttempted - 1;
                  });
                }
              }
            },
            child: OptionTile(
              option: "C",
              description: "${widget.questionModel.option3}",
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                ///correct
                if (widget.questionModel.option4 ==
                    widget.questionModel.correctOption) {
                  setState(() {
                    optionSelected = widget.questionModel.option4;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    _notAttempted = _notAttempted + 1;
                  });
                } else {
                  setState(() {
                    optionSelected = widget.questionModel.option4;
                    widget.questionModel.answered = true;
                    _incorrect = _incorrect + 1;
                    _notAttempted = _notAttempted - 1;
                  });
                }
              }
            },
            child: OptionTile(
              option: "D",
              description: "${widget.questionModel.option4}",
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

class InfoFooter extends StatefulWidget {
  final String quizId;



  InfoFooter({@required this.quizId});

  @override
  _InfoFooterState createState() => _InfoFooterState();
}

class _InfoFooterState extends State<InfoFooter> {

  final FirebaseAuth auth = FirebaseAuth.instance;

  DatabaseService databaseService = new DatabaseService();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => Results(
                          quizTitle: _quizTitle,
                          total: total,
                          correct: _correct,
                          incorrect: _incorrect,
                          notattempted: _notAttempted,
                        )
                      ));
                      // int _correct = 0;
                      // int _incorrect = 0;
                      // int _notAttempted = 0;
                      // int total = 0;
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 2 - 20,
                      padding: EdgeInsets.symmetric(
                          horizontal: 24, vertical: 20),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(30)),
                      child: Text(
                        "Submit",
                        style:
                        TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
        // stream: infoStream,
        // builder: (context, snapshot){
        //   return snapshot.hasData ? Container(
        //     height: 40,
        //     margin: EdgeInsets.only(left: 14),
        //     child: ListView(
        //       scrollDirection: Axis.horizontal,
        //       shrinkWrap: true,
        //       children: <Widget>[
        //         NoOfQuestionTile(
        //           text: "Total",
        //           // number: widget.length,
        //         ),
        //         NoOfQuestionTile(
        //           text: "Correct",
        //           number: _correct,
        //         ),
        //         NoOfQuestionTile(
        //           text: "Incorrect",
        //           number: _incorrect,
        //         ),
        //         NoOfQuestionTile(
        //           text: "NotAttempted",
        //           number: _notAttempted,
        //         ),
        //       ],
        //     ),
        //   ) : Container();
        // }
    );
  }
}
