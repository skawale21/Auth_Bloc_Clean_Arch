import 'package:blog_app_clean_arch/core/common/widgets/loader.dart';
import 'package:blog_app_clean_arch/core/theme/pallete.dart';
import 'package:blog_app_clean_arch/core/utils/show_snackbar.dart';
import 'package:blog_app_clean_arch/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app_clean_arch/features/auth/presentation/pages/login_page.dart';
import 'package:blog_app_clean_arch/features/auth/presentation/widgets/auth_field.dart';
import 'package:blog_app_clean_arch/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const LoginPage(),
      );
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emalController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool isEmailValid = false;
  bool isPasswordValid = false;
  bool isNameValid = false;

  @override
  void dispose() {
    emalController.dispose();
    nameController.dispose();

    passwordController.dispose();
    super.dispose();
  }

  String? passwordValidator(String? value) {
    if (value!.isEmpty) {
      return 'Passowrd is missing!';
    }
    final passwordRegex =
        RegExp(r'^[a-zA-Z0-9!@#$%^&*()]+$'); // Password pattern
    if (value.length < 8 ||
        !passwordRegex.hasMatch(value) ||
        !value.contains(RegExp(r'[A-Z]')) || // Check for uppercase
        !value.contains(RegExp(r'[a-z]')) || // Check for lowercase
        !value.contains(RegExp(r'[0-9]')) || // Check for digit
        !value.contains(RegExp(r'[!@#$%^&*]'))) {
      // Check for special character
      return 'Password must be at least 8 characters and contain 1 uppercase, 1 lowercase, 1 number, and 1 special character.';
    }
    return null;
    // Call the provided validator if any
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }

    const pattern = r'^[^@]+@[^@]+\.[^@]+';
    final regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }

    if (value.length < 3) {
      return 'Name must be at least 3 characters long';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: BlocConsumer<AuthenticatinBloc, AuthenticatinState>(
              listener: (context, state) {
                switch (state.runtimeType) {
                  case AuthSuccess:
                    state = state as AuthSuccess;
                    showSnackBar(context, "Auth Success state");
                    break;

                  case AuthFailure:
                    state = state as AuthFailure;
                    showSnackBar(context, state.message);
                    break;

                  default:
                    showSnackBar(
                        context, "Default listener state from AuthBloc");
                }
              },
              builder: (context, state) {
                switch (state.runtimeType) {
                  case AuthLoading:
                    return const Loader();

                  default:
                  // return const DefaultStateBuilder(
                  //   blocName: 'AuthBloc',
                  // );
                }
                return Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Sign Up.',
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      AuthField(
                        hintText: 'Name',
                        controller: nameController,
                        validator: nameValidator,
                        onChanged: (value) {
                          setState(() {
                            isNameValid = nameValidator(value) == null;
                            formKey.currentState!.validate();
                          });
                        },
                      ),
                      const SizedBox(height: 15),
                      AuthField(
                        hintText: 'Email',
                        controller: emalController,
                        onChanged: (value) {
                          setState(() {
                            isEmailValid = emailValidator(value) == null;
                            formKey.currentState!.validate();
                          });
                        },
                        validator: emailValidator,
                      ),
                      const SizedBox(height: 15),
                      AuthField(
                        hintText: 'Password',
                        controller: passwordController,
                        // isObscureText: true,
                        validator: passwordValidator,
                        onChanged: (value) {
                          setState(() {
                            isPasswordValid = passwordValidator(value) == null;
                            formKey.currentState!.validate();
                          });
                        },
                      ),
                      const SizedBox(height: 15),
                      AuthGradientButton(
                        buttonText: 'Sign Up',
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<AuthenticatinBloc>().add(
                                  AuthSignUp(
                                    name: nameController.text.trim(),
                                    email: emalController.text.trim(),
                                    password: passwordController.text.trim(),
                                  ),
                                );
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      RichText(
                        text: TextSpan(
                          text: 'Already havea account? ',
                          style: Theme.of(context).textTheme.titleMedium,
                          children: [
                            TextSpan(
                              text: 'Sign In',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                      color: AppPallete.gradient2,
                                      fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    SignupPage.route(),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
