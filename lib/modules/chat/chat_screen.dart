import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/social_model/social_user_model.dart';
import 'package:social_app/modules/chat_detail/chat_detail_screen.dart';
import 'package:social_app/shared/components/components.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return ListView.separated(
          itemBuilder: (context, index) =>
              SocialCubit.get(context).users.length>0?buildChatItem(context,SocialCubit.get(context).users[index]):const Center(child: CircularProgressIndicator(),),
          separatorBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey[300],
            ),
          ),
          itemCount: SocialCubit.get(context).users.length,
        );
      },
    );
  }

  Widget buildChatItem(context,SocialUserModel model) {
    return InkWell(
      onTap: (){
        navigateTo(context: context, page: ChatDetailScreen(model: model,));
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage(
                '${model.profile}',
              ),
            ),
            const SizedBox(
              width: 15.0,
            ),
            Text(
              '${model.name}',
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    height: 1.4,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
