import 'dart:async';

abstract class StockList2Controller {
  Stream get totalStreamController;

  Stream get productDialogStreamController;
}

class StockList2ControllerImpl extends StockList2Controller {
  final _totalStreamController = StreamController.broadcast();
  final _productDialogStreamController = StreamController.broadcast();

  @override
  Stream get totalStreamController => _totalStreamController.stream;

  Future<void> totalStream(bool value) async =>
      _totalStreamController.add(value);

  @override
  Stream get productDialogStreamController =>
      _productDialogStreamController.stream;

  Future<void> productDialogStream(bool value) async =>
      _productDialogStreamController.add(value);
}
