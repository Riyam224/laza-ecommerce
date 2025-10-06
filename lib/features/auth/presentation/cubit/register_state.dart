import 'package:equatable/equatable.dart';
import 'package:laza/features/auth/domain/entities/register_response_entity.dart';

sealed class RegisterState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final RegisterResponseEntity response;
  RegisterSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class RegisterError extends RegisterState {
  final String message;
  RegisterError(this.message);

  @override
  List<Object?> get props => [message];
}
