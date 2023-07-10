import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:youhealmobile/utils/check_internet_connection.dart';
import 'package:youhealmobile/utils/resources.dart';
import 'package:youhealmobile/view_model/carb_view_model.dart';

import '../components/response/handle_response_msg.dart';

class PdfPlan with ChangeNotifier {
  bool isLoading = false;
  void _notify() {
    isLoading = !isLoading;
    notifyListeners();
  }

  Future downloadPdfPlan({
    required Map<String, dynamic> plan,
    required BuildContext ctx,
    required String name,
  }) async {
    _notify();

    try {
      final List<String> nutritionColumns =
          Provider.of<CarbViewModel>(ctx, listen: false)
              .nutritionData[0]
              .keys
              .toList();
      nutritionColumns.insert(1, tr("mealDetails"));
      // nutritionColumns.putIfAbsent("Meal description", () => null)
      final pdf = pw.Document();
      final arabicFont = Font.ttf(
          await rootBundle.load("assets/fonts/NotoNaskhArabic-Regular.ttf"));
      final ByteData image = await rootBundle.load(Resources.appLogo);
      Uint8List imageData = (image).buffer.asUint8List();

      plan.forEach((key, value) {
        final title = name.startsWith("Blood")
            ? key.toString()
            : "${tr("Day")} ${key.toString().split(" ")[1]}";
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            // orientation: PageOrientation.,
            textDirection: ctx.locale == const Locale('ar', 'EG')
                ? pw.TextDirection.rtl
                : pw.TextDirection.ltr,
            build: (pw.Context context) {
              return pw.Container(
                padding: const pw.EdgeInsets.all(20),
                child: pw.Column(
                  children: [
                    pw.Image(
                      pw.MemoryImage(imageData),
                      height: 100,
                      width: 200,
                    ),
                    pw.SizedBox(height: 20),
                    pw.Container(
                      width: double.infinity,
                      color: PdfColor.fromHex("#35D8A6"),
                      padding: const pw.EdgeInsets.all(20),
                      child: pw.Text(
                        title,
                        style: ctx.locale == const Locale('ar', 'EG')
                            ? pw.TextStyle(
                                font: arabicFont,
                                fontWeight: FontWeight.bold,
                                fontSize: 8,
                              )
                            : pw.TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                      ),
                    ),
                    pw.Table(
                      border: pw.TableBorder.all(),
                      tableWidth: pw.TableWidth.max,
                      children: [
                        if (name.startsWith("Blood"))
                          _tableColumns(
                            ctx.locale == const Locale('ar', 'EG'),
                            arabicFont,
                          ),
                        if (!name.startsWith("Blood"))
                          pw.TableRow(
                            children: [
                              ...nutritionColumns
                                  .map(
                                    (e) => pw.Container(
                                      color: PdfColor.fromHex("E4E9F2"),
                                      width: 200,
                                      height: 30,
                                      padding: const pw.EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 10,
                                      ),
                                      child: pw.Text(
                                        tr(e.toString()),
                                        style: ctx.locale ==
                                                const Locale('ar', 'EG')
                                            ? pw.TextStyle(
                                                font: arabicFont,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 8)
                                            : pw.TextStyle(
                                                fontSize: 8,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        textAlign: pw.TextAlign.center,
                                        textDirection: ctx.locale ==
                                                const Locale('ar', 'EG')
                                            ? pw.TextDirection.rtl
                                            : pw.TextDirection.ltr,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ],
                          ),
                        ...value.map(
                          (item) {
                            return _tableRow(
                                item,
                                ctx.locale == const Locale('ar', 'EG'),
                                arabicFont,
                                name,
                                ctx);
                          },
                        ).toList(),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      });
      PermissionStatus status = await Permission.storage.request();
      if (status.isGranted) {
        Directory? appDocDir = Platform.isAndroid
            ? await getExternalStorageDirectory()
            : await getDownloadsDirectory();

        String appDocPath = appDocDir!.path;
        final date = DateTime.now();
        final dateStr =
            "${date.year}-${date.month}-${date.day} ${date.hour}:${date.minute}";
        String fileName =
            'YouHeal $name ($dateStr).pdf'; // Replace with your desired file name

        final file = File('$appDocPath/$fileName');
        final pdfBytes = await pdf.save();
        await file.writeAsBytes(pdfBytes);

        // Show a download prompt
        await OpenFile.open(file.path).then((value) => print(value.message));
        // ignore: use_build_context_synchronously
        HandleResponseMsg.showSnackBar(
          context: ctx,
          msg: "planDownloadedSuccessfully",
          statusCode: 200,
        );
      } else {
        // Permission is denied
        if (status.isPermanentlyDenied) {
          // The user has permanently denied the permission, show a dialog or navigate to app settings
        } else {
          // The user has denied the permission, handle the denied state
        }
      }
      // Save the PDF to a temporary directory
    } catch (err) {
      print(err);
      InternetConnection.checkUserConnection(context: ctx);
    }
    _notify();
  }

  Map<String, dynamic> _getplanKeyNutritionData(
      {required String meal, required BuildContext context}) {
    final nutritionData =
        Provider.of<CarbViewModel>(context, listen: false).nutritionData;
    Map<String, dynamic> nutririonRow =
        nutritionData.firstWhere((element) => element['meal'] == meal);
    print(nutririonRow);
    nutririonRow = {
      "Carbohydrates (g)": nutririonRow['Carbohydrates (g)'],
      "Protein (g)": nutririonRow['Protein (g)'],
      "Fat (g)": nutririonRow['Fat (g)'],
      "Calories": nutririonRow['Calories'],
    };
    print(nutririonRow);
    // nutririonRow = nutririonRow.remove("meal");
    return nutririonRow;
  }

  pw.TableRow _tableColumns(bool isArabic, Font arabicFont) {
    return pw.TableRow(
      children: [
        pw.Container(
          color: PdfColor.fromHex("E4E9F2"),
          width: 200,
          height: 30,
          padding: const pw.EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: pw.RichText(
            text: pw.TextSpan(
              text: tr("readingType"),
              style: isArabic
                  ? pw.TextStyle(
                      font: arabicFont,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    )
                  : pw.TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
            ),
            textAlign: pw.TextAlign.center,
            textDirection:
                isArabic ? pw.TextDirection.rtl : pw.TextDirection.ltr,
          ),
        ),
        pw.Container(
          height: 30,
          color: PdfColor.fromHex("E4E9F2"),
          padding: const pw.EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: pw.Text(
            tr("time"),
            style: isArabic
                ? pw.TextStyle(
                    font: arabicFont,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  )
                : pw.TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
            textAlign: pw.TextAlign.center,
            textDirection:
                isArabic ? pw.TextDirection.rtl : pw.TextDirection.ltr,
          ),
        ),
        pw.Container(
          height: 30,
          color: PdfColor.fromHex("E4E9F2"),
          padding: const pw.EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: pw.Text(
            tr("value"),
            style: isArabic
                ? pw.TextStyle(
                    font: arabicFont,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  )
                : pw.TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
            textAlign: pw.TextAlign.center,
            textDirection:
                isArabic ? pw.TextDirection.rtl : pw.TextDirection.ltr,
          ),
        ),
      ],
    );
  }

  pw.TableRow _tableRow(Map<String, dynamic> rowData, bool isArabic,
      Font arabicFont, String type, BuildContext context) {
    final readTimeAndType = rowData.keys.first.split("|");
    Map<String, dynamic> nutritionData = {};
    if (!type.startsWith("Blood")) {
      nutritionData =
          _getplanKeyNutritionData(meal: readTimeAndType[0], context: context);
    }
    return pw.TableRow(
      children: [
        pw.Container(
          // width: 200,
          padding: const pw.EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: pw.Text(
            tr(readTimeAndType[0]),
            style: isArabic
                ? pw.TextStyle(font: arabicFont, fontSize: 10)
                : const pw.TextStyle(fontSize: 8),
            textAlign: isArabic ? pw.TextAlign.right : pw.TextAlign.left,
            textDirection:
                isArabic ? pw.TextDirection.rtl : pw.TextDirection.ltr,
          ),
        ),
        if (type.startsWith("Blood"))
          pw.Container(
            height: 50,
            padding:
                const pw.EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: pw.Text(
              readTimeAndType[1],
              style: isArabic
                  ? pw.TextStyle(font: arabicFont, fontSize: 10)
                  : const pw.TextStyle(fontSize: 8),
              textAlign: isArabic ? pw.TextAlign.right : pw.TextAlign.left,
              textDirection:
                  isArabic ? pw.TextDirection.rtl : pw.TextDirection.ltr,
            ),
          ),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: pw.Text(
            rowData[rowData.keys.first],
            style: isArabic
                ? pw.TextStyle(font: arabicFont, fontSize: 10)
                : const pw.TextStyle(fontSize: 8),
            textAlign: isArabic ? pw.TextAlign.right : pw.TextAlign.left,
            textDirection:
                isArabic ? pw.TextDirection.rtl : pw.TextDirection.ltr,
          ),
        ),
        if (!type.startsWith("Blood"))
          ...nutritionData.values
              .map(
                (e) => pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  child: pw.Text(
                    e.toString(),
                    style: isArabic
                        ? pw.TextStyle(font: arabicFont, fontSize: 10)
                        : const pw.TextStyle(fontSize: 8),
                    textAlign:
                        isArabic ? pw.TextAlign.right : pw.TextAlign.left,
                    textDirection:
                        isArabic ? pw.TextDirection.rtl : pw.TextDirection.ltr,
                  ),
                ),
              )
              .toList(),
      ],
    );
  }
}
