import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

import '../modules/new_post/new_post_screen.dart';

class HomeLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is SocialNewPostState) {
          navigateTo(context: context, page: NewPostScreen());
        }
      },
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              cubit.titles[cubit.currentIndex],
            ),
            actions: [
              IconButton(
                icon: Icon(
                  IconBroken.Notification,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  IconBroken.Search,
                ),
                onPressed: () {},
              ),
            ],
            // backgroundColor: Colors.white,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index){
              cubit.changeBottomNavBar(index: index);
            },
            items:  [
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Home,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Chat,
                ),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Paper_Upload,
                ),
                label: 'Post',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Location,
                ),
                label: 'Users',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Setting,
                ),
                label: 'Settings',
              ),
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
        );
      },
    );
  }
}

//cubit.model != null
//               ? Column(
//                   children: [
//                     !FirebaseAuth.instance.currentUser!.emailVerified
//                         ? Container(
//                             color: Colors.amber.withOpacity(.6),
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 12.0,
//                             ),
//                             child: Row(
//                               children: [
//                                 const Icon(
//                                   Icons.info_outline_rounded,
//                                 ),
//                                 const SizedBox(
//                                   width: 15.0,
//                                 ),
//                                 const Expanded(
//                                   child: Text(
//                                     'please verify your email',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                                 TextButton(
//                                   onPressed: () {
//                                     FirebaseAuth.instance.currentUser
//                                         ?.sendEmailVerification()
//                                         .then(
//                                       (value) {
//                                         showToast(
//                                           msg: 'check your email.',
//                                           state: ToastStates.SUCCESS,
//                                         );
//                                       },
//                                     );
//                                   },
//                                   child: const Text(
//                                     'SEND',
//                                     style: TextStyle(
//                                       color: Colors.blue,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )
//                         : const Text(
//                             'hello',
//                           ),
//                   ],
//                 )
//               : const Center(
//                   child: CircularProgressIndicator(),
//                 ),
