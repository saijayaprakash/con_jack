import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';
import 'package:con_jack/util.dart';
class SubList extends StatelessWidget{
  Map<String, dynamic> person;  
  SubList({this.person});
  @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: PersonData(person: person,)
      );
    }
}

class PersonData extends StatelessWidget{
  Map<String, dynamic> person;
  PersonData({this.person});
  @override
    Widget build(BuildContext context) {
      Timer timer = new Timer(duration: person['totalDuration']);
      return CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text("Call Log Details"),
            expandedHeight: 300,
            flexibleSpace: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(29),
                  child: Container(),
                ),
                ListTile(
                  title: Text("${person['name'] != null?person['name']:'-'}",style: TextStyle(fontSize: 20,color: Colors.white),textAlign: TextAlign.center,),
                ),
                ListTile(
                  title: Text("${person['number']}",style: TextStyle(fontSize: 20,color: Colors.white),textAlign: TextAlign.center,),
                ),
                ListTile(
                  title: Text("${timer.hr} h : ${timer.min} m : ${timer.sec} s",style: TextStyle(fontSize: 20,color: Colors.white),textAlign: TextAlign.center,),
                ),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((BuildContext context, int index){
                int totalLen = person['callLog'].length;
                if(index >= totalLen){
                  return null;
                }
                return _singleCallLogList(person['callLog'][index]);
              }
            ),
            // delegate: SliverChildListDelegate(
            //   _callLogList(person['callLog'])
            // ),
          )
        ],
      );
      // return Column(children: <Widget>[
      //   Text("Name : ${person['name']}")
      //   Text("Name : ${person['name']}")
      // ],);
    }

    Color _getColor(int callType){
      switch(callType){
        case 1 : return Color.fromARGB(150, 255, 255, 169); //outgoing
        case 2 : return Color.fromARGB(120, 255, 189, 189); //Missed
        case 0 : return Color.fromARGB(100, 189, 255, 211); //Income
        case 4 : return Color.fromARGB(150,199, 189, 255); //Reject
      }
    }

    IconButton _getIcon(int callType){
      switch(callType){
        case 0 : return IconButton(icon: Icon(Icons.call_received,color: Colors.blue,),tooltip: "Incoming Call",);
        case 1 : return IconButton(icon: Icon(Icons.call_made,color: Colors.green,),tooltip: "Outgoing Call",);
        case 2 : return IconButton(icon: Icon(Icons.call_missed,color: Colors.redAccent,),tooltip: "Missed Call",);
        case 4 : return IconButton(icon: Icon(Icons.cancel,color: Colors.red,),tooltip: "Call Rejected",);
      }
    }

    Container _singleCallLogList(Map<String,dynamic> singleLog){
      CallType callType = singleLog["type"];
      int callTypeInd = callType.index;
      Timer timer = new Timer(duration: singleLog['duration']);
      return Container(
          decoration: BoxDecoration(
            color: _getColor(callTypeInd)
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(10),
            trailing: _getIcon(callTypeInd),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Text("${timer.hr} h: ${timer.min} m: ${timer.sec} s",style: TextStyle(fontSize: 20),),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Text("${singleLog['timestamp']}"),
                )
              ],
            )
          )
      );
    }
}