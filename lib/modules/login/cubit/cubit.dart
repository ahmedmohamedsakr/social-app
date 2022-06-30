import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/login/cubit/states.dart';

class SocialLoginCubit extends Cubit<SocialLoginStates> {
  SocialLoginCubit() : super(SocialLoginInitState());

  static SocialLoginCubit get(context) => BlocProvider.of(context);

  void login({
    required String email,
    required String password,
  }) {
    emit(SocialLoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value){
      print(value.user?.uid);
      print(value.user?.email);
      emit(SocialLoginSuccessState(value.user?.uid));
    }).catchError((error){
      print(error.toString());
      emit(SocialLoginErrorState(error));
    });
  }

  bool isSecure=true;
  IconData suffixIcon=Icons.visibility_outlined;
  void showPassword(){
    isSecure=!isSecure;
    suffixIcon=isSecure?Icons.visibility_outlined:Icons.visibility_off_outlined;
    emit(SocialChangeVisibilityState());
  }

}//Cubit class
