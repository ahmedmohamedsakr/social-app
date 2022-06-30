import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/social_model/social_user_model.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class EditProfileScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        SocialUserModel? model = cubit.userModel;
        nameController.text = model!.name!;
        bioController.text = model.bio!;
        phoneController.text = model.phone!;
        var profileImage = cubit.profileImage;
        var coverImage = cubit.coverImage;
        return Scaffold(
          appBar: kAppBar(
            context: context,
            title: 'Edit Profile',
            actions: [
              TextButton(
                onPressed: () {
                  cubit.updateUser(
                    name: nameController.text,
                    bio: bioController.text,
                    phone: phoneController.text,
                  );
                },
                child: const Text(
                  'Update',
                ),
              ),
              const SizedBox(
                width: 15.0,
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (state is SocialUserUpdateLoadingState)
                    const LinearProgressIndicator(),
                  if (state is SocialUserUpdateLoadingState)
                    const SizedBox(
                      height: 5.0,
                    ),
                  SizedBox(
                    height: 200.0,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Align(
                              alignment: AlignmentDirectional.topCenter,
                              child: Container(
                                width: double.infinity,
                                height: 140.0,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(4.0),
                                  ),
                                  image: DecorationImage(
                                    image: coverImage == null
                                        ? NetworkImage('${model.cover}')
                                        : FileImage(coverImage)
                                            as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                cubit.getImagePicker(false);
                              },
                              icon: const CircleAvatar(
                                child: Icon(
                                  IconBroken.Camera,
                                  size: 20.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 64.0,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                radius: 60.0,
                                backgroundImage: profileImage == null
                                    ? NetworkImage(
                                        '${model.profile}',
                                      )
                                    : FileImage(profileImage) as ImageProvider,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                cubit.getImagePicker(true);
                              },
                              icon: const CircleAvatar(
                                child: Icon(
                                  IconBroken.Camera,
                                  size: 20.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  if (cubit.coverImage != null || cubit.profileImage != null)
                    Row(
                      children: [
                        if (cubit.coverImage != null)
                          Expanded(
                            child: kButton(
                              onPressed: () {
                                cubit.uploadImage(
                                  name: nameController.text,
                                  bio: bioController.text,
                                  phone: phoneController.text,
                                  isProfile: false,
                                );
                              },
                              text: 'Upload Cover',
                            ),
                          ),
                       const SizedBox(
                          width: 5.0,
                        ),
                        if (cubit.profileImage != null)
                          Expanded(
                            child: kButton(
                              onPressed: () {
                                cubit.uploadImage(
                                  name: nameController.text,
                                  bio: bioController.text,
                                  phone: phoneController.text,
                                  isProfile: true,
                                );
                              },
                              text: 'Upload Profile',
                            ),
                          ),
                      ],
                    ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  kTextFormField(
                    controller: nameController,
                    label: 'Name',
                    validator: (value) {
                      if (value == null) return 'name must not be empty';
                    },
                    prefixIcon: IconBroken.Profile,
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  kTextFormField(
                    controller: bioController,
                    label: 'Bio',
                    validator: (value) {
                      if (value == null) return 'bio must not be empty';
                    },
                    prefixIcon: IconBroken.Info_Circle,
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  kTextFormField(
                    controller: phoneController,
                    label: 'Phone',
                    validator: (value) {
                      if (value == null) return 'Phone must not be empty';
                    },
                    prefixIcon: Icons.phone_android_outlined,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
