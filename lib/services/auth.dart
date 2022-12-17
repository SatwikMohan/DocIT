import 'package:docit/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService{
    FirebaseAuth auth=FirebaseAuth.instance;

    UserData? userUID(User? user){
      if(user!=null){
        return UserData(uid: user.uid);
      }else{
        return null;
      }
    }

    Stream<UserData?> get user{
      return auth.authStateChanges().map(userUID);
    }

    Future RegisterWithEmailAndPassword(String email,String password) async{
      try{
        UserCredential userCredential=await auth.createUserWithEmailAndPassword(email: email, password: password);
        User? user=userCredential.user;
        return userUID(user);
      }catch(e){
        print('registerwithemailandpassword-> ${e.toString()}');
        return null;
      }
    }

    Future SignINWithEmailAndPassword(String email,String password) async{
      try{
        UserCredential userCredential=await auth.signInWithEmailAndPassword(email: email, password: password);
        User? user=userCredential.user;
        print('signinwithemailandpassword-> signininside');
        return userUID(user);
      }catch(e){
        print('signinwithemailandpassword-> ${e.toString()}');
        return null;
      }
    }

    Future SignOUT()  async{
      try{
        return await auth.signOut();
      }catch(e){
        print(e.toString());
        return null;
      }
    }

}