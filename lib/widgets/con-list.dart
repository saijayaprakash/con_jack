import 'package:flutter/material.dart';
import 'package:con_jack/util.dart';
import 'dart:collection';
import 'sub-list.dart';
import 'package:device_id/device_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:call_log/call_log.dart';

class List extends StatefulWidget{
  Function func;
  Map<String,dynamic> data;
  List({this.func,this.data}){

  }
  _ListState createState() => _ListState();
}
class _ListState extends State<List>{
  @override
    Widget build(BuildContext context) {
      return MainView(data: widget.data,);
      // return FutureBuilder(
      //   builder: (context, snapshot){
      //     if(!snapshot.hasData){
      //       return CircularProgressIndicator();
      //     }
      //     else{
      //       return MainView(data: snapshot.data,);
      //     }
      //   },
      //   future: widget.func(),
      // );
    }
}

class MainView extends StatelessWidget{
  Map<String , dynamic> data;
  MainView({this.data});

  Widget _getHeader(var totalDuration){
    Timer timer = new Timer(duration: totalDuration);
    return Column(
      children: <Widget>[
        Text("Total Time Wasted",style: TextStyle(fontSize: 28),),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          Text("${timer.hr}",style: TextStyle(fontSize: 30)),
          Text(" hrs :"),
          Text("${timer.min}",style: TextStyle(fontSize: 30)),
          Text(" mins :"),
          Text("${timer.sec}",style: TextStyle(fontSize: 30)),
          Text(" secs :"),
        ],)
    ],);
  }
  @override
    Widget build(BuildContext context) {
      return Column(
        children: <Widget>[
          _getHeader(data['totalDuration']),
          Expanded(
            child: ListBuilder(data: data['data'],),
          )
        ],
      );
    }
}

class ListBuilder extends StatelessWidget{
  SplayTreeMap<dynamic, dynamic> data;
  ListBuilder({this.data});

  Widget _eachTile(String key, Map<String, dynamic> personData){
    Timer timer = new Timer(duration: personData["totalDuration"]);
    return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(key,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                Text("${timer.hr} hrs : ${timer.min} mins : ${timer.sec} secs")
            ]);
  }

  void _updateData(String deviceId, SplayTreeMap<dynamic,dynamic> data){
    var db = Firestore.instance;
    var batch = db.batch();
    Iterator itr = data.keys.iterator;
    while(itr.moveNext()){
      Map<String,dynamic> mapper = data[itr.current];
      Map<String,dynamic> newData = {};
      if(mapper.containsKey("name")){
        newData["name"] = mapper["name"];
      }
      if(mapper.containsKey("number")){
        newData["number"] = mapper["number"];
      }
      if(mapper.containsKey("totalDuration")){
        newData["totalDuration"] = mapper["totalDuration"];
      }
      batch.setData( 
        db.collection(deviceId).document(itr.current), 
        newData
      );
    }
    batch.commit();
  }

  void _storeData(SplayTreeMap<dynamic, dynamic> treeData) async{
    //  Iterator itr = treeData.keys.iterator;
    //  int ind = 0;
    //  while(itr.moveNext()){
    //    ind++;
    //    Map<String,dynamic> personData = treeData[itr.current];
    //    var call_log = [];
    //    call_log =  personData["callLog"];
    //    Iterator callLogItr =  call_log.iterator;
    //    if(ind == 1){
    //      while(callLogItr.moveNext()){
    //       Map<String, dynamic> callLog = callLogItr.current;
    //       CallType callType = callLog["type"];
    //      }
    //    }
    //  }
    String device_id = await DeviceId.getID;
    // _updateData(device_id, treeData);
    Firestore.instance.document("metadata/" + device_id).get().then((data){
      if(data.data == null){
        Firestore.instance.document("metadata/" + device_id).setData({"name":"Rookie Boy"});
        _updateData(device_id, treeData);
      }
    });
  } 
  @override
    Widget build(BuildContext context) {
      _storeData(data);
      return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context,index){
          String key  = data.keys.elementAt(index);
          Map<String, dynamic> personData = data[key];
          return ListTile(
            onTap: (){
              Navigator.of(context).push( new MaterialPageRoute(
                builder: (BuildContext context) => SubList(person:personData)
              ));
            },
            contentPadding: EdgeInsets.all(10),
            leading: Text((index+1).toString(),style: TextStyle(fontSize: 20,color: Colors.indigo),),
            title: _eachTile(key,personData),
          ); 
        },
      );
    }
}