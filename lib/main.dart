import 'package:billing_app/admin/adminOrder.dart';
import 'package:billing_app/admin/adminPendingOrder.dart';
import 'package:billing_app/admin/admin_pay_bill/admin_pay_bill.dart';
import 'package:billing_app/admin/admin_pay_bill/admin_show_bill_details.dart';
import 'package:billing_app/admin/admincstlist.dart';
import 'package:billing_app/admin/admincstlist2.dart';
import 'package:billing_app/admin/adminOrderlist.dart';
import 'package:billing_app/admin/adminprofile.dart';
import 'package:billing_app/admin/allbills.dart';
import 'package:billing_app/admin/billdetails1.dart';
import 'package:billing_app/admin/billdetails2.dart';
import 'package:billing_app/admin/billdetails3.dart';
import 'package:billing_app/admin/billhistory.dart';
import 'package:billing_app/admin/categories.dart';
import 'package:billing_app/admin/collectionroutes.dart';
import 'package:billing_app/admin/create_stock_line.dart';
import 'package:billing_app/admin/createcategory.dart';
import 'package:billing_app/admin/createcollectionstore.dart';
import 'package:billing_app/admin/createemployee.dart';
import 'package:billing_app/admin/createindividualbill.dart';
import 'package:billing_app/admin/createproducts.dart';
import 'package:billing_app/admin/createroute.dart';
import 'package:billing_app/admin/createshop.dart';
import 'package:billing_app/admin/edit_stockline.dart';
import 'package:billing_app/admin/editcategory.dart';
import 'package:billing_app/admin/editcollectionpath.dart';
import 'package:billing_app/admin/editemployee.dart';
import 'package:billing_app/admin/editproduct.dart';
import 'package:billing_app/admin/editroute.dart';
import 'package:billing_app/admin/editshop.dart';
import 'package:billing_app/admin/employeedetails.dart';
import 'package:billing_app/admin/employees.dart';
import 'package:billing_app/admin/home_admin.dart';
import 'package:billing_app/admin/individualbill.dart';
import 'package:billing_app/admin/lines.dart';
import 'package:billing_app/admin/orderrecieved.dart';
import 'package:billing_app/admin/pendingproductlines.dart';
import 'package:billing_app/admin/pendingproductsadmin.dart';
import 'package:billing_app/admin/products.dart';
import 'package:billing_app/admin/receipts/bill_details_2_receipt_admin.dart';
import 'package:billing_app/admin/receipts/bill_details_receipt_admin.dart';
import 'package:billing_app/admin/receipts/individual_bills_receipt.dart';
import 'package:billing_app/admin/report.dart';
import 'package:billing_app/admin/routes.dart';
import 'package:billing_app/admin/shops.dart';
import 'package:billing_app/admin/shops_balance_amount.dart';
import 'package:billing_app/admin/stock_line_collection_report.dart';
import 'package:billing_app/admin/stock_line_report.dart';
import 'package:billing_app/admin/stock_line_report_show.dart';
import 'package:billing_app/form/reset_password.dart';
import 'package:billing_app/user/Newpendingorder.dart';
import 'package:billing_app/user/Stockline.dart';
import 'package:billing_app/user/announce.dart';
import 'package:billing_app/user/billdetails.dart';
import 'package:billing_app/user/billentries.dart';
import 'package:billing_app/user/create_stocklist.dart';
import 'package:billing_app/user/createstocklist.dart';
import 'package:billing_app/user/entered_bills.dart';
import 'package:billing_app/form/forget.dart';
import 'package:billing_app/form/login.dart';
import 'package:billing_app/form/otp.dart';
import 'package:billing_app/user/home.dart';
import 'package:billing_app/user/neworderpage.dart';
import 'package:billing_app/user/newstock.dart';
import 'package:billing_app/user/newstockorderconfirm.dart';
import 'package:billing_app/user/orderlist.dart';
import 'package:billing_app/user/orderpage.dart';
import 'package:billing_app/user/pendingorder.dart';
import 'package:billing_app/user/pendingproducts.dart';
import 'package:billing_app/user/profile.dart';
import 'package:billing_app/user/receipts/bill_details_receipt.dart';
import 'package:billing_app/user/receipts/shop_bills_receipt.dart';
import 'package:billing_app/user/shopbills.dart';
import 'package:billing_app/form/splash.dart';
import 'package:billing_app/user/stocklist.dart';
import 'package:billing_app/user/stocklist2.dart';
import 'package:billing_app/user/stocklisthistory.dart';
import 'package:billing_app/services/common_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: false, ignoreSsl: true);
  
  // Initialize offline support (cache and network services)
  await CommonService().initializeOfflineSupport();
  
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Billing App',
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(
            name: '/createstocklist',
            page: () {
              return const Create_Stocklist_Screen();
            }),
        GetPage(
            name: '/billdetails',
            page: () {
              return const BillDetails();
            }),
        GetPage(
            name: '/enteredbills',
            page: () {
              return const EnteredBills();
            }),
        GetPage(
            name: '/billDetailsReceipt',
            page: () {
              return const BillDetailsReceipt();
            }),
        GetPage(
            name: '/pendingorder',
            page: () {
              return const PendingOrder();
            }),
        GetPage(
            name: '/orderlist',
            page: () {
              return const Orderlist();
            }),
        GetPage(
            name: '/orderscreen',
            page: () {
              return const order_screen();
            }),
        GetPage(
            name: '/orderrecieved',
            page: () {
              return const OrdersRecieved();
            }),
        GetPage(
            name: '/stlisthistory',
            page: () {
              return const Stlisthistory();
            }),
        GetPage(
            name: '/billdetails2',
            page: () {
              return const Billdetails2();
            }),
        GetPage(
            name: '/billDetailsReceiptAdmin',
            page: () {
              return const BillDetailsReceiptAdmin();
            }),
        GetPage(
            name: '/billDetails2ReceiptAdmin',
            page: () {
              return const BillDetails2ReceiptAdmin();
            }),
        GetPage(
            name: '/individualbilldetails',
            page: () {
              return const Bill_Details3();
            }),
        GetPage(
            name: '/individualBillsReceipt',
            page: () {
              return const IndividualBillsReceipt();
            }),
        GetPage(
            name: '/cstlist',
            page: () {
              return const Cstlist();
            }),
        GetPage(
            name: '/announce',
            page: () {
              return const Announce();
            }),
        GetPage(
            name: '/stocklist',
            page: () {
              return const Stocklist();
            }),
        GetPage(
            name: '/profile',
            page: () {
              return const Profile();
            }),
        GetPage(
            name: '/shopbills',
            page: () {
              return const Shopbills();
            }),
        GetPage(
            name: '/billentries',
            page: () {
              return const Billentries();
            }),
        GetPage(
            name: '/home',
            page: () {
              return const Home();
            }),
        GetPage(
            name: '/otp',
            page: () {
              return const Otp();
            }),
        GetPage(
            name: '/forget',
            page: () {
              return const Forget();
            }),
        GetPage(
            name: '/login',
            page: () {
              return const Login();
            }),
        GetPage(
            name: '/splash',
            page: () {
              return const Splash();
            }),
        GetPage(
            name: '/categories',
            page: () {
              return const Categories();
            }),
        GetPage(
            name: '/adminprofile',
            page: () {
              return const Admin_Profile();
            }),
        GetPage(
            name: '/admincstlist2',
            page: () {
              return const AdminCstList2();
            }),
        GetPage(
            name: '/shopsBalanceAmount',
            page: () {
              return const ShopsBalanceAmount();
            }),
        GetPage(
            name: '/admincstlist',
            page: () {
              return const AdminCstList();
            }),
        GetPage(
            name: '/billdetails1',
            page: () {
              return const BillDetails1();
            }),
        GetPage(
            name: '/billhistory',
            page: () {
              return const BillHistory();
            }),
        GetPage(
            name: '/allbills',
            page: () {
              return const AllBills();
            }),
        GetPage(
            name: '/savedroute',
            page: () {
              return const Collections_Route();
            }),
        GetPage(
            name: '/createindividualbill',
            page: () {
              return const Create_Individual_Bill();
            }),
        GetPage(
            name: '/individualbill',
            page: () {
              return const Individual_bill();
            }),
        GetPage(
            name: '/report',
            page: () {
              return const Report_Page();
            }),
        GetPage(
            name: '/editemployee',
            page: () {
              return EditEmployee();
            }),
        GetPage(
            name: '/employeedetails',
            page: () {
              return const EmployeeDetails();
            }),
        GetPage(
            name: '/createemployee',
            page: () {
              return const CreateEmployee();
            }),
        GetPage(
            name: '/employees',
            page: () {
              return const Employees();
            }),
        GetPage(
            name: '/createshop',
            page: () {
              return const CreateShop();
            }),
        GetPage(
            name: '/shops',
            page: () {
              return const Shops();
            }),
        GetPage(
            name: '/editshop',
            page: () {
              return const EditShop();
            }),
        GetPage(
            name: '/createroute',
            page: () {
              return const CreateRoute();
            }),
        GetPage(
            name: '/routes',
            page: () {
              return const Routes();
            }),
        GetPage(
            name: '/editroute',
            page: () {
              return const EditRoute();
            }),
        GetPage(
            name: '/editcategory',
            page: () {
              return const EditCategory();
            }),
        GetPage(
            name: '/editproducts',
            page: () {
              return const EditProduct();
            }),
        GetPage(
            name: '/createproducts',
            page: () {
              return const CreateProducts();
            }),
        GetPage(
            name: '/products',
            page: () {
              return const Products();
            }),
        GetPage(
            name: '/createcategory',
            page: () {
              return const CreateCategory();
            }),
        GetPage(
            name: '/adminhome',
            page: () {
              return const HomeAdmin();
            }),
        GetPage(
            name: '/resetpassword',
            page: () {
              return const ResetPassword();
            }),
        GetPage(
            name: '/stocklist2',
            page: () {
              return const Stocklist2_Screen();
            }),
        GetPage(
            name: '/createsavedcollection',
            page: () {
              return const Create_Collection_Store();
            }),
        GetPage(
            name: '/editcollectionpath',
            page: () {
              return const Editcollectionpath();
            }),
        GetPage(
            name: '/adminorderscreen',
            page: () {
              return const Admin_order_screen();
            }),
        GetPage(
            name: '/adminorderlist',
            page: () {
              return const Admin_page_Orderlist();
            }),
        GetPage(
            name: '/adminpendingorder',
            page: () {
              return const Admin_Page_PendingOrder();
            }),
        GetPage(
            name: '/newstock',
            page: () {
              return const New_Stock();
            }),
        GetPage(
            name: '/neworderscreen',
            page: () {
              return const New_order_screen();
            }),
        GetPage(
            name: '/shopBillReceipt',
            page: () {
              return const ShopBillsReceipt();
            }),
        // GetPage(
        //     name: '/neworderlist',
        //     page: () {
        //       return New_Orderlist();
        //     }),
        GetPage(
            name: '/confirmorderlist',
            page: () {
              return const ConfirmStockOrder();
            }),
        GetPage(
            name: '/newpendingorder',
            page: () {
              return const NewPendingOrder();
            }),
        GetPage(
            name: '/lines',
            page: () {
              return const Lines();
            }),
        GetPage(
            name: '/createstockline',
            page: () {
              return const CreateStockLine();
            }),
        GetPage(
            name: '/stocklinereport',
            page: () {
              return const Stock_Line_Report();
            }),
        GetPage(
            name: '/showstocklinereport',
            page: () {
              return const Stock_Line_Report_Show();
            }),
        GetPage(
            name: '/stockline',
            page: () {
              return const Stockline();
            }),
        GetPage(
            name: '/editstockline',
            page: () {
              return const Edit_StockLine();
            }),
        GetPage(
            name: '/pendingproducts',
            page: () {
              return const PendingProducts();
            }),
        GetPage(
            name: '/pendingproductsadmin',
            page: () {
              return const PendingProductsAdmin();
            }), 
        GetPage(
            name: '/pendingproductslines',
            page: () {
              return const PendingProductLines();
            }),
        /// CHANGE THE CLASS NAME FOR THE NAV AFTER CHANGE CLEAR IT
        GetPage(
            name: '/adminPayBill',
            page: () {
              return const AdminPayBill();
            }),
        GetPage(
            name: '/stocklinecollectionreport',
            page: () {
              return const StockLineCollectionReport();
            }),
        GetPage(
            name: '/adminShowBillDetails',
            page: () {
              return const AdminShowBillDetails();
            }),
      ],
      home: const Splash(),
    );
  }
}
