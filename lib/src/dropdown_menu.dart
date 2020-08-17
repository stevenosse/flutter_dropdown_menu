import 'package:dropdown_menu/dropdown_menu.dart';
import 'package:dropdown_menu/src/dropdown_body.dart';
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
  OverlayState overlayState;
  OverlayEntry overlayEntry;
  double overlayX;
  double overlayY;

  bool isOverlayActive = false;

  final GlobalKey containerKey = GlobalKey();

  @override
  void initState() {
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

  void updateOverlay() {
    if (isOverlayActive) {
      hideOverlay();
    } else {
      showOverlay();
    }
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
              showOverlay();
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
      overlayEntry = null;
    });
  }

  showOverlay() {
    overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        final Size size = MediaQuery.of(context).size;
        return Positioned(
          top: 0,
          left: 0,
          child: Stack(
            children: [
              GestureDetector(
                onTapDown: (TapDownDetails details) {
                  hideOverlay();
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
                top: overlayY,
                right: overlayX >= size.width * (2 / 3) ? 5 : overlayX,
                child: DropdownMenuBody(
                  onClose: () {
                    this.hideOverlay();
                  },
                  actions: widget.dropdownMenuActions,
                ),
              ),
            ],
          ),
        );
      },
    );
    overlayState.insert(overlayEntry);
  }

  @override
  void dispose() {
    if (overlayEntry != null) {
      overlayEntry.remove();
    }
    super.dispose();
  }
}

