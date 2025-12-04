import 'dart:async';

abstract class AdminOrderController {
  Stream get totalAmountStreamController;
}

class AdminOrderControllerImpl extends AdminOrderController {
  final StreamController _totalAmountStreamController =
      StreamController.broadcast();

  @override
  Stream get totalAmountStreamController => _totalAmountStreamController.stream;

  Future<void> totalAmountStream(bool value) async => _totalAmountStreamController.add(value);
}
