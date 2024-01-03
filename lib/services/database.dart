import "package:cloud_firestore/cloud_firestore.dart";

class DatabaseService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('demo4_user');
  final CollectionReference locationCollection =
      FirebaseFirestore.instance.collection('location');

  final String uid;
  DatabaseService({required this.uid});

  Future setUserData(String name, String email, String password) async {
    return await userCollection.doc(uid).set({
      "name": name,
      "email": email,
      "password": password,
    });
  }

  Future<String?> getUserData() async {
    try {
      DocumentSnapshot dataSnapshot = await userCollection.doc(uid).get();
      if (dataSnapshot.exists) {
        String name = dataSnapshot["name"];
        return name;
      } else {
        print("Document does not exist for user with UID: $uid");
        return null;
      }
    } catch (e) {
      print("Error getting user data: $e");
    }
  }

  Future setLocation(String latitude, String longtude) async {
    return await locationCollection.doc(uid).update({
      "latitude": latitude,
      "longtude": longtude,
    });
  }

  Future getLocation() async {
    try {
      DocumentSnapshot dataSnapshot = await locationCollection.doc(uid).get();
      if (dataSnapshot.exists) {
        return dataSnapshot;
      }
    } catch (e) {}
  }
}
