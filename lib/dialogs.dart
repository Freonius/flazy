import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'buttons.dart';

void confirmDialog({
  required BuildContext context,
  required String title,
  required String text,
  required String okLabel,
  required String rejectLabel,
  required Future<void> Function() onConfirm,
  Color? color,
  Color? fontColor,
  Future<void> Function()? onReject,
}) {
  onReject ??= () async => Navigator.of(context).pop();

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(
        title,
        style: TextStyle(
          color: fontColor,
        ),
      ),
      content: Text(
        text,
      ),
      actions: [
        MainButton(
          okLabel,
          relativeWidth: 0.3,
          onClick: onConfirm,
        ),
        MainButton(
          rejectLabel,
          relativeWidth: 0.3,
          onClick: onReject!,
          mainColor: color,
          backgroundColor: fontColor,
        ),
      ],
    ),
  );
}

void closableDialog({
  required BuildContext context,
  required String title,
  required String text,
  required String btnLabel,
  Color? color,
  Color? fontColor,
  Future<void> Function()? onClose,
  IconData? icon,
}) {
  onClose ??= () async => Navigator.of(context).pop();
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Row(
        children: [
          icon != null
              ? Icon(
                  icon,
                  color: fontColor,
                )
              : Container(),
          icon != null
              ? const SizedBox(
                  width: 8,
                )
              : Container(),
          Text(
            title,
            style: TextStyle(
              color: fontColor,
            ),
          ),
        ],
      ),
      content: Text(
        text,
      ),
      actions: [
        MainButton(
          btnLabel,
          relativeWidth: 0.3,
          onClick: onClose!,
          backgroundColor: fontColor,
          mainColor: color,
        ),
      ],
    ),
  );
}

void redirectableDialog({
  required BuildContext context,
  required String title,
  required String text,
  required String btnLabel,
  required Widget Function() goTo,
  Color? color,
  Color? fontColor,
  bool withNavBar = true,
}) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(
        title,
        style: TextStyle(
          color: fontColor,
        ),
      ),
      content: Text(
        text,
      ),
      actions: [
        MainButton(
          btnLabel,
          relativeWidth: 0.3,
          mainColor: color,
          backgroundColor: fontColor,
          onClick: () async {
            pushNewScreen(
              context,
              screen: goTo(),
              withNavBar: withNavBar,
              pageTransitionAnimation: PageTransitionAnimation.fade,
            );
          },
        ),
      ],
    ),
  );
}
