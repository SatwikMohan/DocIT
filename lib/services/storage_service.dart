import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Storage{
  FirebaseStorage storage=FirebaseStorage.instance;
  FirebaseStorage ref=FirebaseStorage.instance;
  FirebaseDatabase database=FirebaseDatabase.instance;
  String? fileURL;
  Future uploadFile(String uid,Uint8List? fileData,String fileName,String fileExtension) async{

      try{
        await storage.ref(uid).child(fileName).putData(fileData!).then((p0) async{
         String fileUrl= await ref.ref(uid).child(fileName).getDownloadURL();
         fileURL=fileUrl.toString();
         var databaseRef=database.ref(uid);
         String key=databaseRef.push().key.toString();
         databaseRef.child(key).child('FileName').set(fileName);
         databaseRef.child(key).child('FileExtension').set(fileExtension);
         databaseRef.child(key).child('FileURL').set(fileURL);
        });
      }catch(e){
        print('Fileuploaderror->>>>> ${e.toString()}');
      }
  }

  Future uploadFile2(String uid,String? filePath,String fileName,String fileExtension) async{

    try{
      File file=File(filePath!);
      await storage.ref(uid).child(fileName).putFile(file).then((p0) async{
        String fileUrl= await ref.ref(uid).child(fileName).getDownloadURL();
        fileURL=fileUrl.toString();
        var databaseRef=database.ref(uid);
        String key=databaseRef.push().key.toString();
        databaseRef.child(key).child('FileName').set(fileName);
        databaseRef.child(key).child('FileExtension').set(fileExtension);
        databaseRef.child(key).child('FileURL').set(fileURL);
      });
    }catch(e){
      print('Fileupload2error->>>>> ${e.toString()}');
    }
  }

}