import 'package:dart_rss/dart_rss.dart';
import 'package:http/http.dart' as http;

class NewsApi {
  static Future<RssFeed?> getNews({String lang = 'ru'}) async {
    try {
      final Uri url = Uri.parse('https://uzreport.news/feed/rss/$lang');
      final response = await http.get(url);
      final data = RssFeed.parse(response.body);
      return data;
    } catch (e) {
      print(e);
    }
  }
  
  
  
}
