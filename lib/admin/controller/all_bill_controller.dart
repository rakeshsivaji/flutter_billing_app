import 'dart:async';

abstract class AllBillController{
  Stream get listStreamController;
}
class AllBillControllerImpl extends AllBillController{
  final _listStreamController = StreamController.broadcast();
  @override
  Stream get listStreamController => _listStreamController.stream;
   listStream(bool value){
     _listStreamController.add(value);
  }
}