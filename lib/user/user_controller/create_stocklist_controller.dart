import 'dart:async';

abstract class CreateStockListController{
  Stream get quantityStreamController;
}
class CreateStockListControllerImpl extends CreateStockListController{
  final _quantityStreamController = StreamController.broadcast();
  @override
  Stream get quantityStreamController => _quantityStreamController.stream;
  quantityStream(bool value){
    _quantityStreamController.add(value);
  }
}