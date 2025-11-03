import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final uid = user["uid"];
              final name = user["name"];

              // Don't show current user
              if (uid == currentUserId) return Container();

              return ListTile(
                title: Text(name, style: const TextStyle(color: Colors.white)),
                subtitle: Text(user["email"], style: TextStyle(color: Colors.grey[400])),
                leading: const CircleAvatar(child: Icon(Icons.person)),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatPage(
                        receiverId: uid,
                        receiverName: name,
                      ),
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
