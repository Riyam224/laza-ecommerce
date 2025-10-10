import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laza/features/auth/data/models/register/register_request_model.dart';
import 'package:laza/features/auth/domain/use_cases/register_usecase.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase registerUseCase;

  RegisterCubit(this.registerUseCase) : super(RegisterInitial());

  Future<void> registerUser({
    required String email,
    required String username,
    required String password,
  }) async {
    emit(RegisterLoading());

    final parts = username
        .trim()
        .split(' ')
        .where((e) => e.isNotEmpty)
        .toList();
    final firstName = parts.isNotEmpty ? parts.first : 'User';
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : 'Name';

    final request = RegisterRequestModel(
      email: email.trim(),
      password: password.trim(),
      firstName: firstName,
      lastName: lastName,
    );

    final result = await registerUseCase(request);

    result.fold(
      (failure) => emit(RegisterError(failure.message)),
      (registerResponse) => emit(RegisterSuccess(registerResponse)),
    );
  }
}
