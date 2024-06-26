import 'package:blog_app_clean_arch/core/theme/secrets/app_secrets.dart';
import 'package:blog_app_clean_arch/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app_clean_arch/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:blog_app_clean_arch/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app_clean_arch/features/auth/domain/usecases/user_login.dart';
import 'package:blog_app_clean_arch/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blog_app_clean_arch/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

GetIt serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.anonKey,
  );
  serviceLocator.registerLazySingleton(
    () => supabase.client,
  );
}

void _initAuth() {
  //datasource
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(serviceLocator()),
    )
    //Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(serviceLocator()),
    )
    //Usecases
    ..registerFactory(
      () => UserSignUp(serviceLocator()),
    )
    ..registerFactory(
      () => UserLogin(serviceLocator()),
    )
    //bloc
    ..registerLazySingleton(
      () => AuthenticatinBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
      ),
    );
}
