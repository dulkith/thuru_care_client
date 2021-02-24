import 'package:flutter/material.dart';

class User {
  final String doc_id;
  final String id;
  final String email;
  final String name;
  final String country;
  final String profile_image;
  final String token;
  final String gender;

  User({
    this.doc_id,
    @required this.id,
    @required this.email,
    this.name,
    this.country,
    this.profile_image,
    @required this.token,
    this.gender
  });
}