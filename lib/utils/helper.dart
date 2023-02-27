import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screen/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as sio;
import 'package:url_launcher/url_launcher.dart';

// Local import
import 'package:gesvol/helper/save_file_mobile.dart'
if (dart.library.html) 'package:gesvol/helper/save_file_web.dart' as saver;

import '../screen/my_drawer.dart';

class Helper {
  // globals objects
  static User? userFirebase;
  static User? userGoogle;
  static GoogleSignIn? googleSignIn;
  static var authClient;

  Helper._();

  static Widget doBuild(BuildContext context, String title, Widget theWidget) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
              onPressed: ()  {
                Helper.logoff(context);
              },
              icon: const Icon(Icons.power_settings_new))
        ],
      ),
      drawer: const MyDrawer(),
      body: theWidget,
    );
  }

  static Widget getRibbon(BuildContext context, GlobalKey<SfDataGridState> key) {
    return Container(
      color: Colors.black12,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children:<Widget>[
            Tooltip(
              message: 'Esporta in Excel',
              child: TextButton.icon(
                icon: Image.asset(
                  "icons/excel_icon.png",
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                ),
                label: const Text(''),
                onPressed: ()  => Helper.exportDataGridToExcelAndEmail(key),
              ),
            ),
            Tooltip(
              message: 'Email Excel',
              child: TextButton(
                onPressed: () => exportDataGridToExcelAndEmail(key),
                child: SizedBox(
                  height: 24,
                  width: 24 * 1.7,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Image.asset(
                            "icons/excel_icon.png",
                            width: 32,
                            height: 32,
                            fit: BoxFit.cover,
                             ),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          child: const Icon(
                            Icons.email,
                            color: Colors.blue,
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Tooltip(
              message: 'Esporta in PDF',
              child: TextButton.icon(
                icon: Image.asset(
                  "icons/adobe_icon.png",
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                ),
                label: const Text(''),
                onPressed: ()  => Helper.exportDataGridToPdf(key),
              ),
            ),
            Tooltip(
              message: 'Importa',
              child: TextButton.icon(
                icon:  Icon(Icons.upload),
                label: const Text(''),
                onPressed: ()  => Helper.importToCollection(context),
              ),
            ),
          ],
      ),
    );
  }

  static Future<void> importToCollection(BuildContext context) async {
    snackMsg(context, 'un momento ...');
  }

  static Future<void> exportDataGridToExcel(GlobalKey<SfDataGridState> key) async {
    final sio.Workbook workbook = key.currentState!.exportToExcelWorkbook();
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    await saver.saveAndLaunchFile(bytes, 'DataGrid.xlsx');
  }

  static Future<void> exportDataGridToPdf(GlobalKey<SfDataGridState> key) async {
    final PdfDocument document = key.currentState!.exportToPdfDocument(fitAllColumnsInOnePage: true);
    final List<int> bytes = document.saveSync();
    await saver.saveAndLaunchFile(bytes, 'DataGrid.pdf');
    document.dispose();
  }

  static Future<void> exportDataGridToExcelAndEmail(GlobalKey<SfDataGridState> key) async {
    final Uri uri = Uri(
        scheme: 'mailto',
        path: '',
        query: 'subject=Foglio Excel&body=In allegato il foglio Excel&attachment=Datagrid.xls',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print('Could not launch $uri');
    }
  }

  static logoff(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Conferma"),
          content: Text("Confermi uscita dall'applicazione ?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed:  () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("Continue"),
              onPressed:  () async {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => Login()),
                    ModalRoute.withName('/')
                );
              },
            ),
          ],
        );
      },
    );
  }

  static void snackBarPop(BuildContext context, String? message) {
    showModalBottomSheet<void>(
      context: context,
      barrierColor: const Color.fromRGBO(0, 0, 0, 0),
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 3), () {
          try {
            Navigator.pop(context);
            Navigator.pop(context);
          } on Exception {}
        });
        return Container(
            color: Colors.redAccent,
            padding: const EdgeInsets.all(12),
            child: Wrap(children: [
              Text(
                message ?? 'boh?',
                style:
                GoogleFonts.robotoCondensed().copyWith(color: Colors.white),
              )
            ]));
      },
    );
  }

  static snackMsg(BuildContext context, String message, [int? duration]) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: (Colors.red),
        duration: Duration(seconds: duration ?? 3 ),
      ),
    );
  }

  static doMsg(BuildContext context, String title, String msg) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(msg),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed:  () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

}