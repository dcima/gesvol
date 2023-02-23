import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../screen/login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as sio;

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
    return Row(
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
              onPressed: ()  => Helper.exportDataGridToExcel(key),
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

  static snackMsg(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: (Colors.red),
      ),
    );
  }
}