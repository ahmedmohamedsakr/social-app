import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/social_model/social_user_model.dart';
import 'package:social_app/modules/register/cubit/states.dart';

class SocialRegisterCubit extends Cubit<SocialRegisterStates> {
  SocialRegisterCubit() : super(SocialRegisterInitState());

  static SocialRegisterCubit get(context) => BlocProvider.of(context);

  void register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    emit(SocialRegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then(
      (value) {
        print(value.user?.uid);
        print(value.user?.email);
        createUser(
            name: name, email: email, phone: phone, uId: value.user!.uid);
        //emit(SocialRegisterSuccessState());
      },
    ).catchError(
      (error) {
        print(error.toString());
        emit(SocialRegisterErrorState(error));
      },
    );
  }

  void createUser({
    required String name,
    required String email,
    required String phone,
    required String uId,
  }) {
    SocialUserModel model = SocialUserModel(
      email: email,
      name: name,
      phone: phone,
      uId: uId,
      cover:
          'https://img.freepik.com/free-photo/always-state-wonder-awe_73899-12.jpg?w=1380',
      profile:
          'https://img.freepik.com/free-photo/young-man-student-with-notebooks-showing-thumb-up-approval-smiling-satisfied-blue-studio-background_1258-65597.jpg?t=st=1656326717~exp=1656327317~hmac=bacacb645cc1c3acfdeb81ae01faa2dc84c2304f518c38463c8fb643ad110567&w=996',
      bio: 'write your bio...',
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then(
      (value) {
        emit(SocialCreateUserSuccessState());
      },
    ).catchError(
      (error) {
        print(error.toString());
        emit(SocialCreateUserErrorState(error));
      },
    );
  }

  bool isSecure = true;
  IconData suffixIcon = Icons.visibility_outlined;

  void showPassword() {
    isSecure = !isSecure;
    suffixIcon =
        isSecure ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(SocialRegisterChangeVisibilityState());
  }
} //Cubit class
