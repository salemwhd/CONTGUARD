import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:CONTGUARD/components/globale_appBar.dart';
import 'package:CONTGUARD/components/my_follow_button.dart';
import 'package:CONTGUARD/pages/profile_page.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final users = FirebaseFirestore.instance.collection('Users');

    return Scaffold(
      appBar: const GlobalAppBar(title: 'Explore New Friends'),
      body: StreamBuilder<QuerySnapshot>(
        stream: users.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final usersData = snapshot.data!.docs;

          return ListView.builder(
            itemCount: usersData.length,
            itemBuilder: (context, index) {
              final user = usersData[index].data() as Map<String, dynamic>;
              final userId = usersData[index].id; // Get the document ID

              return ListTile(
                leading: Icon(Icons.person),
                title: Text(user['username']),
                trailing: MyFollowButton(userId: userId),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(userId: userId),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
