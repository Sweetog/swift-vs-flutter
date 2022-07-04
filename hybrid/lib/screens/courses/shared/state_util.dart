import 'package:flutter/material.dart';
import 'package:hybrid/screens/courses/shared/state_model.dart';

class StateUtil {
  static List<StateModel> buildStatesList() {
    var list = List<StateModel>();

    var m = StateModel(imgName: 'cali.jpg', name: 'California');
    list.add(m);

    m = StateModel(imgName: 'arizona.jpg', name: 'Arizona');
    list.add(m);

    m = StateModel(imgName: 'colorado.png', name: 'Colorado');
    list.add(m);

    m = StateModel(imgName: 'florida.jpg', name: 'Florida');
    list.add(m);

    m = StateModel(imgName: 'nevada.jpg', name: 'Nevada');
    list.add(m);

    return list;
  }

  static AssetImage buildImg(String imgName) {
    //return ImageProvider(imgName:'assets/states/$imgName')
    return AssetImage('assets/states/$imgName');
  }
}
