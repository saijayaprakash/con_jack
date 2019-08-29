import 'package:flutter/material.dart';
import 'package:device_id/device_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainTitle extends StatelessWidget{
  Future _getDeviceId() async{
    String device_id = await DeviceId.getID;
    return device_id;
  }
  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return FutureBuilder(
        builder: (context,snapshot){
          if(!snapshot.hasData){
            return Text("Loading");
          }
          else{
            return TitleWidget(deviceId: snapshot.data ,);
          }
        },
        future: _getDeviceId(),
      );
    }
}
class TitleWidget extends StatelessWidget{
  String deviceId;
  TitleWidget({this.deviceId});
  @override
    Widget build(BuildContext context) {
     return StreamBuilder(
        stream: Firestore.instance.collection('metadata').document(deviceId).snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Text("ConJacker");
          }
          else{
            return CustomText(doc: snapshot.data,);
          }
        },
      );
    }
}
class CustomText extends StatelessWidget{
  DocumentSnapshot doc;
  CustomText({this.doc});
  @override
    Widget build(BuildContext context) {
      // Iterator<DocumentSnapshot> itr = doc.data;
      // Map<String,dynamic> map;
      // while(itr.moveNext()){
      //   DocumentSnapshot doc = itr.current;
      //   map = doc.data;
      // }
      return Text(doc.data['name']);
    }
}