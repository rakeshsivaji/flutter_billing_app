import 'package:flutter/material.dart';

class Order_Screen extends StatefulWidget {
  const Order_Screen({super.key});

  @override
  State<Order_Screen> createState() => _Order_ScreenState();
}

class _Order_ScreenState extends State<Order_Screen> {
  DateTime _selectedDate = DateTime.now();
  var quantity = 0;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(2050),
    );
    if (pickedDate != null && pickedDate != _selectDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 8,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15, left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.popAndPushNamed(context, '/home');
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: 17,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const Text(
                          'ஆர்டர் டெலிவரி',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 12,
                              backgroundColor: Color.fromRGBO(120, 89, 207, 1),
                              color: Colors.white,
                              fontWeight: FontWeight.w300),
                        ),
                        SizedBox(
                          height: 20,
                          width: MediaQuery.of(context).size.width / 3,
                        ),
                        InkWell(
                          onTap: () => _selectDate(context),
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            height: MediaQuery.of(context).size.height / 33,
                            width: MediaQuery.of(context).size.width / 4.5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text(
                                  'இன்று',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Image.asset(
                                      height: 6, 'assets/images/downarrow.png'),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40)),
                        color: Colors.white,
                      ),
                      height: MediaQuery.of(context).size.height * 1.15,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: Stack(
                          children: [
                            SingleChildScrollView(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.horizontal(
                                          left: Radius.circular(10),
                                          right: Radius.circular(10)),
                                      color: Color.fromRGBO(120, 89, 207, 1),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 5),
                                    child: const Text(
                                      'milk',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    ),
                                  ),
                                  // rowMethod("milk"),
                                  rowMethod('Cool drinks'),
                                  rowMethod('chips'),
                                  rowMethod('Cool drinks'),
                                  rowMethod('chips'),
                                  rowMethod('Cool drinks'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 70,
                      left: 10,
                      child: Container(
                        height: MediaQuery.of(context).size.height / 18,
                        width: MediaQuery.of(context).size.width / 2.2,
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(243, 243, 243, 1),
                            borderRadius: BorderRadius.circular(4)),
                        child: Row(
                          children: [
                            const Padding(padding: EdgeInsets.all(4)),
                            const Text(
                              'பாதையைத் தேர்ந்தெடுக்கவும்',
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Image.asset(
                                height: 7, 'assets/images/downarrow.png')
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 70,
                      right: 10,
                      child: Container(
                        height: MediaQuery.of(context).size.height / 18,
                        width: MediaQuery.of(context).size.width / 2.2,
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(243, 243, 243, 1),
                            borderRadius: BorderRadius.circular(4)),
                        child: Row(
                          children: [
                            const Padding(padding: EdgeInsets.all(4)),
                            const Text(
                              'கடையைத் தேர்ந்தெடுக்கவும்',
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Image.asset(
                                height: 7, 'assets/images/downarrow.png')
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 140,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(120, 89, 207, 0.05),
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(120, 89, 207, 0.05),
                            borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(20),
                                right: Radius.circular(20)),
                          ),
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  gridMethod(
                                      'Heritage Milk Blue',
                                      'assets/images/dairymilk.png',
                                      '25',
                                      'assets/images/amount25.png'),
                                  gridMethod(
                                      'Heritage Milk Blue',
                                      'assets/images/dairymilk.png',
                                      '25',
                                      'assets/images/amount25.png'),
                                  gridMethod(
                                      'Heritage Milk Blue',
                                      'assets/images/dairymilk.png',
                                      '25',
                                      'assets/images/amount25.png'),
                                  gridMethod(
                                      'Heritage Milk Blue',
                                      'assets/images/dairymilk.png',
                                      '25',
                                      'assets/images/amount25.png'),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Column(
                                children: [
                                  gridMethod(
                                      'Heritage Milk Blue',
                                      'assets/images/dairymilk.png',
                                      '25',
                                      'assets/images/amount25.png'),
                                  gridMethod(
                                      'Heritage Milk Blue',
                                      'assets/images/dairymilk.png',
                                      '25',
                                      'assets/images/amount25.png'),
                                  gridMethod(
                                      'Heritage Milk Blue',
                                      'assets/images/dairymilk.png',
                                      '25',
                                      'assets/images/amount25.png'),
                                  gridMethod(
                                      'Heritage Milk Blue',
                                      'assets/images/dairymilk.png',
                                      '25',
                                      'assets/images/amount25.png'),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Column(
                                children: [
                                  gridMethod(
                                      'Heritage Milk Blue',
                                      'assets/images/dairymilk.png',
                                      '25',
                                      'assets/images/amount25.png'),
                                  gridMethod(
                                      'Heritage Milk Blue',
                                      'assets/images/dairymilk.png',
                                      '25',
                                      'assets/images/amount25.png'),
                                  gridMethod(
                                      'Heritage Milk Blue',
                                      'assets/images/dairymilk.png',
                                      '25',
                                      'assets/images/amount25.png'),
                                  gridMethod(
                                      'Heritage Milk Blue',
                                      'assets/images/dairymilk.png',
                                      '25',
                                      'assets/images/amount25.png'),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
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
            bottom: 20,
            left: 25,
            child: Container(
              height: MediaQuery.of(context).size.height * .07,
              width: MediaQuery.of(context).size.width - 50,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(120, 89, 207, 1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'மொத்தம்',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '₹ 300',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: VerticalDivider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                  ),
                  Text(
                    'ஆர்டர் பட்டியல்',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  GestureDetector gridMethod(label, image, label2, image2) {
    return GestureDetector(
      onTap: () {
        _PopupMenu();
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.09),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(2, 3),
            ),
          ],
          borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(15), right: Radius.circular(15)),
          color: const Color.fromRGBO(255, 255, 255, 1),
        ),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 29,
              width: MediaQuery.of(context).size.width / 3.8,
              padding: const EdgeInsets.all(0),
              margin: const EdgeInsets.all(0),
              decoration: const BoxDecoration(),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                  ),
                  color: Color.fromRGBO(120, 89, 207, 0.2),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Image.asset(
              image,
              height: 100,
              width: 100,
            ),
            Stack(
              children: [
                Positioned(
                  top: 8,
                  left: 16,
                  child: Text(
                    '₹' + label2,
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
                Image.asset(
                  'assets/images/amount.png',
                  height: 30,
                  width: 50,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _PopupMenu() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Container(
              height: 420,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(120, 89, 207, 1),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(15)),
                    ),
                    child: const Center(
                        child: Text(
                      'Cavin\'s Milk Red',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    )),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'விலை',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  buildformfield(true),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'மொத்த விலை',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  buildformfield(true),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        buildformfield(false),
                      ],
                    ),
                  ),
                  const Text('or'),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 20.0,
                      ),
                      Text('அளவு'),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 50,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: const Color.fromRGBO(250, 250, 250, 1),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.5),
                            )),
                        child: const Center(
                          child: Icon(
                            Icons.remove_rounded,
                            size: 25,
                            color: Color.fromRGBO(71, 52, 125, 1),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Container(
                        width: 60,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color.fromRGBO(120, 89, 207, 1),
                        ),
                        child: const Center(
                          child: Text(
                            '1',
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      InkWell(
                        onTap: () {
                          // setState(() {
                          //   quantity ++;
                          // });
                        },
                        child: Container(
                          width: 50,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: const Color.fromRGBO(250, 250, 250, 1),
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.5),
                              )),
                          child: const Center(
                            child: Icon(
                              Icons.add,
                              size: 25,
                              color: Color.fromRGBO(71, 52, 125, 1),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 60,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey[300],
                          ),
                          child: const Center(
                            child: Text(
                              'ரத்து',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/orderlist');
                          },
                          child: Container(
                            width: 60,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: const Color.fromRGBO(120, 89, 207, 1),
                            ),
                            child: const Center(
                              child: Text(
                                'சரி',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              height: 30,
              width: 30,
              child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset('assets/images/closeicon2.png')),
            ),
          ],
        ),
      ),
    );
  }

  Container buildformfield(bool symbol) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromRGBO(250, 250, 250, 1),
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          symbol
              ? Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    ' ₹  |',
                    style: TextStyle(
                        fontSize: 22, color: Colors.black.withOpacity(0.6)),
                  ),
                )
              : Container(),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                hintText: '',
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                fillColor: const Color.fromRGBO(71, 52, 125, 1),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container rowMethod(label) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.horizontal(
            left: Radius.circular(10), right: Radius.circular(10)),
        color: Color.fromRGBO(243, 243, 243, 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: Text(
        label,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
      ),
    );
  }
}
