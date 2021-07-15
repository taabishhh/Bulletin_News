
import 'package:http/http.dart' as http;
import 'Article.dart';
import 'dart:convert';


String apiKey = '';   //Enter your api key here from NEWSAPI.org
class News {
  List<Article> news = [];
  

  Future<void> getNews() async {
    String url =
        "http://newsapi.org/v2/top-headlines?country=in&sortBy=popularity&language=en&apiKey=$apiKey";
    // String url = "https://api.first.org/data/v1/news";
// "http://newsapi.org/v2/top-headlines?q=bitcoin&apiKey=$apiKey";
    var response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);


    if (jsonData['status'] == "ok") {
      jsonData["articles"].forEach((element) {
        if (element['urlToImage'] != null && element['description'] != null) {
          Article article = Article(
            title: element['title'],
            author: element['author'],
            description: element['description'],
            urlToImage: element['urlToImage'],
            // publishedAt: DateTime.parse(element['publishedAt']),
            content: element["content"],
            articleUrl: element["url"],
          );
          news.add(article);
        }
      });
    }
  }
}
