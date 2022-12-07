import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:news/domain/providers/locale_provider.dart';
import 'package:news/domain/providers/news_provider.dart';
import 'package:news/generated/l10n.dart';
import 'package:news/l10n/l10n.dart';
import 'package:news/ui/pages/home_page/home_page.dart';
import 'package:provider/provider.dart';

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NewsProvider>(
          create: (context) => NewsProvider(),
        ),
        ChangeNotifierProvider<LocaleProvider>(
          create: (context) => LocaleProvider(),
        ),
      ],
      child: const NewsAppContent(),
    );
  }
}

class NewsAppContent extends StatelessWidget {
  const NewsAppContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    return MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: L10n.all,
      locale: localeProvider.locale,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
