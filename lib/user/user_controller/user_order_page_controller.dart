import 'dart:async';

abstract class UserOrderPagerController {
  Stream get totalAmountStreamController;
  Stream get productDialogStreamController;
}

class UserOrderPagerControllerImpl extends UserOrderPagerController {
  final StreamController _totalAmountStreamController =
  StreamController.broadcast();

  final _productDialogStreamController = StreamController.broadcast();

  @override
  Stream get totalAmountStreamController => _totalAmountStreamController.stream;

  totalAmountStream(bool value) {
    _totalAmountStreamController.add(value);
  }

  @override
  Stream get productDialogStreamController => _productDialogStreamController.stream;
  productDialogStream(bool value){
    _productDialogStreamController.add(value);
  }
}
