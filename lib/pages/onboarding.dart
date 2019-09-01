import 'package:flutter/material.dart';
import 'package:taskrunz/widgets/custom_text.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> with SingleTickerProviderStateMixin{
  AnimationController _animationController;

  Animation<double> _titleTextSizeAnimation;
  Animation<double> _titleTextOpacityAnimation;
  
  Animation<double> _vpTextSizeAnimation;
  Animation<double> _vpTextOpacityAnimation;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    _initializeAnimations();

    _animationController.forward();
    super.initState();
  }

  void _initializeAnimations() {
    _titleTextSizeAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController, curve: Interval(0.0, 0.4, curve: Curves.easeIn)
    ));
    _titleTextOpacityAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController, curve: Interval(0.0, 0.3, curve: Curves.easeIn)
    ));
    
    _vpTextSizeAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController, curve: Interval(0.2, 0.6, curve: Curves.easeIn)
    ));
    _vpTextOpacityAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController, curve: Interval(0.2, 0.5, curve: Curves.easeIn)
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade800,
      body: Container(
        child: Column(
          children: <Widget>[
            FadeTransition(
              opacity: _titleTextOpacityAnimation,
              child: ScaleTransition(
                scale: _titleTextSizeAnimation,
                child: TitleText(text: "TaskRunz",),
              ),
            ),
            FadeTransition(
              opacity: _vpTextOpacityAnimation,
              child: ScaleTransition(
                scale: _vpTextSizeAnimation,
                child: BodyText(text: "Stay organized and productive with the best Todo List and Task organization app",),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}