import 'package:billing_app/Models/admin_pay_bill_model.dart';
import 'package:billing_app/admin/admin_pay_bill/admin_pay_bill_controller.dart';
import 'package:billing_app/components/app_colors.dart';
import 'package:billing_app/components/app_widget_utils.dart';
import 'package:billing_app/components/custom_dropdown_button_form_field.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/widgets/curved_edges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminPayBill extends StatefulWidget {
  const AdminPayBill({super.key});

  @override
  State<AdminPayBill> createState() => _AdminPayBillState();
}

class _AdminPayBillState extends State<AdminPayBill> {
  final _appColors = AppColors();
  final _adminPyBillCon = AdminPayBillConImpl();
  CommonController commonController = CommonController();
  List<AdminPayBillData>? adminPayBillData = [];

  @override
  void initState() {
    super.initState();
    _fetchPathValues();
  }

  @override
  void dispose() {
    super.dispose();
    commonController.pathmodel.close();
    commonController.pathStoreModel.close();
    _adminPyBillCon.dispose();
  }

  Future<void> _fetchPathValues() async {
    await commonController.getPath(withLoader: true);
    _adminPyBillCon.pathStream(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 100,
      flexibleSpace: ClipPath(
        clipper: CurvedEdges(),
        child: Container(
          color: const Color.fromRGBO(120, 89, 207, 1),
          height: 600,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => Navigator.pop(context),
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                color: _appColors.whiteColor,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'ரசீது உள்ளீடுகள்',
                          style: TextStyle(color: _appColors.whiteColor),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 12,
        right: 12,
      ),
      child: Column(
        children: [
          _buildShopNameAndPathNameFilterDropdown(),
          AppWidgetUtils.buildSizedBox(custHeight: 12),
          _buildListView(),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return StreamBuilder(
        stream: _adminPyBillCon.listStreamCon,
        builder: (context, snapshot) {
          return adminPayBillData?.isEmpty == true
              ? Center(
                  child: AppWidgetUtils.buildRobotoTextWidget(
                      'பட்டியல் காலியாக உள்ளது'),
                )
              : Container(
                  child: Flexible(
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          AppWidgetUtils.buildSizedBox(custHeight: 8),
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: adminPayBillData?.length ?? 0,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () async {
                              /*await commonController.getOrderDetails(
                                  adminPayBillData?[index].orderId.toString() ??
                                      '');
                              */ /*Navigator.push(context, MaterialPageRoute(
                          builder: (context) => const Shopbills(),));*/ /*
                              Get.toNamed('/shopbills');*/
                              _popupMenu(adminPayBillData?[index].orderId);
                            },
                            child: _buildContentCard(adminPayBillData?[index]));
                      },
                    ),
                  ),
                );
        });
  }

  Widget _buildContentCard(AdminPayBillData? adminPayBillData) {
    return Container(
      decoration: BoxDecoration(
          color: _appColors.whiteColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: _appColors.blackColor.withOpacity(0.5), blurRadius: 1)
          ]),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppWidgetUtils.buildRobotoTextWidget(
                  fontSize: 12,
                  'ID: ${adminPayBillData?.orderId.toString() ?? ''}',
                  fontWeight: FontWeight.w500),
              AppWidgetUtils.buildRobotoTextWidget(
                  fontSize: 11,
                  'Store Name: ${adminPayBillData?.storeName ?? ''}',
                  fontWeight: FontWeight.w500),
            ],
          ),
          const Divider(),
          AppWidgetUtils.buildRobotoTextWidget(
              'Owner Name: ${adminPayBillData?.ownerName ?? ''}'),
          AppWidgetUtils.buildRobotoTextWidget(
              'Owner Phone: ${adminPayBillData?.ownerPhone ?? ''}')
        ],
      ),
    );
  }

  Widget _buildShopNameAndPathNameFilterDropdown() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StreamBuilder(
            stream: _adminPyBillCon.pathStreamCon,
            builder: (context, snapshot) {
              return _buildShopNameDropdown(
                _adminPyBillCon.selectedPathId,
                'பாதையைத் தேர்ந்தெடுக்கவும்',
                commonController.pathmodel.value?.data.map((item) {
                      return DropdownMenuItem<String?>(
                        value: item.pathId.toString(),
                        child: Text(
                          item.name,
                          style: GoogleFonts.nunitoSans(
                              color: AppColors().blackColor),
                        ),
                      );
                    }).toList() ??
                    [],
                (onChangeValue) async {
                  _adminPyBillCon.selectedPathId = onChangeValue.toString();
                  _adminPyBillCon.selectedStoreId = '';
                  await commonController
                      .getPathStore(_adminPyBillCon.selectedPathId);
                  await _fetchListData();
                  _adminPyBillCon.storeStream(true);
                },
              );
            }),
        const SizedBox(
          height: 10,
        ),
        StreamBuilder(
            stream: _adminPyBillCon.storeStreamCon,
            builder: (context, snapshot) {
              return _buildShopNameDropdown(
                _adminPyBillCon.selectedStoreId,
                'தேர்வு கடை',
                commonController.pathStoreModel.value?.data.map((item) {
                      return DropdownMenuItem<String?>(
                        value: item.id.toString(),
                        child: Text(
                          item.name,
                          style: GoogleFonts.nunitoSans(
                              color: AppColors().blackColor),
                        ),
                      );
                    }).toList() ??
                    [],
                (onChangeValue) async {
                  _adminPyBillCon.selectedStoreId = onChangeValue.toString();
                  await _fetchListData();
                },
              );
            }),
      ],
    );
  }

  Widget _buildShopNameDropdown(
    String dropDownValue,
    String hintText,
    List<DropdownMenuItem<String?>> menuItems,
    Function(String?)? onChange,
  ) {
    return CustomDropDownButtonFormField(
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2)
      ],
      fillColor: Colors.white,
      inputBorder: const OutlineInputBorder(borderSide: BorderSide.none),
      // width: MediaQuery.sizeOf(context).width / 2.4,
      width: MediaQuery.sizeOf(context).width,
      height: 50,
      onChange: onChange,
      dropDownValue: dropDownValue,
      hintText: hintText,
      key: UniqueKey(),
      items: menuItems,
    );
  }

  Future<void> _fetchListData() async {
    await commonController.getAdminPayBillList(
      pathId: _adminPyBillCon.selectedPathId,
      shopId: _adminPyBillCon.selectedStoreId,
      onSuccessCallBack: (statusCode) {
        if (statusCode == 0) {
          adminPayBillData = [];
        } else if (statusCode == 1) {
          adminPayBillData = commonController.adminPayBillModel.value?.data;
        } else {
          adminPayBillData = [];
        }
      },
    );
    _adminPyBillCon.listStream(true);
  }

  void _popupMenu(int? orderId) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'நீங்கள் தொகையை செலுத்த வேண்டுமா?',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 100,
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              'பின்னர் செலுத்தவும்',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 11),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                          Get.toNamed('/adminShowBillDetails',
                              arguments: {'orderId': orderId.toString()})?.then(
                            (value) async {
                              await _fetchListData();
                            },
                          );
                        },
                        child: Container(
                          width: 100,
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(120, 89, 207, 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              'இப்போது செலுத்த',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 11, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              height: 30,
              width: 30,
              child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset('assets/images/closeicon.png')),
            ),
          ],
        ),
      ),
    );
  }
}
