
import 'package:flutter/material.dart';

class FlexRow extends StatefulWidget {

  @override
  State<FlexRow> createState() => _FlexRowState();
}

class _FlexRowState extends State<FlexRow> {

  final weights = <double>[2, 2, 3];

  double getWidth(int index){
    final total = weights.reduce((value, element) => value + element);
    return weights[index]/total;
  }

  @override
  Widget build(BuildContext context) {
    final total = weights.length;
    return Listener(
      child: 
      LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index){
              return SizedBox(
                width: getWidth(index)* maxWidth,
                child: Container(
                  color: Colors.blue,
                ),
              );
            
            }, separatorBuilder: (context, index){
              return Separator(onChange: (dx){
                setState(() {
                  weights[index] += dx;
                });
              
              });
            }, itemCount: weights.length);
          return Row(
            children: [
              SizedBox(
                width: getWidth(0)* maxWidth,
                child: Container(
                  color: Colors.blue,
                ),
              ),
              SizedBox(
                width: getWidth(1)* maxWidth,
                child: Container(
                  color: Colors.green,
                ),
              ),
              SizedBox(
                width: getWidth(2)* maxWidth,
                child: Container(
                  color: Colors.grey,
                ),
              )
            ],
          );
        }
      ),
    );
  }
}

class Separator extends StatelessWidget {

  const Separator({Key? key, required this.onChange}) : super(key: key);

  final Function(double) onChange;

  @override
  Widget build(BuildContext context) {
    
    return Listener(
      onPointerMove: (event){
        onChange(event.delta.dx);
      },
      child: SizedBox(width: 10, height: MediaQuery.of(context).size.height,),
    );
  }
}