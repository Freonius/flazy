import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageCarousel extends StatefulWidget {
  final List<String> images;
  final double height;
  final double borderRadius;
  final bool fit;
  final String? placeholder;
  final Color? color;

  const ImageCarousel({
    required this.images,
    required this.height,
    this.borderRadius = 10,
    this.fit = false,
    this.placeholder,
    this.color,
    super.key,
  });
  @override
  State<StatefulWidget> createState() => ImageCarouselState();
}

class ImageCarouselState extends State<ImageCarousel> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  ImageCarouselState();

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Container(
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            widget.borderRadius,
          ),
          image: DecorationImage(
            image: AssetImage(
              widget.placeholder ?? 'assets/images/placeholder.jpg',
            ),
            fit: widget.fit ? BoxFit.contain : BoxFit.cover,
          ),
        ),
      );
    } else if (widget.images.length == 1) {
      return Container(
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            widget.borderRadius,
          ),
          image: DecorationImage(
            image: NetworkImage(
              widget.images.first,
            ),
            fit: widget.fit ? BoxFit.contain : BoxFit.cover,
          ),
        ),
      );
    }
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: CarouselSlider(
            options: CarouselOptions(
              height: widget.height,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
              // autoPlay: false,
            ),
            items: widget.images
                .map(
                  (item) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        widget.borderRadius,
                      ),
                      image: DecorationImage(
                        image: NetworkImage(
                          item,
                        ),
                        fit: widget.fit ? BoxFit.contain : BoxFit.cover,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.only(
              top: widget.height - 30,
              bottom: 5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.images.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _controller.animateToPage(entry.key),
                  child: Container(
                    width: 12.0,
                    height: 12.0,
                    margin: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 4.0,
                    ),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (widget.color ??
                                Theme.of(context).colorScheme.primary)
                            .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
