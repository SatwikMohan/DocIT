
import 'package:docit/screens/authenticate/register.dart';
import 'package:docit/screens/authenticate/signin.dart';
import 'package:flutter/cupertino.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool view=true;
  void toogleView(){
    setState(() {
      view=!view;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(view){
      return SignIn(toogleView: toogleView);
    }else{
      return Register(toogleView: toogleView);
    }
  }
}
