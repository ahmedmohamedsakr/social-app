import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/home_layout.dart';
import 'package:social_app/modules/login/cubit/cubit.dart';
import 'package:social_app/modules/login/cubit/states.dart';
import 'package:social_app/modules/register/register_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

class LoginScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (context) => SocialLoginCubit(),
        child: BlocConsumer<SocialLoginCubit, SocialLoginStates>(
          listener: (context, state) {
            if (state is SocialLoginSuccessState) {
              CacheHelper.setData(key: 'uId', value: state.uId).then((value){
                navigateAndFinish(context: context, page: HomeLayout());
              });
            }
          },
          builder: (context, state) {
            var cubit = SocialLoginCubit.get(context);
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
                          'LOGIN',
                          style:
                              Theme.of(context).textTheme.headline4!.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 35.0,
                                  ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          'login now to communicate with your friends',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        const SizedBox(
                          height: 20.0,
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
                          type: TextInputType.emailAddress,
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
                              cubit.login(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        state is! SocialLoginLoadingState
                            ? kButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    cubit.login(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    );
                                  }
                                },
                                text: 'LOGIN',
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Don\'t have an account?'),
                            TextButton(
                              onPressed: () {
                                navigateTo(
                                    context: context, page: RegisterScreen());
                              },
                              child: const Text(
                                'REGISTER',
                              ),
                            )
                          ],
                        )
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
