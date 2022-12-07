import 'dart:ffi';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dart_rss/dart_rss.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:news/domain/providers/locale_provider.dart';
import 'package:news/domain/providers/news_provider.dart';
import 'package:news/generated/l10n.dart';
import 'package:news/ui/components/home_page_slider/home_page_slider.dart';
import 'package:news/ui/loaders/app_loaders.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<NewsProvider>(context);
    return Scaffold(
      drawer: HomePageMenu(),
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 4, 32, 55),
          centerTitle: true,
          toolbarHeight: 72,
          title: model.data?.items != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MenuBtn(),
                    Text(
                      model.data!.title!,
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 36),
                  ],
                )
              : AppLoaders.appTitle),
      body: ListView(
        children: <Widget>[
          const SizedBox(height: 24),
          const HomePageSlider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Text(
              S.current.bodytitle,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xff323232),
              ),
            ),
          ),
          HomeAllNews(
            model: model,
          ),
        ],
      ),
    );
  }
}

class MenuBtn extends StatelessWidget {
  const MenuBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
      splashRadius: 1,
      icon: Icon(Icons.menu),
      color: Colors.white,
    );
  }
}

class MenuLangBtn extends StatelessWidget {
  final String langCode;
  final Function btnAction;
  const MenuLangBtn({super.key, this.langCode = 'ru', required this.btnAction});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => btnAction(),
      child: Text(
        langCode.toUpperCase(),
        style: TextStyle(
          fontSize: 24,
          color: Colors.white,
        ),
      ),
    );
  }
}

class HomePageMenu extends StatelessWidget {
  const HomePageMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localeModel = Provider.of<LocaleProvider>(context);
    final model = Provider.of<NewsProvider>(context);
    return Drawer(
      width: 108,
      backgroundColor: const Color.fromARGB(255, 4, 32, 55),
      child: SafeArea(
        child: Column(
          children: [
            MenuLangBtn(
              btnAction: () async {
                final pref = await SharedPreferences.getInstance();
                pref.setString('lang', 'ru');
                localeModel.setLocale(locale: 'ru');
                model.setUp();
              },
            ),
            const SizedBox(height: 24),
            MenuLangBtn(
              langCode: 'en',
              btnAction: () async {
                final pref = await SharedPreferences.getInstance();
                pref.setString('lang', 'en');
                localeModel.setLocale();
                model.setUp();
              },
            ),
            const SizedBox(height: 24),
            MenuLangBtn(
              langCode: 'uz',
              btnAction: () async {
                final pref = await SharedPreferences.getInstance();
                pref.setString('lang', 'uz');
                localeModel.setLocale(locale: 'uz');
                model.setUp();
                model.dispose();
              },
            ),
            const Spacer(),
            FloatingActionButton(
              onPressed: () {
                exit(0);
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: const Icon(
                Icons.exit_to_app,
                size: 36,
              ),
            ),
            SizedBox(height: 24)
          ],
        ),
      ),
    );
  }
}

class HomeAllNews extends StatelessWidget {
  final NewsProvider model;
  const HomeAllNews({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final itemsList = model.data?.items;
    return itemsList != null
        ? ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => AllNewsItem(
              newsItem: itemsList[index],
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemCount: itemsList.length,
          )
        : ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => AppLoaders.allNewsItemLoader,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemCount: 15,
          );
  }
}

class AllNewsItem extends StatelessWidget {
  final RssItem newsItem;
  const AllNewsItem({
    super.key,
    required this.newsItem,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await launchUrlString(newsItem.link!);
      },
      borderRadius: BorderRadius.circular(16),
      splashColor: const Color(0xff323232).withOpacity(.2),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: CachedNetworkImage(
                  fit: BoxFit.fill,
                  progressIndicatorBuilder: (context, url, progress) =>
                      const Center(
                    child: CupertinoActivityIndicator(),
                  ),
                  imageUrl: newsItem.media!.contents.first.url!,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              newsItem.title!,
              maxLines: 3,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
