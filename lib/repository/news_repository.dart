import 'package:my_news_app/model/news.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:my_news_app/server.dart';

class NewsRepository {
  Future<List<News>> getNews(int page) async {
    var response = await http.get(Server.alamat +
        "/everything?q=sport&apiKey=" +
        Server.api_key +
        "&page=" +
        page.toString() +
        "&pageSize=10");
    print(response.body);
    if (response.statusCode == 200) {
      return compute(listNewsFromJson, response.body);
    } else {
      throw Exception();
    }
  }
}
