import 'dart:math';
import '../widges/cat.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  Animation<double> catAnimation;
  AnimationController catController;
  Animation<double> boxAnimation;
  AnimationController boxController;

  @override
  void initState() {
    super.initState();

    boxController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    boxAnimation = Tween(begin: 0.6 * pi, end: 0.65 * pi).animate(
      CurvedAnimation(parent: boxController, curve: Curves.easeIn),
    );
    boxAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed)
        boxController.reverse();
      else if (status == AnimationStatus.dismissed) boxController.forward();
    });
    boxController.forward();

    catController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    catAnimation = Tween(begin: -35.0, end: -80.0).animate(
      CurvedAnimation(parent: catController, curve: Curves.linear),
    );
  }

  onTap() {
    if (catController.status == AnimationStatus.completed) {
      catController.reverse();
      boxController.forward();
    } else if (catController.status == AnimationStatus.dismissed) {
      catController.forward();
      boxController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Animation!'),
        ),
        body: GestureDetector(
          child: Center(
            child: Stack(
              overflow: Overflow.visible,
              children: [
                buildCatAnimation(),
                buildBox(),
                buildRightFlap(),
                buildLeftFlap(),
              ],
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget buildCatAnimation() {
    return AnimatedBuilder(
      animation: catAnimation,
      builder: (context, child) {
        return Positioned(
          child: child,
          top: catAnimation.value,
          right: 0.0,
          left: 0.0,
        );
      },
      child: Cat(),
    );
  }

  Widget buildBox() {
    return Container(
      width: 200.0,
      height: 200.0,
      color: Colors.brown,
    );
  }

  Widget buildLeftFlap() {
    return AnimatedBuilder(
      animation: boxAnimation,
      builder: (context, child) {
        return Positioned(
          // try it if not wrap up AB with position instead!!
          left: 3.0,
          child: Transform.rotate(
            child: child,
            alignment: Alignment.topLeft,
            angle: boxAnimation.value,
          ),
        );
      },
      child: Container(
        height: 10.0,
        width: 125.0,
        color: Colors.brown,
      ),
    );
  }

  Widget buildRightFlap() {
    return AnimatedBuilder(
      animation: boxAnimation,
      builder: (context, child) {
        return Positioned(
          // try it if not wrap up AB with position instead!!
          right: 3.0,
          child: Transform.rotate(
            child: child,
            alignment: Alignment.topRight,
            angle: -boxAnimation.value,
          ),
        );
      },
      child: Container(
        height: 10.0,
        width: 125.0,
        color: Colors.brown,
      ),
    );
  }
}
