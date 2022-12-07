import 'package:dart_rss/dart_rss.dart';
import 'package:flutter/cupertino.dart';
import 'package:news/domain/api/news_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsProvider extends ChangeNotifier {
  RssFeed? _data;
  RssFeed? get data => _data;

  NewsProvider() {
    setUp();
  }

  void setUp({String? lang}) async {
    final pref = await SharedPreferences.getInstance();
    lang = pref.getString('lang');
    _data = await NewsApi.getNews(lang: lang ?? 'ru');
    notifyListeners();
  }
}
