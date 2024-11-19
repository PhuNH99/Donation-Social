import 'dart:convert';

import 'package:donationsystem/models/category/category.dart';
import 'package:http/http.dart' as http;

abstract class BaseCategoryRepository {
  Future<List<CategoryModel>> fetchCategory();
}

class CategoryRepository implements BaseCategoryRepository {
  @override
  Future<List<CategoryModel>> fetchCategory() async {
    List<CategoryModel> tmpList = null;
    try {
      final response =
          await http.get('https://swdapi.azurewebsites.net/api/Category');
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        tmpList = new List();
        data.forEach((element) {
          tmpList.add(CategoryModel.fromJson(element));
        });
        return tmpList;
      }
    } catch (e) {
      print(e);
    } finally {
      return tmpList;
    }
  }
}
