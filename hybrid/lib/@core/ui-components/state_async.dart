import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

/**
 * CustomState refines the basic structure of a state object for a stateful widget. The standard build method now include
 * a FutureBuilder that calls the loadWidget method for widget initialization, especially for async calls. For using this class
 * the widget building code must be inside "customBuild" instead of "build"
 *
 */
abstract class StateAsync<T extends StatefulWidget> extends State<T> {

  //Use _isInit to indicate if loadWidget is called for the first time
  bool _isInit;

  @override
  initState() {super.initState();_isInit=true;}

  // The actual widget returned by customBuild should be embedded but a FutureBuilder to incorporate the loading screen
  // and support the loadWidget method for widget initialization
  @override
  Widget build(BuildContext context) {
    debugPrint("CustomState(${T.toString()}).build executed");
    return new FutureBuilder (
        future: loadWidget(context, _isInit),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data) {
              _isInit=false;
              return buildAsync(context);
            }
          } else {
            return new CircularProgressIndicator();
          }
        }
    );
  }

  // Inherited class should create widget here instead of from the build method
  @protected
  Widget buildAsync(BuildContext context) {
    debugPrint("CustomState(${T.toString()}).customBuild executed");
    return null;
  }

  // The following procedure is used for widget startup loading, remember to use await when calling any async call.
  @protected
  Future<bool> loadWidget(BuildContext context, bool isInit) async {
    debugPrint("CustomState(${T.toString()}).loadWidget executed " + (isInit?"for the first time":"again"));
    return true;
  }

}