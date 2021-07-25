
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizapp2/services/auth.dart';
import 'package:quizapp2/views/home.dart';
import 'package:quizapp2/views/signin.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final AuthService _authService = AuthService();
  final padding = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Color.fromRGBO(50, 75, 205, 1),
        child: ListView(
          padding: padding,
          children: <Widget>[
            const SizedBox(height: 50),
            buildMenuItem(
              text: 'Home',
              icon: Icons.people,
              onClicked: () => selectedItem(context, 0),
            ),
            const SizedBox(height: 16),
            Divider(color: Colors.white70),
            const SizedBox(height: 16),
            buildMenuItem(
              text: 'Logout',
              icon: Icons.people,
              onClicked: () => selectedItem(context, 1),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    String text, IconData icon,VoidCallback onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) async{
    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Home(),
        ));
        break;
      case 1:
        await _authService.signOut();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SignIn(),
        ));
        break;
    }
  }
}