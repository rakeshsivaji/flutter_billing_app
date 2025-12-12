# Flutter Billing App - Code Flow Documentation

## Table of Contents
1. [Application Entry Point](#application-entry-point)
2. [Authentication Flow](#authentication-flow)
3. [Architecture Overview](#architecture-overview)
4. [Data Flow](#data-flow)
5. [User Flow](#user-flow)
6. [Admin Flow](#admin-flow)
7. [Key Components](#key-components)

---

## Application Entry Point

### 1. Main Entry (`lib/main.dart`)
- **Entry Function**: `main()`
  - Initializes Flutter bindings
  - Initializes FlutterDownloader
  - Sets device orientation to portrait only
  - Runs the app with `MyApp` widget

- **MyApp Widget**:
  - Uses `GetMaterialApp` (GetX state management)
  - Defines all routes using `GetPage` (GetX routing)
  - Sets initial route to `/splash` (Splash screen)
  - Contains 50+ defined routes for navigation

---

## Authentication Flow

### 2. Splash Screen (`lib/form/splash.dart`)
**Flow:**
```
Splash Screen → Check Login Status → Route to appropriate screen
```

**Process:**
1. **Initialization**:
   - Creates `CommonController` instance
   - Calls `checkLoginStatus()`

2. **Login Status Check**:
   ```dart
   - Reads SharedPreferences for 'isLoggedIn' and 'userType'
   - If logged in:
     * Admin → Get admin profile → Navigate to '/adminhome'
     * User → Get notifications & user profile → Navigate to '/home'
   - If not logged in:
     * Navigate to '/login'
   ```

### 3. Login Screen (`lib/form/login.dart`)
**Flow:**
```
User Input → API Call → Save Session → Navigate to Home
```

**Process:**
1. User enters phone number and password
2. On submit, calls `CommonService().signin(map)`
3. On success:
   - Saves to SharedPreferences:
     - `isLoggedIn: true`
     - `userType: 'Admin' or 'User'`
     - `userId: customer_id`
     - `token: JWT token`
4. Based on user type:
   - Admin → Get admin profile → Navigate to `/adminhome`
   - User → Get user profile & notifications → Navigate to `/home`

### 4. Password Recovery Flow
- **Forget Password** (`lib/form/forget.dart`) → Send OTP
- **OTP Verification** (`lib/form/otp.dart`) → Verify OTP
- **Reset Password** (`lib/form/reset_password.dart`) → Set new password

---

## Architecture Overview

### Layered Architecture

```
┌─────────────────────────────────────┐
│         UI Layer (Screens)           │
│  (lib/user/, lib/admin/, lib/form/) │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│      Controller Layer                │
│  (lib/controllers/common_controller) │
│  - State Management (GetX)           │
│  - Business Logic                    │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│       Service Layer                  │
│  (lib/services/common_service.dart)  │
│  - API Calls                         │
│  - HTTP Requests                     │
│  - Response Parsing                  │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│         Backend API                  │
│  (http://localhost:8000/api/V1)     │
└─────────────────────────────────────┘
```

---

## Data Flow

### Request Flow Pattern

```
1. User Action (UI)
   ↓
2. Controller Method Call
   ↓
3. Service API Call
   ↓
4. HTTP Request (with Bearer Token)
   ↓
5. Backend API Response
   ↓
6. Service Parses Response
   ↓
7. Controller Updates Observable State
   ↓
8. UI Reacts to State Change (GetX Obx)
```

### Example: Fetching Categories

```dart
// 1. UI calls controller
commonController.getCategories(withLoader: true);

// 2. Controller calls service
dynamic response = await CommonService().getCategory();

// 3. Service makes HTTP GET request
response = await http.get(Uri.parse('$baseUrl/category'), 
                          headers: defaultHeader);

// 4. Service parses response
return getResponse(response); // Returns JSON

// 5. Controller updates observable
categorymodel.value = CategoryModel.fromJson(response);

// 6. UI automatically updates (GetX Obx)
Obx(() => Text(categorymodel.value?.data[0].name))
```

### CommonController (`lib/controllers/common_controller.dart`)
**Key Responsibilities:**
- Manages all observable state variables (Rx variables)
- Contains 100+ methods for data fetching
- Handles loading states
- Manages dropdown data (paths, shops, categories, etc.)

**Key Observable Models:**
- `adminprofilemodel` - Admin profile data
- `categorymodel` - Categories list
- `productmodel` - Products list
- `shopsmodel` - Shops list
- `pathmodel` - Routes/paths list
- `orderListModel` - Order lists
- `stockListModel` - Stock lists
- `notificationModel` - Notifications
- And 50+ more models

### CommonService (`lib/services/common_service.dart`)
**Key Responsibilities:**
- Makes HTTP requests (GET, POST, DELETE)
- Handles authentication (Bearer token)
- Manages SharedPreferences
- Parses API responses
- Handles file uploads (Multipart)

**Base URL:** `http://localhost:8000/api/V1`

**Key Methods:**
- `get(url)` - GET request with auth
- `post(url, map)` - POST request with auth
- `openPost(url, map)` - POST without auth (login, signup)
- `postWithFiles(url, map, files)` - Multipart POST for file uploads
- `getToken()` - Retrieves JWT token from SharedPreferences

---

## User Flow

### User Home Screen (`lib/user/home.dart`)
**Features:**
1. **Profile Display** - Shows user profile image and name
2. **Notifications** - Badge indicator for new notifications
3. **Quick Actions:**
   - Bill Entries (`/billentries`)
   - Shop Bills (`/shopbills`)
   - Stock List (`/stocklist`)
   - Orders (`/orderlist`)
   - Profile (`/profile`)

### User Navigation Structure

```
Home
├── Bill Entries → Bill Details → Receipt
├── Shop Bills → Bill Details → Receipt
├── Stock List → Create Stock List → Confirm
├── Orders
│   ├── Today Orders
│   ├── Tomorrow Orders
│   └── Pending Orders
├── Profile
└── Announcements
```

### Key User Features

#### 1. Bill Entry Flow
```
Bill Entries Screen
  → Select Path/Store
  → Enter Bill Details
  → Save Bill
  → View Bill Details
  → Generate Receipt
```

#### 2. Stock Management Flow
```
Stock List Screen
  → Create Stock List
  → Add Products
  → Confirm Stock Order
  → View Stock History
```

#### 3. Order Management Flow
```
Order Screen
  → View Today's Orders
  → View Tomorrow's Orders
  → View Pending Orders
  → Confirm Orders
```

---

## Admin Flow

### Admin Home Screen (`lib/admin/home_admin.dart`)
**Features:**
1. **Drawer Navigation** with all admin features
2. **Dashboard** with key metrics
3. **Quick Access** to:
   - Products Management
   - Shops Management
   - Routes Management
   - Employees Management
   - Reports
   - Bills Management

### Admin Navigation Structure

```
Admin Home
├── Products
│   ├── Categories (Create/Edit/Delete)
│   └── Products (Create/Edit/Delete)
├── Routes
│   ├── Paths (Create/Edit/Delete)
│   └── Collection Routes (Create/Edit)
├── Shops
│   └── Stores (Create/Edit/Delete)
├── Employees
│   ├── Users (Create/Edit/Delete)
│   └── Lines (Create/Edit)
├── Bills
│   ├── All Bills
│   ├── Bill History
│   ├── Individual Bills
│   └── Pay Bills
├── Orders
│   ├── Order Received
│   ├── Pending Orders
│   └── Order Delivery
├── Stock
│   ├── Stock List
│   ├── Stock History
│   └── Stock Reports
└── Reports
    ├── Collection Reports
    ├── Line Reports
    └── User Reports
```

### Key Admin Features

#### 1. Product Management Flow
```
Products Screen
  → View All Products
  → Create Product (with image upload)
  → Edit Product
  → Delete Product
  → Filter by Category
```

#### 2. Shop Management Flow
```
Shops Screen
  → View All Shops
  → Create Shop (assign to path)
  → Edit Shop
  → Delete Shop
  → View Shop Balance Amount
```

#### 3. Route Management Flow
```
Routes Screen
  → View All Paths
  → Create Path
  → Edit Path
  → Delete Path
  → Create Collection Route
  → Assign Shops to Routes
```

#### 4. Employee Management Flow
```
Employees Screen
  → View All Employees
  → Create Employee (with image upload)
  → Edit Employee
  → Delete Employee
  → View Employee Details
  → Enable/Disable Employee
```

#### 5. Bill Management Flow
```
Bills Screen
  → View All Bills (with filters)
  → View Bill History
  → View Individual Bills
  → Pay Bills
  → Generate Reports
```

#### 6. Stock Management Flow
```
Stock Screen
  → View Stock List
  → Create Stock Line
  → View Stock History
  → Generate Stock Reports
  → View Pending Products
```

---

## Key Components

### 1. Models (`lib/Models/`)
- **67 Model Files** - Data classes for API responses
- Each model follows pattern: `ModelName.fromJson(json)`
- Examples:
  - `CategoryModel` - Category data
  - `ProductModel` - Product data
  - `ShopModel` - Shop data
  - `OrderListModel` - Order data
  - `StockListModel` - Stock data

### 2. Widgets (`lib/widgets/`)
- `customappbar.dart` - Custom app bar
- `buildcard.dart` - Reusable card widget
- `receipt_page.dart` - Receipt generation
- `printer_dialog.dart` - Printer selection dialog
- `curved_edges.dart` - Custom curved edges

### 3. Components (`lib/components/`)
- `custom_form_field.dart` - Custom form input
- `custom_dropdown_button_form_field.dart` - Custom dropdown
- `app_colors.dart` - App color constants
- `app_widget_utils.dart` - Utility functions

### 4. Services (`lib/services/`)
- `common_service.dart` - Main API service
- `app_service.dart` - App-level services

### 5. Controllers (`lib/controllers/`)
- `common_controller.dart` - Main controller (1400+ lines)
- Admin-specific controllers in `lib/admin/controller/`
- User-specific controllers in `lib/user/user_controller/`

---

## State Management (GetX)

### Observable Variables
```dart
Rx<CategoryModel?> categorymodel = (null as CategoryModel?).obs;
RxBool isLoading = false.obs;
RxList billType = <String>[].obs;
```

### Usage in UI
```dart
Obx(() => Text(categorymodel.value?.data[0].name ?? 'Loading'))
```

### Navigation
```dart
Get.toNamed('/products');           // Navigate
Get.offNamed('/home');              // Navigate and remove current
Get.back();                         // Go back
Get.arguments;                      // Get passed arguments
```

---

## API Endpoints Structure

### Authentication
- `POST /signin` - Login
- `POST /forgot-password` - Send OTP
- `POST /password` - Reset password
- `POST /logout` - Logout

### Products
- `GET /category` - Get categories
- `POST /category` - Create category
- `GET /product` - Get products
- `POST /product` - Create product
- `POST /product/{id}` - Update product

### Shops
- `GET /store` - Get shops
- `POST /store` - Create shop
- `GET /store/{id}` - Get shop details
- `POST /store/{id}` - Update shop

### Routes
- `GET /path` - Get paths
- `POST /path` - Create path
- `GET /path/{id}` - Get path details
- `POST /path/{id}` - Update path

### Bills
- `GET /bill-entry` - Get bill entries
- `GET /bill-details/{id}` - Get bill details
- `POST /bill-payment/{id}` - Pay bill
- `GET /total-bill` - Get all bills

### Orders
- `GET /order-list/{id}` - Get order list
- `POST /order-list` - Create order
- `POST /order-confirm/{storeId}` - Confirm order
- `GET /order-received` - Get received orders

### Stock
- `GET /stock` - Get stock
- `POST /stock` - Create stock
- `GET /stock-history` - Get stock history
- `GET /stock-order-list/{id}` - Get stock order list

---

## Key Features Summary

### User Features
1. ✅ Bill Entry & Management
2. ✅ Shop Bills Viewing
3. ✅ Stock List Creation & Management
4. ✅ Order Management (Today/Tomorrow/Pending)
5. ✅ Profile Management
6. ✅ Notifications
7. ✅ Receipt Generation

### Admin Features
1. ✅ Product Management (CRUD)
2. ✅ Category Management (CRUD)
3. ✅ Shop Management (CRUD)
4. ✅ Route Management (CRUD)
5. ✅ Employee Management (CRUD)
6. ✅ Bill Management & Reports
7. ✅ Order Management & Tracking
8. ✅ Stock Management & Reports
9. ✅ Collection Reports
10. ✅ Line Reports
11. ✅ User Reports
12. ✅ Shop Balance Management

---

## File Structure Summary

```
lib/
├── main.dart                    # Entry point
├── form/                        # Authentication screens
│   ├── splash.dart
│   ├── login.dart
│   ├── forget.dart
│   ├── otp.dart
│   └── reset_password.dart
├── user/                        # User screens (30 files)
│   ├── home.dart
│   ├── billentries.dart
│   ├── shopbills.dart
│   ├── stocklist.dart
│   ├── orderlist.dart
│   └── ...
├── admin/                       # Admin screens (50+ files)
│   ├── home_admin.dart
│   ├── products.dart
│   ├── shops.dart
│   ├── routes.dart
│   ├── employees.dart
│   └── ...
├── controllers/                 # State management
│   └── common_controller.dart
├── services/                    # API services
│   ├── common_service.dart
│   └── app_service.dart
├── Models/                      # Data models (67 files)
├── widgets/                     # Reusable widgets
└── components/                  # UI components
```

---

## Important Notes

1. **Authentication**: Uses JWT tokens stored in SharedPreferences
2. **State Management**: GetX for reactive state management
3. **Navigation**: GetX routing (Get.toNamed, Get.offNamed)
4. **API Base URL**: Currently set to `http://localhost:8000/api/V1`
5. **File Uploads**: Uses Multipart requests for images
6. **Offline Support**: Uses SharedPreferences for session persistence
7. **Printing**: Supports thermal printer integration
8. **Download**: Supports file downloads via FlutterDownloader

---

## Common Patterns

### Loading Pattern
```dart
isLoading(true);
// API call
isLoading(false);
```

### Error Handling
```dart
if (response['status'] == 1) {
  // Success
} else {
  // Show error dialog
}
```

### Navigation with Arguments
```dart
Get.toNamed('/billdetails', arguments: {'billId': '123'});
// In destination screen:
final args = Get.arguments;
```

---

This document provides a comprehensive overview of the code flow in the Flutter Billing App. For specific implementation details, refer to the individual source files.

