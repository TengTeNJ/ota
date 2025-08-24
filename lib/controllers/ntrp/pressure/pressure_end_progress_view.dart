import 'package:flutter/material.dart';
class PressureEndProgressView extends StatefulWidget {
  int count;

  PressureEndProgressView({required this.count});


  @override
  State<PressureEndProgressView> createState() => _PressureEndProgressViewState();
}

class _PressureEndProgressViewState extends State<PressureEndProgressView> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 14,
          height: 14,
          // color: Color.fromRGBO(21, 233, 120, 1.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
              color: widget.count < 1 ? Colors.white : Colors.transparent,
              width: 2.0,
            ),
            color:widget.count < 1 ?  Colors.transparent :
            Color.fromRGBO(21, 233, 120, 1.0),
          ),
        ),
        SizedBox(width: 17,),
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
              color: widget.count < 2 ? Colors.white : Colors.transparent,
              width: 2.0,
            ),
            color:widget.count < 2 ?  Colors.transparent :
            Color.fromRGBO(21, 233, 120, 1.0),
          ),
        ),
        SizedBox(width: 17,),

        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.count < 3 ? Colors.white : Colors.transparent,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(7),
            color:widget.count < 3 ?  Colors.transparent :
            Color.fromRGBO(21, 233, 120, 1.0),
          ),
        ),
        SizedBox(width: 17,),

        Container(
          width: 14,
          height: 14,
          // color: Color.fromRGBO(21, 233, 120, 1.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
              color: widget.count < 4 ? Colors.white : Colors.transparent,
              width: 2.0,
            ),
            color:widget.count < 4 ?  Colors.transparent :
            Color.fromRGBO(21, 233, 120, 1.0),
          ),
        ),
        SizedBox(width: 17,),




      ],
    );

  }
}
