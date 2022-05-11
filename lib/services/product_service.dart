import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:win_win/models/api_response.dart';
import 'package:win_win/models/product.dart';
import 'package:win_win/services/user_service.dart';
import 'package:http/http.dart' as http;
import '../constant.dart';

// get all product
Future<ApiResponse> getAllProduct(String sort) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(Uri.parse(AllproductURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    },
    body: {
      'sort':sort
    }
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)["data"].map((p) {
          return Product.fromJson(p);
        }).toList();

        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// gat one product
Future<ApiResponse> getProduct(productId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http
        .post(Uri.parse('$OneproductURL/$productId'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });


    switch (response.statusCode) {
      case 200:
        apiResponse.data = Product.fromJson(jsonDecode(response.body)['data']);
        print(jsonDecode(response.body)['data']['user_id']);
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// Create product
Future<ApiResponse> createProduct(
    {@required String name,
    @required String price,
    @required String quantity,
    @required String phone_number,
    @required String photo,
    @required String classification,
    @required String expirationDate,
      @required   discout1,
      @required   discout2,
      @required   discout3,
      @required   days1,
      @required   days2,
      @required   days3

    }) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(Uri.parse(CreateProductURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      'name': name,
      'price': price,
      'quantity': quantity,
      'phone_number': phone_number,
      'classification': classification,
      'expirations': expirationDate,
      'photo': photo,
     'date3':days3,
    'price3':discout3,
    'date2':days2,
    'price2':discout2,
    'date1':days1,
      'price1':discout1

    });


    switch (response.statusCode) {
      case 200:
        print(jsonDecode(response.body));
        apiResponse.data = jsonDecode(response.body);
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      case 404:
        final errors = jsonDecode(response.body)['data'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      default:
        print(response.body);
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// update product
Future<ApiResponse> updateProduct(int productId,
    {String name,
    String price,
    String quantity,
    String phone_number,
    String photo,
    String classification,
   }) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response =
        await http.post(Uri.parse('$UpdateProductURL/$productId'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      'name': name,
      'price': price,
      'quantity': quantity,
      'phone_number': phone_number,
      'classification': classification, 'photo': photo
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      case 404:
        final errors = jsonDecode(response.body)['asd'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// Delete product
Future<ApiResponse> deletePost(int productId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http
        .post(Uri.parse('$DeleteProductURL/$productId'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      case 404:
        final errors = jsonDecode(response.body)['asd'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

//-----search product
Future<ApiResponse> searchProduct(String text, String type) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    print(text);
    final response = await http.post(Uri.parse('$baseURL/serach'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
       'name': type == 'name'?text:'',
      'classification': type == 'classification'?text:'',
      'expirations': type == 'expirations'?text:'',

    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['data']
            .map((p) => Product.fromJson(p))
            .toList();

        apiResponse.data as List<dynamic>;
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      case 404:
        apiResponse.error = "not found";
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// Like or unlike post

Future<ApiResponse> likeUnlikeProduct(int productId,bool like) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(Uri.parse('$baseURL/product/$productId/isLiked'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
       'isLiked':like
        }

        );
print(response.body);
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body);
        print('success like');
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;

      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

//--------get my product--------
Future<ApiResponse> getMyProduct() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse('$baseURL/show_my_products'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
print(response.body);
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)["data"].map((p) {
          return Product.fromJson(p);
        }).toList();

        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      case 404:
        final errors = jsonDecode(response.body)['asd'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}