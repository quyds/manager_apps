import 'package:firebase_auth/firebase_auth.dart';

void updateDisplayName(String name) {
  var user = FirebaseAuth.instance.currentUser;
  user?.updateDisplayName(name).then((value) {
    print("DisplayName has been changed successfully");
  }).catchError((e) {
    print("There was an error updating profile");
  });
}

void updatePhotoUrl(String url) {
  var user = FirebaseAuth.instance.currentUser;
  user?.updatePhotoURL(url).then((value) {
    print("photoUrl has been changed successfully");
  }).catchError((e) {
    print("There was an error updating profile");
  });
}
