import 'package:flutter/material.dart';

import '../../services/auth.dart';
import '../../shared/loading.dart';

class SignIn extends StatefulWidget {
  //const SignIn({Key? key}) : super(key: key);

  late Function toogleView;
  SignIn({required this.toogleView});

  @override
  State<SignIn> createState() {
    return _SignInState();
  }
}

class _SignInState extends State<SignIn> {
  String email='',password='',error='';
  AuthService authService=AuthService();
  var formKey=GlobalKey<FormState>();
  bool loading =false;

  @override
  Widget build(BuildContext context) {
    return loading? Loading(): Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Sign IN to DocIT'),
        actions: [
          TextButton.icon(onPressed: (){
            widget.toogleView();
          },
            icon: Icon(Icons.person,color: Colors.black,),
            label: Text('Register',
              style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,),),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20,horizontal: 50),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(height: 20,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Enter Email ',
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white,width: 2)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.pink,width: 2)
                  ),
                ),
                validator: (val)=> val!.isEmpty? 'Enter an Email':null,
                onChanged: (val){
                  setState(() {
                    email=val;
                  });
                },
              ),
              SizedBox(height: 20,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Enter Password ',
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white,width: 2)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.pink,width: 2)
                  ),
                ),
                validator: (val)=> val!.length<6? 'Enter a Password of at least 6 char':null,
                obscureText: true ,
                onChanged: (val){
                  setState(() {
                    password=val;
                  });
                },
              ),
              SizedBox(height: 20,),
              ElevatedButton(onPressed: (){
                if(formKey.currentState!.validate()) {
                  setState(() {
                    loading=true;
                  });
                  dynamic result=authService.SignINWithEmailAndPassword(email, password);
                  if(result==null){
                    setState(() {
                      error='Enter valid email';
                      loading=false;
                    });
                  }
                }
              },
                child: Text(
                  'SignIN',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[400]
                ),
              ),
              SizedBox(height: 20,),
              Text(error,style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
            ],
          ),
        ),
      ),
    );
  }
}
