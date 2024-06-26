import 'package:blog_app_clean_arch/core/common/widgets/loader.dart';
import 'package:blog_app_clean_arch/core/theme/pallete.dart';
import 'package:blog_app_clean_arch/core/utils/show_snackbar.dart';
import 'package:blog_app_clean_arch/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app_clean_arch/features/auth/presentation/pages/signup_page.dart';
import 'package:blog_app_clean_arch/features/auth/presentation/widgets/auth_field.dart';
import 'package:blog_app_clean_arch/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:blog_app_clean_arch/features/dashboard/presentation/dashboard.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const SignupPage(),
      );
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emalController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool isEmailValid = false;
  bool isPasswordValid = false;

  @override
  void initState() {
    _setupAuthListener();
    super.initState();
  }

  @override
  void dispose() {
    emalController.dispose();

    passwordController.dispose();
    super.dispose();
  }

  void _setupAuthListener() {
    supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const DashboardScreen(),
          ),
        );
      }
    });
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

  Future<AuthResponse> _googleSignIn() async {
    const webClientId =
        '313427259211-9bh27c9t8dh2ioitldirjsk61o7l5br2.apps.googleusercontent.com';

    const iosClientId = 'my-ios.apps.googleusercontent.com';

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    return supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      const SizedBox(
                        height: 200,
                      ),
                      const Text(
                        'Sign In.',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
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
                        buttonText: 'Sign In',
                        onPressed: () {
                          if (isEmailValid && isPasswordValid) {
                            if (formKey.currentState!.validate()) {
                              context.read<AuthenticatinBloc>().add(
                                    AuthLogin(
                                      email: emalController.text.trim(),
                                      password: passwordController.text.trim(),
                                    ),
                                  );
                            }
                          } else {
                            showSnackBar(context, 'Invalid email or password');
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      RichText(
                        text: TextSpan(
                          text: 'Don\'t have an account? ',
                          style: Theme.of(context).textTheme.titleMedium,
                          children: [
                            TextSpan(
                              text: 'Sign Up',
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
                                    LoginPage.route(),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: _googleSignIn,
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(
                            220,
                            55,
                          ),
                          backgroundColor: AppPallete.whiteColor,
                          shadowColor: AppPallete.transparentColor,
                        ),
                        child: const Text(
                          'Sign In With Google',
                          style: TextStyle(color: AppPallete.blackColor),
                        ),
                      )
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
