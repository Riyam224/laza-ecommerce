import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laza/features/auth/domain/use_cases/logout_usecase.dart';
import 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final LogoutUseCase logoutUseCase;

  LogoutCubit(this.logoutUseCase) : super(LogoutInitial());

  Future<void> logout() async {
    emit(LogoutLoading());

    final result = await logoutUseCase();

    result.fold(
      (failure) => emit(LogoutError(failure.message)),
      (_) => emit(LogoutSuccess()),
    );
  }
}
