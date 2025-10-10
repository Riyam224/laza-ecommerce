import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laza/features/auth/domain/entities/login_request_entity.dart';
import 'package:laza/features/auth/domain/use_cases/login_usecase.dart';
import 'package:laza/core/storage/shared_prefs.dart';

import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  LoginCubit(this.loginUseCase) : super(LoginInitial());

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());

    final request = LoginRequestEntity(
      email: email.trim(),
      password: password.trim(),
    );

    final result = await loginUseCase(request);

    result.fold(
      (failure) => emit(LoginError(failure.message)),
      (loginResponse) async {
        await saveToken(loginResponse.accessToken);
        emit(LoginSuccess(loginResponse));
      },
    );
  }
}
