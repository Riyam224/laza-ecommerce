import 'package:equatable/equatable.dart';

class RegisterResponseEntity extends Equatable {
  final String message;

  const RegisterResponseEntity({required this.message});

  @override
  List<Object?> get props => [message];
}