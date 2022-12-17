import 'dart:typed_data';

import 'package:docit/services/auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/storage_service.dart';

class Home extends StatefulWidget {
  //const Home({Key? key}) : super(key: key);
  String? uid;
  Home({required this.uid});

  @override
  State<Home> createState() => _HomeState(uid : uid);
}

class _HomeState extends State<Home> {
String? uid;
FirebaseDatabase databaseref=FirebaseDatabase.instance;
_HomeState({required this.uid});
  AuthService authService=AuthService();
  Storage storage = Storage();
  @override
  Widget build(BuildContext context) {
    var fileref=databaseref.ref(uid.toString());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[300],
        title: Text('Deck'),
        actions: [
          TextButton.icon(icon: Icon(Icons.person,color: Colors.black,),
              onPressed:() async{
                  await authService.SignOUT();
          },
              label: Text(
                'SignOUT',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
          ),
          TextButton.icon(icon: Icon(Icons.add,color: Colors.black,),
            onPressed:() async{
                print(uid);
                var result=await FilePicker.platform.pickFiles(
                    allowMultiple: false,
                    type: FileType.custom,
                    allowedExtensions: ['png','jpg','pdf','txt','doc','docx','xls']
                );
                if(result==null){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No File is chosen')));
                  return null;
                }
                var fileName=result.files.single.name;
                var fileExtension=result.files.single.extension;
                Uint8List? fileData=result.files.single.bytes;
                //print(result.files.single.path);
                print(fileData);
                //print('FilePath-> ${fileData.toString()}');
                if(fileData!=null){
                  storage.uploadFile(uid.toString(), fileData, fileName,fileExtension.toString()).then((value) => print('Uploaded'));
                } else{
                  storage.uploadFile2(uid.toString(), result.files.single.path, fileName,fileExtension.toString()).then((value) => print('Uploaded'));
                }

            },
            label: Text(
              'Add',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
        body: SingleChildScrollView(
          child: Container(
            child: FirebaseAnimatedList(
                shrinkWrap: true,
                query: fileref,
                itemBuilder: (BuildContext context,
                    DataSnapshot snapshot,
                    Animation<double> animation,int index
                    ){
                  Map? data=snapshot.value as Map?;
                  return ListTile(
                    trailing: IconButton(icon: Icon(Icons.delete),
                      onPressed: (){
                        fileref.child(snapshot.key.toString()).remove();
                      },
                    ),

                    leading: IconButton(icon: Icon(Icons.download),
                    onPressed: () async{
                        //launch url
                        var url=data?['FileURL'];
                        if (await canLaunchUrl(Uri.parse(url))){
                          await launchUrl(Uri.parse(url)).then((value){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('File downloaded')));
                          });
                        }else{
                          print('Launchurl->>> cannot launch') ;
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cannot download file')));
                        }
                    },
                    ),

                    title: Text(
                        data?['FileName']
                    ),

                    subtitle: Text(
                        data?['FileExtension']
                    ),
                  );
                }),
          ),
        ),
    );
  }
}
