import 'package:flutter/material.dart';
import 'package:taskrunz/pages/name.dart';
import 'package:taskrunz/widgets/custom_text.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> with SingleTickerProviderStateMixin{
  AnimationController _animationController;

  Animation<double> _titleTextScaleAnimation;
  Animation<double> _titleTextOpacityAnimation;
  
  Animation<double> _vpTextScaleAnimation;
  Animation<double> _vpTextOpacityAnimation;

  Animation<double> _imgScaleAnimation;
  Animation<double> _imgTextOpacityAnimation;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 2000));
    _initializeAnimations();
    _animationController.forward();

    super.initState();
  }

  void _initializeAnimations() {
    _titleTextScaleAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController, curve: Interval(0.0, 0.4, curve: Curves.decelerate)
    ));
    _titleTextOpacityAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController, curve: Interval(0.0, 0.3, curve: Curves.easeIn)
    ));
    
    _vpTextScaleAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController, curve: Interval(0.2, 0.6, curve: Curves.easeIn)
    ));
    _vpTextOpacityAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController, curve: Interval(0.2, 0.5, curve: Curves.easeIn)
    ));

    _imgScaleAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController, curve: Interval(0.5, 1.0, curve: Curves.decelerate)
    ));
    _imgTextOpacityAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController, curve: Interval(0.5, 0.8, curve: Curves.easeIn)
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade800,
      body: SafeArea(
        // padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FadeTransition(
                opacity: _titleTextOpacityAnimation,
                child: ScaleTransition(
                  scale: _titleTextScaleAnimation,
                  child: TitleText(text: "TaskRunz",),
                ),
              ),
              SizedBox(height: 20,),
              FadeTransition(
                opacity: _vpTextOpacityAnimation,
                child: ScaleTransition(
                  scale: _vpTextScaleAnimation,
                  child: BodyText(text: "Stay organized and productive with the best Todo List and Task organization app",
                  textOverflow: TextOverflow.clip, textAlign: TextAlign.center,),
                ),
              ),
              SizedBox(height: 40,),
              FadeTransition(
                opacity: _imgTextOpacityAnimation,
                child: ScaleTransition(
                  scale: _imgScaleAnimation,
                  child: Icon(Icons.today, size: 300, color: Colors.white,),
                ),
              ),
              SizedBox(height: 40,),
              FadeTransition(
                opacity: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(0.6, 1, curve: Curves.easeInCubic)
                )),
                child: RaisedButton(
                  child: BodyText(text: "BEGIN", textColor: Colors.orange.shade800,
                  fontWeight: FontWeight.bold,),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)
                  ),
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => NamePage()
                    ));
                  },
                ),
              )
            ],
          ),
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