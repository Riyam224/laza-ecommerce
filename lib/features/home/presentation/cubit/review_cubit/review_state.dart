import 'package:equatable/equatable.dart';
import 'package:laza/features/home/domain/entities/review_entity.dart';

sealed class ReviewState extends Equatable {
  const ReviewState();
  @override
  List<Object?> get props => [];
}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewLoaded extends ReviewState {
  final List<ReviewEntity> reviews;
  const ReviewLoaded(this.reviews);
  @override
  List<Object?> get props => [reviews];
}

class ReviewPosting extends ReviewState {}

class ReviewPosted extends ReviewState {
  final String message;
  const ReviewPosted(this.message);
  @override
  List<Object?> get props => [message];
}

class ReviewError extends ReviewState {
  final String message;
  const ReviewError(this.message);
  @override
  List<Object?> get props => [message];
}
