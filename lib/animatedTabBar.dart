import 'package:flutter/material.dart';

class AnimatedTabBar extends StatefulWidget {
  final Color tabColor = Color(0xff3c3b3c);

  @override
  _AnimatedTabBarState createState() => _AnimatedTabBarState();
}

class _AnimatedTabBarState extends State<AnimatedTabBar>
    with SingleTickerProviderStateMixin {
  Size screenSize;
  double cardHeight = 90.0;
  double tabIconWidth;
  int currentIndex;
  int totalTabs;

  List<IconData> _iconData;
  List<double> _opacity;
  List<Color> _iconColor;

  Animation<Offset> animation;
  AnimationController controller;

  @override
  void initState() {
    currentIndex = 0;

    //IconData
    _iconData = [Icons.shop, Icons.favorite_border, Icons.search];
    _opacity = [1, 0, 0];
    _iconColor = [Colors.white, Colors.grey, Colors.grey];
    totalTabs = _iconData.length;

    //Animation variables
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    animation = Tween<Offset>(begin: Offset(0, 0), end: Offset(2, 0))
        .animate(controller);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    tabIconWidth = (screenSize.width * 0.64) / 3;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.15),
      color: widget.tabColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 12.0,
      child: Container(
        width: double.infinity,
        height: cardHeight,
        padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.03),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SlideTransition(
              position: animation,
              child: Container(
                height: 5.0,
                width: tabIconWidth / 2,
                margin: EdgeInsets.symmetric(horizontal: tabIconWidth * 0.25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List<Widget>.generate(
                  totalTabs, (i) => _buildIcon(i, _iconData[i])),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(int index, IconData iconData) {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: TrapeziumClipper(),
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 700),
            curve: Curves.easeInOut,
            opacity: _opacity[index],
            child: Container(
              height: cardHeight - 5,
              width: tabIconWidth,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ),
        Container(
          height: cardHeight - 5,
          width: tabIconWidth,
          child: IconButton(
            onPressed: () {
              setState(() {
                currentIndex = index;
                _opacity = [0, 0, 0];
                controller.animateTo(index / (totalTabs - 1));
                Future.delayed(Duration(milliseconds: 700), () {
                  setState(() {
                    _iconColor = [Colors.grey, Colors.grey, Colors.grey];
                  });
                });

                Future.delayed(Duration(milliseconds: 950), () {
                  setState(() {
                    _iconColor[index] = Colors.white;
                    _opacity[index] = 1.0;
                  });
                });
              });
            },
            icon: Icon(
              iconData,
              color: _iconColor[index],
            ),
          ),
        ),
      ],
    );
  }
}

class TrapeziumClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width * 0.73, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(size.width * 0.27, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
