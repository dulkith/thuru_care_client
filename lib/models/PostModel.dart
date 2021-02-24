class PostModel {
  String post_id;
  String profile_id;
  String profile_name;
  String profile_country;
  String profile_image;
  String post_image;
  String post_desc;
  String post_likes;
  String post_timestamp;
  List<String> post_comments;
  List<String> post_comments_profile_name;
  List<String> post_comments_profile_image_id;
  List<String> post_comments_timestamp;

  PostModel(String post_id,
      String profile_id,
      String profile_name,
      String profile_country,
      String profile_image,
      String post_image,
      String post_desc,
      String post_likes,
      String post_timestamp,
      List<dynamic> post_comments,
      List<dynamic> post_comments_profile_name,
      List<dynamic> post_comments_profile_image_id,
      List<dynamic> post_comments_timestamp){
      this.post_id = post_id;
      this.profile_id = profile_id;
      this.profile_name = profile_name;
      this.profile_country = profile_country;
      this.profile_image = profile_image;
      this.post_image = post_image;
      this.post_desc = post_desc;
      this.post_likes = post_likes;
      this.post_timestamp = post_timestamp;
      this.post_comments = post_comments.cast<String>();
      this.post_comments_profile_name = post_comments_profile_name.cast<String>();
      this.post_comments_profile_image_id = post_comments_profile_image_id.cast<String>();
      this.post_comments_timestamp = post_comments_timestamp.cast<String>();

  }

  

  
}
