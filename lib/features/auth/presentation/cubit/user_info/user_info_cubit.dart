import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laza/features/auth/domain/entities/user_entity.dart';
import 'package:laza/features/auth/domain/use_cases/get_user_info_usecase.dart';

part 'user_info_state.dart';

class UserInfoCubit extends Cubit<UserInfoState> {
  final GetUserInfoUsecase getUserInfoUsecase;

  UserInfoCubit(this.getUserInfoUsecase) : super(UserInfoInitial());

  Future<void> fetchUserInfo() async {
    emit(UserInfoLoading());
    print('👤 [UserInfoCubit] Fetching user info...');

    try {
      final result = await getUserInfoUsecase();

      result.fold(
        (failure) {
          print('❌ [UserInfoCubit] Error: ${failure.message}');

          // Detect unauthorized or token issues
          final isAuthError =
              failure.message.toLowerCase().contains('unauthorized') ||
              failure.message.toLowerCase().contains('token') ||
              failure.message.contains('401');

          if (isAuthError) {
            emit(UserInfoError('Unauthorized — please log in again.'));
          } else {
            emit(UserInfoError(failure.message));
          }
        },
        (user) {
          print(
            '✅ [UserInfoCubit] User fetched: '
            '${user.fullName}, ${user.email}, ${user.userId}',
          );
          emit(UserInfoSuccess(user));
        },
      );
    } catch (e, stack) {
      print('🔥 [UserInfoCubit] Exception: $e');
      print(stack);
      emit(UserInfoError('Something went wrong: $e'));
    }
  }
}
