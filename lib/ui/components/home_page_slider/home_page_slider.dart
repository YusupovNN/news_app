import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/domain/providers/news_provider.dart';
import 'package:news/ui/loaders/app_loaders.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomePageSlider extends StatelessWidget {
  const HomePageSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<NewsProvider>(context);
    final itemsList = model.data?.items;
    return itemsList != null
        ? CarouselSlider.builder(
            itemBuilder: (context, index, realIndex) => SliderItem(
              bgPath: itemsList[index].media!.contents.first.url!,
              itemTitle: itemsList[index].title!,
            ),
            itemCount: itemsList.length,
            options: CarouselOptions(
              viewportFraction: 0.75,
              height: 220,
              autoPlay: true,
              enlargeCenterPage: true,
              autoPlayInterval: const Duration(seconds: 10),
            ),
          )
        : AppLoaders.homeSliderLoader;
  }
}

class SliderItem extends StatelessWidget {
  final String bgPath;
  final String itemTitle;
  const SliderItem({
    super.key,
    required this.bgPath,
    required this.itemTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 220,
          width: 320,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.grey.shade300,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: bgPath,
              progressIndicatorBuilder: (context, url, progress) =>
                  const Center(
                child: CupertinoActivityIndicator(),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          width: 320,
          height: 220,
          decoration: BoxDecoration(
            color: Colors.black45,
            borderRadius: BorderRadius.circular(24),
          ),
          alignment: Alignment.bottomLeft,
          child: Text(
            itemTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
