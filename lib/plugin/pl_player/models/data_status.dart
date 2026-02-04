import 'package:get/get.dart';

enum DataStatus { none, loading, loaded, error }

extension PlPlayerDataStatus on Rx<DataStatus> {
  bool get none => value == DataStatus.none;
  bool get loading => value == DataStatus.loading;
  bool get loaded => value == DataStatus.loaded;
  bool get error => value == DataStatus.error;
}
