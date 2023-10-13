import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Loadable extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final Color color;
  final double? size;

  const Loadable({
    required this.isLoading,
    required this.child,
    required this.color,
    this.size,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? SizedBox(
            height: size,
            width: size,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  color,
                ),
              ),
            ),
          )
        : child;
  }
}

const Color _baseDefault = Color.fromRGBO(245, 245, 245, 1);
const Color _highlightDefault = Color.fromRGBO(224, 224, 224, 1);

class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({
    required this.isLoading,
    required this.child,
    required this.height,
    required this.width,
    this.radius = 50,
    this.baseColor = _baseDefault,
    this.highlightColor = _highlightDefault,
    super.key,
  });

  final bool isLoading;
  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final double height;
  final double width;
  final double radius;

  @override
  State<ShimmerLoading> createState() => ShimmerLoadingState();
}

class ShimmerLoadingState extends State<ShimmerLoading> {
  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Shimmer.fromColors(
        baseColor: widget.baseColor,
        highlightColor: widget.highlightColor,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            color: Colors.white,
          ),
          height: widget.height,
          width: widget.width,
        ),
      ),
    );
  }
}

class LoadableText extends StatefulWidget {
  final Future<String> Function() text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final TextAlign? textAlign;

  const LoadableText(
    this.text, {
    this.style,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.textAlign,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => LoadableTextState();
}

class LoadableTextState extends State<LoadableText> {
  bool isLoading = true;
  String textToShow = '';
  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      isLoading: isLoading,
      height: widget.style != null && widget.style!.fontSize != null
          ? (widget.style!.fontSize! + 2)
          : 15,
      width: 150,
      child: Text(
        textToShow,
        style: widget.style,
        maxLines: widget.maxLines,
        overflow: widget.overflow,
        softWrap: widget.softWrap,
        textAlign: widget.textAlign,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    widget.text().then((value) {
      setState(() {
        textToShow = value;
        isLoading = false;
      });
    });
  }
}
