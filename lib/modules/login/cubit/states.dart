abstract class SocialLoginStates{}

class SocialLoginInitState extends SocialLoginStates{}

class SocialLoginSuccessState extends SocialLoginStates{
  final uId;
  SocialLoginSuccessState(this.uId);
}
class SocialLoginLoadingState extends SocialLoginStates{}
class SocialLoginErrorState extends SocialLoginStates{
  final error;
  SocialLoginErrorState(this.error);
}
class SocialChangeVisibilityState extends SocialLoginStates{}
