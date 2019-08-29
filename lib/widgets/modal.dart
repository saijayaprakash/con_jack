import 'package:flutter/material.dart';
import 'package:con_jack/main.dart';

class Modal{
    int val;
    void _setFunc(int num){
      val = num;
    }
    Function(int) callback;
    show(BuildContext context, Function callBack){
      this.callback = callBack;
      Future<void> future =  showModalBottomSheet(
        context: context,
        builder: (BuildContext context){
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: ModalWidget(
                  modalSetFunc: _setFunc,
                ),
              )
            ],
          );
        }
      );
      future.then((void val1) => {
          callback(val)
      });
    }
}

class ModalWidget extends StatefulWidget{
  Function modalSetFunc;
  ModalWidget({this.modalSetFunc});
  _ModalWidgetState createState() => _ModalWidgetState();
}

class _ModalWidgetState extends State<ModalWidget>{
  var sliderValue = 5.0;
  int sliderVal = 5;
  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("I want to see analysis for ",style: TextStyle(fontSize: 20),),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(sliderVal.toString(),style: TextStyle(fontSize: 30),),
              Text(" days..",style: TextStyle(fontSize: 20),),
            ],
          ),
          Slider(
            min: 0,
            max: 30,
            divisions: 30,
            value: sliderValue,
            activeColor: Colors.teal,
            inactiveColor: Colors.grey,
            onChanged: (newVal){
              setState(() {
                sliderValue = newVal;
                sliderVal = newVal.toInt();
                widget.modalSetFunc(newVal.toInt());
              });
            },
          ),
        ],
      );
    }
}