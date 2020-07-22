import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Post {
  String _userIdWhoPosted, _content, _imageUrl, _postId, _profile_url;
  Timestamp _time_posted;
  Map<String, dynamic> _comments;
  bool _isImage, _is_yt_vid;

  List<dynamic> _likes;

  List<dynamic> get likes => _likes;

  set likes(List<dynamic> value) {
    _likes = value;
  }

  get is_yt_vid => _is_yt_vid;

  set is_yt_vid(value) {
    _is_yt_vid = value;
  }

  bool get isImage => _isImage;

  set isImage(bool value) {
    _isImage = value;
  }

  Map<String, dynamic> get comments => _comments;

  set comments(Map<String, dynamic> value) {
    _comments = value;
  }

  get profile_url => _profile_url;

  set profile_url(value) {
    _profile_url = value;
  }

  String get userIdWhoPosted => _userIdWhoPosted;

  set userIdWhoPosted(String value) {
    _userIdWhoPosted = value;
  }

  Timestamp get time_posted => _time_posted;

  set time_posted(Timestamp value) {
    _time_posted = value;
  }

  get postId => _postId;

  set postId(value) {
    _postId = value;
  }

  get content => _content;

  get imageUrl => _imageUrl;

  set imageUrl(value) {
    _imageUrl = value;
  }

  set content(value) {
    _content = value;
  }
}
