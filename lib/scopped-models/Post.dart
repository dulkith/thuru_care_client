import 'package:scoped_model/scoped_model.dart';
import 'package:thuru_care_client/models/PostModel.dart';

class Posts extends Model {
  List<PostModel> _postList = [];


  List<PostModel> get postsLists{
    return List.from(this._postList);
  }




}