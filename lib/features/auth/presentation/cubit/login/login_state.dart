import 'package:equatable/equatable.dart';
import 'package:laza/features/auth/domain/entities/login_response_entity.dart';

sealed class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final LoginResponseEntity response;
  LoginSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class LoginError extends LoginState {
  final String message;
  LoginError(this.message);

  @override
  List<Object?> get props => [message];
}
