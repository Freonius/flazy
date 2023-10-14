import 'package:flutter/material.dart';
import 'loadable.dart';

/// MainButton widget is a simple button with a text and an onClick callback.
///
/// When onClick is called, the button will display a [CircularProgressIndicator]
///
class MainButton extends StatefulWidget {
  final String text;
  final bool disabled;
  final bool inverted;
  final Color? mainColor;
  final Color? backgroundColor;
  final Future<void> Function() onClick;
  final Future<void> Function(Object)? onError;
  final double verticalPadding;
  final double? fontSize;
  final double? relativeWidth;
  final double horizontalPadding;
  final double borderSize;

  /// Creates a MainButton widget.
  /// [text] is the text displayed on the button.
  const MainButton(
    this.text, {
    required this.onClick,
    this.mainColor,
    this.backgroundColor,
    this.onError,
    this.inverted = false,
    this.disabled = false,
    this.verticalPadding = 8,
    this.fontSize,
    this.relativeWidth = 0.5,
    this.horizontalPadding = 0,
    this.borderSize = 4,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => MainButtonState();
}

class MainButtonState extends State<MainButton> {
  bool isLoading = false;
  MainButtonState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(
        5,
      ),
      child: InkWell(
        onTap: () async {
          if (widget.disabled || isLoading) {
            return;
          }
          setState(() {
            isLoading = true;
          });
          try {
            await widget.onClick();
            setState(() {
              isLoading = true;
            });
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
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: widget.verticalPadding,
            horizontal: widget.horizontalPadding,
          ),
          width: widget.relativeWidth == null
              ? null
              : (MediaQuery.of(context).size.width * widget.relativeWidth!),
          decoration: BoxDecoration(
            color: widget.inverted
                ? (widget.backgroundColor ??
                    Theme.of(context).colorScheme.secondary)
                : (widget.mainColor ?? Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(
              50,
            ),
            border: Border.all(
              color: widget.mainColor ?? Theme.of(context).colorScheme.primary,
              width: widget.borderSize,
            ),
          ),
          child: Center(
            child: Loadable(
              size: (widget.fontSize ??
                      ((Theme.of(context).textTheme.bodyMedium ??
                                  const TextStyle(fontSize: 13))
                              .fontSize ??
                          13)) +
                  3.5,
              isLoading: isLoading,
              color: widget.inverted
                  ? (widget.mainColor ?? Theme.of(context).colorScheme.primary)
                  : (widget.backgroundColor ??
                      Theme.of(context).colorScheme.secondary),
              child: Text(
                widget.text,
                style: TextStyle(
                  color: widget.inverted
                      ? (widget.mainColor ??
                          Theme.of(context).colorScheme.primary)
                      : (widget.backgroundColor ??
                          Theme.of(context).colorScheme.secondary),
                  fontSize: (widget.fontSize ??
                      ((Theme.of(context).textTheme.bodyMedium ??
                                  const TextStyle(fontSize: 13))
                              .fontSize ??
                          13)),
                  // fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CircularButton extends StatefulWidget {
  final String? text;
  final Widget icon;
  final double size;
  final Future<void> Function() onClick;
  final Future<void> Function(Object)? onError;
  final bool disabled;
  final Color? color;
  final Color? fontColor;
  final double? fontSize;
  final Color? borderColor;

  const CircularButton({
    required this.icon,
    required this.onClick,
    this.text,
    this.size = 50,
    this.onError,
    this.disabled = false,
    this.color,
    this.fontColor,
    this.fontSize,
    this.borderColor,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => CircularButtonState();
}

class CircularButtonState extends State<CircularButton> {
  bool isLoading = false;

  CircularButtonState();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (widget.disabled || isLoading) {
          return;
        }
        setState(() {
          isLoading = true;
        });
        try {
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
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: widget.color ?? Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(
            widget.size,
          ),
          border: Border.all(
            color: widget.borderColor ??
                (widget.color ?? Theme.of(context).colorScheme.primary),
            width: 4,
          ),
        ),
        padding: const EdgeInsets.all(2),
        child: Center(
          child: Loadable(
            size: widget.size * 0.7,
            isLoading: isLoading,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.icon,
                widget.text != null
                    ? const SizedBox(
                        height: 2,
                      )
                    : Container(),
                widget.text != null
                    ? Text(
                        widget.text!,
                        style: TextStyle(
                          color: widget.fontColor ??
                              Theme.of(context).colorScheme.onPrimary,
                          fontSize: (widget.fontSize ??
                              ((Theme.of(context).textTheme.bodyMedium ??
                                          const TextStyle(fontSize: 13))
                                      .fontSize ??
                                  13)),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
