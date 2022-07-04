import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/social_model/message_model.dart';
import 'package:social_app/models/social_model/social_user_model.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class ChatDetailScreen extends StatelessWidget {
  SocialUserModel? chatModel;

  ChatDetailScreen({model}) {
    chatModel = model;
  }

  @override
  Widget build(BuildContext context) {
    var textController = TextEditingController();
    return Builder(builder: (context) {
      SocialCubit.get(context)
          .getMessages(receiverId: chatModel?.uId as String);
      return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 25.0,
                    backgroundImage: NetworkImage(
                      '${chatModel?.profile}',
                    ),
                  ),
                  const SizedBox(
                    width: 15.0,
                  ),
                  Text(
                    '${chatModel?.name}',
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          height: 1.4,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SocialCubit.get(context).messages.isNotEmpty
                  ? Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            itemBuilder: (context, index) {
                              var message =
                                  SocialCubit.get(context).messages[index];
                              if (SocialCubit.get(context).userModel?.uId ==
                                  message.receiverId) {
                                return buildMyMessage(message);
                              }
                              return buildMyMessage(message);
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 10.0,
                            ),
                            itemCount: SocialCubit.get(context).messages.length,
                          ),
                        ),
                        Container(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey[300] as Color,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: TextFormField(
                                    controller: textController,
                                    decoration: InputDecoration(
                                      hintText: 'write your message here...',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  SocialCubit.get(context).sendMessage(
                                    text: textController.text,
                                    receiverId: chatModel?.uId as String,
                                    dateTime: DateTime.now().toString(),
                                  );
                                  textController.clear();
                                },
                                color: Colors.blue,
                                minWidth: 1.0,
                                height: 50.0,
                                child: Icon(
                                  IconBroken.Send,
                                  size: 18.0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          );
        },
      );
    });
  }

  Widget buildMessage(MessageModel message) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.only(
            bottomEnd: Radius.circular(10.0),
            topEnd: Radius.circular(10.0),
            topStart: Radius.circular(10.0),
          ),
          color: Colors.grey[300],
        ),
        child: Text(
          message.text,
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }

  Widget buildMyMessage(MessageModel message) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.only(
            bottomStart: Radius.circular(10.0),
            topEnd: Radius.circular(10.0),
            topStart: Radius.circular(10.0),
          ),
          color: Colors.blue.withOpacity(.2),
        ),
        child: Text(
          message.text,
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}
