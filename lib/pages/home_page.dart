import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:CONTGUARD/components/globale_appBar.dart';
import 'package:CONTGUARD/components/text_field.dart';
import 'package:CONTGUARD/components/wall_post.dart';
import 'package:CONTGUARD/helper/helper_method.dart';
import 'package:CONTGUARD/pages/explore_page.dart';
import 'package:CONTGUARD/pages/profile_page.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser!;

  //text controller
  final textController = TextEditingController();
  File? _imageFile;
  //sign user out
  

  //post message
  void postMessage() {
    //only post if there is something in textfield
    if (textController.text.isNotEmpty) {
      //store in firebase
      FirebaseFirestore.instance.collection("User Posts").add({
        'UserEmail': currentUser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
      });
    }

    //clear the text field
    setState(() {
      textController.clear();
    });
  }

  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(253, 253, 253, 1),
      appBar: const GlobalAppBar(
        title: 'HOME',
      ),
      body: Center(
        child: Column(
          children: [
            //the wall
            Expanded(
                child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("User Posts")
                  .orderBy("TimeStamp", descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      //get the message
                      final post = snapshot.data!.docs[index];
                      return WallPost(
                        user: post['UserEmail'],
                        message: post['Message'],
                        postId: post.id,
                        likes: List<String>.from(post['Likes'] ?? []),
                        time: formatDate(post['TimeStamp']),
                        image:
                            _imageFile != null ? FileImage(_imageFile!) : null,
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error : ${snapshot.error}'),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            )),

            //post message
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  //textfield
                  Expanded(
                    child: MyTextField(
                        controller: textController,
                        hintText: "Write something on the wall...",
                        obscureText: false),
                  ),
                  // IconButton(
                  //   icon: Icon(Icons.image),
                  //   onPressed: () async {
                  //     try {
                  //       final ImagePicker _picker = ImagePicker();
                  //       final XFile? image = await _picker.pickImage(
                  //           source: ImageSource.gallery);

                  //       if (image != null) {
                  //         // Use the image file
                  //         setState(() {
                  //           _imageFile = File(image.path);
                  //         });
                  //       }
                  //     } catch (e) {
                  //       print('Error picking image: $e');
                  //     }
                  //   },
                  // ),
                  //post button
                  IconButton(
                      onPressed: postMessage,
                      icon: const Icon(Icons.arrow_circle_up))
                ],
              ),
            ),

            //logged in as
            Text(
              "Logged in as: " + currentUser.email!,
              style: TextStyle(
                  color: Color.fromARGB(255, 197, 0, 251),
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
