import 'package:flutter/material.dart';

class ClickableText extends StatefulWidget {
  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Future<void> Function() onClick;
  final Future<void> Function(Object)? onError;

  const ClickableText(
    this.text, {
    required this.onClick,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.onError,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => ClickableTextState();
}

class ClickableTextState extends State<ClickableText> {
  bool isLoading = false;

  ClickableTextState();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (isLoading) {
          return;
        }
        setState(() {
          isLoading = true;
        });
        try {
          setState(() {
            isLoading = true;
          });
          await widget.onClick();
        } on Exception catch (e) {
          if (widget.onError != null) {
            widget.onError!(e);
          } else {
            rethrow;
          }
        } catch (e) {
          if (widget.onError != null) {
            widget.onError!(e);
          } else {
            rethrow;
          }
        } finally {
          setState(() {
            isLoading = false;
          });
        }
      },
      child: Text(
        widget.text,
        style: TextStyle(
          color: widget.color,
          fontSize: widget.fontSize,
          fontWeight: widget.fontWeight,
        ),
      ),
    );
  }
}

class ClickableSentence extends StatelessWidget {
  final String prefix;
  final String suffix;
  final String clickable;
  final Color? clickableColor;
  final double? fontSize;
  final FontWeight? clickableWeight;
  final Color? color;
  final FontWeight? fontWeight;
  final Future<void> Function() onClick;
  final Future<void> Function(Object)? onError;
  final TextAlign? textAlign;
  final bool center;

  const ClickableSentence({
    required this.prefix,
    required this.suffix,
    required this.clickable,
    required this.onClick,
    this.clickableColor,
    this.clickableWeight,
    this.color,
    this.fontWeight,
    this.onError,
    this.fontSize,
    this.textAlign,
    this.center = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          center ? MainAxisAlignment.center : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          prefix,
          style: TextStyle(
            fontSize: fontSize,
            color: color,
            fontWeight: fontWeight,
          ),
        ),
        ClickableText(
          clickable,
          onClick: onClick,
          fontSize: fontSize,
          fontWeight: clickableWeight,
          color: clickableColor,
        ),
        Text(
          suffix,
          textAlign: textAlign,
          style: TextStyle(
            fontSize: fontSize,
            color: color,
            fontWeight: fontWeight,
          ),
        ),
      ],
    );
  }
}
