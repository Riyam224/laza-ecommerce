import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laza/features/auth/data/models/register_request_model.dart';
import 'package:laza/features/auth/domain/use_cases/register_usecase.dart';

import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase registerUseCase;

  RegisterCubit(this.registerUseCase) : super(RegisterInitial());

  Future<void> registerUser({
    required String email,
    required String firstName,
    required String lastName,
    required String password,
  }) async {
    emit(RegisterLoading());

    try {
      final result = await registerUseCase(
        RegisterRequestModel(
          email: email,
          firstName: firstName,
          lastName: lastName,
          password: password,
        ),
      );

      emit(RegisterSuccess(result));
    } catch (e) {
      // You could later replace this with a Failure mapper
      emit(RegisterError(e.toString()));
    }
  }
}
