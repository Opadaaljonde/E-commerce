
import 'package:win_win/models/user.dart';

class Product {
  int id;
  String name;
  final price;
  int quantity;

  final contactInfo;
  String photo;
  String category;
  String expirationDate;
  int user_id;
  int number_of_views;
  int likesCount;
  int comment_count;
  final price_with_offer;

  int selfLiked;
  Product(
      {
        this.id,
      this.name,
      this.category,
      this.contactInfo,
      this.price,
      this.quantity,
      this.expirationDate,
      this.photo,
      this.user_id,
        this.likesCount,
       this.selfLiked,
        this.number_of_views,
        this.comment_count,
        this.price_with_offer

      });

// map json to product model


  factory Product.fromJson(Map<dynamic, dynamic> json) {
    return Product(
        id: json['id'],
        name: json['name'],
        category: json['classification'],
        price: json['price'],
        quantity: json['quantity'],
        expirationDate: json['expirations'],
       contactInfo: json['phone_number'],
        photo: json['photo'],
        user_id: json['user_id'],
        likesCount: json['number_of_likes'],
       selfLiked: json['isliked'],
       number_of_views:json['number_of_views'],
        comment_count:json['comment_count'],
        price_with_offer: json["price_with_offfer"]

    );
  }
}
