import 'package:flutter/material.dart';

class HeadlineText extends StatelessWidget{
  final String text;
  final Color textColor;
  final TextAlign textAlign;

  HeadlineText({this.text, this.textColor = Colors.white, this.textAlign = TextAlign.left});

  double _targetWidth = 0;

  double _getSize(final double default_1440){
    return (default_1440 / 14) * (0.0027 * _targetWidth + 10.136);
  }

  @override
  Widget build(BuildContext context) {
    _targetWidth = MediaQuery.of(context).size.width;

    return Text(text,
      style: TextStyle(
        // fontFamily: 'Montserrat',
        fontWeight: FontWeight.w900,
        fontSize: _getSize(33),
        color: textColor,
        letterSpacing: 2,
      ),
      textAlign: textAlign,
    );
  }
}

class TitleText extends StatelessWidget{
  final String text;
  final Color textColor;
  final TextAlign textAlign;

  TitleText({this.text, this.textColor = Colors.white, this.textAlign = TextAlign.left});

  double _targetWidth = 0;

  double _getSize(final double default_1440){
    return (default_1440 / 14) * (0.0027 * _targetWidth + 10.136);
  }

  @override
  Widget build(BuildContext context) {
    _targetWidth = MediaQuery.of(context).size.width;

    return Text(text,
      style: TextStyle(
        // fontFamily: 'Montserrat',
        fontWeight: FontWeight.w900,
        fontSize: _getSize(20),
        color: textColor,
        // letterSpacing: 2,
      ),
      textAlign: textAlign,
    );
  }
}

class BodyText extends StatelessWidget{
  final String text;
  final Color textColor;
  final TextAlign textAlign;
  final TextOverflow textOverflow;
  final FontWeight fontWeight;

  BodyText({this.text, this.textColor = Colors.white, this.textAlign = TextAlign.left, this.textOverflow = TextOverflow.ellipsis, this.fontWeight = FontWeight.normal});

  double _getTextSize(final double targetWidth){
    // at 1440px width, fontsize = 14
    return 0.0027 * targetWidth + 10.136;
  }

  @override
  Widget build(BuildContext context) {
    return Text(text,
      style: TextStyle(
          // fontFamily: 'Lato',
          fontSize: _getTextSize(MediaQuery.of(context).size.width),
          color: textColor,
          fontWeight: fontWeight
      ),
      textAlign: textAlign,
      overflow: textOverflow,
    );
  }
}

class TinyText extends StatelessWidget{
  final String text;
  final Color textColor;
  final TextAlign textAlign;

  TinyText({this.text, this.textColor = Colors.white, this.textAlign = TextAlign.left});

  double _targetWidth = 0;

  double _getSize(final double default_1440){
    return (default_1440 / 14) * (0.0027 * _targetWidth + 10.136);
  }

  @override
  Widget build(BuildContext context) {
    _targetWidth = MediaQuery.of(context).size.width;

    return Text(text,
      style: TextStyle(
        // fontFamily: 'Montserrat',
        fontWeight: FontWeight.w400,
        fontSize: _getSize(12),
        color: textColor,
        // letterSpacing: 2,
      ),
      textAlign: textAlign,
    );
  }
}
