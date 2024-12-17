import 'package:flutter/material.dart';
import 'pages/job_sheet_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Sheet Maker',

      home: JobSheetPage(),
    );
  }
}
