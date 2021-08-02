/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/base/loadingSpinner/zwapLoader.dart';

/// The Function to handle the future builder inside this custom component
typedef MyFutureBuilderBuildFunction<T> = Widget Function(T snapshotData);

/// it builds a custom component based on Future data from an async API call
class ZwapFuture<T> extends StatelessWidget{

  /// The custom builder widget to use with the future data
  final MyFutureBuilderBuildFunction<T> builder;

  /// The future data
  final Future<T> future;

  ZwapFuture({Key? key,
    required this.future,
    required this.builder
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasData){
            return builder(snapshot.data!);
          }
          else{
            return ZwapLoader();
          }
        }
        else{
          return ZwapLoader();
        }
      },
    );
  }


}