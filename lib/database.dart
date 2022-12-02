import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  // Upload user information for authentication to database
  uploadUserInfo(String userId, Map<String, dynamic> userMap) {
    FirebaseFirestore.instance.collection("users")
        .doc(userId)
        .set(userMap)
        .catchError((e){
          print(e.toString());
    });
  }

  // Create a task (add task) and add it to database
  createTask(String userId, Map<String, dynamic> taskMap) {
    FirebaseFirestore.instance.collection("users")
        .doc(userId)
        .collection("tasks")
        .add(taskMap);
  }

  // Update a task (check it off) on database
  updateTask(String userId, Map<String, dynamic> taskMap, String documentId) {
    FirebaseFirestore.instance.collection("users")
        .doc(userId)
        .collection("tasks")
        .doc(documentId)
        .set(taskMap, SetOptions(merge: true));
  }

  // Get task from Firestore database
  getTasks(String userId) async {
    return await FirebaseFirestore.instance.collection("users")
        .doc(userId)
        .collection("tasks")
        .snapshots();
  }

  // Delete task on database
  deleteTask(String userId, String documentId) {
    FirebaseFirestore.instance.collection("users")
        .doc(userId)
        .collection("tasks")
        .doc(documentId)
        .delete()
        .catchError((e) {
          print(e.toString());
        });
  }
}