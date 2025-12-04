import 'dart:async';

abstract class AdminCsList2Controller {
  Stream get bottomSheetStreamController;

  Stream get productDialogStreamController;

  Stream get totalAmountStreamController;

  Stream get pathDropdownStreamController;
}

class AdminCsList2ControllerImpl extends AdminCsList2Controller {
  final _bottomSheetStreamController = StreamController.broadcast();
  final _productDialogStreamController = StreamController.broadcast();
  final _totalAmountStreamController = StreamController.broadcast();
  final _pathDropdownStreamController = StreamController.broadcast();

  String? selectedPath;
  String? selectedUser;
  bool isEnable = true;

  @override
  Stream get bottomSheetStreamController => _bottomSheetStreamController.stream;

  bottomSheetStream(bool value) {
    _bottomSheetStreamController.add(value);
  }

  @override
  Stream get productDialogStreamController =>
      _productDialogStreamController.stream;

  productDialogStream(bool value) {
    _productDialogStreamController.add(value);
  }

  @override
  Stream get totalAmountStreamController => _totalAmountStreamController.stream;

  totalAmountStream(bool value) {
    _totalAmountStreamController.add(value);
  }

  @override
  Stream get pathDropdownStreamController =>
      _pathDropdownStreamController.stream;

  pathDropdownStream(bool value) {
    _pathDropdownStreamController.add(value);
  }
}
