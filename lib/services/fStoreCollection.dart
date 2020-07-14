import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:virtualclass/modals/teamModal.dart';
import 'package:virtualclass/modals/userModal.dart';

class DbUserCollection {
  String uid;
  Uuid uuid;

  DbUserCollection(this.uid);

  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  final CollectionReference postCollection =
      Firestore.instance.collection('posts');

  final CollectionReference teamsCollection =
      Firestore.instance.collection('teams');

  Future pushUserDeta(Myusers user) async {
    return await userCollection.document(uid).setData({
      'followers': user.followers,
      'following': user.following,
      'images': user.images,
      'links': user.links,
      'name': user.name,
      'phone': user.phone,
      'posts': user.posts,
      'videos': user.videos,
      'email': user.email,
      'post_liked': user.post_liked,
      'profile_url': user.profile_url,
      'no_of_posts': user.noOfPost,
      'gender': user.gender,
      'interests': {
        'computer Networking': false,
        'Artificial Intelligence': false,
        'Graphic Design': false,
        'Python Programing': false,
      },
      'is_teacher': false,
    });
  }

  Future updateLikesinUser(String uid, likedPosts) async {
    return await userCollection.document(uid).updateData({
      'post_liked': likedPosts,
    });
  }

  Future addcomment(String comment, String uid, String postId) async {
    uuid = new Uuid();
    var newComment = comment;
    Map<String, dynamic> oldComments;
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('posts').document(postId).get();
    DocumentSnapshot usersnapshot =
        await Firestore.instance.collection('users').document(uid).get();
    var userImgurl = usersnapshot.data['profile_url'];
    var userName = usersnapshot.data['name'];
    oldComments = snapshot.data['comments'];
    oldComments.putIfAbsent(
        userImgurl +
            '>>.>>' +
            uid +
            '>>.>>' +
            DateTime.now().toString() +
            '>>.>>' +
            userName,
        () => newComment);

    return await postCollection.document(postId).updateData({
      'comments': oldComments,
    });
  }

  Future addLikeInPost(String postId) async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('posts').document(postId).get();
    int likesBefore = snapshot.data['likes'];

    return await postCollection
        .document(postId)
        .updateData({'likes': likesBefore + 1});
  }

  Future removeLikeInPost(String postId) async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('posts').document(postId).get();
    int likesBefore = snapshot.data['likes'];
    return await postCollection
        .document(postId)
        .updateData({'likes': likesBefore - 1});
  }

  Future<Myusers> getUserDeta(String uid) async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('users').document(uid).get();
    Myusers _user = new Myusers();

    _user.followers = snapshot.data['followers'];
    _user.following = snapshot.data['following'];
    _user.images = snapshot.data['images'];
    _user.links = snapshot.data['links'];
    _user.name = snapshot.data['name'];
    _user.phone = snapshot.data['phone'];
    _user.posts = snapshot.data['posts'];
    _user.videos = snapshot.data['videos'];
    _user.email = snapshot.data['email'];
    _user.post_liked = snapshot.data['post_liked'];
    _user.profile_url = snapshot.data['profile_url'];
    _user.noOfPost = snapshot.data['no_of_posts'];
    _user.gender = snapshot.data['gender'];

    return _user;
  }

  Future makePostWithIamge(
      String fileName, Uuid uuid, String caption, String uid) async {
    //Whenever Stucked with Instance of Dynamic try Using var Insted Of String i Solvs
    var fileUrl;
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('images/').child(fileName);
    fileUrl = await firebaseStorageRef.getDownloadURL();

    DocumentSnapshot snapshot =
        await Firestore.instance.collection('users').document(uid).get();

    var userName = snapshot.data['name'];
    var profileUrl = snapshot.data['profile_url'];

    return await postCollection.document(fileName).setData({
      'content': caption,
      'image_url': fileUrl,
      'likes': 0,
      'post_id': fileName,
      'time_uploaded': Timestamp.fromDate(DateTime.now()),
      'user_id_who_posted': userName,
      'comments': {},
      'profile_url': profileUrl,
      'is_image': true,
    });

    updateuserPostmade();
  }

  Future makePostWithVideo(String fileName, Uuid uuid, String caption,
      String uid, BuildContext context) async {
    //Whenever Stucked with Instance of Dynamic try Using var Insted Of String i Solvs
    var fileUrl;

    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('videos/').child(fileName);
    fileUrl = await firebaseStorageRef.getDownloadURL();
    if (fileUrl == null) {
      showDialog(
          context: context,
          child: Dialog(
            child: Text('Wait While Video Is Being Uploaded'),
          ));
    } else {
      DocumentSnapshot snapshot =
          await Firestore.instance.collection('users').document(uid).get();

      var userName = snapshot.data['name'];
      var profileUrl = snapshot.data['profile_url'];

      return await postCollection.document(fileName).setData({
        'content': caption,
        'image_url': fileUrl,
        'likes': 0,
        'post_id': fileName,
        'time_uploaded': Timestamp.fromDate(DateTime.now()),
        'user_id_who_posted': userName,
        'comments': {},
        'profile_url': profileUrl,
        'is_image': false,
      });
    }

    //updateuserPostmade();
  }

  Future updateuserProfilerPic(String fileName, Uuid uuid, String uid) async {
    var fileUrl;
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('images/').child(fileName);
    fileUrl = await firebaseStorageRef.getDownloadURL();

    return await userCollection
        .document(uid)
        .updateData({'profile_url': fileUrl});
  }

  void updateuserPostmade() async {
    // just Adding No of Post Noe AfterWord Add image Urkl to shghow In user profile Section
    DocumentSnapshot snapshot =
        await Firestore.instance.collection(uid).document(uid).get();
    int newNoOfPosts = snapshot.data['no_of_posts'] + 1;
    return await userCollection
        .document(uid)
        .updateData({'no_of_posts': newNoOfPosts});
  }

  Future makeNewTeam(Team team) async {
    return await teamsCollection.document(team.teamId).setData({
      'team_name': team.teamName,
      'about': team.about,
      'location': team.location,
      'who_can_post': team.whoCnaPost,
      'who_can_see_post': team.whoCanSeePost,
      'who_can_send_message': team.whoCanSendMessage,
      'team_id': team.teamId,
      'user_id': team.userId,
      'members': {},
    });
  }

  Future updateBasicUserData(String name, String email, String location,
      String skill, String uid) async {
    return await userCollection.document(uid).updateData({
      'name': name,
      'email': email,
      'location': location,
      'skill': skill,
    });
  }

  Future updateUserInterests(List<String> interests) async {
    return await userCollection.document(uid).updateData({
      'interests': interests,
    });
  }

  Future makeRoleUpdateRequest(String mail, String name) async {
    return await Firestore.instance
        .collection('professor_requests')
        .document(uid)
        .setData({
      'email': mail,
      'user_id': uid,
      'request_time': Timestamp.fromDate(new DateTime.now()),
      'name': name,
    });
  }

  Future makeAccountPrivate() async {
    return await userCollection.document(uid).updateData({
      'private_account': true,
    });
  }
}
