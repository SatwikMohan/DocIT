import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import 'authenticate/authenticate.dart';
import 'home/home.dart';
class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user=Provider.of<UserData?>(context);
    if(user==null){
      return Authenticate();
    }else{
      return Home(uid: user.uid);
    }
  }
}
