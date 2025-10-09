class ReviewEntity {
  final String? id;
  final String userName;
  final String comment;
  final num rating;
  final String? date;
  final String? userPicture; 

  ReviewEntity({
    this.id,
    required this.userName,
    required this.comment,
    required this.rating,
    this.date,
    this.userPicture, 
  });
}
