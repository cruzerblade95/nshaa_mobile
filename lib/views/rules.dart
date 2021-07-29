
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizapp2/widget/widget.dart';

class Rules extends StatefulWidget {

  @override
  _RulesState createState() => _RulesState();
}

class _RulesState extends State<Rules> {
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
      body: Container(
        margin: const EdgeInsets.only(top: 10.0, left: 30.0, right: 15.0),
        child: Column(
          children: [
            Text("DI BAWAH ADALAH SYARAT UNTUK MENJAWAB QUIZ:",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text("1. Peserta diwajibkan untuk membaca risalah RSG Medicare sebelum menjawab.",
                  textAlign: TextAlign.center,),
            const SizedBox(height: 10),
            Text("2. Peserta diwajibkan untuk menonton video program Bicara Pakar Dari Bumi di YT Channel.",
              textAlign: TextAlign.center,),
            const SizedBox(height: 10),
            Text("3. Setiap soalan perlu dijawab dalam masa 60 saat.",
              textAlign: TextAlign.center,),
          ],
        ),
      ),
    );
  }

}