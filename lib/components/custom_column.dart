import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class CustomColumn extends MultiChildRenderObjectWidget {
  const CustomColumn({
    super.key,
    List<Widget> children = const [],
  }) : super(children: children);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCustomColumn();
  }
}

class CustomColumnParentData extends ContainerBoxParentData<RenderBox> {}

class RenderCustomColumn extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, CustomColumnParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, CustomColumnParentData> {
  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! CustomColumnParentData) {
      child.parentData = CustomColumnParentData();
    }
  }

  @override
  void performLayout() {
    double width = 0, height = 0;

    RenderBox? first = firstChild;

    while (first != null) {
      final firstParentData = first.parentData as CustomColumnParentData;

      first.layout(
        BoxConstraints(maxWidth: constraints.maxWidth),
        parentUsesSize: true,
      );

      // increment the size
      height += first.size.height;
      width = max(width, first.size.width);

      // traverse next sibling of child
      first = firstParentData.nextSibling;
    }

    first = firstChild;

    var firstOffset = const Offset(0, 0);

    double x = 0;

    while (first != null) {
      final firstParentData = first.parentData as CustomColumnParentData;
      firstParentData.offset = Offset(x, firstOffset.dy);

      x += 10;

      firstOffset += Offset(x, first.size.height);

      first = firstParentData.nextSibling;
    }

    size = Size(width, height);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }
}
