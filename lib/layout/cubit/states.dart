abstract class SocialStates{}
class SocialInitState extends SocialStates{}
class SocialGetUserLoadingState extends SocialStates{}
class SocialGetUserSuccessState extends SocialStates{}
class SocialGetUserErrorState extends SocialStates{}

class SocialGetAllUserSuccessState extends SocialStates{}
class SocialGetAllUserErrorState extends SocialStates{}

class SocialChangeBottomNavState extends SocialStates{}
class SocialNewPostState extends SocialStates{}

class SocialGetImagePickerSuccessState extends SocialStates{}
class SocialGetImagePickerErrorState extends SocialStates{}

class SocialUploadImageErrorState extends SocialStates{}
//class SocialUploadCoverImageErrorState extends SocialStates{}
class SocialUserUpdateLoadingState extends SocialStates{}
class SocialUserUpdateErrorState extends SocialStates{}

class SocialGetPostImageSuccessState extends SocialStates{}
class SocialGetPostImageErrorState extends SocialStates{}
class SocialRemovePostImageSuccessState extends SocialStates{}


class SocialCreatePostLoadingState extends SocialStates{}
class SocialUploadPostImageErrorState extends SocialStates{}
class SocialCreatePostSuccessState extends SocialStates{}
class SocialCreatePostErrorState extends SocialStates{}


class SocialGetPostsLoadingState extends SocialStates{}
class SocialGetPostsSuccessState extends SocialStates{}
class SocialGetPostsErrorState extends SocialStates{
  final error;
  SocialGetPostsErrorState(this.error);
}

class SocialGetMessagesSuccessState extends SocialStates{}


class SocialLikePostSuccessState extends SocialStates{}
class SocialLikePostErrorState extends SocialStates{
  final error;
  SocialLikePostErrorState(this.error);
}

class SocialCommentPostSuccessState extends SocialStates{}
class SocialCommentPostErrorState extends SocialStates{
  final error;
  SocialCommentPostErrorState(this.error);
}

class SocialSendMessageSuccessState extends SocialStates{}
class SocialSendMessageErrorState extends SocialStates{
  final error;
  SocialSendMessageErrorState(this.error);
}

