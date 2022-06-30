class PostModel {
  String? name;
  String? profileImage;
  String? uId;
  String? dateTime;
  String? text;
  String? postImage;

  PostModel({
    required this.name,
    required this.uId,
    this.profileImage,
    required this.dateTime,
    required this.text,
    this.postImage,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    uId = json['uId'];
    profileImage = json['profileImage'];
    dateTime = json['dateTime'];
    text = json['text'];
    postImage = json['postImage'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uId': uId,
      'profileImage': profileImage,
      'dateTime': dateTime,
      'text': text,
      'postImage': postImage,
    };
  }
}
