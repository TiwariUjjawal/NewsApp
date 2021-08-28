import 'dart:convert';

import 'package:final_project/models/news.dart';
import 'package:http/http.dart' as http;

Future<List<News>> getNewsData(country, category) async {
  String url = "";
  if (country == "" && category == "") {
    country = 'in';
    url =
        'https://newsapi.org/v2/top-headlines?country=$country&apiKey=f4bc54e7e76b48f19915f5424b1156cc';
  }
  if (country != "" && category == "") {
    url =
        'https://newsapi.org/v2/top-headlines?country=$country&apiKey=f4bc54e7e76b48f19915f5424b1156cc';
  }
  if (country == "" && category != "") {
    url =
        'https://newsapi.org/v2/top-headlines?&category=$category&apiKey=f4bc54e7e76b48f19915f5424b1156cc';
  } else {
    url =
        'https://newsapi.org/v2/top-headlines?country=$country&category=$category&apiKey=f4bc54e7e76b48f19915f5424b1156cc';
  }
  Uri uri = Uri.parse(url);
  String host = uri.host;
  String path = uri.path;
  Map<String, String> queryParameters = uri.queryParameters;
  var response = await http.get(Uri.https(host, path, queryParameters));
  var jsonData = jsonDecode(response.body);
  var data = jsonData['articles'];

  List<News> news = [];
  for (var d in data) {
    String title = d['title'] ?? '';
    String imageURL = d['urlToImage'] ??
        'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse3.mm.bing.net%2Fth%3Fid%3DOIP.pv2wz4BWWHobFRCJ6nAKEQHaDt%26pid%3DApi&f=1';
    String content = d['content'] ?? '';
    String url = d['url'] ?? '';

    News newsPage = new News(
      title,
      url,
      imageURL,
      content,
    );
    news.add(newsPage);
  }
  return news;
}
