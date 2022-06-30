import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/home_layout.dart';
import 'package:social_app/modules/register/cubit/cubit.dart';
import 'package:social_app/modules/register/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';

class RegisterScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register',
        ),
      ),
      body: BlocProvider(
        create: (context) => SocialRegisterCubit(),
        child: BlocConsumer<SocialRegisterCubit, SocialRegisterStates>(
          listener: (context, state) {
            if (state is SocialRegisterErrorState) {
              showToast(msg: state.error.toString(), state: ToastStates.ERROR);
            }else if (state is SocialCreateUserSuccessState) {
             // showToast(msg: msg, state: ToastStates.SUCCESS);
              navigateAndFinish(context: context, page: HomeLayout());
            }
          },
          builder: (context, state) {
            var cubit = SocialRegisterCubit.get(context);
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          'Register',
                          style:
                              Theme.of(context).textTheme.headline4!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          'Register now to chat with your friends',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        kTextFormField(
                          controller: nameController,
                          type: TextInputType.name,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please insert your name.';
                            }
                          },
                          prefixIcon: Icons.person,
                          label: 'Name',
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        kTextFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please insert your email.';
                            }
                          },
                          prefixIcon: Icons.email_outlined,
                          label: 'Email Address',
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        kTextFormField(
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please insert your password.';
                            }
                            return null;
                          },
                          prefixIcon: Icons.lock_outline_rounded,
                          onSuffixPressed: () {
                            cubit.showPassword();
                          },
                          obscure: cubit.isSecure,
                          label: 'Password',
                          suffixIcon: cubit.suffixIcon,
                          onSubmit: (value) {
                            if (formKey.currentState!.validate()) {
                              cubit.register(
                                name: nameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                                phone: phoneController.text,
                              );
                            }
                          },
                        ),
                       const SizedBox(
                          height: 15.0,
                        ),
                        kTextFormField(
                          controller: phoneController,
                          type: TextInputType.phone,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please insert your phone number.';
                            }
                          },
                          prefixIcon: Icons.phone,
                          label: 'Phone',
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        state is! SocialRegisterLoadingState
                            ? kButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    cubit.register(
                                      name: nameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      phone: phoneController.text,
                                    );
                                  }
                                },
                                text: 'Register',
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
