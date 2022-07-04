import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class NewCommentScreen extends StatelessWidget {
  var commentController = TextEditingController();
  var formKey=GlobalKey<FormState>();
  late int index;
  NewCommentScreen({required index}){
    print('index:${index}');
   this.index=index;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        return Scaffold(
          appBar: kAppBar(context: context),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Form(
                  key: formKey,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25.0,
                        backgroundImage: NetworkImage(
                          '${cubit.userModel?.profile}',
                        ),
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      Expanded(
                        child: kTextFormField(
                          controller: commentController,
                          label: 'write a comment...',
                          validator: (value) {
                            if(value!.isEmpty)return 'please insert a comment';
                          },
                        ),
                      ),
                      IconButton(
                        iconSize: 25.0,
                        onPressed: () {
                          if(formKey.currentState!.validate()){
                            cubit.commentPost(postId: cubit.postId[index], comment: commentController.text);
                          }
                        },
                        icon: Icon(
                          IconBroken.Send,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
