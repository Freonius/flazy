import 'package:flutter/material.dart';

class FlazySwitcher extends StatefulWidget {
  final bool active;
  final String title;
  final Color? color;
  final Future<void> Function(bool) onChange;
  final Future<void> Function(Object)? onError;

  const FlazySwitcher({
    required this.active,
    required this.title,
    required this.onChange,
    this.color,
    this.onError,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => FlazySwitcherState();
}

class FlazySwitcherState extends State<FlazySwitcher> {
  late bool active;
  bool _isLoading = false;

  FlazySwitcherState();

  @override
  void initState() {
    super.initState();
    active = widget.active;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.title,
                style: const TextStyle(),
              ),
            ),
            Switch(
              value: active,
              activeColor: widget.color,
              onChanged: (v) async {
                if (_isLoading) {
                  return;
                }
                setState(() {
                  _isLoading = true;
                  active = v;
                });

                try {
                  setState(() {
                    _isLoading = true;
                  });
                  await widget.onChange(v);
                } on Exception catch (e) {
                  setState(() {
                    active = !active;
                  });
                  if (widget.onError != null) {
                    widget.onError!(e);
                  } else {
                    rethrow;
                  }
                } finally {
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
            )
          ],
        ),
        const Divider(
          height: 2,
        ),
      ],
    );
  }
}

class PlusMinusButton extends StatelessWidget {
  final String button;
  final double? size;
  final Color? color;
  final double? fontSize;

  const PlusMinusButton({
    required this.button,
    required this.color,
    required this.fontSize,
    required this.size,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.black.withAlpha(25),
            width: 1,
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Center(
          child: Text(
            button,
            style: TextStyle(
              color: color,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class PlusMinusWidget extends StatefulWidget {
  final double value;
  final double step;
  final double? maxValue;
  final double? minValue;
  final Orientation orientation;
  final double? buttonSize;
  final double? buttonFontSize;
  final Color? plusColor;
  final Color? minusColor;
  final Color? labelColor;
  final double? labelFontSize;
  final Future<void> Function(double) onClick;
  final Future<void> Function(Object)? onError;
  final bool updateLabelOnClick;
  final FontWeight? labelFontWeight;

  const PlusMinusWidget({
    required this.value,
    required this.onClick,
    this.onError,
    this.updateLabelOnClick = true,
    this.labelFontWeight = FontWeight.w600,
    this.step = 0.1,
    this.minValue,
    this.maxValue,
    this.orientation = Orientation.portrait,
    this.buttonFontSize = 50,
    this.buttonSize = 70,
    this.plusColor = Colors.red,
    this.minusColor = Colors.blue,
    this.labelColor,
    this.labelFontSize = 50,
    super.key,
  });
  @override
  State<StatefulWidget> createState() => PlusMinusWidgetState();
}

class PlusMinusWidgetState extends State<PlusMinusWidget> {
  late double value;
  bool _isLoading = false;

  PlusMinusWidgetState();

  @override
  void initState() {
    super.initState();
    value = widget.value;
  }

  double _getValueToSend(bool increase) {
    if (widget.updateLabelOnClick) {
      return value;
    }
    if (increase) {
      return value + widget.step;
    }
    return value - widget.step;
  }

  Future<void> _onTap(bool increase) async {
    if (increase &&
        widget.maxValue != null &&
        value + widget.step > widget.maxValue!) {
      return;
    }
    if (increase == false &&
        widget.minValue != null &&
        value - widget.step < widget.minValue!) {
      return;
    }
    if (_isLoading) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    if (widget.updateLabelOnClick) {
      if (increase) {
        setState(() {
          value = value + widget.step;
        });
      } else {
        setState(() {
          value = value - widget.step;
        });
      }
    }
    try {
      setState(() {
        _isLoading = true;
      });
      await widget.onClick(_getValueToSend(increase));
      if (widget.updateLabelOnClick == false) {
        if (increase) {
          setState(() {
            value = value + widget.step;
          });
        } else {
          setState(() {
            value = value - widget.step;
          });
        }
      }
    } on Exception catch (e) {
      if (widget.updateLabelOnClick) {
        if (increase) {
          setState(() {
            value = value - widget.step;
          });
        } else {
          setState(() {
            value = value + widget.step;
          });
        }
      }
      if (widget.onError != null) {
        widget.onError!(e);
      } else {
        rethrow;
      }
    } catch (e) {
      if (widget.updateLabelOnClick) {
        if (increase) {
          setState(() {
            value = value - widget.step;
          });
        } else {
          setState(() {
            value = value + widget.step;
          });
        }
      }
      if (widget.onError != null) {
        widget.onError!(e);
      } else {
        rethrow;
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: widget.orientation == Orientation.portrait
          ? Axis.vertical
          : Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        InkWell(
          onTap: () async {
            _onTap(true);
          },
          child: PlusMinusButton(
            button: '+',
            size: widget.buttonSize,
            fontSize: widget.buttonFontSize,
            color: widget.plusColor,
          ),
        ),
        Container(
          width: widget.orientation == Orientation.portrait
              ? MediaQuery.of(context).size.width
              : null,
          child: Center(
            child: Text(
              value.toString(),
              style: TextStyle(
                fontSize: widget.labelFontSize,
                color: widget.labelColor,
                fontWeight: widget.labelFontWeight,
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            _onTap(false);
          },
          child: PlusMinusButton(
            button: '-',
            size: widget.buttonSize,
            fontSize: widget.buttonFontSize,
            color: widget.minusColor,
          ),
        ),
      ],
    );
  }
}
