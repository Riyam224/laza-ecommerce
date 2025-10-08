part of 'user_info_cubit.dart';

abstract class UserInfoState {}

class UserInfoInitial extends UserInfoState {}

class UserInfoLoading extends UserInfoState {}

class UserInfoLoaded extends UserInfoState {
  final UserModel user;
  UserInfoLoaded(this.user);
}

class UserInfoError extends UserInfoState {
  final String message;
  UserInfoError(this.message);
}
