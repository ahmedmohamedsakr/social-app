class SocialUserModel {
  String? name;
  String? phone;
  String? email;
  String? uId;
  String? cover;
  String? profile;
  String? bio;

  SocialUserModel({
    required this.email,
    required this.name,
    required this.phone,
    required this.uId,
    this.cover,
    this.profile,
    this.bio,
  });

   SocialUserModel.fromJson(Map<String, dynamic>? json) {
    email = json!['email'];
    name = json['name'];
    phone = json['phone'];
    uId = json['uId'];
    cover = json['cover'];
    profile = json['photo'];
    bio = json['bio'];
  }

   Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'phone': phone,
      'uId': uId,
      'cover': cover,
      'photo': profile,
      'bio': bio,
    };
  }
}
