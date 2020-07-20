import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:virtualclass/modals/classModal.dart';
import 'package:virtualclass/modals/skillModal.dart';
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

  final CollectionReference skillCollection =
      Firestore.instance.collection('skills');

  final CollectionReference classesCollection =
      Firestore.instance.collection('classes');

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
      'skills_made': [],
      'classes_made': [],
      'teams_made': [],
      'location': '',
      'skills_joined': [],
      'classes_joined': [],
      'teams_joined': [],
      'skills': [],
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

  Future makePostWithIamge(String fileName, Uuid uuid, String caption,
      String uid, String AssignedWith) async {
    //Whenever Stucked with Instance of Dynamic try Using var Insted Of String i Solvs
    var fileUrl;
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('images/').child(fileName);
    fileUrl = await firebaseStorageRef.getDownloadURL();

    DocumentSnapshot snapshot =
        await Firestore.instance.collection('users').document(uid).get();

    var userName = snapshot.data['name'];
    var profileUrl = snapshot.data['profile_url'];
    updateuserPostmade(fileName);

    return await postCollection.document(fileName).setData({
      'content': caption,
      'image_url': fileUrl,
      'likes': 0,
      'post_id': fileName,
      'time_uploaded': Timestamp.fromDate(DateTime.now()),
      'user_id_who_posted': userName + '??.??' + uid,
      'comments': {},
      'profile_url': profileUrl,
      'is_image': true,
      'assigned_with': AssignedWith,
    });
  }

  Future makePostWithVideo(String fileName, Uuid uuid, String caption,
      String uid, BuildContext context, String AssignedWith) async {
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
      updateuserPostmade(fileName);

      return await postCollection.document(fileName).setData({
        'content': caption,
        'image_url': fileUrl,
        'likes': 0,
        'post_id': fileName,
        'time_uploaded': Timestamp.fromDate(DateTime.now()),
        'user_id_who_posted': userName + '??.??' + uid,
        'comments': {},
        'profile_url': profileUrl,
        'is_image': false,
        'assigned_with': AssignedWith,
      });
    }
  }

  void updateuserPostmade(String postId) async {
    // just Adding No of Post Noe AfterWord Add image Urkl to shghow In user profile Section
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('users').document(uid).get();
    int newNoOfPosts = snapshot.data['no_of_posts'] + 1;
    var posts = new List(newNoOfPosts);
    posts = snapshot.data['posts'];
    posts.add(postId);
    return await userCollection
        .document(uid)
        .updateData({'no_of_posts': newNoOfPosts, 'posts': posts});
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

  Future updateSkillPicture(String fileName, Uuid uuid, String skillId) async {
    var fileUrl;
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('images/').child(fileName);
    fileUrl = await firebaseStorageRef.getDownloadURL();

    return await skillCollection
        .document(skillId)
        .updateData({'skill_image': fileUrl});
  }

  Future updateclassPicture(String fileName, Uuid uuid, String skillId) async {
    var fileUrl;
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('images/').child(fileName);
    fileUrl = await firebaseStorageRef.getDownloadURL();

    return await classesCollection
        .document(skillId)
        .updateData({'class_image': fileUrl});
  }

  Future updateTeamsPicture(String fileName, Uuid uuid, String teamId) async {
    var fileUrl;
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('images/').child(fileName);
    fileUrl = await firebaseStorageRef.getDownloadURL();

    return await teamsCollection
        .document(teamId)
        .updateData({'team_image': fileUrl});
  }

  Future makeNewTeam(Team team) async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('users').document(uid).get();
    var userName = snapshot.data['name'];

    updateUserTeamsMade(team.teamId, team.teamName);

    return await teamsCollection
        .document(team.teamId + '??.??' + team.teamName)
        .setData({
      'team_name': team.teamName,
      'about': team.about,
      'location': team.location,
      'who_can_post': team.whoCnaPost,
      'who_can_see_post': team.whoCanSeePost,
      'who_can_send_message': team.whoCanSendMessage,
      'team_id': team.teamId + '??.??' + team.teamName,
      'user_id': team.userId,
      'members': {},
      'host': userName,
      'date_created': Timestamp.fromDate(new DateTime.now()),
      'team_image': ''
    });
  }

  Future updateUserTeamsMade(String teamId, String teamName) async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('users').document(uid).get();
    var teamsMade = snapshot.data['teams_made'];
    teamsMade.add(teamId + '??.??' + teamName);
    return await userCollection.document(uid).updateData({
      'teams_made': teamsMade,
    });
  }

  Future makeNewSkill(Skill skill) async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('users').document(uid).get();
    var userName = snapshot.data['name'];

    updateuserCreatedSkills(skill.skillId, skill.skillName);
    return await skillCollection
        .document(skill.skillId + '??.??' + skill.skillName)
        .setData({
      'skill_name': skill.skillName,
      'about': skill.about,
      'who_can_post': skill.whoCnaPost,
      'who_can_see_post': skill.whoCanSeePost,
      'who_can_send_message': skill.whoCanSendMessage,
      'skill_id': skill.skillId + '??.??' + skill.skillName,
      'user_id': skill.userId,
      'host': userName,
      'fees': skill.price,
      'members': {},
      'date_created': Timestamp.fromDate(new DateTime.now()),
      'skill_image': ''
    });
  }

  Future updateuserCreatedSkills(String skillId, String skillName) async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('users').document(uid).get();
    var skillsMade = snapshot.data['skills_made'];
    skillsMade.add(skillId + '??.??' + skillName);
    return await userCollection.document(uid).updateData({
      'skills_made': skillsMade,
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

  Future makeNewClass(Classes classes) async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('users').document(uid).get();
    var userName = snapshot.data['name'];

    DateTime startTime = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, classes.startTime.hour, classes.startTime.minute);

    updateuserCreatedClass(classes.classId, classes.className);
    return await classesCollection
        .document(classes.classId + '??.??' + classes.className)
        .setData({
      'class_name': classes.className,
      'location': classes.location,
      'start_date': classes.startDate,
      'end_date': classes.endDate,
      'is_daily': classes.daily,
      'timing': startTime,
      'about': classes.about,
      'class_id': classes.classId + '??.??' + classes.className,
      'user_id': classes.userId,
      'host': userName,
      'fees': classes.fees,
      'time_created': Timestamp.fromDate(new DateTime.now()),
      'class_image': '',
      'members': {},
    });
  }

  void updateuserCreatedClass(String classId, String className) async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('users').document(uid).get();
    var skillsMade = snapshot.data['classes_made'];
    skillsMade.add(classId + '??.??' + className);
    return await userCollection.document(uid).updateData({
      'classes_made': skillsMade,
    });
  }

  Future makwPostWithCaption(Uuid uuid, String caption, String uid,
      BuildContext context, String assigedWith) async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('users').document(uid).get();

    var userName = snapshot.data['name'];
    var profileUrl = snapshot.data['profile_url'];
    updateuserPostmade(uid);
    String uniquePostId = uuid.v1();

    return await postCollection.document(uniquePostId).setData({
      'content': caption,
      'likes': 0,
      'post_id': uniquePostId,
      'time_uploaded': Timestamp.fromDate(DateTime.now()),
      'user_id_who_posted': userName + '??.??' + uid,
      'comments': {},
      'profile_url': profileUrl,
      'is_image': false,
      'assigned_with': assigedWith,
      'image_url': null,
    });
  }

  Future makeSkillsMember(String skillId) async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('skills').document(skillId).get();
    Map<String, dynamic> members = snapshot.data['members'];
    members.putIfAbsent(uid, () => uid);
    updateUserJoinedSkills(skillId);
    return await skillCollection.document(skillId).updateData({
      'members': members,
    });
  }

  Future updateUserJoinedSkills(String skillId) async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('users').document(uid).get();
    var skillsJoined = snapshot.data['skills_joined'];
    skillsJoined.add(skillId);

    return await userCollection.document(uid).updateData({
      'skills_joined': skillsJoined,
    });
  }

  Future updateUserLeavedSkills(String skillId) async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('users').document(uid).get();
    var skillsJoined = snapshot.data['skills_joined'];
    skillsJoined.remove(skillId);
    removememberfromSkill(skillId);
    return await userCollection.document(uid).updateData({
      'skills_joined': skillsJoined,
    });
  }

  Future removememberfromSkill(String skillId) async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('skills').document(skillId).get();
    Map<String, dynamic> members = snapshot.data['members'];
    members.remove(uid);

    return await skillCollection.document(skillId).updateData({
      'members': members,
    });
  }

  Future makeTeamMember(String teamId) async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('teams').document(teamId).get();
    Map<String, dynamic> members = snapshot.data['members'];
    members.putIfAbsent(uid, () => uid);
    updateUserJoinedTeams(teamId);
    return await teamsCollection.document(teamId).updateData({
      'members': members,
    });
  }

  Future updateUserJoinedTeams(String teamId) async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('users').document(uid).get();
    var teamsJoined = snapshot.data['teams_joined'];
    teamsJoined.add(teamId);

    return await userCollection.document(uid).updateData({
      'teams_joined': teamsJoined,
    });
  }

  Future updateUserLeavedTeams(String teamId) async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('users').document(uid).get();
    var teamsJoined = snapshot.data['teams_joined'];
    teamsJoined.remove(teamId);
    removememberfromTeam(teamId);
    return await userCollection.document(uid).updateData({
      'teams_joined': teamsJoined,
    });
  }

  Future removememberfromTeam(String teamId) async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('teams').document(teamId).get();
    Map<String, dynamic> members = snapshot.data['members'];
    members.remove(uid);

    return await teamsCollection.document(teamId).updateData({
      'members': members,
    });
  }

  Future makeClassMember(String classId) async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('classes').document(classId).get();
    Map<String, dynamic> members = snapshot.data['members'];
    members.putIfAbsent(uid, () => uid);
    updateUserJoinedClasses(classId);
    return await classesCollection.document(classId).updateData({
      'members': members,
    });
  }

  Future updateUserJoinedClasses(String classId) async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('users').document(uid).get();
    var classJoined = snapshot.data['classes_joined'];
    classJoined.add(classId);

    return await userCollection.document(uid).updateData({
      'classes_joined': classJoined,
    });
  }

  Future updateUserLeavedClasses(String classId) async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('users').document(uid).get();
    var classesJoined = snapshot.data['classes_joined'];
    classesJoined.remove(classId);
    removememberfromClass(classId);
    return await userCollection.document(uid).updateData({
      'classes_joined': classesJoined,
    });
  }

  Future removememberfromClass(String classId) async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('classes').document(classId).get();
    Map<String, dynamic> members = snapshot.data['members'];
    members.remove(uid);

    return await classesCollection.document(classId).updateData({
      'members': members,
    });
  }

  Future followUser(String otherUser) async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('users').document(uid).get();
    var following = snapshot.data['following'];
    following.add(otherUser);
    updateOtherUsersFollowers(otherUser);
    return await userCollection.document(uid).updateData({
      'following': following,
    });
  }

  Future updateOtherUsersFollowers(String otherUser) async {
    DocumentSnapshot snp =
        await Firestore.instance.collection('users').document(otherUser).get();
    var followers = snp.data['followers'];
    followers.add(uid);

    return await userCollection.document(otherUser).updateData({
      'followers': followers,
    });
  }

  Future unFollowUser(String otherUser) async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('users').document(otherUser).get();
    var followers = snapshot.data['followers'];
    followers.remove(uid);
    removeFromFolllowing(otherUser);
    return await userCollection.document(otherUser).updateData({
      'followers': followers,
    });
  }

  Future removeFromFolllowing(String otherUser) async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('users').document(uid).get();
    var following = snapshot.data['following'];
    following.remove(otherUser);
    return await userCollection.document(uid).updateData({
      'following': following,
    });
  }
}
