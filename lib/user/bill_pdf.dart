/*
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

void printRecipt(BuildContext context) async {
  final godImage = await imageFromAssetBundle("assets/header.png");
  final image = await imageFromAssetBundle("assets/Screenshot (15).jpg");
  final clientSign = await imageFromAssetBundle("assets/client_signature.jpg");
  final tamil = await rootBundle.load("assets/font/TiroTamil-Regular.ttf");
  final ttf = pw.Font.ttf(tamil);
  final doc = pw.Document();

  doc.addPage(pw.MultiPage(
      margin: pw.EdgeInsets.all(0),
      // maxPages: 100,

      build: (pw.Context context) {
        final result = contentData.result.billBook;
        return [
          pw.Column(children: [
            pw.Container(
                height: 200,
                child: pw.Image(godImage, fit: pw.BoxFit.fitHeight)),
            pw.SizedBox(height: 30),
            pw.Container(
                height: 100, child: pw.Image(image, fit: pw.BoxFit.fitWidth)),
            pw.SizedBox(height: 30),
            pw.Container(
                alignment: pw.Alignment.centerRight,
                padding: pw.EdgeInsets.only(right: 30),
                margin: pw.EdgeInsets.only(right: 30),
                child: pw.Text("Reg.No : 25/2017",
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 25,
                      fontWeight: pw.FontWeight.bold,
                      fontBold: pw.Font.type1(pw.Type1Fonts.helveticaBold),
                      height: 1.5,
                    ))),
            pw.SizedBox(height: 30),
            pw.Container(
              alignment: pw.Alignment.topCenter,
              padding: const pw.EdgeInsets.only(left: 20, right: 20),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Divider(thickness: 5),
                  pw.SizedBox(height: 30),
                  pw.Table(
                    border: pw.TableBorder.symmetric(),
                    children: [
                      pw.TableRow(children: [
                        pw.Container(
                          alignment: pw.Alignment.bottomLeft,
                          padding:
                          const pw.EdgeInsets.only(bottom: 35, left: 10),
                          width: 120,
                          child: pw.Row(
                            children: [
                              pw.Text('Trans-Id',
                                  textAlign: pw.TextAlign.left,
                                  style: pw.TextStyle(
                                    font: pw.Font.helveticaBold(),
                                    fontSize: 29,
                                    fontWeight: pw.FontWeight.bold,
                                    fontBold: pw.Font.type1(
                                        pw.Type1Fonts.helveticaBold),
                                    // letterSpacing: 0,
                                    // height: 1.5,
                                  )),
                              pw.Spacer(),
                              pw.Text(':',
                                  textAlign: pw.TextAlign.left,
                                  style: pw.TextStyle(
                                    font: ttf,
                                    fontSize: 29,
                                    fontWeight: pw.FontWeight.bold,
                                    fontBold: pw.Font.type1(
                                        pw.Type1Fonts.helveticaBold),
                                    letterSpacing: 0,
                                    height: 1.5,
                                  ))
                            ],
                          ),
                        ),
                        pw.Container(
                          alignment: pw.Alignment.bottomLeft,
                          padding: const pw.EdgeInsets.only(
                            bottom: 35,
                            left: 10,
                          ),
                          width: 150,
                          // margin: const pw.EdgeInsets.only(bottom: 16),
                          child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              children: [
                                pw.Text(
                                  result.transacId.toString(),
                                  style: pw.TextStyle(
                                    // font: ttf,
                                    fontSize: 29,
                                    fontWeight: pw.FontWeight.bold,
                                    fontBold: pw.Font.type1(
                                        pw.Type1Fonts.helveticaBold),
                                    letterSpacing: 0.5,
                                    height: 0,
                                  ),
                                )
                              ]),
                        ),
                      ]),

                      pw.TableRow(children: [
                        pw.Container(
                          alignment: pw.Alignment.bottomLeft,
                          padding:
                          const pw.EdgeInsets.only(bottom: 35, left: 10),
                          width: 120,
                          child: pw.Column(children: [
                            pw.Row(
                              children: [
                                pw.Text('Date',
                                    textAlign: pw.TextAlign.left,
                                    style: pw.TextStyle(
                                      font: ttf,
                                      fontSize: 29,
                                      fontWeight: pw.FontWeight.bold,
                                      fontBold: pw.Font.type1(
                                          pw.Type1Fonts.helveticaBold),
                                    )),
                                pw.Spacer(),
                                pw.Text(':',
                                    textAlign: pw.TextAlign.left,
                                    style: pw.TextStyle(
                                      font: ttf,
                                      fontSize: 29,
                                      fontWeight: pw.FontWeight.bold,
                                      fontBold: pw.Font.type1(
                                          pw.Type1Fonts.helveticaBold),
                                    ))
                              ],
                            )
                          ]),
                        ),
                        pw.Container(
                          alignment: pw.Alignment.bottomLeft,
                          padding:
                          const pw.EdgeInsets.only(bottom: 35, left: 10),
                          width: 150,
                          // margin: const pw.EdgeInsets.only(bottom: 16),
                          child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              children: [
                                pw.Text(
                                  DateFormat('yyyy-MM-dd HH:mm:ss')
                                      .format(result.createdDateTime),
                                  style: pw.TextStyle(
                                    font: ttf,
                                    fontSize: 29,
                                    fontWeight: pw.FontWeight.bold,
                                    fontBold: pw.Font.type1(
                                        pw.Type1Fonts.helveticaBold),
                                  ),
                                )
                              ]),
                        ),
                      ]),
                      pw.TableRow(children: [
                        pw.Container(
                          alignment: pw.Alignment.bottomLeft,
                          padding:
                          const pw.EdgeInsets.only(bottom: 35, left: 10),
                          width: 120,
                          child: pw.Column(children: [
                            pw.Row(
                              children: [
                                pw.Text('Recipt Name',
                                    textAlign: pw.TextAlign.left,
                                    style: pw.TextStyle(
                                      font: ttf,
                                      fontSize: 29,
                                      fontWeight: pw.FontWeight.bold,
                                      fontBold: pw.Font.type1(
                                          pw.Type1Fonts.helveticaBold),
                                    )),
                                pw.Spacer(),
                                pw.Text(':',
                                    textAlign: pw.TextAlign.left,
                                    style: pw.TextStyle(
                                      font: ttf,
                                      fontSize: 29,
                                      fontWeight: pw.FontWeight.bold,
                                      fontBold: pw.Font.type1(
                                          pw.Type1Fonts.helveticaBold),
                                    ))
                              ],
                            )
                          ]),
                        ),
                        pw.Container(
                          alignment: pw.Alignment.bottomLeft,
                          padding:
                          const pw.EdgeInsets.only(bottom: 35, left: 10),
                          width: 150,
                          // margin: const pw.EdgeInsets.only(bottom: 16),
                          child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              children: [
                                pw.Text(
                                  result.accountHeadName.toString(),
                                  style: pw.TextStyle(
                                    font: ttf,
                                    fontSize: 29,
                                    fontWeight: pw.FontWeight.bold,
                                    fontBold: pw.Font.type1(
                                        pw.Type1Fonts.helveticaBold),
                                  ),
                                )
                              ]),
                        ),
                      ]),
                      pw.TableRow(children: [
                        pw.Container(
                          alignment: pw.Alignment.bottomLeft,
                          padding:
                          const pw.EdgeInsets.only(bottom: 35, left: 10),
                          width: 120,
                          // margin: const pw.EdgeInsets.only(bottom: 16),
                          child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              children: [
                                pw.Row(
                                  children: [
                                    pw.Text('Id',
                                        textAlign: pw.TextAlign.left,
                                        style: pw.TextStyle(
                                          font: ttf,
                                          fontSize: 29,
                                          fontWeight: pw.FontWeight.bold,
                                          fontBold: pw.Font.type1(
                                              pw.Type1Fonts.helveticaBold),
                                        )),
                                    pw.Spacer(),
                                    pw.Text(':',
                                        textAlign: pw.TextAlign.left,
                                        style: pw.TextStyle(
                                          font: ttf,
                                          fontSize: 29,
                                          fontWeight: pw.FontWeight.bold,
                                          fontBold: pw.Font.type1(
                                              pw.Type1Fonts.helveticaBold),
                                        ))
                                  ],
                                )
                              ]),
                        ),
                        pw.Container(
                          alignment: pw.Alignment.bottomLeft,
                          padding:
                          const pw.EdgeInsets.only(bottom: 35, left: 10),
                          width: 150,
                          child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              children: [
                                pw.Text(
                                  result.transactorId.toString(),
                                  style: pw.TextStyle(
                                    font: ttf,
                                    fontSize: 29,
                                    fontWeight: pw.FontWeight.bold,
                                    fontBold: pw.Font.type1(
                                        pw.Type1Fonts.helveticaBold),
                                  ),
                                )
                              ]),
                        ),
                      ]),
                      pw.TableRow(children: [
                        pw.Container(
                          alignment: pw.Alignment.bottomLeft,
                          padding:
                          const pw.EdgeInsets.only(bottom: 35, left: 10),
                          width: 120,
                          // margin: const pw.EdgeInsets.only(bottom: 16),
                          child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              children: [
                                pw.Row(
                                  children: [
                                    pw.Text('Name',
                                        textAlign: pw.TextAlign.left,
                                        style: pw.TextStyle(
                                          font: ttf,
                                          fontSize: 29,
                                          fontWeight: pw.FontWeight.bold,
                                          fontBold: pw.Font.type1(
                                              pw.Type1Fonts.helveticaBold),
                                        )),
                                    pw.Spacer(),
                                    pw.Text(':',
                                        textAlign: pw.TextAlign.left,
                                        style: pw.TextStyle(
                                          fontSize: 29,
                                          fontWeight: pw.FontWeight.bold,
                                          fontBold: pw.Font.type1(
                                              pw.Type1Fonts.helveticaBold),
                                        ))
                                  ],
                                )
                              ]),
                        ),
                        pw.Container(
                          alignment: pw.Alignment.bottomLeft,
                          padding:
                          const pw.EdgeInsets.only(bottom: 35, left: 10),
                          width: 150,
                          child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              children: [
                                pw.Text(
                                  result.transactor.toString(),
                                  style: pw.TextStyle(
                                    font: ttf,
                                    fontSize: 29,
                                    fontWeight: pw.FontWeight.bold,
                                    fontBold: pw.Font.type1(
                                        pw.Type1Fonts.helveticaBold),
                                  ),
                                )
                              ]),
                        ),
                      ]),
                      pw.TableRow(children: [
                        pw.Container(
                          alignment: pw.Alignment.bottomLeft,
                          padding:
                          const pw.EdgeInsets.only(bottom: 35, left: 10),
                          width: 120,
                          // margin: const pw.EdgeInsets.only(bottom: 16),
                          child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              children: [
                                pw.Row(
                                  children: [
                                    pw.Text('Amount',
                                        textAlign: pw.TextAlign.left,
                                        style: pw.TextStyle(
                                          font: ttf,
                                          fontSize: 29,
                                          fontWeight: pw.FontWeight.bold,
                                          fontBold: pw.Font.type1(
                                              pw.Type1Fonts.helveticaBold),
                                        )),
                                    pw.Text('(₹)',
                                        textAlign: pw.TextAlign.left,
                                        style: pw.TextStyle(
                                          font: ttf,
                                          fontSize: 29,
                                          // fontWeight: pw.FontWeight.bold,
                                          fontBold: pw.Font.type1(
                                              pw.Type1Fonts.helveticaBold),
                                        )),
                                    pw.Spacer(),
                                    pw.Text(':',
                                        textAlign: pw.TextAlign.left,
                                        style: pw.TextStyle(
                                          font: ttf,
                                          fontSize: 29,
                                          fontWeight: pw.FontWeight.bold,
                                          fontBold: pw.Font.type1(
                                              pw.Type1Fonts.helveticaBold),
                                        ))
                                  ],
                                )
                              ]),
                        ),
                        pw.Container(
                            alignment: pw.Alignment.bottomLeft,
                            padding:
                            const pw.EdgeInsets.only(bottom: 35, left: 10),
                            width: 150,
                            // margin: const pw.EdgeInsets.only(bottom: 16),
                            child: pw.Text(
                              'Rs.${result.amount.round()}',
                              style: pw.TextStyle(
                                font: ttf,
                                fontSize: 29,
                                fontWeight: pw.FontWeight.bold,
                                fontBold:
                                pw.Font.type1(pw.Type1Fonts.helveticaBold),
                              ),
                            )),
                      ]),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                  pw.Container(
                    padding: const pw.EdgeInsets.only(right: 60),
                    alignment: pw.Alignment.centerRight,
                    height: 50,
                    child: pw.Image(clientSign),
                  ),
                  pw.Container(
                    alignment: pw.Alignment.centerRight,
                    padding: const pw.EdgeInsets.only(right: 80),
                    height: 20,
                    child: pw.Text('Signature',
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(
                          font: ttf,
                          fontSize: 29,
                          fontWeight: pw.FontWeight.bold,
                          fontBold: pw.Font.type1(pw.Type1Fonts.helveticaBold),
                        )),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Container(
                      alignment: pw.Alignment.centerRight,
                      padding: const pw.EdgeInsets.only(right: 30),
                      child: pw.Column(children: [
                        pw.Text("S.Karthik",
                            textAlign: pw.TextAlign.left,
                            style: pw.TextStyle(
                              font: ttf,
                              fontSize: 29,
                              fontWeight: pw.FontWeight.bold,
                              fontBold:
                              pw.Font.type1(pw.Type1Fonts.helveticaBold),
                            )),
                        pw.Text("Ph no : 9043147777",
                            textAlign: pw.TextAlign.left,
                            style: pw.TextStyle(
                              font: ttf,
                              fontSize: 29,
                              fontWeight: pw.FontWeight.bold,
                              fontBold:
                              pw.Font.type1(pw.Type1Fonts.helveticaBold),
                            )),
                      ])),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Padding(
              padding: const pw.EdgeInsets.only(left: 20, right: 20),
              child: pw.Divider(thickness: 5),
            ),
            pw.SizedBox(height: 20),
            pw.Column(children: [
              pw.Text("****www.techlambdas.com****",
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    font: ttf,
                    fontSize: 25,
                    fontWeight: pw.FontWeight.bold,
                    fontBold: pw.Font.type1(pw.Type1Fonts.helveticaBold),
                  )),
              pw.Text("Digital Partner",
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    font: ttf,
                    fontSize: 25,
                    fontWeight: pw.FontWeight.bold,
                    fontBold: pw.Font.type1(pw.Type1Fonts.helveticaBold),
                  )),
              pw.Text("TECH-LAMBDAS Pvt Ltd",
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    font: ttf,
                    fontSize: 25,
                    fontWeight: pw.FontWeight.bold,
                    fontBold: pw.Font.type1(pw.Type1Fonts.helveticaBold),
                  )),
            ])
          ])
        ];
      }));
  await Printing.layoutPdf(name:  TransactionSingleton().contentlist.result.billBook.transactorId.toString(),
      onLayout: (PdfPageFormat format) async => doc.save());
}
*/
