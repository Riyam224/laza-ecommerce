import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laza/features/auth/data/models/user/user_model.dart';
import 'package:laza/features/auth/domain/use_cases/GetUserInfoUseCase.dart';

part 'user_info_state.dart';

class UserInfoCubit extends Cubit<UserInfoState> {
  final GetUserInfoUseCase getUserInfoUseCase;

  UserInfoCubit(this.getUserInfoUseCase) : super(UserInfoInitial());

  Future<void> loadUserInfo() async {
    emit(UserInfoLoading());
    try {
      final user = await getUserInfoUseCase();
      emit(UserInfoLoaded(user));
    } catch (e) {
      emit(UserInfoError(e.toString()));
    }
  }
}
