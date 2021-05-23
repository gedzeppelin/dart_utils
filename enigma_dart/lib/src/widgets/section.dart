import "package:flutter/material.dart";

class Section extends StatelessWidget {
  const Section({
    Key? key,
    this.padding = const EdgeInsets.symmetric(horizontal: 8.0),
    this.title,
    this.trailing,
  }) : super(key: key);

  final EdgeInsets padding;
  final String? title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    if (title == null && trailing == null) {
      return Divider();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (title != null) Text(title!),
        Expanded(child: Divider()),
        if (trailing != null) trailing!,
      ],
    );
  }
}
