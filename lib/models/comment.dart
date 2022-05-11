class Comment {
  int id;
  String comment;
  String user_name;

  // User  user;

  Comment({
    this.id,
    this.comment,
     this.user_name
  });

  // map json to comment model
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      comment: json['comment'],
      user_name:json['name']
      /*user: User(
        id: json['user']['id'],
        name: json['user']['name'],
        image: json['user']['image']
      )*/
    );
  }
}
