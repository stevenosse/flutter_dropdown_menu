import 'package:dropdown_menu/src/dropdown_menu_action.dart';
import 'package:flutter/material.dart';

class DropdownMenuBody extends StatefulWidget {
  final List<DropdownMenuAction> actions;
  final VoidCallback onClose;

  DropdownMenuBody({this.actions, @required this.onClose});

  @override
  _DropdownMenuBodyState createState() => _DropdownMenuBodyState();
}

class _DropdownMenuBodyState extends State<DropdownMenuBody>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.ease);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.reverse();
    controller.removeListener(() {});
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return ScaleTransition(
      scale: scaleAnimation,
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
        child: Column(
          children: [
            ...widget.actions.map((e) {
              if (e.isDivider) return Divider();
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    e.onTap();
                    widget.onClose();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        if (e.icon != null) ...[
                          e.icon,
                          SizedBox(width: 10),
                        ],
                        Text(
                          e.title,
                          style: e.titleStyle ??
                              Theme.of(context).textTheme.bodyText2,
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
    );
  }
}
