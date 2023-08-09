library flexbox;

export 'flexrow.dart';

import 'package:flutter/material.dart';

class FlexBox extends StatefulWidget {
  FlexBox({super.key, this.children = const [], required this.constraints});

  final List<Widget> children;
  final BoxConstraints constraints;

  @override
  State<FlexBox> createState() => _FlexBoxState();
}

class _FlexBoxState extends State<FlexBox> {
  late double width, height;
  late double x,y;
  List<bool> borderFocus = [false, false, false, false];

  @override
  void initState() {
    final maxWidth = widget.constraints.maxWidth;
    final maxHeight = widget.constraints.maxHeight;
    width = maxWidth*0.8;
    height = maxHeight*0.8;
    x = (maxWidth - width)/2;
    y = (maxHeight - height)/2;
    super.initState();
  }

  void setBorderFocus(int index) {
    borderFocus.setAll(0, [false, false, false, false]);
    if (index != -1) {
      setState(() {
        borderFocus[index] = true;
      });
    } else {
      setState(() {
        borderFocus.setAll(0, [false, false, false, false]);
      });
    }
  }

  bool get isLeft => borderFocus[0];
  bool get isRight => borderFocus[1];
  bool get isTop => borderFocus[2];
  bool get isBottom => borderFocus[3];

  final area = 20;
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, contraints) {
      final maxWidth = contraints.maxWidth;
      final maxHeight = contraints.maxHeight;
      return Listener(
        onPointerDown: (event) {
          isPressed = true;
        },
        onPointerUp: (event) {
          isPressed = false;
        },
        onPointerHover: (event) {
          // print('hover: ${event.position}');
          final offset = event.position;

          // is inside
          if (offset.dx > (x + area) &&
              offset.dx < (x + width - area) &&
              offset.dy > (y + area) &&
              offset.dy < (y + height - area)) {
            setBorderFocus(-1);
          } else {
            //   print('border');
            if ((offset.dx - x).abs() < area) {
              // left
              setBorderFocus(0);
            } else if ((offset.dx - (x + width)).abs() < area) {
              // right
              setBorderFocus(1);
            } else if ((offset.dy - y).abs() < area) {
              // top
              setBorderFocus(2);
            } else if ((offset.dy - (y + height)).abs() < area) {
              // bottom
              setBorderFocus(3);
            } else {
              setBorderFocus(-1);
            }
          }
        },
        onPointerMove: (event) {
          final offset = event.position;
          if (offset.dx > (x + area) &&
              offset.dx < (x + width - area) &&
              offset.dy > (y + area) &&
              offset.dy < (y + height - area)) {
            setBorderFocus(-1);
            setState(() {
              x += event.delta.dx;
              y += event.delta.dy;
            });
          } else {
            if (isLeft) {
              setState(() {
                x += event.delta.dx;
                width -= event.delta.dx;
              });
            } else if (isTop) {
              setState(() {
                y += event.delta.dy;
                height -= event.delta.dy;
              });
            } else if (isRight || isBottom) {
              setState(() {
                width += event.delta.dx;
                height += event.delta.dy;
              });
            }
          }
        },
        child: Stack(
          children: [
            Container(
                width: maxWidth, height: maxHeight, color: Colors.transparent),
            ...widget.children.map((child) {
              return FlexContainer(
                  x: x,
                  y: y,
                  width: width,
                  height: height,
                  isLeft: isLeft,
                  isRight: isRight,
                  isTop: isTop,
                  isBottom: isBottom,
                  child: child);
            }),
          ],
        ),
      );
    });
  }
}

class FlexContainer extends Container {
  FlexContainer(
      {required this.x,
      required this.y,
      required this.width,
      required this.height,
      required this.isLeft,
      required this.isRight,
      required this.isTop,
      required this.isBottom,
      super.child})
      : super();

  final double x, y;
  final double width, height;
  final bool isLeft, isRight, isTop, isBottom;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: y,
      left: x,
      child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                  color: isLeft ? Colors.red : Colors.black,
                  width: isLeft ? 3 : 1),
              right: BorderSide(
                  color: isRight ? Colors.red : Colors.black,
                  width: isRight ? 3 : 1),
              top: BorderSide(
                  color: isTop ? Colors.red : Colors.black,
                  width: isTop ? 3 : 1),
              bottom: BorderSide(
                  color: isBottom ? Colors.red : Colors.black,
                  width: isBottom ? 3 : 1),
            ),
          ),
          child: super.build(context)),
    );
  }
}
