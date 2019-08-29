import 'package:flutter/material.dart';
import 'widgets/con-list.dart';
import 'package:call_log/call_log.dart';
import 'package:con_jack/util.dart';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'widgets/title-widget.dart';
import 'widgets/modal.dart';

void main() => runApp(ConApp());
class ConApp extends StatelessWidget{
  @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: "CoNjAcK",
        theme: ThemeData(
          primarySwatch: Colors.teal
        ),
        home: HomePage(
          numOfDays: 5,
        ),
      );
    }
}
class HomePage extends StatefulWidget{
  int numOfDays;
  HomePage({this.numOfDays});
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage>{
  void callBack(int num){
    setState(() {
      widget.numOfDays = num;
    });
  }
  @override
  Widget build(BuildContext context) {
    Modal modal = new Modal();
    return Scaffold(
        appBar: AppBar(
          title: MainTitle(),
        ),
        body: Center(
          child: StateFulList(numOfDays: widget.numOfDays,),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: ()=> modal.show(context,callBack),
          child: Icon(Icons.date_range),
          tooltip: "Jai the Kingmaker",
        ),
      );
    }
}

class StateFulList extends StatefulWidget{
  int numOfDays;
  Map<String,dynamic> fulldata;
  StateFulList({this.numOfDays});
  _StateFulListState createState() => _StateFulListState();
}
class _StateFulListState extends State<StateFulList>{
   //Get Contacts
  Future _getContacts() async{
    await new Future.delayed(Duration(seconds: 1));
    var now = DateTime.now();
    var from = now.subtract(Duration(days: widget.numOfDays)).millisecondsSinceEpoch;
    var to = now.millisecondsSinceEpoch;
    var totalDuration = 0;

    Iterable<CallLogEntry> entries = await CallLog.query(
      dateFrom: from,
      dateTo: to,
    );
    var map = <String, Object>{};
    entries.forEach((val){
      totalDuration += val.duration;
      if(val.name != null){
        if(!map.containsKey(val.name)){
          var subMap = <String , Object>{};
          subMap  = constructSubMap(val: val);
          map[val.name] = subMap;
        }
        else{
          adjustTotalDuration(map: map[val.name],val: val);
        }
      }
      else if(val.formattedNumber != null){
        if(!map.containsKey(val.formattedNumber)){
          var subMap = <String , Object>{};
          subMap  = constructSubMap(val: val);
          map[val.formattedNumber] = subMap;
        }
        else{
          adjustTotalDuration(map: map[val.formattedNumber],val: val);
        }
      }
      else if(val.number != null){
        if(!map.containsKey(val.number)){
          var subMap = <String , Object>{};
          subMap  = constructSubMap(val: val);
          map[val.number] = subMap;
        }
        else{
          adjustTotalDuration(map: map[val.number],val: val);
        }
      }
    });
    final sorted = new SplayTreeMap.from(map, (a, b){
      Map<String,Object> map1 = map[a];
      Map<String,Object> map2 = map[b];
      return -1*int.parse(map1['totalDuration'].toString()).compareTo(int.parse(map2['totalDuration'].toString()));
    });

    var keys = sorted.keys; 
    for(int i=0;i<keys.length;i++){
      Map<String, Object> val = map[keys.elementAt(i)];
      Timer timer = new Timer(duration: val['totalDuration']);
    }
    Timer timer2 = new Timer(duration: totalDuration);
    
    Map<String, dynamic> result = <String, dynamic>{};
    result['totalDuration'] = totalDuration;
    result['data'] = sorted;
    return result;
  }
  
  void adjustTotalDuration({Map<String,Object> map, CallLogEntry val}){
      int dur = map['totalDuration'];
      map['totalDuration'] = dur + val.duration;
      var temp = [];
      temp = map['callLog'];
      var callLog = <String, Object>{};
      callLog['type'] = val.callType;
      callLog['duration'] = val.duration;
      callLog['timestamp'] = DateTime.fromMillisecondsSinceEpoch(val.timestamp);
      temp.add(callLog);
      map['callLog'] = temp;
  }
  
  Map<String , Object> constructSubMap({CallLogEntry val}){
      Map<String,Object> map = <String,Object>{};
      if(val.name != null){
        map['name'] = val.name;
      }
      if(val.number != null){
        map['number'] = val.number;
      }
      else if(val.formattedNumber != null){
        map['number'] = val.formattedNumber;
      }
      else{
        map['number'] = "-NA-";
      }
      map['totalDuration'] = val.duration;
      var list = [];
      var callLog = <String, Object>{};
      callLog['type'] = val.callType;
      callLog['duration'] = val.duration;
      callLog['timestamp'] = DateTime.fromMillisecondsSinceEpoch(val.timestamp);
      list.add(callLog);
      map['callLog'] = list;
      return map;
  }
  @override
    // void initState() {
    //   // TODO: implement initState
    //   super.initState();
    //   fulldata = null;
    // }
  @override
    Widget build(BuildContext context) {
      if(widget.fulldata == null){
        _getContacts().then((data){
          setState(() {
            widget.fulldata = data;
          });
        });
        return CircularProgressIndicator();
      }
      else{
        // return List(func: _getContacts);
        return List(data: widget.fulldata,);
      }
    }
}