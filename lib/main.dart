import 'package:blog_app_clean_arch/core/theme/theme.dart';
import 'package:blog_app_clean_arch/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app_clean_arch/features/auth/presentation/pages/login_page.dart';
import 'package:blog_app_clean_arch/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => serviceLocator<AuthenticatinBloc>(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth Bloc Clean Arch',
      theme: AppTheme.darkThemeMode,
      home: const LoginPage(),
    );
  }
}
