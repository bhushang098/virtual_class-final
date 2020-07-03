import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:virtualclass/modals/userModal.dart';

class DbUserCollection {
  String uid;

  DbUserCollection(this.uid);

  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  Future pushUserDeta(Myusers user) async {
    return await userCollection.document(uid).setData({
      'followers': user.followers.toString(),
      'following': user.following.toString(),
      'images': user.images,
      'links': user.links,
      'name': user.name,
      'phone': user.phone,
      'posts': user.posts,
      'videos': user.videos,
    });
  }
}
