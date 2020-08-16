import 'package:dropdown_menu/src/dropdown_menu_action.dart';
import 'package:flutter/material.dart';

class DropdownMenu extends StatefulWidget {
  final Key key;
  final Widget menuIcon;
  final List<DropdownMenuAction> dropdownMenuActions;

  DropdownMenu({this.key, this.menuIcon, this.dropdownMenuActions})
      : super(key: key) {
    assert(menuIcon != null &&
        dropdownMenuActions != null &&
        dropdownMenuActions.length > 0);
  }

  @override
  _DropdownMenuState createState() => _DropdownMenuState();
}

class _DropdownMenuState extends State<DropdownMenu> {
  FocusNode _focusNode;
  OverlayState overlayState;
  OverlayEntry overlayEntry;
  double overlayX;
  double overlayY;

  bool isOverlayActive = false;

  final GlobalKey containerKey = GlobalKey();

  @override
  void initState() {
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      print("focus changed");
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      overlayState = Overlay.of(context);

      _initPosition();
    });
    super.initState();
  }

  _initPosition() {
    RenderBox box = containerKey.currentContext.findRenderObject();
    Offset position = box.localToGlobal(Offset.zero);
    overlayX = position.dx;
    overlayY = position.dy + 50;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: containerKey,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (isOverlayActive == false) {
              _showOverlay();
              setState(() {
                isOverlayActive = true;
              });
            } else {
              hideOverlay();
            }
          },
          child: widget.menuIcon,
        ),
      ),
    );
  }

  hideOverlay() {
    overlayEntry?.remove();
    setState(() {
      isOverlayActive = false;
    });
  }

  _showOverlay() {
    overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        final Size size = MediaQuery.of(context).size;
        return Positioned(
            top: overlayY,
            right: overlayX >= size.width * (2 / 3) ? 5 : overlayX,
            child: Stack(
              children: [
                GestureDetector(
                  onTapDown: (TapDownDetails details) {
                    final RenderBox referenceBox = context.findRenderObject();
                    Offset tapPosition =
                    referenceBox.globalToLocal(details.globalPosition);

                    if (tapPosition.dx <= overlayX) {
                      hideOverlay();
                    }
                  },
                  child: Container(
                    width: size.width,
                    height: size.height,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: Container(
                    width: size.width * 0.5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 3.0,
                          color: Colors.black.withOpacity(0.3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          ...widget.dropdownMenuActions.map((e) {
                            if (e.isDivider) return Divider();
                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  e.onTap();
                                  hideOverlay();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 4.0,
                                  ),
                                  child: Row(
                                    children: [
                                      if (e.icon != null) ...[
                                        e.icon,
                                        SizedBox(width: 10),
                                      ],
                                      Text(
                                        e.title,
                                        style: e.titleStyle ??
                                            Theme.of(context)
                                                .textTheme
                                                .bodyText2,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          })
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ));
      },
    );
    overlayState.insert(overlayEntry);
  }

  @override
  void dispose() {
    _focusNode?.removeListener(() {});
    if (overlayEntry != null) {
      overlayEntry.remove();
    }
    super.dispose();
  }
}