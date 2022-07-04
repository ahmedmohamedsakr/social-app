import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/social_model/message_model.dart';
import 'package:social_app/models/social_model/post_model.dart';
import 'package:social_app/models/social_model/social_user_model.dart';
import 'package:social_app/modules/chat/chat_screen.dart';
import 'package:social_app/modules/feeds/feeds_screen.dart';
import 'package:social_app/modules/new_post/new_post_screen.dart';
import 'package:social_app/modules/settings/settings_screen.dart';
import 'package:social_app/modules/users/users_screen.dart';

import '../../shared/components/constants.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitState());

  static SocialCubit get(context) => BlocProvider.of(context);

  SocialUserModel? userModel;

  int currentIndex = 0;
  List<Widget> screens = [
    FeedsScreen(),
    ChatScreen(),
    NewPostScreen(),
    UsersScreen(),
    SettingsScreen(),
  ];

  List<String> titles = [
    'Home',
    'Chat',
    'New Post',
    'Users',
    'Settings',
  ];

  void changeBottomNavBar({required int index}) {
    if (index == 1) {
      getAllUsers();
    }
    if (index == 2) {
      emit(SocialNewPostState());
    } else {
      currentIndex = index;
      emit(SocialChangeBottomNavState());
    }
  }

  var picker = ImagePicker();
  File? profileImage;
  File? coverImage;

  Future<void> getImagePicker(bool source) async {
    //print('imagePicker');
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      source
          ? profileImage = File(pickedFile.path)
          : coverImage = File(pickedFile.path);
      emit(SocialGetImagePickerSuccessState());
    } else {
      print('No image selected.');
      emit(SocialGetImagePickerErrorState());
    }
  }

  void getUserData() {
    emit(SocialGetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then(
      (value) {
        //print(value.data());
        userModel = SocialUserModel.fromJson(value.data());
        emit(SocialGetUserSuccessState());
      },
    ).catchError(
      (error) {
        print(error.toString());
        emit(SocialGetUserErrorState());
      },
    );
  }

  //upload profile & cover image
  void uploadImage({
    required String? name,
    required String? bio,
    required String? phone,
    required bool isProfile,
  }) {
    emit(SocialUserUpdateLoadingState());
    var userImage = isProfile ? profileImage : coverImage;
    var imageRef = Uri.file(userImage!.path).pathSegments.last;
    // print('imageRef:$imageRef');
    FirebaseStorage.instance
        .ref()
        .child('users/$imageRef')
        .putFile(userImage)
        .then(
      (value) {
        // print('hello:$value');
        value.ref.getDownloadURL().then(
          (value) {
            //print(value);
            isProfile
                ? updateUser(name: name, bio: bio, phone: phone, profile: value)
                : updateUser(name: name, bio: bio, phone: phone, cover: value);
          },
        ).catchError(
          (error) {
            // print('first');
            print(error.toString());
            emit(SocialUploadImageErrorState());
          },
        );
      },
    ).catchError(
      (error) {
        //print('second');
        print(error.toString());
        emit(SocialUploadImageErrorState());
      },
    );
  }

  // void uploadCoverImage() {
  //   emit(SocialUserUpdateLoadingState());
  //   var imageRef = Uri.file(coverImage!.path).pathSegments.last;
  //   FirebaseStorage.instance
  //       .ref()
  //       .child('images/$imageName')
  //       .putFile(coverImage!)
  //       .then(
  //     (value) {
  //       value.ref.getDownloadURL().then(
  //         (value) {
  //           updateUser(cover: value);
  //         },
  //       ).catchError(
  //         (error) {
  //           emit(SocialUploadCoverImageErrorState());
  //         },
  //       );
  //     },
  //   ).catchError(
  //     (error) {
  //       emit(SocialUploadCoverImageErrorState());
  //     },
  //   );
  // }
  //
  void updateUser({
    required String? name,
    required String? phone,
    required String? bio,
    String? cover,
    String? profile,
  }) {
    if (cover == null && profile == null) emit(SocialUserUpdateLoadingState());
    SocialUserModel model = SocialUserModel(
      name: name ?? userModel?.name,
      phone: phone ?? userModel?.phone,
      bio: bio ?? userModel?.bio,
      uId: userModel?.uId,
      email: userModel?.email,
      cover: cover ?? userModel?.cover,
      profile: profile ?? userModel?.profile,
    );
    //print(profile);
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .update(model.toMap())
        .then((value) => getUserData())
        .catchError(
      (error) {
        emit(SocialUserUpdateErrorState());
      },
    );
  }

  File? postImage;

  void getPostImage() async {
    var pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialGetPostImageSuccessState());
    } else {
      print('No Image Selected');
      emit(SocialGetPostImageErrorState());
    }
  }

  void removePostImage() {
    postImage = null;
    emit(SocialRemovePostImageSuccessState());
  }

  void uploadPostImage({
    required String? dateTime,
    required String? text,
  }) {
    emit(SocialCreatePostLoadingState());
    var imageRef = Uri.file(postImage!.path).pathSegments.last;
    // print('imageRef:$imageRef');
    FirebaseStorage.instance
        .ref()
        .child('posts/$imageRef')
        .putFile(postImage!)
        .then(
      (value) {
        value.ref.getDownloadURL().then(
          (value) {
            createPost(dateTime: dateTime, text: text, postImage: value);
          },
        ).catchError(
          (error) {
            print(error.toString());
            emit(SocialUploadPostImageErrorState());
          },
        );
      },
    ).catchError(
      (error) {
        //print('second');
        print(error.toString());
        emit(SocialUploadPostImageErrorState());
      },
    );
  }

  void createPost({
    required String? dateTime,
    required String? text,
    String? postImage,
  }) {
    PostModel model = PostModel(
      name: userModel?.name,
      uId: userModel?.uId,
      text: text,
      dateTime: dateTime,
      postImage: postImage,
    );
    //print(profile);
    FirebaseFirestore.instance.collection('posts').add(model.toMap()).then(
      (value) {
        emit(SocialCreatePostSuccessState());
      },
    ).catchError(
      (error) {
        emit(SocialCreatePostErrorState());
      },
    );
  }

  List<PostModel> posts = [];
  List<String> postId = [];
  List<int> likes = [];

  //List<String>? postComments = []; //comment doc id
  List<int> comments = []; // number of comments on each post.

  void getPosts() {
    FirebaseFirestore.instance.collection('posts').get().then(
      (value) {
        value.docs.forEach(
          (element) {
            element.reference.collection('likes').get().then(
              (value) {
                likes.add(value.docs.length);
                postId.add(element.id);
                element.reference.collection('comments').get().then((value) {
                  comments.add(value.docs.length);
                  //postComments?.add(element.id);
                  posts.add(PostModel.fromJson(element.data()));
                }).catchError((error) {});
              },
            ).catchError((error) {});
          },
        );
        emit(SocialGetPostsSuccessState());
      },
    ).catchError(
      (error) {
        emit(SocialGetPostsErrorState(error));
      },
    );
  }

  void likePost({required String postId}) {
    //postId: add the user who make like.
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel?.uId)
        .set({'like': true}).then((value) {
      emit(SocialLikePostSuccessState());
    }).catchError((error) {
      emit(SocialLikePostErrorState(error));
    });
  }

  void commentPost({required String postId, required String comment}) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(userModel?.uId)
        .set({'comment': comment}).then((value) {
      emit(SocialCommentPostSuccessState());
    }).catchError(
      (error) {
        emit(SocialCommentPostErrorState(error));
      },
    );
  }

  List<SocialUserModel> users = [];

  void getAllUsers() {
    if (users.isEmpty) {
      FirebaseFirestore.instance.collection('users').get().then(
        (value) {
          value.docs.forEach((element) {
            if (element.data()['uId'] != userModel?.uId)
              users.add(SocialUserModel.fromJson(element.data()));
          });
          emit(SocialGetAllUserSuccessState());
        },
      ).catchError(
        (error) {
          emit(SocialGetAllUserErrorState());
        },
      );
    }
  }

  void sendMessage({
    required String text,
    required String receiverId,
    required String dateTime,
  }) {
    MessageModel model = MessageModel(
      text: text,
      senderId: userModel?.uId as String,
      receiverId: receiverId,
      dateTime: dateTime,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel?.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then(
      (value) {
        emit(SocialSendMessageSuccessState());
      },
    ).catchError(
      (error) {
        emit(SocialSendMessageErrorState(error));
      },
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel?.uId)
        .collection('messages')
        .add(model.toMap())
        .then(
      (value) {
        emit(SocialSendMessageSuccessState());
      },
    ).catchError(
      (error) {
        emit(SocialSendMessageErrorState(error));
      },
    );
  }

  List<MessageModel> messages = [];

  void getMessages({required String receiverId}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel?.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen(
      (event) {
        messages=[];
        event.docs.forEach(
          (element) {
            messages.add(MessageModel.fromJson(element.data()));
          },
        );
        emit(SocialGetMessagesSuccessState());
      },
    );
  }
}
