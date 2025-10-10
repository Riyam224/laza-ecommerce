part of 'user_info_cubit.dart';

sealed class UserInfoState extends Equatable {
  const UserInfoState();

  @override
  List<Object> get props => [];
}

final class UserInfoInitial extends UserInfoState {}

final class UserInfoLoading extends UserInfoState {}

final class UserInfoSuccess extends UserInfoState {
  final UserEntity user;

  const UserInfoSuccess(this.user);

  @override
  List<Object> get props => [user];
}

final class UserInfoError extends UserInfoState {
  final String message;

  const UserInfoError(this.message);

  @override
  List<Object> get props => [message];
}
