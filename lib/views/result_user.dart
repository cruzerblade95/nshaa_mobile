import 'package:flutter/material.dart';
import 'package:quizapp2/services/database.dart';
import 'package:quizapp2/widget/widget.dart';
import 'package:quizapp2/widgets/navigation_drawer_widget.dart';

class ResultUser extends StatefulWidget {

  final String userEmail;
  ResultUser(this.userEmail);

  @override
  _ResultUserState createState() => _ResultUserState();
}

class _ResultUserState extends State<ResultUser> {
  Stream quizStream;
  DatabaseService databaseService = new DatabaseService();

  Widget quizList() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            child: StreamBuilder(
              stream: quizStream,
              builder: (context, snapshot) {
                return snapshot.data == null
                    ? Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  height: 150,
                )
                    :
                ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      return QuizTile(
                        noOfQuestions: snapshot.data.documents.length,
                        title:
                        snapshot.data.documents[index].data['quizTitle'],
                        correct:
                        snapshot.data.documents[index].data['correct'],
                        incorrect:
                        snapshot.data.documents[index].data['incorrect'],
                      );
                    });
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  void initState() {
    databaseService.getResultUserData(widget.userEmail).then((value) {
      quizStream = value;
      setState(() {});
    });

    print(quizStream);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: AppLogo(),
        brightness: Brightness.light,
        elevation: 0.0,
        backgroundColor: Colors.blue[100],
        //brightness: Brightness.li,
      ),
      body: quizList(),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () {
      //     Navigator.push(
      //         context, MaterialPageRoute(builder: (context) => CreateQuiz()));
      //   },
      // ),
    );
  }
}

class QuizTile extends StatelessWidget {
  final String correct, title, incorrect;
  final int noOfQuestions;

  QuizTile(
      {@required this.title,
        @required this.correct,
        @required this.incorrect,
        @required this.noOfQuestions});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        height: 150,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              Container(
                color: Colors.black26,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 4,),
                      Text(
                        "Correct",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        correct,
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 4,),
                      Text(
                        "Incorrect",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        incorrect,
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
