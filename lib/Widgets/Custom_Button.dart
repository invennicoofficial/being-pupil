import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'Arrow_Clipper.dart';

class SimpleAccountMenu extends StatefulWidget {
  final List<Text>? text;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? iconColor;
  final ValueChanged<int>? onChange;

  const SimpleAccountMenu({
    Key ?key,
    this.text,
    this.borderRadius,
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.iconColor = Colors.white,
    this.onChange,
  })  : assert(text != null),
        super(key: key);
  @override
  _SimpleAccountMenuState createState() => _SimpleAccountMenuState();
}

class _SimpleAccountMenuState extends State<SimpleAccountMenu>
    with SingleTickerProviderStateMixin {
  GlobalKey? _key;
  bool isMenuOpen = false;
  Offset? buttonPosition;
  Size? buttonSize;
  OverlayEntry? _overlayEntry;
  BorderRadius? _borderRadius;
  AnimationController? _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    _borderRadius =  BorderRadius.circular(5);
    _key = LabeledGlobalKey("button_icon");
    super.initState();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  findButton() {
    RenderBox? renderBox = _key!.currentContext!.findRenderObject() as RenderBox?;
    buttonSize = Size(30.0.w, 5.0.h);
    buttonPosition = renderBox!.localToGlobal(Offset(-80, 0));
  }

  void closeMenu() {
    _overlayEntry!.remove();
    _animationController!.reverse();
    isMenuOpen = !isMenuOpen;
  }

  void openMenu() {
    findButton();
    _animationController!.forward();
    _overlayEntry = _overlayEntryBuilder();
    Overlay.of(context)!.insert(_overlayEntry!);
    isMenuOpen = !isMenuOpen;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _key,
      decoration: BoxDecoration(
        color: Color(0xFF231F20),
        borderRadius: _borderRadius,
      ),
      child: IconButton(
        icon: Icon(Icons.expand_more_outlined),
        // AnimatedIcon(
        //   icon: AnimatedIcons.arrow_menu,
        //   progress: _animationController!,
        // ),
        color: Colors.white,
        onPressed: () {
          if (isMenuOpen) {
            closeMenu();
          } else {
            openMenu();
          }
        },
      ),
    );
  }

  OverlayEntry _overlayEntryBuilder() {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          top: buttonPosition!.dy + buttonSize!.height,
          left: buttonPosition!.dx,
          width: buttonSize!.width,
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: ClipPath(
                    clipper: ArrowClipper(),
                    child: Container(
                      width: 17,
                      height: 17,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Container(
                    height: widget.text!.length * buttonSize!.height,
                    decoration: BoxDecoration(
                      color: widget.backgroundColor,
                      borderRadius: _borderRadius,
                    ),
                    child: Theme(
                      data: ThemeData(
                        iconTheme: IconThemeData(
                          color: Colors.white,
                        ),
                      ),
                      child: Column(
                        //mainAxisSize: MainAxisSize.min,
                        children: List.generate(widget.text!.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              widget.onChange!(index);
                              closeMenu();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [BoxShadow(
                                color: Colors.grey.shade100,
                                 blurRadius: 1.0,
                                ),]
                              ),
                              width: buttonSize!.width,
                              height: buttonSize!.height,
                              child: Center(
                                child: widget.text![index],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}