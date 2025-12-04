import 'dart:async';

abstract class AdminPayBillCon {
  Stream get pathStreamCon;

  Stream get storeStreamCon;

  Stream get listStreamCon;

  String get selectedPathId;

  String get selectedStoreId;
}

class AdminPayBillConImpl extends AdminPayBillCon {
  final _pathStreamCon = StreamController.broadcast();
  final _storeStreamCon = StreamController.broadcast();
  final _listStreamCon = StreamController.broadcast();
  String _selectedPathId = '';
  String _selectedStoreId = '';

  @override
  Stream get storeStreamCon => _storeStreamCon.stream;

  storeStream(bool value) {
    _storeStreamCon.add(value);
  }

  @override
  Stream get listStreamCon => _listStreamCon.stream;

  listStream(bool value) {
    _listStreamCon.add(value);
  }

  @override
  Stream get pathStreamCon => _pathStreamCon.stream;

  pathStream(bool value) {
    _pathStreamCon.add(value);
  }

  @override
  String get selectedPathId => _selectedPathId;

  set selectedPathId(String value) {
    _selectedPathId = value;
  }

  @override
  String get selectedStoreId => _selectedStoreId;

  set selectedStoreId(String value) {
    _selectedStoreId = value;
  }


  void dispose() {
    _pathStreamCon.close();
    _storeStreamCon.close();
    _listStreamCon.close();
  }
}
