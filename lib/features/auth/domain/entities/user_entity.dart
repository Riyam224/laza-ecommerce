import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String userId;
  final String email;
  final String fullName;
  final String? profilePicture;

  const UserEntity({
    required this.userId,
    required this.email,
    required this.fullName,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [userId, email, fullName, profilePicture];
}
