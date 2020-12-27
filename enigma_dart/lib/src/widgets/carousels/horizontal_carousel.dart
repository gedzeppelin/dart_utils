import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";

class HorizontalCarousel extends StatelessWidget {
  /// Margin to be applied to all text inside the card.
  static const double horizontalMargin = 8.0;

  /// Carousel title.
  final List<Widget> items;
  final double height;
  final String title;
  final double innerMargin;
  final double edgesMargin;

  HorizontalCarousel({
    Key key,
    @required this.items,
    @required this.height,
    this.title,
    this.innerMargin = 8.0,
    this.edgesMargin = 16.0,
  }) : super(key: key);

  static List<Widget> withTitle({
    @required List<Widget> items,
    @required double height,
    String title,
    double innerMargin = 8.0,
    double edgesMargin = 16.0,
  }) {
    return <Widget>[
      // ANCHOR Carousel title.
      if (title != null)
        Container(
          margin: const EdgeInsets.only(top: 12.0, left: 16.0, bottom: 4.0),
          child: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
          ),
        ),
      // ANCHOR Product carousel itself.
      SizedBox(
        height: height,
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: _makeChildren(items, innerMargin, edgesMargin),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (this.title == null) {
      return SizedBox(
        height: height,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: _makeChildren(items, innerMargin, edgesMargin),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // ANCHOR Carousel title.
        Container(
            margin: const EdgeInsets.only(top: 12.0, left: 16.0, bottom: 4.0),
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
            )),
        // ANCHOR Product carousel itself.
        Container(
          margin: const EdgeInsets.only(top: 6.0),
          height: height,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: _makeChildren(items, innerMargin, edgesMargin),
          ),
        ),
      ],
    );
  }
}

List<Widget> _makeChildren(List<Widget> input, double innerMargin, double edgesMargin) {
  List<Widget> widgetList = List<Widget>();
  final int lastIdx = input.length - 1;

  input.asMap().forEach((idx, widget) {
    widgetList.add(Container(
      margin: idx != 0 && idx != lastIdx
          ? EdgeInsets.symmetric(horizontal: innerMargin)
          : idx == 0
              ? EdgeInsets.only(left: edgesMargin, right: innerMargin)
              : EdgeInsets.only(left: innerMargin, right: edgesMargin),
      child: Center(child: widget),
    ));
  });

  return widgetList;
}
